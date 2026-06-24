# Terraform + CI/CD Pipeline

## Purpose
This section shows how Terraform can be used in a production-grade CI/CD workflow to provision infrastructure safely.

## Typical flow
1. Validate Terraform files
2. Run `terraform fmt` and `terraform init`
3. Run `terraform plan`
4. Approve and apply changes
5. Store state securely

## Key interview topics
- What is Infrastructure as Code?
- Why use Terraform over manual provisioning?
- Difference between `plan` and `apply`
- Why remote state is important
- How to use workspaces or environments for dev/staging/prod

## Example files
- [main.tf](main.tf)
- [variables.tf](variables.tf)
- [terraform-pipeline.yml](terraform-pipeline.yml)
