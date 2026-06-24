# CI/CD Interview Questions and Answers

## GitHub Actions
### Q1. What is the difference between `workflow_dispatch` and `push` triggers?
**Answer:**
- `push` runs automatically when code is pushed to a branch.
- `workflow_dispatch` allows a user to manually trigger the pipeline from the UI.

### Q2. Why do we use `needs:` in GitHub Actions?
**Answer:**
- `needs:` ensures one job waits for another job to complete successfully before running.
- This enforces correct pipeline order.

### Q3. How do you secure secrets in GitHub Actions?
**Answer:**
- Store them in GitHub Secrets.
- Use environment-scoped secrets for different environments.
- Never hardcode secrets in YAML files.

## Azure DevOps
### Q1. What is the role of stages in Azure DevOps pipelines?
**Answer:**
- Stages represent high-level phases such as build, test, and deploy.
- They help visually organize and control deployment flow.

### Q2. What is the difference between a job and a deployment job?
**Answer:**
- A job runs scripts on a runner.
- A deployment job is designed for environment-based deployments and approvals.

## GitLab CI
### Q1. What does `stages` define in GitLab CI?
**Answer:**
- It defines the order in which jobs run.
- Jobs in the same stage run in parallel unless constrained.

### Q2. How do you control job execution in GitLab CI?
**Answer:**
- Use `rules`, `only`, or `except` to decide when jobs run.

## Jenkins
### Q1. What is the purpose of a Jenkinsfile?
**Answer:**
- It stores the pipeline definition as code.
- It allows version control of pipeline logic.

### Q2. What is the difference between declarative and scripted pipelines?
**Answer:**
- Declarative pipelines are structured and easier to read.
- Scripted pipelines are more flexible and allow custom logic.

## Kubernetes
### Q1. What is the difference between a Deployment and a Service?
**Answer:**
- A Deployment manages pods and rollout behavior.
- A Service exposes pods to the network.

### Q2. Why are readiness and liveness probes important?
**Answer:**
- Readiness ensures traffic is sent only to healthy pods.
- Liveness restarts containers if they are stuck.

## Terraform
### Q1. What is Infrastructure as Code?
**Answer:**
- It is the practice of defining infrastructure using code instead of manual steps.

### Q2. Why should you avoid applying Terraform changes manually in production?
**Answer:**
- Manual changes create drift.
- CI/CD ensures traceability, review, and repeatability.
