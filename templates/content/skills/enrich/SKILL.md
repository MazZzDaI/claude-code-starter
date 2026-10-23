---
name: enrich
description: "Enriching content with examples, exercises, quizzes and cross-links."
allowed-tools: Read Write Edit Glob Grep
disable-model-invocation: false
---

# Skill: Enrich

## Purpose

Make content practical, connected and useful without losing the original meaning.

## Input

- existing content units
- audience
- content type
- local format rules

## Enrichment Passes

1. Examples and cases
2. Exercises
3. Quizzes
4. Glossary/thesaurus
5. Cross-links
6. Pitfalls and best practices
7. Summaries

## Output

- updated content files
- `exercises/*.md`
- `quizzes/*.yaml`
- `thesaurus.yaml` or `glossary.md`
- updated index/cross-links

## Quality

- Enrichment matches audience world
- Exercises are solvable
- Quizzes test taught material only
- Additions do not override rich source material
