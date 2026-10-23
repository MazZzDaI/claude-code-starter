---
name: content-index
description: "Building and updating indexes, registries, tables of contents, course maps and cross-links."
allowed-tools: Read Write Edit Glob Grep Bash
disable-model-invocation: false
---

# Skill: Content Index

## Purpose

Update navigation and the registry so that the project remains readable after content changes.

## Input

- content tree
- existing `INDEX.md`, `00-course-index.md`, `course-registry.md` or README
- metadata files

## Process

1. Scan the content files
2. Extract title, status, type, tags, updated date, summary
3. Check for missing metadata
4. Update the master index
5. Update the section indexes
6. Check relative links
7. Record orphan files

## Output

- `INDEX.md`
- `INDEX-*.md`
- `00-course-index.md`
- `course-registry.md`
- `README.md` navigation section
- optional `orphan-report.md`

## Quality

- Every publishable file is reachable from the index
- No broken relative links
- Index descriptions are one-line and specific
- Archive/drafts clearly separated
