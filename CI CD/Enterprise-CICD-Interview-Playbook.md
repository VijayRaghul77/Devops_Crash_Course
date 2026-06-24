# Enterprise CI/CD Interview Playbook

This playbook is meant to help you crack enterprise DevOps interviews by combining theory, practical flow, and answer structure.

## A. How to structure your answer
When asked about CI/CD, use this flow:
1. Trigger: commit, PR, or manual workflow
2. Validation: lint, unit tests, security checks
3. Build: compile/package artifact
4. Artifact store: registry or package repository
5. Environment deployment: dev, staging, production
6. Approval and monitoring: production gate and rollback

## B. Strong sample answer
> A production-grade CI/CD pipeline starts when code is pushed or a pull request is created. The pipeline checks out code, runs linting and unit tests, performs security scans, builds a verified artifact, pushes it to a registry, and deploys it to dev and staging. Production deployment is gated with approvals and health checks. The pipeline also supports rollback using versioned artifacts and monitoring.

## C. Interview questions with strong points
### 1. How do you secure secrets?
Use secret stores, environment-scoped variables, RBAC, avoid plaintext secrets, rotate them regularly.

### 2. How do you handle rollback?
Keep previous versions, use immutable artifacts, redeploy known-good versions, monitor health after rollback.

### 3. What is a good deployment strategy?
Rolling for low-risk updates, blue-green for safer cutover, canary for gradual traffic increase.

### 4. How do you ensure quality?
Use linting, test coverage, code scanning, security scanning, and approvals.

### 5. Why is artifact promotion important?
It avoids rebuilding and ensures the exact same tested artifact moves across environments.

## D. Enterprise checklist before interview
- Can explain CI/CD end to end
- Can explain secret management
- Can explain deployment strategies
- Can explain Kubernetes deployment flow
- Can explain Terraform in pipelines
- Can explain monitoring, rollback, and incident recovery
