# Jenkins CI/CD Pipeline

## Purpose
This example shows a production-grade Jenkins pipeline using a declarative pipeline script.

## Pipeline stages
- Checkout
- Build
- Test
- Security Scan
- Deploy Dev
- Deploy Staging
- Deploy Prod

## Interview talking points
- Jenkins uses Jenkinsfile for pipeline definition
- `stage` blocks organize the workflow clearly
- `when` conditions can control execution based on branch or environment
- Jenkins agents can run builds on different machines
- Post actions can trigger notifications or cleanup

## Example pipeline
See [Jenkinsfile](Jenkinsfile).
