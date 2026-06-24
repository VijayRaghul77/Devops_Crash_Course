# GitLab CI/CD Pipeline

## Purpose
This example demonstrates a production-grade GitLab CI pipeline.

## Pipeline stages
- build
- test
- security
- deploy-dev
- deploy-staging
- deploy-prod

## Interview talking points
- GitLab CI uses `.gitlab-ci.yml`
- Stages run sequentially unless configured otherwise
- Jobs can use `rules` to control when they run
- GitLab environments help track deployments
- Artifacts can be shared between jobs

## Example pipeline
See [.gitlab-ci.yml](.gitlab-ci.yml).
