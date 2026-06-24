# Azure DevOps CI/CD Pipeline

## Purpose
This example shows how to design a production-grade pipeline in Azure DevOps using YAML.

## Pipeline stages
- Build
- Test
- Security scan
- Deploy to Dev
- Deploy to Staging
- Deploy to Production

## Interview talking points
- Azure DevOps uses YAML pipelines with stages and jobs
- The `dependsOn` keyword controls job order
- Approvals can be configured at environment level
- Variables and secure files help manage config safely
- Deployment jobs are useful for environment-specific rollouts

## Example pipeline
See [azure-pipeline.yml](azure-pipeline.yml).
