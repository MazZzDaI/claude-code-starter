# Rule: Delegation to subagents

## Task assessment criteria

On receiving a task — first assess:

**Yourself (< 2 min):**
- Quick edits, small fixes
- Discussions, analysis, answering questions
- Changes < 50 lines of code
- Updating configs and meta-files

**Subagent (> 5 min):**
- Code > 50 lines
- New modules or components
- Refactoring existing code
- UI changes
- Research and documentation analysis
- Testing (unit, integration, E2E)

## Delegation protocol

1. **Write a detailed brief** for the subagent:
   - Task context
   - Files to read
   - Expected result
   - Constraints

2. **Launch the subagent** (via the Agent tool)

3. **Tell the user** what has been launched (briefly)

4. **Parallelism:** launch several subagents at once on independent tasks

## Orchestration: charter, fan-out/solo, single writer, evidence

A layer on top of delegation — the operational levers of the orchestrator model (see `autonomy.md` →
"Orchestrator model"; full code — `~/.claude/rules/orchestration-model.md`).

- **Charter — the unit of control over a worker (O5).** Give a writing worker a short contract: goal;
  sources of truth (read); expected output; owner of files/contracts; permitted actions;
  verification commands; stop conditions; report format. **Without a charter a worker only scouts (read-only)
  and does not change the shared codebase.** Charter = an internalised handoff: you write it, not the owner.
- **Fan-out or solo (O10).** Fan-out (several workers) — for the decomposable, for coverage (many
  readers from different angles), for parallel writers. Solo (yourself) — for coherence-critical
  authorial work (a single contract, methodology, subtle unified logic): parallelising something
  authorially whole = a Frankenstein. Knowing when NOT to fan out is part of judgement.
- **Single writer per shared contract (O3).** Schema / API / migration / dependency-manifest / CI /
  entrypoint — one designated writer + a separate integration path. Parallel writers into one
  contract are made **impossible** by worktree isolation (`isolation:"worktree"`), not by discipline.
  Separate them in advance — don't wait for a merge conflict as the coordination signal.
- **Evidence without substitution (O6).** The outcome of a verification worker is exactly one of
  `passed / failed / not_run / inconclusive`; don't rewrite the last two with optimism. The verifier
  is independent and does **not** fix its own findings. Don't invent progress / ETA / success.
- **Deterministic orchestration — Workflow.** For a graph of work with integration (pipeline/parallel,
  worktree isolation, budget, resume) use saved workflows in `.claude/workflows/`, not a manual
  fan-out of subagents. Judgement goes to the model worker, bookkeeping (tracking/dedup/ordering/statuses) to code (O4).

## Mandatory cycle after a subagent finishes

**This is critically important. Without this step the subagent's work is "lost".**

Subagents (implementer, researcher, reviewer) **do not commit themselves** — that is the manager's responsibility. The `SubagentStop` hook will remind you, but you must carry out the cycle.

After a subagent has returned its result:

1. **Assess the result** — was the brief carried out correctly
2. **git add + git commit** — record the subagent's changes (the manager commits, not the subagent)
3. **Update SNAPSHOT.md** — what changed, what the project state is now
4. **Integrate into context** — make sure your understanding of the project is up to date

**With parallel subagents:** don't wait for all of them to finish. Commit each subagent's result as it arrives. One subagent = one commit + one SNAPSHOT update.

If this cycle is not carried out:
- After compaction the agent will "forget" the subagent's work
- In the next session the project state will be out of date
- Drift is possible: the agent will start doing what has already been done

## Standard subagents

| Agent | When to use |
|-------|-------------------|
| `researcher` | Code search, web research, documentation analysis |
| `implementer` | Writing code > 50 lines, creating modules |
| `reviewer` | Code review, quality checks, finding problems |
