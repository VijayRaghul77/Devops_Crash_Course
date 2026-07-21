# private-nginx

Helm chart for running Nginx in a completely private, network-isolated
environment — no path in from outside the cluster, and no path out except
DNS.

## What "completely private" means here

| Concern | How it's handled |
|---|---|
| External exposure | `Service` is `ClusterIP` only. No `Ingress`, `NodePort`, or `LoadBalancer` is created by this chart. |
| Lateral movement (ingress) | A `NetworkPolicy` selects the pod for `Ingress` and `Egress`, which makes Kubernetes deny everything by default. Only traffic matching `networkPolicy.ingress.allowFrom`/`ports` is permitted. |
| Data exfiltration (egress) | Egress is denied except DNS (`networkPolicy.egress.allowDNS`) and anything explicitly added to `networkPolicy.egress.allowTo`. |
| Container escape / privilege escalation | Pod and container run as a fixed non-root UID/GID, `allowPrivilegeEscalation: false`, all Linux capabilities dropped, `readOnlyRootFilesystem: true`, `seccompProfile: RuntimeDefault`. |
| Token leakage | `automountServiceAccountToken: false` — the pod has no Kubernetes API credentials at all. |
| Private registries | Set `image.pullSecret` to reference an existing `imagePullSecret` if pulling from a private registry. |

Because the root filesystem is read-only, Nginx's default writable paths
(`/var/cache/nginx`, PID file, temp dirs) are redirected to `emptyDir`
volumes / `/tmp` via the custom `nginx.conf` in `values.yaml`, and the
container listens on port 8080 (non-privileged) instead of 80.

## Install

```bash
helm install my-nginx . -n my-private-ns --create-namespace
```

## Verify it's actually private

```bash
# Should have no external IP / no Ingress object
kubectl get svc,ingress -n my-private-ns

# Should show ingress+egress rules restricted to what's in values.yaml
kubectl describe networkpolicy -n my-private-ns

# Reach it only from an allowed pod inside the cluster
kubectl run -it --rm debug --image=busybox --restart=Never -n my-private-ns -- \
  wget -qO- http://my-nginx-private-nginx.my-private-ns.svc.cluster.local
```

## Key values

```yaml
service.type: ClusterIP        # keep as ClusterIP for a private deployment
networkPolicy.enabled: true
networkPolicy.ingress.allowFrom:
  - podSelector: {}            # restrict further, e.g. to a specific app label,
                                # or add a namespaceSelector for cross-namespace access
networkPolicy.egress.allowDNS: true
networkPolicy.egress.allowTo: []  # add entries only if this nginx must call out somewhere
image.pullSecret: ""           # set if pulling from a private registry
```

Tighten `networkPolicy.ingress.allowFrom` beyond the default (`podSelector: {}`,
i.e. any pod in the same namespace) by scoping it to a specific label selector,
e.g.:

```yaml
networkPolicy:
  ingress:
    allowFrom:
      - podSelector:
          matchLabels:
            app.kubernetes.io/name: my-frontend
```
