# Production-Grade Monitoring Stack (Alloy + Loki + Grafana + Prometheus)

This module started from a real draft config that *claimed* to be a "production-grade HA
monitoring stack." It wasn't — it had the right component list but several single points of
failure hiding behind HA-sounding settings. This README documents what was wrong and why,
then [values/](values/) contains the corrected configuration.

Use this as a case study: reading a values.yaml and asking "does this setting actually do what
the comment above it claims?" is a core production-readiness-review skill.

## What was actually wrong with the draft

### 1. Every "HA" component was a single point of failure
The README claimed 2 Prometheus replicas, an HA Loki gateway, and HA Grafana — but:
- `prometheus.prometheusSpec.replicas` was `1`, while a pod anti-affinity rule for 2+ replicas
  sat right above it, doing nothing.
- Loki ran in `SingleBinary` mode with `replicas: 1`, `replication_factor: 1`, and `filesystem`
  storage on a `ReadWriteOnce` disk. The "HA Gateway" was 2 nginx replicas in front of that
  *one* Loki process — if it dies, both gateway replicas serve 503s. Local-disk `filesystem`
  storage also means log data lives and dies with a single pod/PVC.
- Grafana ran `replicas: 1` on SQLite (`database.type: sqlite3`). SQLite doesn't support
  concurrent writers, so Grafana literally cannot run >1 replica without a real database —
  the "HA priority" comment was aspirational, not implemented.

**Fix:** Prometheus → 2 replicas (matches the anti-affinity that was already there). Loki →
`SimpleScalable` mode with `write`/`read`/`backend` replicas ≥ 2-3, `replication_factor: 3`,
and Azure Blob object storage instead of local disk. Grafana → external Postgres, persistence
disabled (stateless pods), replicas: 2.

### 2. Metrics and logs disagreed about which cluster they came from
Alloy tagged logs with `cluster: aks-production, env: production`. Prometheus tagged metrics
with `cluster: aks-dev, environment: development`. Correlating a log line with a metric spike
in Grafana Explore relies on matching label values — this would have silently broken it.

**Fix:** one label vocabulary, applied consistently in [values/alloy-values.yaml](values/alloy-values.yaml)
and [values/prometheus-values.yaml](values/prometheus-values.yaml).

### 3. Node-level metrics weren't collected by *anything*
`nodeExporter.enabled: false` in the Prometheus stack, with the comment "using Grafana Alloy for
node metrics instead" — but the Alloy config only shipped logs; it had no `prometheus.exporter.unix`
component. Result: no CPU/memory/disk/network metrics per node, from either source.

**Fix:** added `prometheus.exporter.unix "node"` to Alloy, scraped in-process with
`prometheus.scrape` and pushed via `prometheus.remote_write` to Prometheus. This requires
Prometheus's remote-write receiver to be turned on
(`prometheusSpec.enableRemoteWriteReceiver: true`, added in
[values/prometheus-values.yaml](values/prometheus-values.yaml)) — plain `serviceMonitor`
scraping alone can't pull metrics out of Alloy's exporter component, since those metrics aren't
part of Alloy's own self-instrumentation endpoint.

### 4. The Alloy log pipeline computed a path it never used
`discovery.relabel` built an `__path__` label (for file-based tailing), but the pods were fed
into `loki.source.kubernetes`, which pulls logs via the Kubernetes API and ignores `__path__`
entirely. The `hostPath` mounts for `/var/log` and `/var/lib/docker/containers` were declared
but nothing read them consistently with that label. It also ran `stage.json` directly on raw
container output — but containerd wraps every line in a CRI-format prefix
(`<time> <stream> <flag> <content>`), so `stage.json` would fail to parse almost everything
unless a `stage.cri` unwrapped it first.

**Fix:** switched to one consistent pipeline: `discovery.kubernetes` → `discovery.relabel` with
a *correct* `__path__` (`/var/log/pods/<namespace>_<pod>_<uid>/*/*.log`) → `local.file_match` →
`loki.source.file` → `loki.process` with `stage.cri` before `stage.json`. See
[values/alloy-values.yaml](values/alloy-values.yaml) for the full River config.

### 5. Grafana's admin password was a plaintext secret in a values file
`adminPassword: "admin@123"` — checked into a values file (with a `# Change this!` comment,
which is not a mitigation). This is the kind of thing that ends up in `git log` forever even
after "fixing" it later.

**Fix:** removed from values entirely; Grafana now reads `admin.existingSecret`, pointing at a
Kubernetes Secret created out-of-band (or synced from Azure Key Vault via the CSI driver / External
Secrets Operator — see [Secrets](#secrets-handling) below).

### 6. The dashboard/datasource sidecar was told to run without permissions
`serviceAccount.automountServiceAccountToken: false` was set globally, but
`sidecar.dashboards.enabled` / `sidecar.datasources.enabled` need the sidecar container to call
the Kubernetes API (list/watch ConfigMaps and Secrets by label) to do their job. With no token
mounted, the sidecar silently fails to discover anything.

**Fix:** left `automountServiceAccountToken: true` (the chart already scopes the token to a
dedicated ServiceAccount + RBAC role, so this isn't a broad grant).

### 7. Wrong TLS annotation on the Grafana Ingress
`kubernetes.io/tls-acme: "true"` is a *kube-lego* annotation (kube-lego was deprecated in 2018).
It does nothing on a cert-manager-based cluster. Loki's ingress block (unused, but present)
correctly used `cert-manager.io/cluster-issuer`, so the fix was just to match it.

### 8. A stray top-level key in the Prometheus values
```yaml
kubeStateMetrics:
  ...
  # Node Selector
nodeSelector:              # <- not indented under kubeStateMetrics: this is a ROOT key
  agentpool: "e864large"
```
This `nodeSelector` landed at the document root instead of nested under `kubeStateMetrics`, so
it had no effect on where kube-state-metrics actually scheduled. Classic YAML indentation bug —
worth grepping for after every edit to a deeply nested values file.

### 9. Alerts were defined but had nowhere to go
`alertmanager.enabled: false` (a deliberate choice to centralize on Grafana Unified Alerting)
plus `defaultRules.create: true` means Prometheus generates alerting *rules*, but with no
Alertmanager and no configured Grafana contact points/notification policies, firing alerts had
no delivery path. This is easy to miss because "alerts are defined" reads as "alerting works."

**Fix:** documented as a required follow-up in [Alerting](#alerting-still-a-todo) below —
intentionally not faking a webhook URL in the values file.

## Corrected architecture

| Component | Draft | Fixed |
|---|---|---|
| Prometheus | 1 replica (anti-affinity unused) | 2 replicas + anti-affinity, consistent `externalLabels` |
| Node metrics | Not collected anywhere | `prometheus.exporter.unix` inside Alloy |
| Loki | SingleBinary, 1 replica, local disk | SimpleScalable, write/read/backend ≥ 2-3 replicas, Azure Blob storage, `replication_factor: 3` |
| Grafana | 1 replica, SQLite, plaintext password | 2 replicas, external Postgres, `admin.existingSecret` |
| Alloy | Dead `__path__`, no CRI unwrapping, no node exporter | File-tailing pipeline with `stage.cri`, node exporter added |
| Ingress TLS | `kubernetes.io/tls-acme` (no-op) | `cert-manager.io/cluster-issuer` |

## Deployment order

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

kubectl create namespace monitoring

# 1. Secrets first — see "Secrets handling" below
kubectl -n monitoring create secret generic grafana-admin-credentials \
  --from-literal=admin-user=admin \
  --from-literal=admin-password="$(openssl rand -base64 24)"

# 2. Log collector
helm upgrade --install alloy grafana/alloy \
  --namespace monitoring -f values/alloy-values.yaml

# 3. Log storage (deploy before Grafana so the datasource resolves)
helm upgrade --install loki grafana/loki \
  --namespace monitoring -f values/loki-values.yaml --version 6.20.0

# 4. Metrics
helm upgrade --install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring -f values/prometheus-values.yaml --version 67.0.0

# 5. Dashboards
helm upgrade --install grafana grafana/grafana \
  --namespace monitoring -f values/grafana-values.yaml --version 10.5.8
```

Prometheus is deployed before Grafana here (reversed from the draft's order) because Grafana's
Postgres connection secret and the Prometheus/Loki datasource URLs should exist before Grafana
starts, avoiding a first-boot error loop.

## Secrets handling

Nothing in [values/](values/) contains a real credential. Three things need to exist in the
cluster before install, none of them committed to git:

1. `grafana-admin-credentials` Secret (`admin-user`, `admin-password` keys) — referenced by
   `admin.existingSecret` in [values/grafana-values.yaml](values/grafana-values.yaml).
2. `grafana-db-credentials` Secret (`GF_DATABASE_USER`, `GF_DATABASE_PASSWORD`) for the external
   Postgres connection.
3. Loki's object storage credential — prefer **Azure Workload Identity**
   (`useManagedIdentity: true` in [values/loki-values.yaml](values/loki-values.yaml)) over a
   static storage account key, so there's no long-lived secret to rotate or leak at all.

For a real environment, back these with Azure Key Vault + the Secrets Store CSI Driver or
External Secrets Operator rather than raw `kubectl create secret`.

## Alerting — still a TODO

This stack collects metrics/logs and evaluates Prometheus recording/alerting rules
(`defaultRules.create: true`), but nothing routes a firing alert to a human. Before calling this
"production-ready," add either:
- An Alertmanager config with real receivers (Slack/PagerDuty/email), or
- Grafana Unified Alerting contact points + notification policies (since Alertmanager is
  disabled here in favor of centralizing on Grafana).

Deliberately not stubbed out with a placeholder webhook — a fake receiver that looks configured
is worse than an obviously-missing one.

## Open items / things to validate against your cluster before go-live

- Confirm the `agentpool: e864large` node pool actually has ≥ 2 nodes, or Prometheus's
  anti-affinity will leave one replica permanently `Pending`.
- Confirm your cluster allows `system-node-critical` / `system-cluster-critical` priority
  classes outside `kube-system` (some policy-hardened clusters restrict this).
- Loki's `SimpleScalable` values below use the schema for chart `6.20.0` — re-check
  `helm show values grafana/loki --version <yours>` if you bump the chart version.
- 7-day Prometheus retention is short for real incident postmortems; consider longer retention
  or remote-writing to long-term storage (Thanos/Mimir) as a next step.
