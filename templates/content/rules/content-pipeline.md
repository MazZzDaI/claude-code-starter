# Rule: Content Pipeline

## Purpose

A common working cycle for projects where the product is content.

## Mandatory Intake

Before research, writing or editing, determine the input mode.

### Rich input

Signs:
- an author's text, transcript, chapter, lecture, document;
- wording, examples and the order of thought matter;
- the task resembles adaptation, structuring, clean-up, editing.

Rules:
- the source of truth is the input material;
- do not shorten or rewrite the author's meaning;
- structure, headings, formatting, explanations and transitions are permitted;
- add explanations as a supplement, not a replacement.

### Sparse input

Signs:
- a topic or a short brief;
- few sources;
- generation of structure and text is expected.

Rules:
- run research;
- record sources;
- separate facts from conclusions;
- log deficits explicitly.

### Intake output

```text
Mode: rich / sparse / mixed
Content type: book / course / knowledge-base / docs / transcripts / report / hybrid
Audience: beginner / intermediate / advanced / mixed
Output format: ...
Source sufficiency: full / partial / weak
Constraints: ...
Deficits: ...
```

## Pipeline Stages

```text
Intake → Research → Outline → Write → Enrich → Review → Export/Index
```

### Stage 1: Research

Goal: gather and systematise the material.

Outputs:
- `research-report.md`
- `sources.md`
- `concepts.md` or `source-map.md`

Criteria:
- key topics are covered;
- sources have provenance;
- disputed facts are flagged;
- gaps are recorded as deficits.

### Stage 2: Outline

Goal: build the product's structure.

Outputs:
- course: `program.md`, `learning-objectives.md`, `dependencies.md`
- book: `arc.md`, `chapter-map.md`, `briefs/chapter-N.md`
- knowledge base: `INDEX.md`, `INDEX-*.md`, taxonomy
- documents: `document-map.md`, canonical files list

Criteria:
- the sequence follows the learning or decision flow;
- no circular prerequisites;
- every section has a function;
- the structure does not lose a mandatory source.

### Stage 3: Write

Goal: create or adapt content units.

Rules:
- one unit — one focus;
- the goal or function is visible at the start;
- terms are explained at their first significant use;
- rich input is preserved;
- sparse input relies on research.

### Stage 4: Enrich

Goal: make the content practical and useful.

Possible passes:
- examples and cases
- exercises and quizzes
- glossary/thesaurus
- cross-links
- diagrams/media references
- pitfalls and best practices
- summaries and study notes

### Stage 5: Review

Goal: check conformance with the task, sources, style and format.

Severity:
- Critical — factual error, loss of a mandatory source, broken structure, violation of the hierarchy.
- Major — weak explanation, missing example, mismatch with the audience, incomplete format.
- Minor — stylistics, local wording, nice-to-have.

Maximum iterations: 3. After 3, write an escalation note.

### Stage 6: Export/Index

Goal: prepare the final product.

Check:
- metadata is filled in;
- index/registry is updated;
- internal links work;
- assets sit next to the content unit;
- the output bundle matches the contract.

## Anti-Paralysis

- Log deficits and move on if they do not block the meaning.
- Do not search endlessly for the perfect source; note the confidence and carry on.
- A draft with explicit deficits is better than a standstill.
- Escalate only conflicts of meaning that cannot be resolved by the source hierarchy.
