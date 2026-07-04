# DevOps Interview Questions with Strong Answers

This file is designed for interview prep from beginner fundamentals to production-grade DevOps knowledge.

## 1. Linux and scripting

1. What is the difference between a process and a thread?
   - A process is an independent running instance of a program, while a thread is a lightweight unit of execution within a process.

2. What is the purpose of chmod in Linux?
   - It changes file permissions so the owner, group, or others can read, write, or execute the file.

3. What is the difference between apt and yum?
   - They are package managers; apt is used on Debian/Ubuntu systems, while yum/dnf is used on RHEL/CentOS/Fedora.

4. How do you check running processes in Linux?
   - Use ps, top, or htop to inspect active processes.

5. What is the difference between a service and a daemon?
   - A service is a managed background process, often controlled by systemd, while a daemon is a long-running background process.

6. What is a shell script used for in DevOps?
   - It automates repetitive system tasks such as deployment, backup, or environment setup.

## 2. Git and version control

7. What is the difference between git pull and git fetch?
   - git fetch downloads changes without merging them, while git pull fetches and merges immediately.

8. What is a merge conflict?
   - It happens when two branches modify the same lines of a file in different ways and Git cannot automatically reconcile them.

9. What is the difference between git merge and git rebase?
   - merge preserves history, while rebase rewrites it to create a cleaner linear history.

10. Why are pull requests important?
   - They enable review, quality checks, and controlled collaboration before code enters the main branch.

11. What is the difference between main and develop branches?
   - main usually represents production-ready code, while develop is used for ongoing integration work.

12. What is a git stash used for?
   - It temporarily stores uncommitted changes so you can switch contexts safely.

## 3. Docker and containers

13. What is the difference between a Docker image and a container?
   - An image is a read-only blueprint, while a container is a running instance of that image.

14. What is a Dockerfile?
   - It defines the steps to build a container image.

15. Why do we use Docker Compose?
   - It defines and runs multi-container applications with a single configuration file.

16. What is the difference between CMD and ENTRYPOINT?
   - CMD provides default arguments, while ENTRYPOINT defines the executable that runs inside the container.

17. What is a container volume used for?
   - It persists data outside the container lifecycle and enables sharing data between containers or the host.

18. How do you troubleshoot a container that exits immediately?
   - Check the logs, inspect the exit code, verify the command, and review environment variables and dependencies.

## 4. CI/CD and pipelines

19. What is CI/CD?
   - CI is continuous integration, where code is automatically validated and tested; CD is continuous delivery or deployment to environments.

20. What is the purpose of a build stage?
   - It compiles or packages the application so it is ready for testing and deployment.

21. What is the purpose of a test stage?
   - It validates code quality and catches regressions before deployment.

22. What is artifact promotion?
   - It means moving the same tested build artifact through dev, staging, and production rather than rebuilding it each time.

23. How do you secure secrets in a pipeline?
   - Use secret stores or environment-scoped variables, avoid hardcoding, and restrict access with RBAC.

24. Why are approvals important in production deployments?
   - They add human control and reduce the chance of accidental or risky changes reaching production.

25. What is the difference between continuous delivery and continuous deployment?
   - Continuous delivery requires manual approval before production release, while continuous deployment automates it.

## 5. Kubernetes

26. What is a Kubernetes pod?
   - A pod is the smallest deployable unit and usually hosts one or more tightly coupled containers.

27. What is the difference between a Deployment and a Service?
   - A Deployment manages replica sets and rollout behavior, while a Service exposes pods to traffic.

28. What is a ConfigMap used for?
   - It stores configuration data separately from application code.

29. What is a Secret used for?
   - It stores sensitive information such as passwords, tokens, and certificates.

30. What are readiness and liveness probes?
   - Readiness probes check if a pod is ready to receive traffic, while liveness probes check if it should be restarted.

31. What is a rolling update?
   - It updates pods gradually so the application remains available during deployment.

32. What is the difference between blue-green and canary deployment?
   - Blue-green switches traffic between two full environments, while canary sends traffic to a small subset first.

## 6. Terraform and IaC

33. What is Terraform?
   - Terraform is an infrastructure-as-code tool used to define and provision cloud and infrastructure resources declaratively.

34. What is the purpose of Terraform state?
   - State tracks the real infrastructure managed by Terraform so it can plan and apply changes safely.

35. What is the difference between plan and apply?
   - plan shows what will change, while apply executes the changes.

36. Why is infrastructure as code important?
   - It makes environments repeatable, version-controlled, and easier to audit.

37. What is a module in Terraform?
   - A module is a reusable group of resources and configuration.

## 7. Monitoring and reliability

38. Why is monitoring important in production?
   - It helps detect issues early, reduce downtime, and give visibility into application health.

39. What is the difference between logs and metrics?
   - Logs record events, while metrics are numeric measurements over time.

40. What is an alerting threshold?
   - It is a rule that triggers a notification when a metric crosses a defined limit.

41. What is a rollback strategy?
   - It is the process of reverting to a previous known-good version when a deployment fails.

42. How do you handle a production incident?
   - Triage the issue, identify impact, mitigate quickly, communicate clearly, and document the root cause.

## 8. Security and governance

43. What is the principle of least privilege?
   - Give users and services only the minimum permissions required to do their job.

44. Why should secrets not be stored in source code?
   - Because they can be exposed, leaked, and abused by unauthorized users.

45. What is RBAC?
   - Role-Based Access Control restricts access based on the user’s role.

46. How do you scan container images for vulnerabilities?
   - Use image scanning tools such as Trivy, Grype, or a registry-integrated scanner.

47. Why is code review important?
   - It improves quality, shares knowledge, and reduces mistakes before changes reach shared environments.

## 9. Production thinking

48. How would you explain a full DevOps workflow to an interviewer?
   - Start with code changes, move through version control, validation, build, testing, packaging, deployment, monitoring, and rollback.

49. What makes a pipeline production-grade?
   - It is secure, repeatable, observable, approved for production, and designed with rollback and recovery in mind.

50. What skills matter most for a DevOps engineer?
   - Strong fundamentals in Linux, networking, Git, automation, cloud basics, CI/CD, containers, and troubleshooting.
