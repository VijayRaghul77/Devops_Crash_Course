# Opensearch

Notes and hands-on exercises for Opensearch as part of the DevOps crash course.

Helm values/manifests for an OpenSearch 3.5.0 cluster + Dashboards on AKS live in
[helm/](helm/). This is a 3-role cluster (master/cluster_manager, data, client) deployed
with the official `opensearchproject/opensearch` and `opensearchproject/opensearch-dashboards`
Helm charts, fronted by nginx ingress.

## Deploy order

```bash
kubectl apply -f helm/00-namespace.yaml
# Fill in real values first — see the comments in each file
kubectl apply -f helm/01-alpha-secrets.yaml
kubectl apply -f helm/02-keystore-secret.yaml
kubectl create secret docker-registry acr-auth -n opensearch \
  --docker-server=botml.azurecr.io --docker-username=<user> --docker-password=<pass>

helm install opensearch-cluster opensearch/opensearch -n opensearch -f helm/master-values.yaml
helm upgrade opensearch-cluster opensearch/opensearch -n opensearch -f helm/data-values.yaml
helm upgrade opensearch-cluster opensearch/opensearch -n opensearch -f helm/client-values.yaml
helm install opensearch-dashboards opensearch/opensearch-dashboards -n opensearch -f helm/dashboard.yaml

kubectl apply -f helm/ingress-base.yaml
```

## Changes made vs. the original drafts

These files started as three near-duplicate `*-values.yaml` drafts with a few real bugs
and one leaked-secret file. Fixed while consolidating:

- **Leaked credentials removed.** `alpha-secrets.yaml` had a real Azure Storage account
  key and admin password committed as base64 (base64 ≠ encryption). Replaced with
  `stringData` placeholders — rotate that storage key if it was ever pushed to a shared
  remote.
- **`keystore-secrets` didn't exist.** All three node-group files reference
  `keystore: [{secretName: keystore-secrets}]` for the `repository-azure` plugin, but no
  such secret was defined anywhere — pods would fail on keystore init. Added
  `02-keystore-secret.yaml`.
- **Admin password wired to a secret, not a literal.** The same plaintext password was
  copy-pasted across all three values files. It's actually a no-op today since
  `plugins.security.disabled` / `DISABLE_SECURITY_PLUGIN` are both `true` — OpenSearch
  never checks it. Now sourced via `secretKeyRef` from `alpha-secrets.opensearch-admin-secret`
  so it's live the moment security is re-enabled, and there's one password to rotate, not three.
- **Client `Service` was `LoadBalancer`.** Combined with the security plugin being
  disabled cluster-wide, that was a public IP with zero authentication in front of the
  full OpenSearch HTTP API (read/write/delete on every index). `ingress-base.yaml` already
  exposes the same client Service externally at `/os` behind TLS, so the LoadBalancer was
  redundant on top of being a bigger hole. Changed to `ClusterIP`.
- **Master was missing the Prometheus plugin.** `serviceMonitor` was enabled on all three
  roles scraping `/_prometheus/metrics`, but only `data`/`client` installed the
  `prometheus-exporter` plugin — master's `serviceMonitor` would have scraped a
  nonexistent endpoint. Enabled it on master too, matching data/client.
- **`imagePullSecrets` missing on `client`/`data`.** All node images pull from the private
  `botml.azurecr.io` mirror; only `master`/`dashboard` had the pull secret. Added
  `acr-auth` to `client-values.yaml` and `data-values.yaml`.
- **Dashboards pinned a minor version behind the cluster** (`3.0.0` vs. the cluster's
  `3.5.0`). Bumped to `3.5.0` (confirmed that tag exists on Docker Hub) to keep the
  Dashboards↔OpenSearch API compatible.
- **Dead `pathType: ImplementationSpecific` field removed from `dashboard.yaml`.** The
  dashboards chart's `templates/ingress.yaml` hardcodes `pathType: Prefix` — there's no
  values field for it, so it was silently ignored either way. Confirmed via
  `helm template` diff before/after removing it.

All four values files were verified with `helm lint` and `helm template` against the
real `opensearch`/`opensearch-dashboards` 3.5.0 charts (not just YAML-syntax checked) —
confirmed the client Service renders as `ClusterIP`, the admin password renders as a
`secretKeyRef`, and the dashboards Ingress backend renders correctly.

## Known, deliberately-unfixed tradeoffs

- **Security plugin is disabled cluster-wide** (`plugins.security.disabled: true`,
  `DISABLE_SECURITY_PLUGIN: true`) and `ingress-base.yaml` allows CORS from `*`. That's a
  reasonable simplification for a learning cluster on a locked-down network, but it means
  anything that can reach the ingress host or a Pod's ClusterIP has unauthenticated
  read/write/delete on all data. Don't reuse this config for anything beyond a private
  dev/test exercise without re-enabling the security plugin and tightening CORS.
- **Dashboards image isn't mirrored to ACR** like the OpenSearch node images are — it
  pulls straight from Docker Hub. Left as-is since it wasn't clear whether that's
  intentional; mirror it if the cluster's egress is locked down or you're hitting
  Docker Hub's anonymous pull rate limit.
