# Rule: Content Commit Policy

## Principle

In a content project the product is `*.md`, `*.txt`, `*.pdf`, `*.docx`, images, metadata, indexes, bundles and source materials.

Use `git add` with specific files. Do not use `git add .` or `git add -A`.

## Prefixes

| Prefix | Use |
|--------|-----|
| `content:` | new material, article, section, document |
| `edit:` | editing existing text |
| `chapter:` | book chapter |
| `lesson:` | course lesson |
| `research:` | sources, research reports, notes |
| `index:` | INDEX, registry, cross-links, navigation |
| `meta:` | SNAPSHOT, manifest, project metadata |
| `format:` | templates, format cleanup, metadata normalisation |
| `pipeline:` | supporting scripts, extractor, generator, converter |
| `fix:` | fixing a bug in code or content |

## repo_access Modes

### public / private-shared

Commit the product:
- publishable content
- user-facing docs
- source files (if part of the product)
- metadata, indexes, templates
- production scripts and tests

Do not commit the process:
- `.claude/`, `CLAUDE.md`, `manifest.md` (if the framework is local)
- private notes, drafts, scratch, logs
- raw dumps with sensitive data
- unpublished author feedback

### private-solo

All working materials may be committed, except always-forbidden ones.

## Always Forbidden

- `.env`, `.env.*`
- keys, certs, credentials
- `.claude/settings.local.json`
- local databases with private data
- `node_modules/`, `.venv/`, `__pycache__/`
- generated build artifacts (unless a deliverable)
- private tax/legal/medical docs in public/shared repos

## Content Atomicity

A commit should be meaningful as a unit:
- one chapter + metadata/index updates
- one lesson + quiz/exercise + index update
- one research pass + sources/concepts
- one pipeline change + tests

If an edit to a content unit requires an index update, the commit includes both.

## Before Push

- No secrets
- No private source docs in public/shared
- Indexes updated
- Links not broken
- SNAPSHOT up to date
