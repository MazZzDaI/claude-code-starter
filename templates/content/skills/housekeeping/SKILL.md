---
name: housekeeping
description: "Maintaining a content project: indexes, metadata, snapshot, links, sources."
allowed-tools: Read Edit Write Glob Grep Bash
disable-model-invocation: true
---

# Skill: Housekeeping

## Purpose

Check that the content project has not drifted apart: navigation, metadata, links, snapshot, formats.

## Checks

### 1. Index and Registry
- `INDEX.md`, `00-course-index.md` exist, if needed
- New content files have been added to the index
- Archived/draft files are not mixed with current ones
- Orphan files are listed or linked in

### 2. Metadata
- `meta.yaml` or frontmatter is filled in
- Status is up to date
- Audience/type/tags are specified
- Updated date is not older than the last edit

### 3. Links
- Relative links resolve
- Image/media paths exist
- Cross-links between chapters/lessons are not broken

### 4. Source Hygiene
- `sources.md` updated after research
- Important claims have provenance
- Deficits have not been lost

### 5. SNAPSHOT
- current phase
- current unit
- progress table
- open deficits
- pending review
- next actions

### 6. CLAUDE.md Drift

- Does the content structure in `CLAUDE.md` match the actual folder tree?
- Is the workflow description up to date?
- Has the source hierarchy changed?
- Are audience and content_type out of date?

If drift is detected, update `CLAUDE.md` automatically.

### 7. Commit Hygiene
- No secrets
- No private docs in public/shared mode
- Generated artifacts ignored unless deliverable

## What Not To Do

- Do not rewrite content
- Do not change the meaning
- Do not delete drafts without being asked
- Do not spend more than 3 minutes without a reason

## When To Run

- before push
- before handoff
- after moving files en masse
- after generating a new bundle
- at the user's request
