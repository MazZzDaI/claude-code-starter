---
description: Create a release of the Claude Code Starter framework
---

# Framework release

> Use this command to create a new framework release with automatic updating of the version, CHANGELOG, README and archives.

## ⚠️ IMPORTANT

This command is intended **ONLY for the claude-code-starter project**.
Do not use it in user projects!

---

## 🎯 What the command does

1. **Analyses changes** since the last release
2. **Determines the release type** (patch/minor/major)
3. **Updates the version** everywhere
4. **Updates CHANGELOG.md** with a description of the changes
5. **Updates README files** if needed
6. **Rebuilds the zip archives**
7. **Creates a release commit**
8. **Pushes to GitHub**

---

## 📋 Release process

### Step 1: Determine the current version

```bash
# Read the current version from README.md
grep "badge/version" README.md
```

Current version in badge format: `version-<current-version>`

### Step 2: Analyse the changes

```bash
# Get all commits since the last release commit
git log --oneline --grep="chore: Bump version" -1
# Get the commits after the last release
git log <last-release-commit>..HEAD --oneline
```

**Analyse the commits:**
- Which files were changed?
- New features or bug fixes?
- Breaking changes?
- Changes to templates (migration/templates/)?

### Step 3: Determine the release type

**Ask the user:**

```
🎯 Analysis of changes since the last release:

Commits found: X
Main changes:
- [short list of changes from git log]

What type of release should be created?

1. Patch (1.2.X) - bug fixes, documentation, minor improvements
2. Minor (1.X.0) - new features, backward-compatible changes
3. Major (X.0.0) - breaking changes, major refactoring

Choose [1/2/3]:
```

**Versioning rules (Semantic Versioning):**

- **Patch (X.X.N):**
  - Bug fixes
  - Documentation updates
  - Minor improvements without new features
  - Dependency updates
  
- **Minor (X.N.0):**
  - New features
  - New commands (slash commands)
  - New sections in templates
  - Backward-compatible changes
  - Improvements to existing features
  
- **Major (N.0.0):**
  - Breaking changes
  - Removal of deprecated functions
  - Changes to the file structure
  - Incompatible API changes

### Step 4: Calculate the new version

```bash
# Example: current 1.2.5
# Patch: 1.2.6
# Minor: 1.3.0
# Major: 2.0.0

CURRENT_VERSION="1.2.5"
# Split into major.minor.patch
# Increment the relevant part
# Form NEW_VERSION
```

**Confirm with the user:**
```
New version: ${NEW_VERSION}
Continue? [y/n]
```

### Step 5: Gather information for the CHANGELOG

**For each commit since the last release:**

1. Read the commit message
2. Determine the category:
   - `feat:` → Added
   - `fix:` → Fixed
   - `docs:` → Changed/Documentation
   - `refactor:` → Changed
   - `chore:` → (skip or Maintenance)
3. Extract the key changes

**Group by category:**
- Added (new features)
- Fixed (fixes)
- Changed (changes)
- Removed (removals)
- Deprecated (deprecated items)

### Step 6: Create the CHANGELOG section

**Template:**

```markdown
## [${NEW_VERSION}] - $(date +%Y-%m-%d)

### [Short description of the release]

**Goal:** [Main goal of this release]

### Added

- [New feature 1]
  - Description
  - Files: migration/templates/file.template.md
- [New feature 2]

### Fixed

- [Fix 1]
  - Problem: [description]
  - Solution: [description]
- [Fix 2]

### Changed

- [Change 1]
- [Change 2]

### Impact

**For Users:**
- ✅ [Benefit 1]
- ✅ [Benefit 2]

### Files Modified

**Templates:**
- migration/templates/FILE.template.md (+X lines)

**Documentation:**
- README.md
- README_RU.md

**Archives:**
- init-starter.zip (recreated)
- init-starter-en.zip (recreated)

---
```

**Insert at the top of CHANGELOG.md** (after the heading, before the latest version)

### Step 7: Update the version in README files

**Files to update:**
1. README.md - the badge line
2. README_RU.md - the badge line

**Use the Edit tool:**

```markdown
OLD:
[![Version](https://img.shields.io/badge/version-${CURRENT_VERSION}-orange.svg)]

NEW:
[![Version](https://img.shields.io/badge/version-${NEW_VERSION}-orange.svg)]
```

### Step 8: Check whether README updates are needed

**Ask the user:**

```
Should the description in the README files be updated?
(For example, add a new feature to the "The Solution" list)

[y/n]
```

If yes - propose concrete changes based on the CHANGELOG.

### Step 9: Rebuild the zip archives

```bash
# Rebuild both archives
cd Init && zip -r ../init-starter.zip . -x "*.DS_Store"
cd ../init_eng && zip -r ../init-starter-en.zip . -x "*.DS_Store"
cd ..
ls -lh init-starter*.zip
```

### Step 10: Create the release commit

**Commit message template:**

```
chore: Release v${NEW_VERSION}

Release v${NEW_VERSION} includes [short description].

## Highlights:

[2-3 key changes]

## Changes in this commit:

### Version Updates
- README.md: ${CURRENT_VERSION} → ${NEW_VERSION}
- README_RU.md: ${CURRENT_VERSION} → ${NEW_VERSION}

### CHANGELOG.md
Added v${NEW_VERSION} entry documenting:
- [Category 1]: [briefly]
- [Category 2]: [briefly]

### Archives Recreated
- init-starter.zip (updated with all changes)
- init-starter-en.zip (updated with all changes)

[If there were README changes - describe them]

## Impact:

[Key impact metrics]

See CHANGELOG.md for full details.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

**Create the commit:**

```bash
git add CHANGELOG.md README.md README_RU.md init-starter.zip init-starter-en.zip

# If there were other changes - add them too
git add [other files if needed]

git commit -m "[message from template]"
```

### Step 11: Show the diff for review

```bash
git show HEAD --stat
```

**Confirm with the user:**
```
Commit created. Review the changes above.

Push to GitHub? [y/n]
```

### Step 12: Push to GitHub

```bash
git push origin main
```

### Step 13: Create a GitHub Release (optional)

**Ask the user:**
```
Create a GitHub Release?

This will create:
- Tag v${NEW_VERSION}
- A release page on GitHub
- Attach the archives to the release

[y/n]
```

**If yes:**

```bash
# Create the tag
git tag -a "v${NEW_VERSION}" -m "Release v${NEW_VERSION}"
git push origin "v${NEW_VERSION}"

# Create the GitHub Release using the gh CLI
gh release create "v${NEW_VERSION}" \
  --title "v${NEW_VERSION}" \
  --notes "[Extract the section for this version from CHANGELOG.md]" \
  dist-release/init-project.sh \
  dist-release/framework.tar.gz \
  dist-release/framework-commands.tar.gz \
  CLAUDE.md
```

**Files in the release:**
- `init-project.sh` - Installer script for installing the framework
- `framework.tar.gz` - Full framework archive (for installation)
- `framework-commands.tar.gz` - Commands only (for auto-update)
- `CLAUDE.md` - Main protocol (for auto-update)

### Step 14: Final output

```
🎉 RELEASE v${NEW_VERSION} CREATED SUCCESSFULLY!

✅ What was done:
- ✅ CHANGELOG.md updated
- ✅ Version in README: ${CURRENT_VERSION} → ${NEW_VERSION}
- ✅ Archives rebuilt
- ✅ Commit created and pushed
[- ✅ GitHub Release created (if applicable)]

📊 Statistics:
- Commits since the last release: X
- Files changed: Y
- Release type: [Patch/Minor/Major]

🔗 Links:
- Commit: https://github.com/alexeykrol/claude-code-starter/commit/[hash]
[- Release: https://github.com/alexeykrol/claude-code-starter/releases/tag/v${NEW_VERSION}]

📋 Next steps:
- Check CHANGELOG.md on GitHub
- Check that the version has been updated in README
- If necessary, update the release description on GitHub

---

Release v${NEW_VERSION} is ready for use! 🚀
```

---

## 🚫 Stop conditions

Stop the release if:

### Critical conditions:
- ❌ No new commits since the last release
- ❌ Working directory is not clean (uncommitted changes)
- ❌ Not in the claude-code-starter folder
- ❌ No push permissions

### Warnings (ask the user):
- ⚠️ Very few changes (1-2 trivial commits)
- ⚠️ No tests for new features
- ⚠️ Documentation not updated for new features

**If stopped:**
```
🛑 Release stopped

Reason: [DESCRIPTION]

Actions to continue:
1. [Action 1]
2. [Action 2]
3. Run /release again
```

---

## 💡 Tips

### Good release practices:

1. **Regularity:**
   - Patch releases: as soon as a bug is fixed
   - Minor releases: every 1-2 weeks for new features
   - Major releases: rarely, only for breaking changes

2. **CHANGELOG quality:**
   - Write for users, not for developers
   - Explain WHY, not just WHAT
   - Include examples of impact ("saves 60% tokens")
   - Add a migration path for breaking changes

3. **Communication:**
   - Announce in Issues/Discussions for major releases
   - Highlight breaking changes
   - Provide upgrade guide

---

## 🔄 Integration with other commands

- After `/feature` → A minor release may be needed
- After `/fix` → A patch release may be needed
- After refactoring → Check whether a release is needed

---

🤖 Generated with [Claude Code](https://claude.com/claude-code)
