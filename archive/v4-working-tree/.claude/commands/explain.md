---
description: Explain how a particular part of the code works
---

# Adaptive Code Explanation

**IMPORTANT: Automatically assess code complexity BEFORE explaining.**

## Step 1: Complexity Assessment

Quickly evaluate the code size and complexity:

**Simple** (1-10 lines, basic operations):
- Variable assignments
- Simple loops/conditions
- Basic function calls
- Config declarations

**Medium** (10-50 lines, multiple functions):
- Multiple interacting functions
- Data transformations with logic
- Component with props/state
- API endpoint implementation

**Complex** (50+ lines, architecture):
- Full modules or features
- Multiple components interaction
- Advanced patterns (HOCs, middleware chains)
- System architecture decisions

## Step 2: Adaptive Explanation

### For SIMPLE code:

**Format:**
```
Brief explanation (2-3 sentences):

1. What the code does
2. Key points (if any)
3. Result

[If there are important details - add 1-2 points]
```

**Example:**
```
This bash script generates a unique file name for a bug report:

1. Takes the name of the current folder: PROJECT_NAME=$(basename "$(pwd)")
2. Creates a timestamp: 20260116-143055
3. Assembles the path: .claude/logs/ProjectName-bug-20260116-143055.md

Result: a unique file name for each report.
```

### For MEDIUM code:

**Sections:**
1. **General overview** (1-2 sentences)
2. **Step-by-step explanation** (key blocks)
3. **Edge cases** (if there is error handling)

**Skip:**
- Detailed patterns (unless important)
- Alternative approaches (unless asked)
- Concepts (unless non-obvious)

### For COMPLEX code:

**Full breakdown with all sections:**

1. **General overview:**
   - What does this code do?
   - What is its role in the project?
   - What does it interact with?

2. **Step-by-step explanation:**
   - Break down the code line by line or block by block
   - Explain the logic
   - Point out important details

3. **Concepts and patterns:**
   - Which concepts are used?
   - Which design patterns?
   - Why was this approach chosen?

4. **Data flow:**
   - How does data come in?
   - How is it transformed?
   - What is returned?

5. **Dependencies:**
   - What external dependencies?
   - Which internal modules are used?
   - What side effects?

6. **Edge cases:**
   - How are errors handled?
   - What happens in boundary cases?
   - What are the limitations?

7. **Possible improvements:**
   - Point out potential improvements
   - Suggest alternative approaches

## Guidelines

**Token economy:**
- Simple code → 50-100 tokens response
- Medium code → 200-400 tokens
- Complex code → Full detailed breakdown

**Always:**
- Start with complexity assessment (don't mention it to user)
- Match detail level to code complexity
- Focus on "what" and "why", not just "how"
- Use simple language for complex concepts

**Never:**
- Force all 6 sections for simple code
- Add unnecessary details
- Explain obvious things
- Include improvements unless asked or clearly needed

**Examples:**

Good (simple):
```
User: Explain this code
const name = path.basename(filePath);

Response: Extracts the file name from the full path (strips directories).
Example: "/home/user/file.txt" → "file.txt"
```

Bad (simple):
```
[500 lines with all 6 sections for 1 line of code]
```

Good (complex):
```
User: Explain middleware.ts authentication flow

Response: [Full breakdown with all sections, patterns, edge cases]
```
