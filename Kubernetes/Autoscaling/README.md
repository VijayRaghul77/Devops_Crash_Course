# KEDA Autoscaling — HPA-style + Time-based (Cron), via Helm

Hands-on example of autoscaling a Deployment with [KEDA](https://keda.sh) using a
single `ScaledObject` that combines two trigger styles:

1. **HPA-style / metric-based** — scales on a real signal (queue depth, CPU, Prometheus
   query, etc.), the same way a plain `HorizontalPodAutoscaler` would.
2. **Time-based (cron)** — forces a minimum replica count during known traffic windows,
   regardless of what the metric says.

The chart lives at [`helm/keda-scaledobject/`](helm/keda-scaledobject/). It is a
generalized, installable version of a real ScaledObject running in production
(`bot-live-exporter-queue-processor`, scaling an Azure Storage Queue consumer) — the
raw object is reproduced at the bottom of this file for reference.

## Why KEDA instead of a plain HPA

A standard `HorizontalPodAutoscaler` only understands metrics already exposed through
the Kubernetes metrics APIs (resource metrics from `metrics-server`, or custom/external
metrics adapters you've deployed yourself). **KEDA doesn't replace the HPA** — it
creates and manages one for you (`kubectl get hpa` shows `keda-hpa-<scaledobject-name>`)
and acts as the metrics adapter, so you can point it at ~60 built-in scalers (queues,
Kafka, Prometheus, cron, etc.) without writing a custom metrics server. `cpu`/`memory`
triggers in a ScaledObject still go through `metrics-server` just like a vanilla HPA;
external triggers (queue length, cron, Prometheus) bypass it entirely and are the only
ones that support **scaling to zero**.

## How the two trigger types combine

A `ScaledObject` accepts a list of `triggers`. KEDA evaluates every trigger on every
polling interval and **scales to the MAX replica count any single trigger asks for**
(OR logic for "should we be scaled up", not average/sum). That's what lets one
ScaledObject do both jobs at once:

```yaml
triggers:
  - type: azure-queue        # HPA-style: react to actual queue depth
    metadata:
      queueName: preqindocumentexporter
      queueLength: "3"
      connectionFromEnv: AzureWebJobsStorage
  - type: cron               # Time-based: guarantee capacity ahead of known load
    metadata:
      timezone: Asia/Kolkata
      start: "0 8 * * 1-5"
      end: "0 20 * * 1-5"
      desiredReplicas: "5"
```

- Outside 08:00–20:00 IST on weekdays, replicas track queue depth only (down to
  `minReplicaCount`, including 0).
- Inside that window, replicas never drop below 5, even if the queue is empty — and
  can still scale above 5 if the queue trigger asks for more.

## Chart layout

```
helm/keda-scaledobject/
├── Chart.yaml
├── values.yaml                     # all tunables — see comments inline
└── templates/
    ├── deployment.yaml              # target workload (scaleTargetRef)
    ├── secret.yaml                  # holds the queue connection string
    ├── triggerauthentication.yaml   # optional: secretTargetRef-based auth instead of connectionFromEnv
    ├── scaledobject.yaml            # renders keda.metricTriggers + keda.cronTriggers into spec.triggers
    └── NOTES.txt
```

### Key values (`values.yaml`)

| Key | Purpose |
|---|---|
| `keda.metricTriggers` | List of raw KEDA trigger blocks (`type` + `metadata`). Default is an `azure-queue` trigger; a commented-out `cpu` example shows the plain-HPA-equivalent form. |
| `keda.cronTriggers` | Simplified list of `{timezone, start, end, desiredReplicas}` — one entry per scaling window. |
| `keda.minReplicaCount` / `keda.maxReplicaCount` | Scaling bounds. `0` requires that at least one trigger be an external (non cpu/memory) type. |
| `keda.pollingInterval` / `keda.cooldownPeriod` | How often triggers are checked, and how long to wait after the last active trigger before scaling down. |
| `keda.fallback` | Replica count to hold steady if the metric source becomes unreachable (`failureThreshold` consecutive failed polls). |
| `secretEnv` | Connection string materialized into a Secret and wired into the pod via `connectionFromEnv`. |
| `keda.triggerAuthentication` | Set `enabled: true` to reference a `TriggerAuthentication` (`secretTargetRef`) instead of `connectionFromEnv`. |

## Prerequisites

- A Kubernetes cluster with the [KEDA operator](https://keda.sh/docs/latest/deploy/) installed
  (`helm install keda kedacore/keda -n keda --create-namespace`).
- `metrics-server` running if you use any `cpu`/`memory` trigger.

## Install / upgrade / uninstall

```bash
# render locally first
helm template demo ./helm/keda-scaledobject

# install
helm install demo ./helm/keda-scaledobject -n platform-apps --create-namespace

# change trigger config, e.g. switch the cron window or queue threshold
helm upgrade demo ./helm/keda-scaledobject -n platform-apps -f my-values.yaml

# remove — KEDA hands the Deployment back to its original replica count first
helm uninstall demo -n platform-apps
```

## Verifying it's working

```bash
# ScaledObject status — look for Ready=True, Active tells you if a trigger is currently firing
kubectl describe scaledobject demo-keda-scaledobject -n platform-apps

# the HPA KEDA created and is driving for you
kubectl get hpa -n platform-apps

# watch replicas move
kubectl get deployment demo-keda-scaledobject -n platform-apps -w
```

## Troubleshooting notes

- **`ScalerNotActive` / `Active: False`** is normal — it just means no trigger is
  currently asking for replicas above `minReplicaCount`. Not an error.
- **Scale-to-zero not happening**: check that every trigger you rely on for zero is an
  external type — `cpu`/`memory` triggers force a floor of 1 regardless of
  `minReplicaCount`.
- **Fallback active** (`status.conditions` → `Fallback: True`) means KEDA can't reach
  the metric source (e.g. bad `connectionFromEnv`, network policy blocking egress) and
  is holding `fallback.replicas` steady — fix connectivity/credentials, it clears
  automatically.
- **Cron trigger seems ignored**: cron respects `metadata.timezone` literally including
  DST — double check server time vs the timezone string, and that `start`/`end` are
  valid 5-field cron expressions.

## Reference: the real ScaledObject this chart is modeled on

```yaml
apiVersion: keda.sh/v1alpha1
kind: ScaledObject
metadata:
  name: bot-live-exporter-queue-processor
  namespace: platform-apps
spec:
  cooldownPeriod: 30
  fallback:
    behavior: static
    failureThreshold: 3
    replicas: 1
  maxReplicaCount: 30
  minReplicaCount: 0
  pollingInterval: 5
  scaleTargetRef:
    name: bot-live-exporter-queue-processor
  triggers:
    - type: azure-queue
      metadata:
        connectionFromEnv: AzureWebJobsStorage
        queueLength: "3"
        queueName: preqindocumentexporter
```

This chart's default `values.yaml` reproduces this trigger and adds a cron trigger
alongside it as the time-based example.
