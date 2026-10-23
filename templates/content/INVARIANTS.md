---
title: Invariants
type: invariants
updated: YYYY-MM-DD
---

# Invariants

## Why this file

This is where the **hard rules of the product** live, the ones that must not be broken. Not
a stylistic preference, not "how we usually write", but guarantees without
which the product stops being itself. Breaking an invariant = a defect, not
a matter of taste.

How it differs from `.claude/rules/`:
- `rules/` — how the **agent** works (workflow, commit policy, delegation).
- `INVARIANTS.md` — what must not happen to the **product**: voice,
  sources, factual accuracy, navigation, format, promises to the reader.

If an invariant gets in the way of a task, that is no reason to break it. It is a reason to
open a discussion and either reformulate it or change the task.
Before changing an invariant, record in `History` what prompted it.

**Categories (hint):** `source` · `voice` · `style` · `audience` ·
`accuracy` · `structure` · `format` · `attribution` · `safety`

---

### INV-001: The source is not rewritten with loss of voice

**Category:** source / voice
**Rule:** When working with rich input (an author's text, transcript,
lecture, document) it is forbidden to replace the author's wording with synonyms,
smooth out repetitions or change the order of thought without an explicit reason
recorded in the brief. Markup, formatting,
headings, transitions and explanations are permitted **as a supplement** to the author's
text, not in place of it.
**Why:** The author's voice is part of the product. The reader comes for a
specific voice, not for an "improved version". Loss of voice is
irreversible: you cannot reassemble "how it was" from the polished text.
**How to check:**
- the editor checks every rich-input unit for preservation of voice (see
  `.claude/rules/content-quality.md`, Style and Voice section);
- review checklist: read 1-2 paragraphs of the original and the final side by side and answer
  "does this still sound like the author?";
- diff against the source when editing, if the source is stored separately.
**History:** <!-- link to a specific case, if there was one; otherwise leave empty -->

<!--
Add new invariants below. Template:

### INV-NNN: <short name>

**Category:** ...
**Rule:** <one sentence, in the affirmative>
**Why:** <the real risk to the product or the reader>
**How to check:** <review checklist / editor / automated check>
**History:** <the case that led to it, if there was one>

Typical candidates for content invariants:
- The source hierarchy is not violated: canon beats draft, brief beats
  generated notes.
- Quotes, links and authors' names are not invented.
- The audience level is respected: for beginner — no jargon without a
  definition, for advanced — no spoon-feeding the basics.
- The mandatory sections of the format are present (for example, for a lesson:
  objective, prerequisites, example, summary).
- Internal links are relative and working.
- Provenance is preserved: where an important claim was taken from.
- The style ban list from CLAUDE.md is respected.

Rules for a good invariant:
- One rule = one item.
- The wording is checkable in review or automatically.
- If you cannot explain "why", it is most likely a stylistic
  preference; it belongs in the style guide, not here.
-->
