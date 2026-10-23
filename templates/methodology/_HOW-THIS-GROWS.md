# Methodology Layer — how this grows

## Why this directory exists

This is where **methodologies** live — techniques applied by automated pipelines (router → adapter → executor): it is not me, the agent, applying them on the fly; instead, code retrieves the right methodology from a signal in the task and assembles a prompt for the executor from it.

How this differs from `.claude/rules/`:

| Layer | Addressed to | When applied | Format |
|------|-----------------|-------------------|--------|
| `.claude/rules/` | Me (Claude Code, the interactive agent) | Always in session context | Free text, operational rules |
| `methodology/` | Automated pipelines (router + LLM executor) | On a routing signal from the task | Formalised specification: signals, decomposition, prompt skeleton |

Roughly: rules = "how I work"; methodology = "how the pipeline solves recurring tasks without me".

## Maturity ladder

Methodologies are not born finished. They go through four stages:

```
draft        — observation: "noticed that approach Y helps in tasks X"
               (free text, minimal metadata)
               ↓ once it has recurred in 3+ places
pattern      — description: what, when, in which cases
               (Concept + Anti-patterns, no rigid structure)
               ↓ once it has stabilised and is invoked often
mature       — full specification: routing signals, decomposition,
               prompt skeleton (the format for mature methodologies)
               ↓ once it is invoked the same way, consistently
crystallized — translated into deterministic code; the methodology
               remains as the specification
```

Files live in subdirectories by status: `draft/`, `patterns/`, `mature/`. When the status goes up, move the file into the right directory and change `maturity:` in the frontmatter. `crystallized` stays in `mature/` (it is still a specification, just executed by code).

## When to raise the status

| From → To | Signal for the transition |
|--------|-------------------|
| draft → pattern | The same approach has surfaced in 3+ tasks/files/sessions. It has become clear in which cases to apply it and in which not. |
| pattern → mature | A stable prompt scaffold has emerged, the inputs/outputs are known, the result is repeatable. The routing signals can be described formally. |
| mature → crystallized | The methodology is invoked the same way, has been validated on real tasks, the cost/speed of LLM execution has become the bottleneck, or the behaviour has become deterministic. Part of it moves into code. |

Movement in the other direction happens too: if a pattern "didn't take off", leave it as a draft marked `seen_in: []` (empty = not confirmed).

## Low barrier to entry

**This is the most important part.**

A `draft` is a 5-line note, not a report. If you have noticed something useful, open `templates/draft.md`, copy it, fill in "What I noticed" and "In which cases", and put it in `draft/`. That's it.

- No full justification needed.
- No source references needed.
- No need to know whether it will ever make it into code.
- An unpolished draft is better than a lost observation.

Most drafts will never rise to mature — and that is fine. They work as an **archive of observations** that you reread once a month to see patterns that would otherwise have been forgotten.

## Global vs project layer

There are two levels:

- `~/.claude/methodology/` — methodologies shared by all projects (for example, `llm-as-component`).
- `<project>/methodology/` — this project's methodologies.

If the global layer has a suitable methodology, a project file can **reference** it and refine it for the specific domain without duplicating the content:

```yaml
---
maturity: mature
id: my-project-extraction
related: [[~global/llm-as-component]]   # reference to the global methodology
---

# Methodology: Extraction in this project

Based on [[llm-as-component]] (global). Refinements:
- chunk size: 8 items (rather than the general recommended one)
- routing: apply only to JSON logs with an `event_type` field
- ...
```

The project layer takes priority: if the router finds a match in the project layer, it takes that one. The global layer is the fallback.

## Composing methodologies: Router → Adapter → Executor

Methodologies are not used one at a time. They are assembled into chains:

```
[Task input]
     ↓
[Router]    — LLM call 1: looks at the task, selects the methodology(ies) by
              applies_when / does_not_apply signals
     ↓
[Adapter]   — LLM call 2 (or code): takes the prompt skeleton of the selected
              methodology, substitutes data from the task, generates
              the final prompt for the executor
     ↓
[Executor]  — LLM call 3 (cheap model): makes a narrow judgement in a small
              window from the prompt it received
     ↓
[Bookkeeping code] — accounting, dedup, aggregation, contract validation
```

Each stage is a separate call with a separate responsibility. This is a direct application of the [[rules/llm-as-component]] principle: a strong model designs and evaluates offline; the runtime is assembled from cheap, reliable steps.

The `composes_with` field in a mature methodology's frontmatter indicates which other methodologies naturally chain with this one in a pipeline.

## Relationship to other layers

- [[INVARIANTS]] — methodologies must not contradict the project's invariants. If they do, the conflict is escalated to either changing the invariant or abandoning the methodology.
- [[ARCHITECTURE]] — methodologies describe **how** the pipeline makes decisions. The architecture describes **where** those pipelines live (modules, boundaries, contracts).
- [[rules/llm-as-component]] — the foundation. Any methodology for an LLM pipeline is an application of this principle to a specific domain.

## What to read next

- `00-example-llm-as-component.md` — the canonical example of a fully filled-in mature methodology (it is the global `llm-as-component` rule, reformatted).
- `templates/draft.md` — the minimal template to start from.
- `templates/pattern.md`, `templates/mature.md`, `templates/crystallized.md` — templates for the later stages.
