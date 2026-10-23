---
name: setup-project
description: "Install the Claude Code Starter framework into the current folder. Auto-detects the project type (code/content/hybrid). Invoked by the phrases: /setup-project, setup project, start a project, initialisation, new project, set up the framework, install the framework, bootstrap framework. (Not to be confused with the built-in /init, which only generates CLAUDE.md.)"
allowed-tools: Read Write Edit Bash Glob Grep
disable-model-invocation: false
---

# Skill: Setup Project (Framework Bootstrap)

## Purpose

Install the Claude Code Starter framework into the current working folder. Auto-detects what kind of project it is (code, content, hybrid) and creates the minimum necessary structure without damaging existing files.

## When it applies

- The user said `/setup-project`, `setup project`, `bootstrap`, `set up the framework`, `install the framework`, `start a project`, `initialise the project`, `new project`
- The user is working in a freshly created folder without `CLAUDE.md` and `.claude/`, and asks to start work
- The project has an outdated framework and the user wants to upgrade

**Do NOT confuse** this with the built-in Claude Code command `/init` — that one does something quite different (generates a documentation CLAUDE.md). This skill is about installing the framework infrastructure (rules, skills, agents, hooks, manifest).

## Algorithm

### 1. Find the framework source

Check in order:

```bash
# Step 1: cached source path
if [ -f ~/.claude/framework-source-path ]; then
    FRAMEWORK_PATH=$(cat ~/.claude/framework-source-path)
fi

# Step 2: common locations
for candidate in "$FRAMEWORK_PATH" "$HOME/Code/Project_init" "$HOME/Code/claude-code-starter" "$HOME/.claude/framework-source"; do
    if [ -n "$candidate" ] && [ -f "$candidate/init-project.sh" ] && [ -f "$candidate/scripts/lib/install_common.sh" ]; then
        FRAMEWORK_PATH="$candidate"
        break
    fi
done

# Step 3: clone if missing
if [ -z "$FRAMEWORK_PATH" ]; then
    git clone https://github.com/alexeykrol/claude-code-starter.git ~/.claude/framework-source/
    FRAMEWORK_PATH=~/.claude/framework-source
fi
```

Write the path you found back: `echo "$FRAMEWORK_PATH" > ~/.claude/framework-source-path`.

### 2. Check the state of the current folder

```bash
PROJECT_DIR="$(pwd)"
HAS_FRAMEWORK="no"
[ -d ".claude" ] && [ -d ".claude/rules" ] && HAS_FRAMEWORK="yes"
HAS_CLAUDE_MD="no"
[ -f "CLAUDE.md" ] && HAS_CLAUDE_MD="yes"
TOTAL_FILES=$(find . -maxdepth 2 -type f -not -path './.git/*' 2>/dev/null | wc -l | tr -d ' ')
```

### 3. Run the installer

Just invoke the main installer — it does the auto-detect, backup and safe merge itself:

```bash
bash "$FRAMEWORK_PATH/init-project.sh"
```

If the installation wants a project name (fresh folder), the installer will take the name of the current directory. It will determine the project type automatically from the contents.

### 4. After installation

Read `manifest.md` and tell the user in one line what the outcome was:

```text
✅ Framework installed: <project_type> / <content_type>
   Backup in .claude/backup-<TIMESTAMP>/
   Rollback: bash init-project.sh --rollback
   Next: edit CLAUDE.md for the project and say /start
```

## Edge cases

### Folder already has the framework

If `HAS_FRAMEWORK=yes`, do not silently run the install again. Ask a single question:
- "The framework is already installed in this folder. Upgrade additively (migrate)? [Y/n]"
- On Y — run `bash "$FRAMEWORK_PATH/scripts/migrate.sh" --template "$FRAMEWORK_PATH"`
- On n — do nothing, report back

### Serious CLAUDE.md conflict

If the installer exited with exit 2, it has already written `.claude/CLAUDE.md.merge-proposal.md` and has NOT changed any files. Show the user a short summary of the proposal and the command to apply it:
```text
⚠️ Installation stopped — conflict in CLAUDE.md.
I have prepared a resolution in .claude/CLAUDE.md.merge-proposal.md.
Apply:  bash init-project.sh --apply-proposal
```

### git not found

The installer itself offers `git init` if there is no repo. That is OK — skip it, carry on.

### What NOT to do

- Do not silently run the installation in a large project with many files and no .git — first show what you are about to do
- Do not rewrite an existing CLAUDE.md "by hand" — that is the job of `merge_claude_md.py`
- Do not ask more than one question. Auto-detect should cover 95% of cases. If unsure — choose yourself and tell the user what you chose

## Output

Always brief: what was there before, what was added, the backup path, the next action.
