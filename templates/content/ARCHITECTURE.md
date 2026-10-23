---
title: Architecture
type: architecture
status: draft
updated: YYYY-MM-DD
---

# Architecture

<!--
A living map of the content project. Not history and not a plan, but the answer to
"where is everything and how is it connected". Update it when the structure changes: new
sections, a rebuilt arc, new sources, a change to the export pipeline.

The contract layer (how the product is built), not the state layer (what is currently
in progress). State lives in SNAPSHOT.md, the plan in BACKLOG.md, the hard rules
of the product in INVARIANTS.md.
-->

## Project map

<!--
The layout of folders and content units. What exists at all: chapters, lessons,
sections, transcripts, documents, indexes, assets. One line per unit.
-->

- <!-- Example: `chapters/` — book chapters, NN-slug.md -->
- <!-- Example: `briefs/` — chapter briefs, one per chapter -->
- <!-- Example: `bible/` — canon: characters, terms, world -->
- <!-- Example: `sources/` — primary sources (transcripts, documents, links) -->
- <!-- Example: `assets/` — images, diagrams, next to the content units -->
- <!-- Example: `INDEX.md` — entry point, navigation across the product -->

## Narrative / arc

<!--
How the product's arc is built: where the reader/student moves from and to.
For a book — the plot or argument arc. For a course — the learning trajectory
from prerequisites to outcomes. For a knowledge base — the taxonomy or dependency
graph between articles.
-->

- <!-- Example: book — three parts: problem, analysis, synthesis -->
- <!-- Example: course — sections 1-3 foundational, 4-6 advanced, 7 capstone -->
- <!-- Example: knowledge base — root `concepts/`, links branch out from here -->

## Source hierarchy

<!--
A brief reference to the project's source hierarchy. Details are in
.claude/rules/source-management.md or in CLAUDE.md. Here — a map of
which level is stored where.
-->

1. <!-- Primary source: `sources/transcripts/` — the author's transcripts -->
2. <!-- Canon: `bible/`, `style-guide.md` — approved rules and terms -->
3. <!-- Brief: `briefs/` — tasks for specific units -->
4. <!-- Existing content: `chapters/`, `lessons/` — units already written -->
5. <!-- Generated: `notes/`, `research/` — research materials and drafts -->

## Navigation and indexes

<!--
Where the entry point lives and how the reader (or agent) finds their way.
Indexes are the navigation contract. If you renamed a chapter, you must
update the index as well.
-->

- <!-- Example: `INDEX.md` — top-level, links to all sections -->
- <!-- Example: `chapters/INDEX.md` — list of chapters with statuses -->
- <!-- Example: `course-registry.md` — registry of all lessons, links and duration -->

## Pipeline and export

<!--
How content turns into the final product. Stages, scripts,
output formats, where it is published.
-->

- <!-- Example: Intake → Research → Outline → Write → Enrich → Review → Export -->
- <!-- Example: export via `scripts/build-bundle.sh` → `dist/bundle/` -->
- <!-- Example: publication: PDF (Pandoc) + EPUB + web (static site) -->

## Dependencies

<!--
External materials and tools without which the product does not exist.
Source licences, links to the canon, mandatory libraries/scripts.
-->

- <!-- Example: the author's materials under licence X, provenance must not be removed -->
- <!-- Example: Pandoc for the final PDF build -->
- <!-- Example: an external glossary we link to, version pinned -->

## Open questions

<!--
Structural decisions not yet made. Not tasks and not deficits, but
forks in the road where you need to stop and think before
moving on. Once a question is closed, it moves into the main text or
is deleted.
-->

- <!-- Example: glossary — shared across the whole product or per chapter? -->
- <!-- Example: exercises — at the end of the lesson or as a separate section? -->
