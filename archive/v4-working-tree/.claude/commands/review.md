---
description: Conduct a code review of recent changes
---

Conduct a detailed code review of the recent changes in the project.

**What to check:**

1. **Security:**
   - Validation of all user input
   - Authorisation checks in Server Actions
   - No SQL injections
   - XSS protection
   - No leaked secrets

2. **Code quality:**
   - Compliance with coding standards (.claude/coding-standards.md)
   - TypeScript types are correct and strict
   - No use of `any`
   - Clear variable and function names
   - Comments for complex logic

3. **Architecture:**
   - Compliance with project patterns (.claude/architecture.md)
   - Correct separation of Client/Server Components
   - Correct use of Server Actions
   - No code duplication

4. **Performance:**
   - No unnecessary re-renders
   - Memoisation used where needed
   - Database queries optimised
   - No blocking operations

5. **Testability:**
   - Code is easy to test
   - Functions are not overly complex
   - Logic is separated from UI

**Response format:**

For each file, state:
- ✅ What was done well
- ⚠️ What could be improved (with code examples)
- ❌ Critical problems (require fixing)

At the end, give an overall assessment and top-3 recommendations.
