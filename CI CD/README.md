# CI/CD Interview Preparation Repository

This folder is designed for DevOps interview preparation and hands-on practice.

## Goal
Build a production-grade understanding of how CI/CD pipelines work across major tools and enterprise scenarios:
- GitHub Actions
- Azure DevOps
- GitLab CI
- Jenkins
- Kubernetes deployment flow
- Terraform automation

## What you will learn
- Build, test, scan, and deploy workflows
- Pipeline stages and approval gates
- Artifact promotion from dev to staging to production
- Rollback and troubleshooting strategies
- Security, governance, and monitoring for enterprise pipelines
- Interview-ready explanations for each tool

## Suggested interview topics
- What is CI/CD?
- Difference between continuous integration, delivery, and deployment
- Why we use stages like build, test, security, deploy
- How to handle secrets and environment-specific configs
- How to troubleshoot failed pipelines
- How to design a rollback strategy
- What are the best practices for enterprise CI/CD pipelines

## Repository layout
- [sample-app](sample-app) — example application used by pipeline demos
- [Github-actions](Github-actions) — GitHub Actions workflow example
- [Azure Devops](Azure%20Devops) — Azure DevOps YAML pipeline example
- [Gitlab](Gitlab) — GitLab CI example
- [Jenkins](Jenkins) — Jenkins declarative pipeline example
- [Kubernetes](Kubernetes) — deployment and rollout examples
- [Terraform](Terraform) — infrastructure as code validation flow
- [Interview-Questions](Interview-Questions) — Q&A practice material
- [Practice-Checklists](Practice-Checklists) — interview practice checklist
- [Enterprise-Production-Grade-CICD-Guide.md](Enterprise-Production-Grade-CICD-Guide.md) — enterprise blueprint
- [Enterprise-CICD-Interview-Playbook.md](Enterprise-CICD-Interview-Playbook.md) — interview answer guide

## Production-grade pipeline principles
1. Use separate stages for build, test, scan, and deploy
2. Keep secrets in secure stores and never hardcode them
3. Use artifact promotion instead of rebuilding from source each time
4. Add approvals for production deployments
5. Ensure rollback and monitoring are part of the process
6. Make pipelines idempotent and deterministic
7. Use immutable artifacts and versioned releases
8. Enforce policy checks and code review gates
9. Run security and compliance scans before production
10. Ensure observability and auditability for every deployment

## Hands-on flow
1. Read the sample app README
2. Study one pipeline example at a time
3. Run tests locally
4. Compare how the same flow looks in each CI/CD tool
5. Practice explaining the pipeline in interview language
6. Rehearse the enterprise rollout and rollback story for interviews
