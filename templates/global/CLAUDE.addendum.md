# Global Claude Code settings

## Available framework layers

`~/.claude/` contains the universal rules, skills and agents of Claude Code Starter. They act as a **baseline grid** across all projects. When a project has its own `.claude/`, it overrides the global layer for its own files; everything else is taken from the global layer.

### Rules (`~/.claude/rules/`)

Universal:
- `autonomy.md`, `delegation.md`, `context-management.md`, `commit-policy.md`, `production-safety.md`, `logging.md`, `local-first.md`, `dialog-preservation.md`
- `orchestration-model.md` (v6.3.0+) — the orchestrator model: owner = product **above** production; agent = orchestrator + lead developer, who spins up workers itself. Read it when choosing how to run a task (yourself / subagent / fan-out / workflow).

Content (for projects with texts/courses/books):
- `content-pipeline.md` — Intake → Research → Outline → Write → Enrich → Review → Export
- `content-quality.md` — universal review checklist (28 points)
- `source-management.md` — provenance, hierarchy, deficits
- `content-formats.md` — chapter/lesson/transcript/article/document formats
- `content-commit-policy.md` — content prefixes (`content:`, `chapter:`, `lesson:`, `research:`, `index:`)

Apply the content rules if the project's `manifest.md` has `project_type=content` or `project_type=hybrid`.

### Skills (`~/.claude/skills/`)

General: `/start`, `/finish`, `/testing`, `/handoff`, `/housekeeping` (universal — checks both code and content), `/save-dialog` (archive of session JSONL files)

Code: `/db-migrate`, `/playwright`

Content: `/research`, `/outline`, `/write-content`, `/review-content`, `/enrich`, `/content-index`

Bootstrap: `/setup-project` — installs the framework into the current folder (auto-detects type). This is a custom skill from Claude Code Starter; do not confuse it with the built-in `/init` command, which simply generates CLAUDE.md documentation.

### Dialog Preservation (`dialog-preservation.md` + `/save-dialog`)

Claude Code writes the current session's JSONL to `~/.claude/projects/<encoded-cwd>/`. These files are cleaned up over time by retention. The global grid includes:

- the `dialog-preservation.md` rule — where to copy, how to index, the `repo_access` policy;
- the `/save-dialog` skill — explicitly saves the current session into `.claude/dialogs/`;
- automatic saving on `/finish` (if `scripts/save-dialogs.sh` is installed in the project).

The `.claude/dialogs/` archive is committed only under `repo_access=private-solo`; in shared/public it stays local.

### Agents (`~/.claude/agents/`)

- `researcher` — research (universal: code and content)
- `implementer` — code implementation
- `reviewer` — code review
- `writer` — writing/adapting content units
- `editor` — checks content style/voice/format (finds problems, does not rewrite)
- `content-reviewer` — release review for content (28-point checklist)

### Methodology layer (`~/.claude/methodology/`)

Global methodologies for pipelines (router → adapter → executor). Their consumers are automated LLM chains, not the interactive agent.

- `_HOW-THIS-GROWS.md` — explains the maturity ladder draft → pattern → mature → crystallized
- `00-example-llm-as-component.md` — canonical mature example (the LLM as an unreliable component)

Project methodologies in `<project>/methodology/` may reference the global ones and refine them for the local context. More detail — `_HOW-THIS-GROWS.md`.

### Project memory layers

Projects with the framework keep memory on two axes:

- **Contracts** (change slowly): `.claude/ARCHITECTURE.md`, `.claude/INVARIANTS.md`, `methodology/`
- **State** (changes quickly): `.claude/SNAPSHOT.md`, `.claude/BACKLOG.md`, `.claude/dialogs/`

When a session starts in a project, read both axes. When it finishes, update both. Do not collapse the contracts into SNAPSHOT (this is a known v5 regression).

### The `/start` protocol and the three kinds of constraint (v6.2.1+)

The `/start` skill in v6.2.1+ projects works on these principles:

1. **Reads both memory axes** (contracts + state) — mandatory.
2. **Grounds the map in the territory** — `git log`, `wc -l` over the main directories, `grep` for TODO/FIXME/NotImplementedError. The meta-files are the map; if it has drifted from the code, you inherit its blind spots. Grounding costs a minute; the value is a picture you can trust.
3. **The report scales to the user's request**, it is not fixed by a format. A routine "start" — compact; "get to grips with the project" — a full analytical breakdown. The minimum is a floor of adequacy; there is no ceiling.
4. **Remembers that after `/start` this is the map, not the territory** — before changing a subsystem it reads that subsystem's code and local docs.

This follows from the "three kinds of constraint" principle documented in the header of the project `CLAUDE.md`:

| Kind of constraint | Norm |
|---|---|
| On actions (INVARIANTS, production-safety) | **strict** |
| On attention (reading order, two axes) | **useful** |
| On depth/output of the report | **never cap** |

If any protocol says "report N lines" in relation to **understanding**, that is a structural bug, not a norm. See [FRAMEWORK-CASE-ONBOARDING.md](https://github.com/alexeykrol/claude-code-starter/blob/main/FRAMEWORK-CASE-ONBOARDING.md) for the analysis.

A parallel `ONBOARDING.md` is not generated in framework projects and is forbidden by the validator: the constitution lives only in `CLAUDE.md`, which the harness auto-loads.

### The orchestrator model (v6.3.0+)

The default way of working is three-tier, not a flat "agent + subagents":

```
OWNER         product/methodologist ABOVE production: goal + scope of authority + review + stop points
ORCHESTRATOR  agent in the lead session: cuts work into streams, spins up workers ITSELF, integrates, verifies, commits
WORKERS       ephemeral executors in their own contexts (subagents / worktree / workflows); invisible to the owner
```

Key rules (full compendium — `~/.claude/rules/orchestration-model.md`, O1–O12):

1. **Don't pester the owner** about spinning up workers, integration or commits — that is the agent's production layer. Stop points: production, external effects, the irreversible, deletion of runtime data.
2. **A writing worker gets a charter** (goal, sources of truth, boundaries, verification commands, stop conditions); without a charter — read-only reconnaissance only.
3. **Single writer per shared contract** (schema/API/CI/entrypoint) — enforced by worktree isolation, not by discipline.
4. **Evidence:** `passed / failed / not_run / inconclusive`, without substituting optimism; the verifier is independent and does not fix its own findings.
5. **Continuity between sessions** is held by two-axis bounded memory + `/handoff` as a thin pointer — not an ever-growing context megafile.

## Behaviour at session start

1. **If the current folder has no project `.claude/`** — this is probably a new folder. Suggest that the user run `/setup-project`, which will install the framework. Do not run it silently — it creates files in their project.

2. **If there is a project `.claude/`** — normal work. Do the usual cold start: read `CLAUDE.md`, `.claude/SNAPSHOT.md`, report readiness.

3. **If there is a project `.claude/` but it is outdated** (for example, it contains `.claude/commands/` or `.claude/protocols/` — artefacts of old versions) — this is a legacy framework. Suggest running `/setup-project` for a safe additive migration.

## How to determine the current project's type

If there is a `manifest.md` → read `project_type` and `content_type`. If not — determine it from the contents:

- Folders `chapters/`, `briefs/`, `bible/` → book
- `modules/`, `lessons/` → course
- `articles/`, `INDEX.md` → knowledge base
- `Section-*/`, `*-Lecture-*` → transcripts
- `package.json`/`pyproject.toml` + content folders → hybrid
- Only `package.json`/`pyproject.toml` without content folders → code

If it is ambiguous — ask a single question.

## Framework source

The path to the framework checkout is recorded in `~/.claude/framework-source-path`. The `/setup-project` skill uses it to run the installer. If the file is missing, the skill will find the checkout in the standard locations itself or clone it from GitHub.
