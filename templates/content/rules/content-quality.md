# Rule: Content Quality

## Purpose

A single review protocol for texts, courses, books, documents, transcripts and knowledge bases.

## Universal Checklist

### 1. Task Fit
- The content answers the original task
- The output type matches the request
- The scope includes what is mandatory and excludes what is forbidden

### 2. Audience Fit
- The level of complexity matches the audience
- Terms are explained at their first significant use
- Examples come from the audience's world
- The reader knows what to do next

### 3. Source Integrity
- Mandatory sources are preserved
- Rich input has not been rewritten with loss of voice/meaning
- Facts, quotes and links have provenance
- Disputed claims are flagged

### 4. Structure
- Clear heading hierarchy
- One section — one function
- Transitions are logical
- No knowledge jumps without scaffolding

### 5. Style and Voice
- The tone matches the style guide
- Terminology is consistent
- No forbidden turns of phrase
- No unexpected genre/academic register/marketing

### 6. Format
- The file matches the template
- Metadata is filled in
- Links are relative
- Assets exist and are linked

### 7. Utility
- Learning material has examples
- The summary/takeaway serves the format
- A collection has an index/cross-links
- A course has exercises/quizzes

## Review Report Format

```markdown
# Content Review: [Name]

**Date:** YYYY-MM-DD
**Status:** APPROVED / NEEDS REVISION / ESCALATION

## Summary
[Short assessment of readiness.]

## Critical Issues
1. [file:line] Description → suggested route

## Major Issues
1. ...

## Minor Issues
1. ...

## Checklist Results
- Task Fit: pass/fail
- Audience Fit: pass/fail
- Source Integrity: pass/fail
- Structure: pass/fail
- Style and Voice: pass/fail
- Format: pass/fail
- Utility: pass/fail

## Recommendation
Approved / Return to Write / Return to Enrich / Return to Research / Escalate
```

## Routing

| Issue type | Route |
|------------|-------|
| Missing facts or weak evidence | Research |
| Broken sequence or unclear outline | Outline |
| Poor explanation or missing section | Write |
| Missing examples, exercises, glossary | Enrich |
| Broken links or metadata | Export/Index |
| Voice drift | Editor |

## Audience-Level Quality Criteria

| Level | Explanations | Terms | Examples | Pace |
|-------|-----------|---------|---------|------|
| **beginner** | Detailed, step by step | Explain all of them at first use | Many, from everyday experience | Slow |
| **intermediate** | Moderate, with assumptions | Professional terms acceptable, explain key ones | Professional, real-world cases | Medium |
| **advanced** | Minimal, focus on nuances | Professional terms without explanation | Edge cases, anti-patterns | Fast |

## Common Quality Issues

| Issue | Sign | Fix |
|-------|---------|-----|
| Too high-level | The reader does not understand what to do | Add a concrete example |
| Unexplained jargon | A term without a definition | Explain it at first use |
| Missing prerequisite | Knowledge jump | Add a dependency or scaffolding |
| Voice drift | Alien genre, academic register, marketing | Bring it back to the style guide |
| Weak evidence | A claim without a source | Add provenance or flag a deficit |
| Broken structure | The sequence is broken | Restructure according to the outline |

## Rules

- Review is verification, not rewriting.
- Do not block release on minor issues.
- Always cite concrete location.
- If no issues found, list residual risks.
