# Methodology Layer (Global) — how this grows

This is the **global layer** of methodologies: `~/.claude/methodology/`. It holds what applies across many projects. Project methodologies (`<project>/methodology/`) may reference these files and refine them for a specific domain without duplicating them.

## What this is

Methodologies are techniques applied by automated pipelines (router → adapter → executor), not by me, the agent, on the fly.

| Layer | For whom | When |
|------|------|-------|
| `~/.claude/rules/` | Me (Claude Code) | Always in session context |
| `~/.claude/methodology/` | Automated pipelines | On a routing signal |

## Maturity ladder

```
draft → pattern → mature → crystallized
```

- **draft** — a 5-line observation. The lowest barrier to entry.
- **pattern** — has recurred 3+ times; it is clear when to apply it.
- **mature** — a stable prompt scaffold, formal routing signals.
- **crystallized** — has moved into code; the specification remains.

More detail — see the file of the same name in the project layer (it is also the extended version of this cheat sheet).

## Low barrier to entry

A `draft` is 5 lines, not a report. An unpolished draft is better than a lost observation.

## Global vs project

- Global (this directory) — general-purpose methodologies, reusable across projects.
- Project (`<project>/methodology/`) — methodologies of a specific project; they may reference global ones via `related: [[~global/<id>]]`.
- On a routing conflict the project methodology wins; the global one is the fallback.

## Canonical example

`00-example-llm-as-component.md` — a fully filled-in mature methodology. Use it as a model when something of your own matures.
