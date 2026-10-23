---
title: Backlog
type: backlog
updated: 2026-06-12
---

# Backlog

<!--
What is planned but not yet being worked on.

Boundary with other files:
- SNAPSHOT.md — what is **being worked on right now**.
- BACKLOG.md (this file) — what **will come later**, but is already recognised as work.
- GitHub issues — an external tracker, for projects with a team/public presence.

Item format:
- [ ] <id>: <short title> — <one-line context> (opt. `→ path/to/file` or `#123`)

The id can be arbitrary (B-001, FEAT-12, or just a slug). What matters is
that it can be referenced from a commit or SNAPSHOT.
-->

## Next

<!--
What the agent will pick up next. Ordered by priority from top to bottom.
Each item must be concrete enough to start work without
additional research.
-->

- [ ] B-001: example item — what exactly to do and why (→ `src/example.ts`)

## In flight

- [x] B-002: v6.2.0 — two-axis memory model + methodology layer + dialog preservation. Released 2026-06-12.

## Soon

<!--
Known work for the near future. Not yet broken down into specifics, but
no longer "maybe some day". When its turn comes, detail it
and move it to Next.
-->

- [ ] B-010: example — a direction of work, without a precise plan
- [ ] B-011: subagent watchdog — record a hard timeout in `delegation.md` (if the expected 10 min is exceeded 2×, actively check TaskOutput, otherwise restart). Real case: the dialog-preservation subagent ran for 140 min against an expected 10–15, which looked like a "hang". (→ `~/.claude/rules/delegation.md`)
- [ ] B-012: drift watchdog for description docs — extend the `housekeeping` skill so that it goes through README/RELEASING/CLAUDE.addendum when preparing a release and cross-checks versions. At present `validate-release.sh` catches drift in the badge + link + script headers, but not in the substantive sections.

## Later

<!--
Recognised as needed, but not scheduled. Also for ideas that
look reasonable but do not block current goals.
-->

- [ ] B-100: example — a long-term task or improvement
- [ ] B-101: industrialising the distribution of the "agentic pipeline culture" (the rule set `~/.claude/rules/agentic-pipeline.md`). **A PLAN, not a current change; the gate is field statistics from 5-6 projects.** At present the rule set is rolled out BY HAND (the owner drops a standalone drop-in into projects → the agent "reads it and takes note" → observations are collected in an appendix note inside the rule set itself). Once the statistics have accumulated, industrialise it as a source→derivative (P7) of the framework itself: (1) a version stamp in all evolving rules/methodology; (2) an update mode for `install-global`/`init` (overwrite-on-update with a backup — without it the global default is a "v1 forever" trap); (3) auto-embedding into all projects with a `repo_access` check (do not push a copy of the framework into a shared/public product); (4) `framework-doctor` as a feedback HARVESTER: version skew + local diffs of copies + an index of field-generated M-N/INV; (5) a backflow loop: what has been collected is distilled back into the source → new version → redeploy. **Invariant: harvest BEFORE update** (otherwise the overwrite wipes out the very signal the deployment was for). Motivation: breadth of deployment = density of sensors; the deficit is feedback, not code. Design source: dialog of 2026-06-13 (Saved Downloader).

## Won't do

<!--
Explicitly decided "no"s. One item = one reason. Needed so as not to
reopen debates already closed in the next session or after
compaction. If a decision is revisited, move it to Later/Soon rather than
deleting it with a note about the revision.
-->

- [x] B-901: example of a rejected idea — a one-line reason why we are not doing it
