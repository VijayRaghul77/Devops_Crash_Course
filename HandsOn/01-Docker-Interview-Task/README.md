# Docker Interview Task

## Goal
Learn how Docker works by building, running, and testing a simple web app.

## Learning objectives
- Understand the difference between an image and a container
- Learn how Dockerfiles define app setup
- Practice exposing ports and testing endpoints
- Understand why containerization is useful in DevOps interviews

## Task
1. Build the Docker image.
2. Run the container.
3. Test the `/` and `/health` endpoints.
4. Review the Dockerfile and explain each instruction.
5. Answer the interview questions listed below.

## Files in this task
- `app.py` — simple Python web server
- `Dockerfile` — image definition
- `docker-compose.yml` — container orchestration setup

## Commands to run
```bash
docker build -t devops-demo .
docker run -p 8000:8000 devops-demo
```

Then open:
- http://localhost:8000/
- http://localhost:8000/health

## Interview questions
- What is the difference between a Docker image and a container?
- Why do we use `EXPOSE` in a Dockerfile?
- What is the difference between `CMD` and `ENTRYPOINT`?
- Why is Docker useful for DevOps workflows?
- How would you troubleshoot a container that exits immediately?

## Bonus challenge
Use Docker Compose to start the app and explain what each section in the YAML file is doing.
