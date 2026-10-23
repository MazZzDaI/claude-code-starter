# {{PROJECT_NAME}}

## Purpose

{{PROJECT_PURPOSE}}

**Content type:** {{CONTENT_TYPE}}
**Main product:** texts / course / book / knowledge base / documents / transcripts / hybrid
**Code in the project:** none / supporting pipeline / equal layer

## Purpose of this file

To give you an **adequate model of the project**: correct in structure, grounded in the sources and the existing content, aware of its own limits. And to protect the project while that model is being built.

The constraints in this file and the related rules are deliberately of **three different kinds**:

| Kind | Where they live | How to treat them |
|-----|-----------|---------------|
| On actions | `INVARIANTS.md`, source hierarchy, voice prohibitions | **strictly** — a violation = a bug |
| On attention | reading order, navigation, the two memory axes | **helpful** — structure makes depth achievable |
| On depth of understanding and length of report | — | **none** — depth is dictated by the request, not by the format |

Caps on understanding (such as "report in 3–5 lines") cut down the adequacy of the representation and are a protocol bug, not the norm.

## Target audience

{{TARGET_AUDIENCE}}

Describe:
- who the reader/user is;
- level: beginner / intermediate / advanced / mixed;
- what the reader should understand/decide/be able to do;
- what knowledge must not be assumed.

## Content structure

Entry point: `{{ENTRYPOINT_FILE}}`

```text
{{CONTENT_TREE}}
```

**Navigation rule:**
1. Start from the entry point.
2. Read the section indexes (registry, arc, syllabus, map).
3. Only then open specific content units.
4. Do not draw conclusions from a file without checking its place in the structure.

## Source hierarchy

In a conflict, trust in this order:

1. `{{SOURCE_LEVEL_1}}` — the primary source of truth.
2. `{{SOURCE_LEVEL_2}}` — canon, bible, style guide, specs.
3. `{{SOURCE_LEVEL_3}}` — briefs, tasks, working documents.
4. `{{SOURCE_LEVEL_4}}` — drafts, notes, generated artifacts.

**Rule:** do not invent facts, quotations, references, terms or the author's intentions. Deficit or escalation.

## Style and voice

Main style guide: `{{STYLE_GUIDE_FILE}}`

Rules:
- preserve the author's voice when the input is rich;
- explain terms at the audience's level;
- do not introduce new terms without need;
- do not change the genre without a request;
- do not remove the author's material without permission.

Forbidden list:
- `{{FORBIDDEN_PATTERN_1}}`
- `{{FORBIDDEN_PATTERN_2}}`

**Universal prohibitions (always):**
- Do not remove the author's content from rich input
- Do not change the voice/style without explicit permission
- Do not violate the source hierarchy
- Do not add invented facts, quotations or references
- Do not ignore the audience level

## Workflow

```text
Intake → Research → Outline → Write → Enrich → Review → Export/Index
```

### Intake

Determine the mode:

- **Rich input:** the author's text, a transcript, a document, a chapter, a lecture. The task is to preserve the thought, structure and voice; mark-up, formatting, explanations and editing are allowed.
- **Sparse input:** a topic or a short brief. The task is to research, structure and create from scratch.

Record:
```text
Mode: rich / sparse / mixed
Output type: book / course / knowledge-base / docs / transcripts / report / hybrid
Audience: beginner / intermediate / advanced / mixed
Sources: full / partial / weak
Constraints: ...
Deficits: ...
```

## File formats

Use:
- `templates/`
- `.claude/rules/content-formats.md`
- the project's existing files

Basic content unit formats:
- chapter: `chapters/NN-slug.md`
- lesson: `modules/NN-name/lesson-NN.md`
- transcript: `Section-NN/NN-Lecture-Title.md`
- document: `docs/topic-name.md`
- registry/index: `INDEX.md`, `00-course-index.md`, `course-registry.md`
- metadata: `meta.yaml` or frontmatter

## Review and quality

Checklist:
- fits the task and the audience;
- preserves the source and the voice;
- no factual errors;
- no required topics lost;
- the structure is clear;
- links work;
- the format matches the template.

Severity:
- Critical — blocks publication.
- Major — fix before the final version.
- Minor — backlog.

## Memory layers

The project's memory lives on **two axes**. Do not collapse them into one file.

**Axis 1. Contracts — what should be (changes slowly):**

| File | What it holds |
|------|-----------|
| `.claude/ARCHITECTURE.md` | Project map: chapters/lessons/sections, narrative, source hierarchy, navigation |
| `.claude/INVARIANTS.md` | Hard product rules: voice preservation, source hierarchy, audience level |
| `methodology/` | Methodologies (for example, for transcript-processing or research pipelines) |

**Axis 2. State — what is now (changes quickly):**

| File | What it holds |
|------|-----------|
| `.claude/SNAPSHOT.md` | Current phase, readiness of content units, deficits, pending review |
| `.claude/BACKLOG.md` | Plan: chapters/lessons/research/enrichment — Next / Soon / Later / Won't do |
| `.claude/dialogs/` | Archive of session dialogs (see `rules/dialog-preservation.md`) |

At session start read **both axes**. At the end — update both.

## Subsystems

| Layer | Path | Purpose |
|------|------|------------|
| Rules | `.claude/rules/` | workflow, quality, sources, formats, commits, dialog-preservation |
| Skills | `.claude/skills/` | research, outline, write, review, enrich, index, save-dialog |
| Agents | `.claude/agents/` | researcher, writer, editor, reviewer |
| Hooks | `.claude/hooks/` | checkpoints, compaction, reminders |
| Methodologies | `methodology/` | Specifications for content pipelines |
| Metadata | `manifest.md` | project_name, repo_access, project_type, content_type |

## Agents

- `researcher` — researches sources, builds a source map, identifies concepts and gaps.
- `writer` — writes/adapts content units to the brief, structure and style guide.
- `editor` — checks voice, style, terms, format and readability.
- `reviewer` — release review: completeness, links, sources, contract.

## Commits

In a content project, the product is the content files. Prefixes:

- `content:` — new content;
- `edit:` — editing;
- `chapter:` — a book chapter;
- `lesson:` — a course lesson;
- `research:` — sources, notes;
- `index:` — indexes, registry, navigation;
- `meta:` — snapshot, manifest;
- `pipeline:` — supporting code.

Follow `.claude/rules/content-commit-policy.md`.
