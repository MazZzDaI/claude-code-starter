---
description: Help write tests for code
---

Help write tests for the specified code.

**Testing strategy:**

1. **Determine the test type:**
   - Unit test (function, hook)
   - Component test (UI component)
   - Integration test (Server Action, API)
   - E2E test (user flow)

2. **Determine what to test:**
   - Happy path (main scenario)
   - Edge cases (boundary cases)
   - Error cases (error handling)
   - Various input data

3. **Set up the environment:**
   - Required mocks (Supabase, OpenAI, etc)
   - Test data
   - Helpers

4. **Write the tests:**
   - Arrange (preparation)
   - Act (action)
   - Assert (verification)

5. **Coverage:**
   - All main scenarios are covered
   - Edge cases are accounted for
   - Errors are handled

**Example structure:**

```typescript
describe('ComponentName', () => {
  describe('when user is authenticated', () => {
    it('should render correctly', () => {
      // test
    })

    it('should handle submit', () => {
      // test
    })
  })

  describe('when user is not authenticated', () => {
    it('should redirect to login', () => {
      // test
    })
  })

  describe('error handling', () => {
    it('should show error message on failure', () => {
      // test
    })
  })
})
```

**Best practices:**
- Test behaviour, not implementation
- Use clear test names
- Isolate tests from one another
- Mock external dependencies
- Check both success and error cases

See `.claude/testing-guide.md` for details.
