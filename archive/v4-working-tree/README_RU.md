# Claude Code Starter

A dual-agent meta-framework for structured AI development with **Claude Code** and **Codex**.

> The repository name `claude-code-starter` has been kept for backwards compatibility.

[![GitHub](https://img.shields.io/badge/GitHub-claude--code--starter-blue)](https://github.com/alexeykrol/claude-code-starter)
[![Version](https://img.shields.io/badge/version-4.0.2-orange.svg)](https://github.com/alexeykrol/claude-code-starter)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

---

> **EN version:** [README.md](README.md)

## What's new in v4.0.0

- A full **dual-agent** architecture: a Claude branch + a Codex branch in a single framework.
- A shared state contract: `.claude/SNAPSHOT.md`, `.claude/BACKLOG.md`, `.claude/ARCHITECTURE.md`.
- Additive installation: the existing Claude setup is not broken; Codex is added alongside it.
- In Codex, `start` supports automatic routing of migration/upgrade and automatic framework updates.
- Improved migration: legacy/upgrade can produce meaningful memory files from the project's materials.

## For users

### Requirements

- Node.js 18+
- Python 3.x

Check:

```bash
node --version
python3 --version
```

### Installing into any host project

1. Copy `init-project.sh` into the root of the host project.
2. Run the installer:

```bash
./init-project.sh
```

The installer now asks for a **project profile**:
- `software` — for software development projects (service/application/source code).
- `content` — for content projects (course/book/article/research/screenplay).

Each profile uses its own structure of memory files and generation.

3. Run your preferred agent in this project:
- `codex`
- `claude`

4. Start the protocol:
- `start`

5. Finish the protocol:
- `/fi`

## Workflow

### Start

The `start` command performs a cold start:

- migration/upgrade routing (on the first run),
- crash/session check,
- loading of the shared context,
- framework version check (with automatic update if needed).

Context files are chosen by profile:
- software: `.claude/SNAPSHOT.md`, `.claude/BACKLOG.md`, `.claude/ARCHITECTURE.md`
- content: `.claude/content/SNAPSHOT.md`, `.claude/content/BACKLOG.md`, `.claude/content/ARCHITECTURE.md`

### Finish

The `/fi` command performs completion:

- security/export checks,
- git status/diff checks,
- session finalisation.

## Framework structure

```text
claude-code-starter/
├── CLAUDE.md                    # Entry point for Claude
├── AGENTS.md                    # Entry point for Codex
├── init-project.sh              # Installer for host projects
├── CHANGELOG.md
├── README.md
├── README_RU.md
├── .claude/
│   ├── commands/                # Claude workflows/prompts
│   ├── protocols/               # Silent protocol specs
│   ├── scripts/quick-update.sh  # Update entry point for Claude
│   └── templates/               # State/config templates
├── .codex/
│   ├── commands/                # Executable Codex workflows
│   │   └── quick-update.sh      # Update entry point for Codex
│   └── contracts/
├── src/framework-core/          # Shared Python runtime (cold-start/completion)
├── security/                    # Security scan/cleanup scripts
└── migration/                   # Build and release scripts
```

## Migration modes

The installer automatically detects the type of host project:

- `new` — initialisation in a new project,
- `legacy` — migration of an existing project,
- `upgrade` — upgrade from an older version of the framework.

In all modes the installer also records the project profile (`software` or `content`) in `.claude/.framework-config`.

In all modes the host project's business code must not be broken.

## Update model

- A version check is built into `start`.
- If a new version is available and an updater is present, the update is applied automatically.
- The update package includes both branches (Claude + Codex) to preserve parity.

## For framework developers

### Preparation

```bash
git clone https://github.com/alexeykrol/claude-code-starter.git
cd claude-code-starter
npm install
npm run build
```

### Building the distribution

```bash
bash migration/build-distribution.sh
```

Artefacts are created in `dist-release/`:

- `init-project.sh`
- `framework.tar.gz`
- `framework-commands.tar.gz`

## Versioning

- Semantic Versioning is used.
- `4.0.0` is a major release, because the framework moved from a single-agent to a dual-agent contract.

For details, see [CHANGELOG.md](CHANGELOG.md).

## Contributing

1. Create a branch
2. Make your changes
3. Run the local checks/build
4. Open a PR

---

The framework's goal: to give the user a choice of agent with a single project state and a single protocol model.
