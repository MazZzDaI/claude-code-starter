---
name: playwright
description: "E2E UI testing with Playwright. Running and creating tests, analysing results."
paths:
  - "src/**/*.tsx"
  - "src/**/*.jsx"
  - "src/**/*.vue"
  - "src/**/*.svelte"
  - "pages/**/*"
  - "app/**/*"
  - "tests/e2e/**/*"
  - "e2e/**/*"
allowed-tools: Read Edit Write Glob Grep Bash
disable-model-invocation: true
---

# Skill: Playwright E2E Testing

## Environment check

```bash
# Check whether Playwright is installed
npx playwright --version 2>/dev/null || echo "Playwright not installed"
```

If it is not installed:
```bash
npm install -D @playwright/test
npx playwright install chromium
```

## Running existing tests

```bash
npx playwright test
```

With a UI report:
```bash
npx playwright test --reporter=html
```

## Creating a new test

When creating an E2E test:

1. Define the scenario (user flow)
2. Create a file in `tests/e2e/` or `e2e/`
3. Use the pattern:

```typescript
import { test, expect } from '@playwright/test';

test('scenario description', async ({ page }) => {
  await page.goto('/');
  // ... actions
  await expect(page.locator('selector')).toBeVisible();
});
```

## When to use

- After changes to UI components
- After changes to routing
- After changes to forms and interactive elements
- Before a production deploy (mandatory)

## Failure analysis

When a test fails:
1. Show the error screenshot (if there is one in `test-results/`)
2. Show the trace (if enabled)
3. Determine: a bug in the code or an outdated test
4. Propose a fix
