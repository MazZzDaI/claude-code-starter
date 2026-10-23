# The orchestrator model of working: the agent as lead developer — a portable compendium

> **To the recipient.** This file is a reference guide (like `agentic-pipeline.md`,
> `llm-as-component.md`, `human-presence-access.md`), not a config. Read it **when deciding
> how to run the work on a task**: yourself, via a subagent, a fan-out of workers or programmatic orchestration.
> Do not launch anything merely because it has appeared.
>
> **The core in one sentence:** the owner is **the product and methodologist above production**, not a bus
> between threads. The agent is **the orchestrator and lead developer**: it cuts the work into streams itself,
> spins up workers itself (subagents / worktree / Workflow / remote / cron), integrates and
> verifies itself, and raises the owner only at stops. The task is to reproduce **the owner's
> workflow** (the owner stays on top), not the architecture of a particular tool.

*A portable core, derived from the transition "owner = manual glue between sessions" →
"agent = autonomous orchestrator". It lives in `~/.claude/` — the baseline grid of all projects — so that
it applies wherever the owner wants to talk to a single agent as to a production team:
set a goal — receive a verified result, rather than conducting the workers themselves. The second axis of the same
task is **continuity**: context survives a change of session, but the continuity file stays bounded,
so as not to drown the next session (O12).*

This is a **top-level index**, not an encyclopaedia — read it before choosing a mode, not cover to cover.
The file's consumer is **the agent at the moment of planning the work** (authoring-time), so it is a
**rule** (the rules axis), not a methodology-in-a-prompt (cf. the rules⟂methodology boundary by consumer).

---

## Frame: three tiers, the owner above production

```
OWNER  — product / methodologist / architect of abstractions. ABOVE production.
  provides: a green brief + authority envelope (scope of authority) + review of output + decisions at stops.
  does NOT: spin up workers by hand, carry context between threads, conduct.
   │
   ▼
ORCHESTRATOR = AGENT (a single lead session) — architect + lead developer.
  holds the map of seams and the contracts; cuts work into streams; spins up workers ITSELF;
  integrates along dependencies; verifies independently; commits; wakes the owner only at stops.
   │
   ▼
WORKERS — ephemeral executors in THEIR OWN fresh contexts.
  subagent / worktree agent / Workflow agent / remote / cron. Invisible to the owner; they carry
  the territory and return conclusions. What I spin them up with is not the owner's concern.
```

**The shift relative to the manual handoff model.** In the immature model the owner opens sessions themselves,
pastes the handoff, and serves as the bus between threads and as the integrator. That worked while workers could not
be spun up programmatically. Now they can — so the step "the owner spins up a session" **collapses**
into "the orchestrator spins up a worker", and the handoff between sessions turns into an **internal charter**
that the agent issues to the worker itself. The owner is freed into a pure product layer.

**Diagnostic question:** not "how many agents to spin up", but *where here is the owner's work (goal,
priority, risk, stop), and where is mine (decomposition, spinning up workers, integration, evidence)?*
Everything that does not require product will is mine.

---

## Principles

**O1. The owner is above the orchestrator, not inside production.** Their input: a green brief +
authority envelope + review of output + decisions at stops. Do NOT bother them with routine: spinning up workers,
choosing a primitive, integration, commits, "may I run the tests" — that is mine. If I catch myself
asking the owner to act as the bus or the dispatcher, I have put them back into the role they left.

**O2. The orchestrator holds the map, the workers hold the territory.** My context = the map of seams + contracts +
the state of the streams; implementation details live in **the workers' fresh contexts** and come back as
conclusions. This is the only protection against the context ceiling of a single lead session: I do not read the territory
myself — I delegate and accept the conclusion. A large fan-out of readers saves my context rather than spending it.

**O3. Single writer per shared contract — by mechanism, not discipline.** Schema, API, migration,
dependency-manifest, CI, entrypoint have one designated writer and a separate integration path.
Parallel writers into one shared contract are made **physically impossible** by worktree isolation
(`isolation:"worktree"`), not by a promise that "we agreed". Do not wait for a merge conflict as a
coordination signal — separate them in advance.

**O4. In every worker: judgement ⟂ bookkeeping** (llm-as-component P1). The worker model does
only judgement (what to build, whether it is relevant, what to call it). Accounting, dedup, integration order,
numbering, statuses, totals — **deterministic code**, not "ask the worker to tally it". Gates (O6)
catch the error after the fact; the separation makes the class of error structurally impossible. When designing a stream,
always ask: where is the judgement here (→ worker), where is the bookkeeping (→ the orchestrator's code harness).

**O5. The charter is the minimal unit of worker management.** I give a writing worker a short
contract: goal; sources of truth (read); expected output; owner of files/contracts; permitted
actions; verification commands; dependencies; stop conditions; report format. **Without a charter a worker may
reconnoitre (read-only) but not change the shared codebase.** The charter is the former handoff,
internalised: I write and issue it, not the owner.

**O6. Four evidence statuses, without substituting optimism.** Any piece of evidence is exactly one
of `passed / failed / not_run / inconclusive`. The last two are **not rewritten** with an upbeat
phrasing. **The synthetic user / verifier is an independent worker: it opens the real interface,
walks through the scenario, but does NOT fix its own findings**, and it separates a confirmed defect from a deliberate
boundary and from the unverified. Progress, ETAs, deployments or user success must never be invented.
→ cf. the project invariant "verify a fix against an independent source of truth, not the same logic".

**O7. Authority envelope — minimal authority, stop at the irreversible.** Before starting it is known what
is permitted without asking (files, environments, local commands) and what requires a stop: production deploy, external
publication/message, payment, permission changes, a migration without rollback, deletion/overwriting of
runtime data and secrets. A stop is not a weakness of the model but the very boundary within which
autonomy is legitimate at all. Authority is fixed by an allowlist (see the mapping), not by memory.

**O8. Durability = commits + memory + journal, not the context window.** The orchestrator is the single point of
context; its death/compaction must not wipe out production. The safeguards: frequent atomic
commits (state in git), separated project memory (P10 — contracts ⟂ state ⟂ methodology),
and resume-from-journal for programmatic runs. That is why a commit here is a load-bearing element, not hygiene.

**O9. Intent → primitive; the cheapest one that works wins.** Not "which tool is cooler" but
"what is the minimal means that covers the intent" (an echo of the escalation ladder from adjacent compendia).
The mapping table is below. Cheaper = more reliable and cheaper on context: a subagent before a Workflow,
a Workflow before remote/cron.

**O10. Know when NOT to fan out.** Fan-out is for the decomposable, for coverage (many readers from
different angles), for isolating parallel writers. **Solo** is for coherence-critical authorial
work, where one hand maintains consistency (a methodology document, a single contract, subtle
unified logic). Parallelising something authorially whole = getting a Frankenstein. Choosing "fan-out or solo" is
an act of judgement, not a reflex of "more agents = better".

**O11. Introducing it into legacy — don't chop up the org model, put on an orientation** (agentic-pipeline Application B).
A working manual handoff model (owner = glue) is not torn down — it is **wrapped**: the same role
control, but the step "the owner spins up a session" moves into the orchestrator one stream at a time. The first product
of introduction is not a rewrite of the TEAM/handoff layer, but the gap "manual glue vs auto-orchestration" + a transition
roadmap.

**O12. Context continuity between sessions — through a separate bounded layer, not a giant handoff.**
Autonomy is pointless if every new lead session starts from scratch — or, conversely,
chokes on a continuity megafile. Continuity is held **not by one growing handoff but by separated
memory** (contracts ⟂ state ⟂ methodology, P10): the new session reads a **bounded** state layer
(SNAPSHOT + the active stream's charter), not the whole history. The handoff, meanwhile, is not an archive but **a thin
pointer + a verifiable entry point**: what is done, what is active, the next safe step, how to
ground it (a code probe, not a self-description). The rule: a continuity file that grows without limit is already
a bug: it will drown precisely the session it is meant to rescue. Autonomy (O1–O11, "who does what") and
continuity (O12, "what survives a change of session") are **two different axes**; do not confuse them or collapse them into
a single criterion.

---

## Mapping: intent → primitive (Claude Code)

One methodology — **two mappings**. In Codex it maps onto its control files (AGENTS.md); in
Claude Code — onto the CLAUDE.md router + the Workflow layer + the allowlist. Below is the map of Claude Code primitives
(other harnesses have their own, but the roles are the same).

| Intent | Primitive | Note |
|---|---|---|
| Delegate a stream along the way, improvised | **Agent** (subagent, fg/bg) | Fresh context; I continue via SendMessage; a fan-out of readers goes here |
| A deterministic graph of work with integration | **Workflow** (pipeline/parallel/phases) | The core of orchestration: saved+named, budget ceiling, resume journal, nesting 1 level |
| Forbid two writers into a shared contract | **worktree isolation** | Physical enforcement of O3 |
| Spin up a worker in the cloud, always in the background | **remote agent** (`isolation:"remote"`) | Closest to a "separate session" |
| "The company runs continuously" | **cron / scheduled** | Fresh autonomous runs on a trigger/schedule |
| Truly separate parallel sessions | **session-mgmt MCP** | The glue is messaging, not automation; the top rung |

**The mapping rule:** the closest single tool to "the orchestrator runs production" is
**Workflow** (determinism, isolation, budget, resume), supplemented by **Agent** for improvisation.
Do not start with session-mgmt/remote — that is the top of the ladder.

---

## Application A — new work under the orchestrator model

1. **Separate the owner's input from mine.** Owner: outcome, scope, risk, stop (O1). Me: decomposition,
   spinning up workers, integration, evidence. Do not hand the owner anything from the second list.
2. **Check that the brief is green** (Definition of Ready): verifiable acceptance criteria, sources
   of truth, permitted/forbidden actions, a reproducible environment. Yellow → reconnaissance only; red
   → a stop question to the owner.
3. **Decide fan-out or solo** (O10). Coherence-critical authorial work — myself. Decomposable/coverage/
   parallel writers — fan-out.
4. **For every writing stream — a charter** (O5) + an owner of the shared contract (O3, worktree).
5. **Design judgement⟂bookkeeping** inside the workers (O4); integration order is code, not "by eye".
6. **Verify independently** (O6, synthetic user as a separate worker; 4 statuses without substitution).
7. **Lock in durability** (O8): a commit after every accepted output; state goes into the memory layer.
8. **Wake the owner only at stops** (O7).

## Application B — migrating from manual handoff glue (owner = bus)

1. **Fix the orientation:** the owner is above the orchestrator; the agent spins up workers; handoff → charter.
2. **Gap "glue vs auto":** wherever today the owner opens sessions by hand/carries context/integrates —
   that is debt, not a contract.
3. **Move one stream at a time:** the same role control from the existing org model, but the step "spin up
   a worker" is taken over by the orchestrator. You **wrap the existing model, not tear it down** (its roles are right —
   only the launching remains manual).
4. **Lock in every move** with a contract/allowlist and a commit; do not block the project with a big
   rewrite of the org layer.

---

## How to read this file

- **Open it** when choosing how to run a task (yourself / subagent / fan-out / Workflow) or
  designing an autonomous loop in which the owner stays on top as the product.
- **The first question is the owner/orchestrator boundary (O1)**, then fan-out-or-solo (O10), then the primitive.
- **Links:** `agentic-pipeline.md` (designer⟂executor; Application B),
  `llm-as-component.md` (O4: judgement⟂bookkeeping), `human-presence-access.md` (the ladder
  "cheap before expensive"), `delegation.md`/`autonomy.md`/`production-safety.md` (operations,
  stops), the project `TEAM.md` (the reference mapping of state: roles+dependencies), the project
  `INVARIANTS.md`/`METHODOLOGY.md` (contracts and ways of thinking). Continuity between
  sessions — the `/handoff` skill (a thin pointer + a verifiable entry point, O12); the framework mapping
  of the model — `~/Code/Project_init` (the evolution of its handoff/autonomy layer).
- **Add to it:** a new, stable orchestration technique → distil it into O-N (when to apply → technique →
  why). Do not drag domain or harness specifics in here — the primitives live in the mapping.
