---
maturity: draft
domain: framework-design
created: 2026-06-12
related: [[memory-axes-must-stay-separate]]
sources:
  - /Users/alexeykrolmini/Code/Project_init/FRAMEWORK-CASE-ONBOARDING.md
  - /Users/alexeykrolmini/Code/Saved Downloader/docs/FRAMEWORK-REGRESSION-REPORT.md
---

# Observation: an onboarding protocol must not cap depth of understanding

## What I noticed

In session initialisation protocols (`/start`, `cold-start`, any "read N files and report") it is easy to unintentionally write in a **constraint on output** ("report in 3–5 lines", "summary of no more than N"), which the model reads as a **ceiling on depth** rather than a floor on brevity. On a "get to grips with the project" request the agent builds its model exactly to the level sufficient for 5 lines, and stops — even when that is clearly insufficient.

Confirmed by a real incident in the Saved Downloader project: the same agent with the same access to the code, asked to "make sure you've understood the project", produced a meagre 5-line digest following the constitution, whereas when asked to "give an analytical breakdown" (from another folder, without the onboarding cap) it produced a deep analysis with metrics, a reality vs design table and risks.

## In which cases

Session initialisation, onboarding and cold-start protocols. Any document that:
1. prescribes reading a set of metafiles;
2. prescribes reporting the result.

If step (2) has a fixed length in lines/sentences, it is a candidate for this bug.

## Principle

Distinguish **three kinds of constraints** in a protocol:

| Kind | Purpose | Norm |
|-----|------------|-------|
| On actions | protect the project (INVARIANTS, production-safety) | **hard** |
| On attention | make depth achievable (reading order, the two memory axes) | **helpful** |
| On depth/output | — | **never cap** |

Depth is dictated by the user's request, not by the protocol's format. The minimum is a floor of adequacy; there is no ceiling.

Related:
- metafiles are the map, not the territory; a protocol without a grounding step (grep/wc against the claims) gives false confidence in the completeness of the model;
- two files with the same content (CLAUDE.md + ONBOARDING.md) = two sources of truth, inevitable drift. The constitution lives in the file the harness auto-loads; a portable prompt for external agents is **a pointer with no content**.

## What was tried / alternatives

- A "3–5 lines" cap as anti-noise at the start — gives the desired effect for a routine `/start`, but fails on a "get to grips with it" request. The cure is scaling: the report format depends explicitly on the type of request (routine / analytical / task).
- Metafiles only, without grounding — gives a quick result, but reproducibly inherits the blind spots of the self-description. The cure is a mandatory grep/wc/git log step against the claims of ARCHITECTURE/SNAPSHOT.

## Connection to other observations

- A repeat of a user report in the same area (contracts vs state in [[memory-axes-must-stay-separate]]) → this is the second case from the same owner on a closely related topic. If it happens a third time, promote it to a pattern.
- Strongly echoes the principle from `rules/llm-as-component`: the error is structurally possible because the instruction allows the model to "stop early". A ban on early exit = a cap is structurally impossible.

---

*Promote to pattern once the same approach has recurred in 3+ tasks. Currently 2 (memory-axes + onboarding-cap), both from the same owner, in the same consuming repository.*
