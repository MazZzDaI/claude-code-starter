---
name: review-content
description: "Checking content readiness: sources, structure, style, format, links."
allowed-tools: Read Write Edit Glob Grep Bash
disable-model-invocation: false
---

# Skill: Review Content

## Purpose

Check a content unit or bundle before finalisation, publication or handoff.

## Input

- target files or diff
- brief
- style guide
- source hierarchy
- expected output format

## Process

### Brief Compliance (7 checks)
1. The content answers the original task
2. The output type matches the request
3. The scope includes what is mandatory and excludes what is forbidden
4. The audience level matches the brief
5. The output format is correct
6. All mandatory content units have been created
7. The constraints from the brief are respected

### Structure & Flow (7 checks)
8. The heading hierarchy is clear
9. One section — one function
10. Transitions between sections are logical
11. No knowledge jumps without scaffolding
12. Prerequisites are stated or covered
13. Navigation (index, cross-links) works
14. The order follows the learning curve / decision flow

### Content Quality (8 checks)
15. Source integrity — rich input preserved
16. Facts have provenance
17. No invented citations or unsupported claims
18. Terms are explained at the audience's level
19. Examples come from the audience's world
20. No unexplained jargon
21. The summary/takeaway helps (if the format requires one)
22. Exercises/quizzes test taught material (if applicable)

### Format & Delivery (6 checks)
23. The file matches the template from content-formats.md
24. Metadata is filled in (status, audience, sources, updated)
25. Internal links are relative and resolve
26. Assets exist and are linked
27. Index/registry updated
28. Export bundle compliant (if applicable)

## Output

```markdown
# Content Review: [Name]

**Status:** APPROVED / NEEDS REVISION / ESCALATION

## Critical
...

## Major
...

## Minor
...

## Recommendation
...
```

## Rules

- Do not rewrite during review
- Always state the location
- Minor issues do not block
- If there are no problems, say so explicitly
