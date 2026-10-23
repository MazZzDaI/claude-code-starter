---
name: testing
description: "Running project tests: unit, integration. Detecting the project type and choosing a strategy."
allowed-tools: Read Glob Grep Bash
disable-model-invocation: true
---

# Skill: Testing

## Detecting the test environment

```bash
# Node.js project
if [ -f "package.json" ]; then
  echo "node"
  cat package.json | grep -A5 '"scripts"' | grep test
fi

# Python project
if [ -f "pyproject.toml" ] || [ -f "pytest.ini" ] || [ -f "setup.py" ]; then
  echo "python"
fi
```

## Running tests

### Node.js
```bash
npm test
```

### Python
```bash
python3 -m pytest tests/ -v
```

## Interpreting the results

- **All green:** report "tests passed" with the count
- **Some red:** show the list of failed tests, propose a fix
- **No tests:** report it, offer to create a basic set

## When to run

- After every significant commit
- As part of `/finish`
- On the user's explicit request
- After the `implementer` subagent has worked

## Coverage (if configured)

```bash
# Node.js
npx jest --coverage 2>/dev/null || true

# Python
python3 -m pytest --cov=src tests/ 2>/dev/null || true
```

Show the coverage summary, if available.
