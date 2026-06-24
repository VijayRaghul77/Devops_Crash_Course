# Top 20 CI/CD Interview Questions with Model Answers

## 1. What is CI/CD?
**Model Answer:**
CI/CD stands for Continuous Integration and Continuous Delivery/Deployment. CI focuses on automatically integrating code changes and running validations. CD focuses on automatically delivering or deploying the application to environments after validation.

## 2. What is the difference between Continuous Delivery and Continuous Deployment?
**Model Answer:**
Continuous Delivery ensures the code is always ready to deploy, but a human or approval step may be needed before release. Continuous Deployment automates the release to production once the checks pass.

## 3. Why is CI important?
**Model Answer:**
CI helps detect issues early, improves code quality, reduces integration conflicts, and gives faster feedback to developers.

## 4. What are the main stages of a production pipeline?
**Model Answer:**
Typical stages are checkout, build, unit test, lint/static analysis, security scan, packaging, deploy to dev, deploy to staging, and deploy to production.

## 5. How do you secure secrets in CI/CD?
**Model Answer:**
Secrets should be stored in secret management tools such as GitHub Secrets, Azure Key Vault, GitLab CI variables, or Jenkins credentials. They should never be hardcoded.

## 6. What is artifact promotion?
**Model Answer:**
Artifact promotion means reusing a verified build artifact from one environment to another instead of rebuilding it every time.

## 7. How do you handle rollback in CI/CD?
**Model Answer:**
Rollback can be done by redeploying a previous known-good version, using versioned artifacts, or using deployment strategies such as blue-green or rolling updates.

## 8. What is a blue-green deployment?
**Model Answer:**
Blue-green deployment keeps two environments live, one active and one inactive. A new version is deployed to the inactive one and switched over when ready.

## 9. What is a rolling deployment?
**Model Answer:**
A rolling deployment updates pods or instances gradually to reduce downtime and risk.

## 10. What is the role of unit tests in CI/CD?
**Model Answer:**
Unit tests verify individual components and catch issues early before code reaches later stages.

## 11. What is the importance of code quality tools?
**Model Answer:**
Tools such as linting, static analysis, and code scanners help maintain standards and identify vulnerabilities before deployment.

## 12. How do you decide when to deploy to production?
**Model Answer:**
Production deployment should happen only after required tests, security checks, approvals, and health validations pass.

## 13. What is the difference between `build`, `test`, and `deploy` stages?
**Model Answer:**
Build creates the deployable artifact, test validates correctness and quality, and deploy pushes the artifact to an environment.

## 14. Why should pipelines be idempotent?
**Model Answer:**
Idempotency ensures rerunning a pipeline produces the same result and avoids accidental side effects.

## 15. What is the purpose of environment approvals?
**Model Answer:**
Approvals add control for critical environments like production and reduce the risk of accidental releases.

## 16. What is the difference between a container image and a container?
**Model Answer:**
A container image is the immutable packaged application and dependencies. A container is a running instance of that image.

## 17. What are readiness and liveness probes in Kubernetes?
**Model Answer:**
Readiness probes tell Kubernetes when a pod is ready to receive traffic. Liveness probes detect if the application is stuck and should be restarted.

## 18. Why is Infrastructure as Code useful?
**Model Answer:**
It makes infrastructure repeatable, version-controlled, reviewable, and easier to automate.

## 19. How do you troubleshoot a failed pipeline?
**Model Answer:**
I review logs, confirm the failing stage, reproduce locally if possible, inspect config and dependencies, and check recent code or environment changes.

## 20. How do you explain CI/CD in an interview?
**Model Answer:**
I explain that CI/CD automates the path from code change to validated, safe deployment. It reduces manual effort, improves reliability, and helps teams ship faster with confidence.
