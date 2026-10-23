# FRAMEWORK-CASE-ONBOARDING — case study: an onboarding file that narrowed the agent

_A case study for the developer of Claude Code Starter. Date: 2026-06-12, project Saved Downloader.
Written in the immediate aftermath of the incident at the owner's request: the "`.claude/ONBOARDING.md`
as the single constitution of the session" pattern is a candidate for replication across every framework project;
without a fix, the problem described here will reproduce everywhere. Format: problem → symptom →
analysis → principles → solution. Supplements `FRAMEWORK-REGRESSION-REPORT.md`._

---

## TL;DR

`.claude/ONBOARDING.md` ("the single constitution of the project", a session prompt to paste in) has been **deleted**.
The pattern has three structural defects:

1. **A duplicate of the auto-loaded CLAUDE.md** → two sources of truth, inevitable drift.
2. **A cap on output in the understanding protocol** ("report readiness in 3-5 lines") → the agent reads
   the format as a ceiling on depth and builds a minimally sufficient model of the project.
3. **A picture built only from self-description** (only the metafiles are read, with no check against the code) →
   the agent inherits the map's blind spots and does not know it.

Solution: the constitution has been consolidated into CLAUDE.md (the single source of truth), the report format
scales to the request, and a mandatory step of grounding in the code has been added.

## Incident timeline

1. The owner, to a new session: "get to grips with the project, I want to make sure you've understood what it is
   and why it exists, and how it is built".
2. The agent carried out the onboarding by the constitution conscientiously: it read the whole backbone (manifest,
   CLAUDE, SNAPSHOT, ARCHITECTURE, INVARIANTS, METHODOLOGY, BACKLOG) — and reported as
   prescribed by STEP 5: a condensed readiness digest.
3. The owner compared the report with `docs/EXTERNAL-ANALYSIS.md` — an analysis of **the same project**
   made by an agent from a neighbouring folder **without this onboarding**: the "why" thesis from
   ROADMAP/CONCEPT, code metrics, a "reality vs design" table, risks, integration
   conclusions. The contrast was striking; the owner's verdict was "meagre" vs "detailed".
4. The analysis showed that the issue was not the agent's ability (the same agent verified the external analysis's
   metrics with grep and wc in a minute), but the design of the onboarding file. Depth comes
   from how the task is framed and from grounding — the constitution in its current form suppressed both.

## Defect 1. A duplicate of the auto-loaded file

**Mechanics.** The harness puts CLAUDE.md into the agent's context automatically, before the first action —
it does not need to be "read". The agent sees ONBOARDING.md only via a pointer from CLAUDE.md. Meanwhile
the content was ~80% duplicated (the two memory axes, reading order, INV boundaries, working
rules). The chain: a guaranteed-loaded file sends the agent to read a second file
that repeats the first.

**Why this is bad.** Two files with the same content = two sources of truth. They diverge with
edits — and then it is unclear which one is true. Specifically: the defective "3-5 lines" cap lived in
*both* files. This is the "two dictionaries without a contract" anti-pattern — exactly the class of bug that
the project itself had been fixing in its data (MCP dictionary desync, resolved via `tag_alias`).

**Principle for the framework.** The constitution lives in the file that the harness **is guaranteed to
load** (CLAUDE.md). The legitimate function of a separate onboarding file — portability for
agents outside the harness (a session from another folder, Codex with its AGENTS.md, the web) — is implemented
as **a thin pointer with no content**: "read CLAUDE.md and `.claude/*` in this order".
Zero content → nothing to drift.

## Defect 2. A cap on output in the understanding protocol

**Mechanics.** "Report readiness in 3-5 lines" was intended as anti-noise (don't dump a wall of text
at the start), but it worked as an anchor: the agent builds the model up to the level sufficient for 5 lines,
and stops. The protocol format was read as a ceiling rather than a floor — even when the owner's explicit
request ("I want to make sure you've understood") demanded more.

**The root cause is mixing three kinds of constraints with opposite value:**

| Kind of constraint | Example | Verdict |
|---|---|---|
| on **actions** | INV-6 (don't spend money), INV-7 (don't touch the data) | **necessary** — guardrails, they protect the project while the agent's model is being built |
| on **attention** | reading order, the two memory axes, "backbone before docs/" | **helpful** — they make depth achievable in a finite context window |
| on **depth/output** | "report in 3-5 lines" | **harmful** — they cut the adequacy of the picture |

The owner's thesis, adopted as the purpose of the constitution: the file must give an **adequate and
sufficiently deep** picture of the project; anything that limits the depth of understanding
contradicts the very purpose of the file.

**Principle for the framework.** Do not cap output in onboarding protocols. Wording instead of
a fixed length: "scale the report to the request: routine start — brief; a request to
get to grips with / analyse — a full analytical breakdown". The minimum is a floor, not a ceiling.

## Defect 3. A picture built only from self-description

**Mechanics.** The onboarding prescribed reading only the project's metafiles. That is the map, not the
territory: if SNAPSHOT/ARCHITECTURE have diverged from the code, the agent inherits the inaccuracy along
with the blind spots of the self-description — and has no chance of noticing it.

**The counterexample that exposed the defect.** EXTERNAL-ANALYSIS turned out deeper not because it
read more prose, but because it **grounded the map in reality**: it took code metrics
(32 files / ~11.6k lines of `scripts/`), grepped for stubs (`scenario.py`: 8 model steps
`# TODO`), built a "reality vs design" table. The cost of grounding is a minute of work
(git log, wc, a couple of greps); the value is a picture that can be trusted.

**Principle for the framework.** Onboarding must include a grounding step (cheap probes of the code
against the metafiles' claims) and an explicit marker of the limits of knowledge: "after these steps you know the
map, not the territory; before editing a subsystem, read its code and its docs". The danger is not
an incomplete model, but false confidence in its completeness.

## What was done in the project (reference solution)

- `.claude/ONBOARDING.md` has been deleted.
- CLAUDE.md is the only constitution. Its header states the purpose: "an adequate model of the project:
  correct in structure, grounded in the code, aware of its own limits + protection of the project while the
  model is being built; constraints on actions are hard, there are no constraints on depth of understanding".
- "Session start" now includes: a grounding step (item 3), a scalable report with a depth
  benchmark (item 4), a "map ≠ territory" marker (item 5), a pointer for external agents.

## Checklist for the framework

- [ ] Do not generate a separate ONBOARDING.md with content in projects: constitution = CLAUDE.md.
- [ ] A portable prompt for external agents is a pointer with no content (nothing to drift).
- [ ] In the CLAUDE.md template the report format is "scale to the request", with no fixed length.
- [ ] Into the onboarding template — a grounding step (metrics/grep against the metafiles) and a
      "map ≠ territory" marker.
- [ ] Distinguish three kinds of constraints: actions — hard; attention — structure it;
      depth/output — never cap.
