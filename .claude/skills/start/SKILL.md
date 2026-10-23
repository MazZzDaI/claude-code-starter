---
name: start
description: "Initialise a working session. Build an adequate model of the project, ground it in the code, report with depth matching the request."
allowed-tools: Read Glob Grep Bash
disable-model-invocation: true
---

# Skill: Start Session

## Purpose

Build an **adequate model of the project** — structurally correct, grounded in the code, aware of its own limits. Protect the project while the model is being built.

**The three kinds of constraint in this protocol are deliberately different in nature:**

| Kind | Where | How to treat it |
|-----|-----|---------------|
| On actions (`INVARIANTS.md`, production-safety) | in code/contract | **strictly** — guardrails |
| On attention (reading order, the two memory axes) | in this skill | **helpful** — structure makes depth achievable |
| On the depth/output of the report | — | **no such constraints** — depth is dictated by the request, not by the format |

No "report in 3–5 lines". The minimum is a floor of adequacy; there is no ceiling.

## What to do

### 1. Read the memory layers — both axes

**Contracts (what should be):**
```
Read .claude/ARCHITECTURE.md   (if present)
Read .claude/INVARIANTS.md     (if present — violations = a bug, not a preference)
```

**State (what is now):**
```
Read .claude/SNAPSHOT.md       (the current working point)
Read .claude/BACKLOG.md        (if present — the Next/Soon/Later plan)
```

If some layers are missing — that's OK for an old project; in a new v6.2+ one it's a sign of an incomplete installation. Don't panic, carry on.

### 2. Read CLAUDE.md

```
Read CLAUDE.md
```

### 3. Ground the map in the territory (mandatory)

Meta-files are the **map, not the territory**. If SNAPSHOT/ARCHITECTURE have diverged from the code, you will inherit the inaccuracy along with the blind spots and won't notice. The cost of grounding is a minute; the value is a picture you can trust.

Minimum:

```bash
# Chronology
git log --oneline -10
git status --short

# Volume of code/content in the main directories
for d in src lib app scripts chapters lessons modules docs; do
  [ -d "$d" ] && echo "$d: $(find "$d" -type f \( -name '*.py' -o -name '*.ts' -o -name '*.tsx' -o -name '*.js' -o -name '*.sh' -o -name '*.md' \) 2>/dev/null | xargs wc -l 2>/dev/null | tail -1)"
done

# Stubs and unfinished work — where the map promises functionality but the code has a TODO
grep -rn "TODO\|FIXME\|stub\|raise NotImplementedError\|pass *#" src/ lib/ app/ scripts/ 2>/dev/null | head -20
```

If you find a discrepancy — "SNAPSHOT/ARCHITECTURE say X, but grep/wc show Y" — state it explicitly in the report; don't smooth it over.

### 4. Check the framework version (in the background)

```bash
grep -m1 'v[0-9]' README.md 2>/dev/null || true
```

Does not block the start.

### 5. Create the session log

```bash
mkdir -p .claude/logs/sessions
```

The file `.claude/logs/sessions/YYYY-MM-DD_HH-MM.md` with the initial state.

### 6. Report — depth matching the request

The report **scales to the user's request**:

| User's request | Reference report |
|---------------------|-----------------|
| "start", "begin", a silent start | Compact: status, what happened in the previous session, open tasks from BACKLOG.Next, open INVARIANTS, readiness. 5–10 lines. |
| "get to grips with the project", "I want to make sure you've understood", "analyse" | A full analytical breakdown: why it exists, how it is built (modules/layers/contracts), the "map vs territory" table from step 3, the state (what is done/what is in progress/what is blocking), risks, what I understand and where the limits of my knowledge are. Length follows the subject, not the format. |
| A specific task in the first message | State + an explicit link to the task: which INVARIANTS may be affected, which memory layers are relevant, which subsystems will require reading code. |

The minimum is always a floor of adequacy. There is no ceiling. If you found discrepancies in step 3 — name them directly.

### 7. The "map ≠ territory" note

After steps 1–6 you know the project's **map**, not its **territory** (the code). Before editing a specific subsystem:
- read its code (not only the meta-files);
- read its local docs (not only the root ones);
- check the map against what you saw in the code.

The danger is not an incomplete model, but false confidence in its completeness.

## What NOT to do

- Don't show file contents to the user as a raw dump
- Don't run tests (that's `/finish`)
- Don't commit automatically (if there is uncommitted work — report it)
- Don't cap the depth of the report at a fixed length for the sake of "brevity"
- Don't skip the grounding step, even if SNAPSHOT looks fresh
- Don't generate a separate `ONBOARDING.md` — the constitution lives in `CLAUDE.md`, which the harness autoloads

## After running

The agent is ready to accept a brief. If the user's request in the first message was "get to grips/analyse", it has already been fulfilled by this skill, and that first reply itself is the result.
