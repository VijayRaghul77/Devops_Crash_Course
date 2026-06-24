# Sample Application for CI/CD Practice

This sample app is used to demonstrate a production-grade CI/CD flow.

## App purpose
A minimal web service that exposes:
- `/` — welcome message
- `/health` — health check endpoint

## Suggested local checks
```bash
python app.py
curl http://localhost:8000/health
```

## CI/CD learning points
- Build step should verify the app can run
- Test step should run syntax or unit checks
- Docker build can validate packaging
- Health endpoint can be used for post-deploy validation
