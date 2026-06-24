# Kubernetes CI/CD Pipeline

## Purpose
This section shows how a production CI/CD pipeline can deploy an application to Kubernetes.

## Typical pipeline flow
1. Build the image
2. Run tests and security checks
3. Push the image to a registry
4. Update Kubernetes manifests
5. Deploy to dev/staging/prod

## Key interview topics
- Difference between a Deployment and a Service
- Why use Kubernetes manifests and Helm charts
- How rolling updates work
- How readiness and liveness probes help production stability
- How to handle rollback in Kubernetes

## Example files
- [deployment.yaml](deployment.yaml)
- [service.yaml](service.yaml)
- [k8s-pipeline.yaml](k8s-pipeline.yaml)
