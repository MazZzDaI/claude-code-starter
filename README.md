# Claude Code Starter v6

[![Version](https://img.shields.io/badge/version-v6.3.0-2563eb)](https://github.com/alexeykrol/claude-code-starter)
[![Status](https://img.shields.io/badge/status-active-16a34a)](https://github.com/alexeykrol/claude-code-starter)
[![Installer](https://img.shields.io/badge/installer-single--file-f59e0b)](https://github.com/alexeykrol/claude-code-starter/blob/main/init-project.sh)
[![Shell](https://img.shields.io/badge/shell-bash-111827?logo=gnubash)](https://www.gnu.org/software/bash/)
[![Git](https://img.shields.io/badge/git-required-f05032?logo=git&logoColor=white)](https://git-scm.com/)
[![Python](https://img.shields.io/badge/python3-recommended-3776ab?logo=python&logoColor=white)](https://www.python.org/)
[![Claude Code](https://img.shields.io/badge/Claude_Code-rules%2Bskills%2Bagents%2Bhooks-d97706)](https://www.anthropic.com/claude-code)

`Claude Code Starter` is a ready-made management environment for projects in which the main working agent is Claude Code.

It is not meant for generating an application; it is meant for quickly adding to any project:
- a clear `CLAUDE.md` instead of a mega-document;
- modular `rules`, `skills`, `agents`, `hooks`;
- **two-axis project memory** — contracts (`ARCHITECTURE.md`, `INVARIANTS.md`, `methodology/`) and state (`SNAPSHOT.md`, `BACKLOG.md`, `dialogs/`);
- a **methodology layer** with a maturity ladder (draft → pattern → mature → crystallized) for pipelines with automated LLM calls;
- **dialog preservation** — the current session's JSONL is saved to `.claude/dialogs/` before Claude Code performs its retention cleanup;
- an **orchestrator working model** — the owner stays the product above production, while the agent itself spawns and coordinates workers;
- a single installer for new, existing and legacy projects;
- explicit control over what framework state does to git history.

**What's new in v6.3.0:** the framework moves to the **orchestrator model**. The owner is the product/methodologist **above** production: sets the goal and the limits of authority, reviews the result and decides at stop points. The agent is the **orchestrator and lead developer**: it splits the work into streams itself, spawns workers itself (subagents / isolated worktrees / deterministic workflows), integrates, independently verifies and commits — without pestering the owner to confirm every step. Handoff evolves from a manual "bridge" that the owner carried between sessions into an internal **charter** that the orchestrator hands to workers; context continuity between sessions is held by **bounded two-axis memory + a thin pointer**, not by an ever-growing mega-file. The model ships as the portable rule set `orchestration-model.md` (principles O1–O12), the `autonomy`/`delegation` rules have evolved to match it, and the `/handoff` skill is now part of the distribution. See [release-notes/v6.3.0.md](release-notes/v6.3.0.md).

**What's new in v6.2.1:** the `/start` skill has been rewritten — the "report in 3-5 lines" cap has been removed (the model read it as a ceiling on depth, not a floor on brevity), a mandatory step of **grounding the map in the territory** has been added (git log + wc + grep against the metafiles' claims), plus a "map ≠ territory" marker. The header of `CLAUDE.md` gets a new "Purpose of this file" section with **three kinds of constraints** (actions / attention / depth): the first two are normal, a cap on depth is a structural bug. `validate-release.sh` now forbids a parallel `ONBOARDING.md` (the constitution lives only in `CLAUDE.md`). See [release-notes/v6.2.1.md](release-notes/v6.2.1.md).

**What's new in v6.2.0:** the `ARCHITECTURE.md` and `BACKLOG.md` memory layers have been restored, and `INVARIANTS.md` and the `methodology/` directory with its maturity ladder (draft → pattern → mature → crystallized) have been added. A dialog preservation mechanism has been added (`scripts/save-dialogs.sh`, the `/save-dialog` skill, auto-save on `/finish`).

**What's new in v6.0–6.1:** automatic detection of the project type (code / content / hybrid). Content projects — books, courses, knowledge bases, documents, transcripts — get their own set of rules, skills and agents (writer, editor, content-reviewer). An optional global layer `~/.claude/` with the `/setup-project` skill. Installation without flags: `bash init-project.sh` works out where it is and installs the appropriate layer.

## Why It Is Needed

When working with an agent, a project usually sprawls quickly:
- instructions live in one long `CLAUDE.md`;
- rules are mixed up with project context;
- starting a new project and migrating an old one are done differently;
- agent memory is lost between sessions;
- internal framework files accidentally end up in shared/public git history.

`Claude Code Starter` solves these problems:
- separates the project passport from operational logic;
- provides a standard `.claude/` structure;
- adds reusable workflows via `skills`;
- adds background guardrails via `hooks`;
- supports single-file installation;
- introduces `repo_access`, so that the agent's memory does not leak where it does not belong.

## What Gets Installed Into the Project

After installation the host project has the following base:

```text
.claude/
  rules/                # operational rules (autonomy, delegation, dialog-preservation, ...)
                        #   autonomy + delegation carry the orchestrator model (v6.3.0+):
                        #   owner above production, the agent spawns workers itself
  skills/               # /start, /finish, /save-dialog, /testing, ...
  agents/               # researcher, implementer, reviewer (+ writer/editor for content)
  hooks/                # background guardrails (pre-compact, post-compact, ...)
  logs/                 # sessions, migrations, errors (gitignored)
  dialogs/              # archive of session JSONL files (gitignored by default)
  SNAPSHOT.md           # state: the current point of work
  BACKLOG.md            # state: Next / Soon / Later / Won't do
  ARCHITECTURE.md       # contract: map of the system
  INVARIANTS.md         # contract: hard rules, violation = bug
  settings.json
methodology/            # contract: methodologies for pipelines
  _HOW-THIS-GROWS.md
  templates/            # draft / pattern / mature / crystallized
  draft/ patterns/ mature/
  00-example-llm-as-component.md
scripts/
  framework-state-mode.sh
  switch-repo-access.sh
  save-dialogs.sh
CLAUDE.md
manifest.md
.gitignore
```

**Two-axis memory** (see the "Memory layers" section of CLAUDE.md):
- **Contracts — what should be** (changes slowly): `ARCHITECTURE.md`, `INVARIANTS.md`, `methodology/`
- **State — what is now** (changes quickly): `SNAPSHOT.md`, `BACKLOG.md`, `dialogs/`

Key files:
- `CLAUDE.md` — the project passport;
- `manifest.md` — `project_name`, `repo_access`, `project_type`, `content_type`;
- `.claude/SNAPSHOT.md` — what is being worked on right now;
- `.claude/BACKLOG.md` — the plan: Next / Soon / Later / Won't do;
- `.claude/ARCHITECTURE.md` — map of modules, contracts, dependencies;
- `.claude/INVARIANTS.md` — rules whose violation is a bug, not a preference;
- `.claude/dialogs/` — archive of session JSONL files for later analysis;
- `methodology/` — methodologies with a maturity ladder (draft → pattern → mature → crystallized);
- `.claude/rules/`, `.claude/skills/`, `.claude/agents/`, `.claude/hooks/` — the operational layer;
- `scripts/save-dialogs.sh` — idempotent saving of the session JSONL;
- `scripts/switch-repo-access.sh` — safe switching between `private-solo`, `private-shared`, `public`.

## Requirements

Required:
- `bash`
- `git`
- Claude Code with support for:
  - `.claude/rules/`
  - `.claude/skills/`
  - `.claude/agents/`
  - `.claude/hooks/`

Recommended:
- `python3`

Optional:
- `node` / `npm`
- `pytest`
- `sqlite3`
- `psql`
- `supabase`

`python3` is not needed for bootstrap, but for a safe merge of `settings.json` in the migration flow.

## Installation

### Option 1. A single file

Take the root installer `init-project.sh`, put it in the root of the target project and run it:

```bash
chmod +x init-project.sh
./init-project.sh
```

No flags are needed. The launcher determines by itself:

**Installation scenario:**
- `new` — a new project;
- `existing` — an existing project without the framework;
- `legacy` — an old framework;
- `upgrade` — a partially installed one.

**Project type** (from the contents of files and folders):
- `code` — an ordinary software project;
- `content` — books, courses, KB, documents, transcripts;
- `hybrid` — both code and content.

**Content type** for content projects:
- `book` — folders `chapters/`, `briefs/`, `bible/`;
- `course` — folders `modules/`, `lessons/`;
- `knowledge-base` — `articles/`, `INDEX.md`;
- `documents` — `docs/`;
- `transcripts` — `Section-*/`, `*-Lecture-*`;
- `mixed` — several at once.

If installation touches an existing `CLAUDE.md`, it is merged **additively** via `scripts/lib/merge_claude_md.py` — the user's custom sections are preserved, and the framework adds only what is missing. On a hard conflict the installation stops and a concrete resolution proposal is written to `.claude/CLAUDE.md.merge-proposal.md`.

### Option 2. From a local checkout

```bash
cd /path/to/your/project
bash /absolute/path/to/claude-code-starter/init-project.sh
```

### Option 3. Global layer + the `/setup-project` skill

If you want the framework to be available **in any folder** without downloading it every time, install it into `~/.claude/`:

```bash
bash /path/to/claude-code-starter/scripts/install-global.sh
```

This additively copies rules / skills / agents into `~/.claude/` without touching existing settings. It makes a backup in `~/.claude/.backup-TIMESTAMP/`. After that:

```bash
mkdir my-new-project && cd my-new-project
# Open Claude Code in this folder and say:
# /setup-project   — or simply: "new project" / "install the framework"
```

The `/setup-project` skill finds the checkout by itself, determines the project type and installs the framework. No manual download of `init-project.sh` is required.

Rollback: `bash scripts/install-global.sh --rollback`.

### Useful parameters

```bash
./init-project.sh --name "My Project"
./init-project.sh --type content --content-type book
./init-project.sh --mode init
./init-project.sh --mode migrate
./init-project.sh --template /path/to/local/framework
./init-project.sh --rollback
./init-project.sh --apply-proposal
./init-project.sh --force
```

Supported:
- `--name` — the project name for a fresh bootstrap;
- `--type code|content|hybrid|auto` — override project type auto-detection;
- `--content-type book|course|knowledge-base|documents|transcripts|mixed` — override content type auto-detection;
- `--mode init` — forced bootstrap;
- `--mode migrate` — forced migration/integration;
- `--template` — use a local checkout of the framework instead of a download;
- `--rollback` — restore files from the latest `.claude/backup-*/` snapshot;
- `--apply-proposal` — apply the proposal from `.claude/CLAUDE.md.merge-proposal.md`;
- `--force` — overwrite existing files (for framework developers).

## What to Do After Installation

1. Fill in `CLAUDE.md` for the specific project.
2. Check `manifest.md`.
3. If the project is shared/public, switch the mode before the first framework commit:

```bash
scripts/switch-repo-access.sh public --commit
```

or

```bash
scripts/switch-repo-access.sh private-shared --commit
```

4. Open the project in Claude Code and run `/start`.

## Repo Access

`repo_access` is set in `manifest.md`.

Modes:
- `private-solo` — framework files may be kept in git;
- `private-shared` — framework files must stay local;
- `public` — framework files must stay local.

In practical terms:
- if the repository is personal, framework state may be kept in history;
- if the repository is shared or public, the agent's memory must not end up in branch history.

If framework state has already made it into remote history, `.gitignore` alone is not enough. That is exactly what `scripts/switch-repo-access.sh` exists for.

## How This Repository Is Organised

Public entry point:
- [init-project.sh](init-project.sh) — the single installer entrypoint

Internal payload:
- [scripts/init-project.sh](scripts/init-project.sh) — bootstrap payload
- [scripts/migrate.sh](scripts/migrate.sh) — migration payload
- [scripts/framework-state-mode.sh](scripts/framework-state-mode.sh) — `repo_access` logic
- [scripts/switch-repo-access.sh](scripts/switch-repo-access.sh) — safe mode switch

Documentation:
- [CHANGELOG.md](CHANGELOG.md) — history of versions and changes
- [RELEASING.md](RELEASING.md) — how to build and publish a release
- [release-notes/v6.3.0.md](release-notes/v6.3.0.md) — notes for the current release
- [release-notes/GITHUB_RELEASE_v6.3.0.md](release-notes/GITHUB_RELEASE_v6.3.0.md) — ready-made body for the GitHub Release

Archive:
- [archive/V4_ARCHIVE_NOTE.md](archive/V4_ARCHIVE_NOTE.md) — what exactly has been kept from `v4`
- [archive/v4-working-tree](archive/v4-working-tree) — the archived `v4` tree

## Limitations

1. `switch-repo-access.sh` does not rewrite git history.
2. `migrate.sh` depends on `python3` if a safe merge of `.claude/settings.json` is needed.
3. The standalone installer works best via GitHub Release assets.
4. Hooks here are guardrails, not an absolute enforcement layer.

## Quick Links

- Install the framework: [init-project.sh](init-project.sh)
- Read the version history: [CHANGELOG.md](CHANGELOG.md)
- Build a release: [RELEASING.md](RELEASING.md)
- View the notes for the current release: [release-notes/v6.3.0.md](release-notes/v6.3.0.md)
- Take the GitHub Release text: [release-notes/GITHUB_RELEASE_v6.3.0.md](release-notes/GITHUB_RELEASE_v6.3.0.md)

## Version evolution

| Topic | v5 | v6.0–6.1 | v6.2.0 | v6.2.1 | v6.3.0 |
|------|----|----|------|--------|--------|
| Working model | agent-manager + subagents | same | same | same | **orchestrator model**: owner above production, the agent spawns workers itself (`orchestration-model.md`, O1–O12) |
| Owner's role | gives the brief, stitches sessions together by hand | same | same | same | product/methodologist: goal + limits + review + stop points; spawning workers and integration belong to the agent |
| Handoff / continuity | none | none | SNAPSHOT + hooks | same | `/handoff` in the distribution; charter for workers; bounded memory instead of a mega-file |
| Project type | code only | code / content / hybrid with auto-detection | + explicit two-axis memory model | same | same |
| Memory layers | `SNAPSHOT.md` (everything in one) | `SNAPSHOT.md` | `SNAPSHOT.md` + `BACKLOG.md` (state) + `ARCHITECTURE.md` + `INVARIANTS.md` (contracts) | same | same |
| Content projects | none | books, courses, KB, documents, transcripts | + content-flavoured memory layers | same | same |
| Methodology layer | none | none | `methodology/` with a maturity ladder draft → pattern → mature → crystallized | + canonical draft on the onboarding cap | same |
| Dialog preservation | TypeScript stack in v4, dropped in v5 | none | bash script + `/save-dialog` skill + auto-save on `/finish` | same | same |
| `/start` skill | basic | basic | reads both memory axes | + grounding (git log/wc/grep against the metafiles), scalable report, "map ≠ territory" | same |
| `CLAUDE.md` header | passport-only | passport-only | + "Memory layers" | + "Purpose" with three kinds of constraints (actions / attention / depth), depth cap forbidden | same |
| `CLAUDE.md` on migration | merge of `settings.json` hooks only | full additive merge of sections via a Python helper | + documentation of two-axis memory | same | same |
| Conflicts | overwrite or skip | detected, stop the installation, write a concrete proposal | same | same | same |
| Backup | none | automatic `.claude/backup-TIMESTAMP/` | + backup of the new memory files | same | same |
| Rollback | manual | `init-project.sh --rollback` | + restores the new memory files | same | same |
| Global layer | none | optional `~/.claude/` via `install-global.sh` | + global `methodology/`, `/save-dialog` skill | same | + `orchestration-model.md`, `/handoff` skill |
| Drift guards | none | none | none | `validate-release.sh` checks the README badge + release-notes link + script headers, forbids `ONBOARDING.md` | same |
| Content templates | none | `chapter.md`, `lesson.md`, `transcript.md`, `article.md`, `document.md` | same | same | same |

For details on the evolution of versions, see [CHANGELOG.md](CHANGELOG.md).

## Credits and Licence

- **Originator:** [Alexey Krol](https://github.com/alexeykrol) — author of the Claude Code Starter framework ([original repository](https://github.com/alexeykrol/claude-code-starter)).
- **British English translation:** Oleksandr Dudarenko.

Released under the [MIT Licence](LICENSE).
