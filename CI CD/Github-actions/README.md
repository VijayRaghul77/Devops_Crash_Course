# GitHub Actions CI/CD Pipeline

## Purpose
This example shows a production-grade GitHub Actions pipeline for a Python web app.

## Pipeline stages
1. `lint-and-verify` — run syntax checks
2. `test` — run unit tests
3. `build` — build container image
4. `security-scan` — run vulnerability scan
5. `deploy-dev` — deploy to development environment
6. `deploy-staging` — deploy to staging after approval
7. `deploy-prod` — deploy to production after approval

## Interview talking points
- Use `workflow_dispatch` to manually trigger a run
- Use `needs:` to enforce stage order
- Use environment protection rules for prod deployment
- Use secrets for credentials and tokens
- Use artifact retention and caching for performance

## Example workflow file
See [ci-cd-pipeline.yml](ci-cd-pipeline.yml).
