---
paths:
  - "**/deploy/**"
  - "**/infra/**"
  - "**/production/**"
  - "**/.env.production"
  - "**/Dockerfile"
  - "**/docker-compose.prod*"
---

# Rule: Production Safety

## Principle

Anything touching production requires the user's confirmation. Everything else — full autonomy.

## Requires confirmation

- Deploy to a production server
- Changes to the production database (migrations, data)
- Changes to DNS, domain, SSL
- Changes to production environment variables
- Push to main/master (if it is the production branch)
- Publishing a package (npm publish, PyPI upload)
- Changes to the CI/CD pipeline for production

## Full autonomy (don't ask)

- Creating, changing, deleting files in the project
- Running tests (unit, integration, E2E)
- Git operations: commit, branch, merge (except push to production)
- Staging deploy
- Local development
- Installing dependencies
- Refactoring code
- Creating and updating documentation

## How to ask

Briefly. Without unnecessary explanations:

```
Production deploy ready:
- [what will be deployed]
- [what changes]
Confirm? (y/n)
```
