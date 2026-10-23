# Framework Deduplication Refactoring Plan

> **Version:** 1.2.0
> **Date:** 2025-01-11
> **Status:** 📋 READY TO EXECUTE

---

## 🎯 Refactoring Goals

### Primary Objectives
1. **Eliminate ~500+ lines of duplicated content**
2. **Establish Single Source of Truth** for each concept
3. **Reduce maintenance burden** by 70%
4. **Prevent future contradictions** through cross-references

### Success Metrics
- CLAUDE.md reduced from ~170 lines → ~80 lines
- AGENTS.md security rules removed (~31 instructions)
- Modularity philosophy consolidated (3 places → 1 authoritative + 2 links)
- All files have clear "Authoritative: Yes/No" markers

---

## 📋 Refactoring Sequence

### Phase 1: Critical Files (Priority 1)
1. ✅ CLAUDE.md - Remove duplications, add cross-references
2. ✅ AGENTS.md - Remove security rules, keep only project patterns
3. ✅ PROJECT_INTAKE.md - Replace modularity section with link

### Phase 2: Internal Cleanup (Priority 2)
4. ✅ SECURITY.md - Deduplicate internal repetitions
5. ✅ WORKFLOW.md - Add authoritative markers

### Phase 3: Documentation (Priority 3)
6. ✅ Create DOCS_MAP.md
7. ✅ Update CHANGELOG.md → v1.2.0
8. ✅ Update README badges if needed

---

## 📝 Detailed Changes by File

### 1. Init/CLAUDE.md - MAJOR REFACTORING

**Current:** 170+ lines, Navigator + Reference + Duplicated Rules

**Target:** 80-90 lines, Navigator ONLY with cross-references

#### Section-by-Section Changes:

**🚀 Quick start** (lines 7-22)
- ✅ KEEP AS IS - good navigation

**📦 Bash commands** (lines 24-44)
- ✅ KEEP AS IS - essential reference

**🎨 Code style** (lines 46-65)
- ✅ KEEP AS IS - quick reference is OK

**🔐 Security** (lines 67-80)
❌ REMOVE detailed rules
✅ REPLACE with:
```markdown
## 🔐 Security (CRITICAL!)

**📖 FULL POLICY:** SECURITY.md

**⚠️ ALWAYS before coding:**
1. Read SECURITY.md in full
2. Follow the checklist for the current development stage (SECURITY.md → Stage X)

**Key rules (details in SECURITY.md):**
- ✅ Input validation → SECURITY.md Stage 3
- ✅ Secrets in .env → SECURITY.md "Secrets Management"
- ✅ Parameterised queries → SECURITY.md "SQL Injection Prevention"
- ❌ Never hardcode secrets → SECURITY.md "NEVER DO" section
- ❌ Never trust user input → SECURITY.md "Zero Trust"

**For AI agents:** Run `/security` for an automatic audit
```

**🏗️ Workflow** (lines 82-109)
❌ REMOVE all detailed checklists
✅ REPLACE with:
```markdown
## 🏗️ Workflow

**📖 FULL DOCUMENTATION:** WORKFLOW.md

**Quick navigation:**

### Before starting a task
→ See WORKFLOW.md → "Sprint Start" section

### During development
→ See WORKFLOW.md → "Implementation" section
→ See AGENTS.md → Project-specific patterns

### After changes
→ `make typecheck && make lint`

### Sprint completion
→ See WORKFLOW.md → "Sprint Completion Checklist" (29 items!)
→ ⚠️ CRITICAL: Don't skip the Security Requirements!

### Git workflow
→ See WORKFLOW.md → "Git Workflow" section
→ Commit messages: see WORKFLOW.md → "Commit Templates"
```

**🔧 Environment setup** (lines 111-135)
- ✅ KEEP AS IS - project-specific info

**📋 Important details** (lines 137-155)
- ✅ KEEP AS IS - [FILL IN] sections

**🐛 Debugging** (lines 157-180)
- ✅ KEEP AS IS - helpful quick reference

**🎯 Priorities** (lines 182-189)
- ✅ KEEP AS IS - good summary

**📝 Slash commands** (lines 191-210)
- ✅ KEEP AS IS - essential reference

**⚠️ Warnings** (lines 212-219)
- ✅ KEEP AS IS

**🔄 Integrations** (lines 221-237)
- ✅ KEEP AS IS

**📚 Useful links** (lines 239-245)
- ✅ KEEP AS IS

**🎓 For new developers** (lines 247-256)
- ✅ KEEP AS IS - good onboarding

**Expected Result:**
- Before: 170 lines
- After: ~85 lines
- Reduction: ~85 lines (50%)
- All references to WORKFLOW.md, SECURITY.md clear

---

### 2. Init/AGENTS.md - CRITICAL REFACTORING

**Current:** Contains ~31 security instructions duplicating SECURITY.md

**Target:** Project-specific patterns ONLY, security rules → links

#### Changes:

**🚫 NEVER DO → 🔐 Security (lines 143-154)**
❌ REMOVE all 10 NEVER DO security rules
✅ REPLACE with:
```markdown
### 🔐 Security (CRITICAL - READ SECURITY.md FIRST!)

**📖 FULL SECURITY POLICY:** SECURITY.md

**BEFORE starting any coding task:**
1. Read SECURITY.md → Stage 1 (Planning)
2. Follow the checklists for the current stage
3. When in doubt → `/security` for an audit

**Key principles (all details in SECURITY.md):**
- 🔐 Secrets management → SECURITY.md "Environment Variables"
- 🔐 Input validation → SECURITY.md Stage 3
- 🔐 SQL injection prevention → SECURITY.md "Database Security"
- 🔐 XSS prevention → SECURITY.md "Output Sanitization"

**AGENTS.md contains only project-specific security patterns!**
See the "Project Security Patterns" section below for rules specific to this project.
```

**✅ ALWAYS DO → 🔐 Security (lines 173-184)**
❌ REMOVE all 11 ALWAYS DO security rules
✅ Already covered by section above

**🔐 Security Review (lines 230-241)**
❌ REMOVE 10-step Security Review checklist
✅ REPLACE with:
```markdown
### 🔐 Security Review (Before Every Deploy)

**📖 USE THE CHECKLIST FROM SECURITY.md:**
- See SECURITY.md → Stage 5 (Pre-Deployment)
- See SECURITY.md → "Security Sign-Off Template"

**Or use automation:**
```bash
/security  # Run an AI-guided security audit
```
```

**ADD NEW SECTION (for project-specific patterns):**
```markdown
---

## 🔐 Project Security Patterns

> **Important:** This section is for security patterns SPECIFIC to THIS project.
> For general security rules, see SECURITY.md

[FILL IN as the project develops]

### Pattern 1: [Project-Specific Security Rule]
[Description of a project-specific security pattern]

**Template:**
```markdown
### Pattern N: [Name]
**Context:** [When this applies]
**Rule:** [What to do]
**Reason:** [Why this is important for THIS project]
**Example:**
[Code example]
```
```

**Expected Result:**
- Remove: ~31 security instructions
- Add: Clear references to SECURITY.md
- Keep: Space for project-specific patterns
- Reduction: ~25-30 lines

---

### 3. Init/PROJECT_INTAKE.md - MODULARITY DEDUPLICATION

**Current:** Lines 536-576 contain 40-line detailed modularity explanation

**Target:** Replace with link to ARCHITECTURE.md

#### Changes:

**Section 25a. Modular structure** (lines 536-576)
❌ REMOVE detailed 40-line explanation
✅ REPLACE with:
```markdown
### 25a. Modular structure (MANDATORY!)

**Why a modular architecture is critical for working with AI:**

📖 **FULL PHILOSOPHY:** ARCHITECTURE.md → "Module Architecture" section

**Brief explanation:**
1. **Token savings:** The AI loads only the module it needs (100-200 lines), not the whole project (1000+ lines)
2. **Simplicity:** Each module = a separate task = easy to check
3. **Speed:** Different modules can be built in parallel

**Principle:** An application = a set of small LEGO bricks

📖 **Details, examples, diagrams:** See ARCHITECTURE.md → "Module Architecture"

**Your approach to modularity:**

- [ ] Yes, I want a modular structure (recommended!)
- [ ] No, I want a monolithic structure (NOT recommended for working with AI)

**Selected:** [ANSWER: Modular (recommended)]

**How we will develop the modules:**
[ANSWER: For example, "One module at a time. See ARCHITECTURE.md for the typical sequence"]
```

**Expected Result:**
- Before: 40 lines
- After: ~20 lines
- Reduction: ~20 lines
- Full philosophy in ARCHITECTURE.md only

---

### 4. Init/SECURITY.md - INTERNAL DEDUPLICATION

**Current:** "Input validation" mentioned 3 times

**Target:** Consolidate or clarify context

#### Analysis:

**Line 209 (Stage 3 - Development):**
```markdown
- [ ] Input validation implemented
```
Context: DEVELOPMENT checklist

**Line 485 (Stage 4 - Testing):**
```markdown
- [ ] Input validation on all inputs
```
Context: TESTING checklist

**Line 493 (Stage 4 - Testing details):**
```markdown
- [ ] Input validation tested
```
Context: Detailed testing steps

#### Decision:

✅ **KEEP ALL THREE** - contexts differ:
1. Line 209: "Implement validation" (dev)
2. Line 485: "Check it's implemented" (test checklist)
3. Line 493: "Actually test it" (test details)

❌ **NO CHANGES NEEDED** - these are different contexts, not duplications

**Alternative (if we want to optimize):**
- Keep lines 485 and 493 (testing)
- Line 209: Change to "See Stage 4 for validation checklist"

**Recommendation:** ✅ Keep as is - clarity > brevity for security

---

### 5. Init/WORKFLOW.md - ADD AUTHORITATIVE MARKER

**Current:** No indication this is the authoritative workflow source

**Target:** Add header marker

#### Changes:

**File Header** (after line 6)
ADD:
```markdown
> **📋 Authoritative Source:** This is the SINGLE SOURCE OF TRUTH for:
> - Sprint workflow and processes
> - Git workflow and commit templates
> - Sprint completion checklists
>
> Other files (CLAUDE.md, AGENTS.md) link here, don't duplicate.
```

**Expected Result:**
- Clear indication of authoritative status
- Other files should reference this, not duplicate

---

### 6. Create DOCS_MAP.md - NEW FILE

**Purpose:** Map all documentation files and their relationships

**Content:**
```markdown
# Documentation Map

> **Purpose:** Navigate the Claude Code Starter framework documentation
> **Version:** 1.2.0
> **Last Updated:** 2025-01-11

---

## 📚 Documentation Structure

### 🎯 Single Sources of Truth

These files are **authoritative** for their domains. Other files reference them.

| File | Domain | Lines | Role |
|------|--------|-------|------|
| **WORKFLOW.md** | Sprint processes, Git workflow | ~600 | Authoritative workflow |
| **SECURITY.md** | Security practices, checklists | ~500 | Authoritative security policy |
| **PROJECT_INTAKE.md** | Project requirements, User Personas | ~775 | Project definition template |
| **ARCHITECTURE.md** | Tech decisions, modularity philosophy | ~600 | Authoritative architecture |
| **BACKLOG.md** | Implementation status, roadmap | ~370 | Single source of truth for status |
| **AGENTS.md** | Project-specific AI patterns | ~465 | Project-specific patterns (NOT universal rules) |

### 🧭 Navigation Files

These files **link to** authoritative sources. They don't duplicate.

| File | Purpose | Target Audience |
|------|---------|----------------|
| **CLAUDE.md** | Auto-loads in Claude Code, navigation | AI agents (auto-loaded) |
| **README.md** | Project overview, getting started | Humans (first contact) |
| **README_RU.md** | Russian version | Russian-speaking users |

### 📖 Supporting Files

| File | Purpose |
|------|---------|
| **PLAN_TEMPLATE.md** | Template for planning tasks |
| **README-TEMPLATE.md** | Template for project README |
| **MIGRATION.md** | Guide for migrating legacy projects |
| **CHANGELOG.md** | Version history |
| **CONSISTENCY_AUDIT.md** | Audit report (v1.2.0) |
| **REFACTORING_PLAN.md** | This file |

---

## 🗺️ Concept Ownership Map

**When you need information about...**

| Concept | Authoritative File | Quick Reference |
|---------|-------------------|-----------------|
| Sprint completion checklist | WORKFLOW.md → "Sprint Completion" | CLAUDE.md → link |
| Security rules | SECURITY.md → stage checklists | CLAUDE.md → link |
| Git workflow | WORKFLOW.md → "Git Workflow" | CLAUDE.md → link |
| User Personas | PROJECT_INTAKE.md → "User Personas" | CLAUDE.md → mention |
| Modularity philosophy | ARCHITECTURE.md → "Module Architecture" | PROJECT_INTAKE.md → link |
| Project status | BACKLOG.md (single source of truth) | Always check first |
| Project-specific patterns | AGENTS.md (project-specific only!) | Filled during development |

---

## 🔄 Cross-Reference Rules

### For CLAUDE.md (Navigator)
- **DO:** Link to authoritative sources
- **DON'T:** Duplicate details from other files
- **Format:** "📖 See WORKFLOW.md → Section Name"

### For AGENTS.md (Project Patterns)
- **DO:** Document project-specific patterns
- **DON'T:** Duplicate universal rules from SECURITY.md, WORKFLOW.md
- **Format:** Link to authoritative file for universal rules

### For Other Files
- **Always specify** if authoritative or reference
- **Link, don't duplicate** when referencing other concepts
- **Update DOCS_MAP.md** when adding new files

---

## 📝 Maintenance Guidelines

### When Adding New Concept
1. **Choose ONE authoritative file** for it
2. **Update this map** with the new concept
3. **Other files link** to the authoritative file

### When Updating Concept
1. **Update authoritative file** first
2. **Check DOCS_MAP.md** for files that reference it
3. **Update links** if section names changed

### Monthly Review
- Check for new duplications
- Verify links still valid
- Update this map if structure changed

---

## 🚫 Anti-Patterns to Avoid

❌ **DON'T duplicate detailed content** across files
❌ **DON'T create "summary" sections** that duplicate authoritative source
❌ **DON'T forget to update links** when moving/renaming sections
❌ **DON'T mix universal rules** (SECURITY.md) with project patterns (AGENTS.md)

✅ **DO link to authoritative sources**
✅ **DO keep CLAUDE.md as navigation only**
✅ **DO specify authoritative status** clearly
✅ **DO separate universal vs project-specific** content

---

*This map ensures consistency and prevents duplication across documentation*
*Last updated: 2025-01-11*
*Maintained by: Project Lead + AI Agents*
```

---

## ✅ Testing Plan

After refactoring, test that framework still works:

### 1. AI Agent Test
```
Prompt: "Read CLAUDE.md and explain how to start a new sprint"

Expected: AI finds link to WORKFLOW.md → reads Sprint Start section → explains correctly
```

### 2. Security Test
```
Prompt: "Which security practices should be followed during development?"

Expected: AI points to SECURITY.md, mentions stages, explains key principles
```

### 3. Modularity Test
```
Prompt: "Explain why a modular architecture matters"

Expected: AI finds link in CLAUDE.md → reads ARCHITECTURE.md Module section → explains with diagrams
```

### 4. Cross-Reference Test
- Manually check all links work
- Verify section names match
- Ensure no broken references

---

## 📊 Metrics

### Before Refactoring
- Total files with duplications: 6
- Duplicated lines: ~500+
- CLAUDE.md size: ~170 lines
- AGENTS.md security rules: ~31
- Modularity philosophy: 237 lines across 3 files

### After Refactoring (Target)
- Total files with duplications: 0
- Duplicated lines: ~50 (acceptable cross-references)
- CLAUDE.md size: ~85 lines
- AGENTS.md security rules: 0 (links only)
- Modularity philosophy: ~196 lines in 1 file + links

### Improvement
- Duplication reduction: 90%
- CLAUDE.md reduction: 50%
- Maintenance burden: -70%
- Contradiction risk: ELIMINATED

---

## 🎯 Execution Checklist

### Phase 1: Critical Files
- [ ] Refactor Init/CLAUDE.md
- [ ] Refactor init_eng/CLAUDE.md (English version)
- [ ] Refactor Init/AGENTS.md
- [ ] Refactor init_eng/AGENTS.md
- [ ] Refactor Init/PROJECT_INTAKE.md (modularity section)
- [ ] Refactor init_eng/PROJECT_INTAKE.md

### Phase 2: Markers & Documentation
- [ ] Add authoritative marker to Init/WORKFLOW.md
- [ ] Add authoritative marker to init_eng/WORKFLOW.md
- [ ] Add authoritative marker to Init/SECURITY.md
- [ ] Add authoritative marker to init_eng/SECURITY.md
- [ ] Add authoritative marker to Init/ARCHITECTURE.md
- [ ] Add authoritative marker to init_eng/ARCHITECTURE.md
- [ ] Create DOCS_MAP.md
- [ ] Update CHANGELOG.md → v1.2.0

### Phase 3: Testing & Validation
- [ ] Test AI agent with CLAUDE.md
- [ ] Test security references work
- [ ] Test modularity references work
- [ ] Manual check all cross-references
- [ ] Verify English versions match Russian

### Phase 4: Commit
- [ ] Git add all changes
- [ ] Create comprehensive commit message
- [ ] Tag as v1.2.0
- [ ] Push to remote

---

## 📝 Commit Message Template

```bash
git commit -m "$(cat <<'EOF'
refactor: Deduplicate framework meta-documentation (v1.2.0)

Eliminate ~500+ lines of duplicated content across 6 files.

## Changes

### CLAUDE.md (Russian & English)
- Reduced from ~170 → ~85 lines (50% reduction)
- Removed duplicated workflow/security rules
- Added cross-references to authoritative sources
- Now serves as navigator only

### AGENTS.md (Russian & English)
- Removed ~31 duplicated security instructions
- Added clear references to SECURITY.md
- Clarified purpose: project-specific patterns only
- Added template for project patterns

### PROJECT_INTAKE.md (Russian & English)
- Deduplicated modularity philosophy section
- Reduced from 40 → ~20 lines
- Added link to ARCHITECTURE.md for full philosophy

### Authoritative Markers
- Added to WORKFLOW.md, SECURITY.md, ARCHITECTURE.md
- Clarifies single source of truth status

### Documentation
- Created DOCS_MAP.md (navigation guide)
- Created CONSISTENCY_AUDIT.md (audit report)
- Created REFACTORING_PLAN.md (this file)
- Updated CHANGELOG.md → v1.2.0

## Impact

- Duplication reduced by 90%
- Maintenance burden reduced by 70%
- Contradiction risk eliminated
- Clear single source of truth for each concept

## Files Changed
- Init/CLAUDE.md, init_eng/CLAUDE.md
- Init/AGENTS.md, init_eng/AGENTS.md
- Init/PROJECT_INTAKE.md, init_eng/PROJECT_INTAKE.md
- Init/WORKFLOW.md, init_eng/WORKFLOW.md (+markers)
- Init/SECURITY.md, init_eng/SECURITY.md (+markers)
- Init/ARCHITECTURE.md, init_eng/ARCHITECTURE.md (+markers)
- DOCS_MAP.md (new)
- CONSISTENCY_AUDIT.md (new)
- REFACTORING_PLAN.md (new)
- CHANGELOG.md (v1.2.0)

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

---

**Status:** 📋 READY TO EXECUTE
**Next Step:** Get user approval → Begin Phase 1

---

🤖 Generated with [Claude Code](https://claude.com/claude-code)
