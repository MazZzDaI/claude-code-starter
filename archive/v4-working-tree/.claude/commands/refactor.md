---
description: Help with code refactoring
---

Help refactor the code, preserving functionality and improving quality.

**Refactoring goals:**

1. **Improving readability:**
   - Clear names
   - Breaking up large functions
   - Removing duplication
   - Adding comments

2. **Performance:**
   - Rendering optimisation
   - Memoisation
   - Lazy loading
   - Database query optimisation

3. **Type safety:**
   - Strict typing
   - Removing `any`
   - Correct interfaces

4. **Architecture:**
   - Proper separation of concerns
   - Extracting reusable logic
   - Compliance with project patterns

**Process:**

1. **Analysis:**
   - What can be improved?
   - What problems are there?
   - Where is the duplication?

2. **Plan:**
   - Define the refactoring steps
   - Start small
   - Check after each step

3. **Refactoring:**
   - Preserve functionality
   - Follow coding standards
   - Improve incrementally

4. **Verification:**
   - Tests pass (if any)
   - TypeScript has no errors
   - The linter is happy
   - Functionality has not changed

**Principles:**
- DRY (Don't Repeat Yourself)
- KISS (Keep It Simple, Stupid)
- YAGNI (You Aren't Gonna Need It)
- Single Responsibility Principle

**Refactoring examples:**
- Extracting custom hooks
- Creating reusable components
- Simplifying conditional logic
- Optimising queries
