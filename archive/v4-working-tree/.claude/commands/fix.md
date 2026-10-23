---
description: Help find and fix a bug
---

Help find and fix a bug in the project.

**Debugging process:**

1. **Gathering information:**
   - What is the expected behaviour?
   - What actually happens?
   - Are there errors in the console?
   - When does the problem occur?
   - Can it be reproduced?

2. **Code analysis:**
   - Study the related files
   - Check recent changes
   - Find potential causes

3. **Hypotheses:**
   - Propose possible causes of the bug
   - Prioritise by likelihood

4. **Verification:**
   - Add logging if needed
   - Check the data in the database
   - Test the hypotheses

5. **Fix:**
   - Propose a solution
   - Explain why it works
   - Make sure there are no side effects

6. **Prevention:**
   - How can this be prevented in future?
   - Is validation needed?
   - Is it worth adding a test?

**Common problems:**

- Missing validation
- Authorisation problems
- Race conditions
- Incorrect typing
- Errors in async/await
- Caching problems

If the problem is unclear, see `.claude/troubleshooting.md` for common solutions.
