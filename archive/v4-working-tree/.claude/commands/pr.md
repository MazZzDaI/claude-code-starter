---
description: Create a Pull Request with a proper description
---

Create a Pull Request using the GitHub CLI (`gh`).

**IMPORTANT: Analyse ALL commits, not just the last one!**

## Process:

### 1. Analyse the current state of the branch

Run these commands in parallel:
```bash
# Check the current branch and status
git status

# Look at unstaged and staged changes
git diff
git diff --staged

# Check remote tracking
git branch -vv

# Look at ALL commits since the base branch (usually main)
git log main..HEAD --oneline

# Look at the full diff from the base branch
git diff main...HEAD --stat
```

### 2. Determine the base branch
Usually this is `main` or `master`. Check:
```bash
git remote show origin | grep "HEAD branch"
```

### 3. Analyse ALL changes

**CRITICAL:** Do not look only at the last commit! Analyse:
- All commits since divergence from main
- The entire diff between the base branch and HEAD
- All changed files

```bash
# Full list of changed files
git diff main...HEAD --name-status

# Detailed diff of all changes
git diff main...HEAD
```

### 4. Compose the PR description

**Format:**
```markdown
## Summary
[1-3 bullet points describing WHAT was done]

## Why (Motivation)
[WHY these changes are needed - business context]

## What Changed
[Detailed description of changes by category]

### Added
- [New functionality]

### Changed
- [Changes to existing functionality]

### Fixed
- [Fixed bugs]

### Security
- [Security-related changes]

## Technical Details
[Technical details for reviewers]
- Architectural decisions
- Important changes to the API/database schema
- Performance implications

## Test Plan
- [ ] Unit tests pass (`make test`)
- [ ] Type checking pass (`make typecheck`)
- [ ] Linting pass (`make lint`)
- [ ] Manual testing: [describe what you tested]
- [ ] Security check (`make security`)
- [ ] Tested edge cases: [which ones]

## Screenshots/Demo
[If there are UI changes - add screenshots]

## Breaking Changes
[If there are breaking changes - describe them here]
- [ ] Documentation updated
- [ ] Migration guide provided

## Checklist
- [ ] Code follows project style guide
- [ ] Documentation updated (README, ARCHITECTURE, etc.)
- [ ] BACKLOG.md updated with implementation status
- [ ] Security best practices followed (see SECURITY.md)
- [ ] No secrets in code
- [ ] All tests passing

🤖 Generated with [Claude Code](https://claude.com/claude-code)
```

### 5. Push the changes (if needed)

Check whether a push is needed:
```bash
git status
```

If needed:
```bash
# For a new branch
git push -u origin HEAD

# For an existing one
git push
```

### 6. Create the PR with the gh CLI

Use a HEREDOC for correct formatting:

```bash
gh pr create --title "<type>: <short description>" --body "$(cat <<'EOF'
## Summary
- [bullet point 1]
- [bullet point 2]

## Why
[Motivation for the changes]

## What Changed
[Detailed description]

## Technical Details
[Technical details]

## Test Plan
- [ ] Unit tests pass
- [ ] Type checking pass
- [ ] Linting pass
- [ ] Manual testing completed

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```

**Title format:**
- `feat: Add user authentication`
- `fix: Prevent memory leak in dashboard`
- `refactor: Simplify API error handling`
- `docs: Update deployment guide`

### 7. Check the result
```bash
gh pr view --web
```

## 🔐 Security Checklist (before creating the PR)
- [ ] No hardcoded secrets in the code
- [ ] .env files are not committed
- [ ] All secrets are in environment variables
- [ ] Input validation is in place
- [ ] Output sanitisation is implemented
- [ ] SQL queries are parameterised
- [ ] Authentication/Authorisation checked
- [ ] `npm audit` shows no critical vulnerabilities

## 📋 Pre-PR Checklist
- [ ] All commits are meaningful (not "wip", "fix", "update")
- [ ] Squash small fixup commits (if needed)
- [ ] Branch is up to date with main (rebase if needed)
- [ ] All tests pass locally
- [ ] Documentation is updated
- [ ] BACKLOG.md is updated

## 🚫 DO NOT:
- ❌ Analyse only the last commit (look at ALL commits!)
- ❌ Create a PR with failing tests
- ❌ Ignore TypeScript errors
- ❌ Forget to update the documentation
- ❌ Force push to a shared branch
- ❌ A PR with commented-out code
- ❌ A vague PR description

## 💡 Tips:
1. **For large PRs:** split into several smaller PRs
2. **For a hotfix:** use the flag `--label "hotfix"`
3. **For a draft PR:** use the flag `--draft`
4. **Assign reviewers:** `--reviewer @username`
5. **Add to project:** `--project "Project Name"`

## Examples of good PRs:

### Example 1: Feature PR
```bash
gh pr create --title "feat: Add user dashboard with analytics" --body "$(cat <<'EOF'
## Summary
- Implement user dashboard with key metrics
- Add analytics charts for user activity
- Create responsive layout for mobile

## Why
Users requested a centralized view of their activity and statistics.
Dashboard provides better user engagement and data visibility.

## What Changed
### Added
- Dashboard component with metrics cards
- Chart.js integration for analytics
- Mobile-responsive layout
- API endpoints for dashboard data

## Technical Details
- Uses Chart.js for data visualization
- Implements lazy loading for performance
- Adds new /api/dashboard endpoint with proper auth
- All data queries optimized with indexes

## Test Plan
- [x] Unit tests pass (100% coverage on new code)
- [x] Type checking pass
- [x] Tested on mobile (iOS/Android)
- [x] Tested with 1000+ data points (performance OK)
- [x] Security audit completed

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```

### Example 2: Bugfix PR
```bash
gh pr create --title "fix: Resolve memory leak in WebSocket connection" --body "$(cat <<'EOF'
## Summary
- Fix memory leak in WebSocket cleanup
- Add proper event listener cleanup

## Why
Users reported browser slowdown after 30+ minutes of use.
Investigation revealed WebSocket listeners not being cleaned up.

## What Changed
### Fixed
- Add cleanup function to useWebSocket hook
- Remove event listeners on unmount
- Close connections properly

## Technical Details
- Root cause: missing cleanup in useEffect
- Added beforeunload listener cleanup
- Tested with Chrome DevTools memory profiler

## Test Plan
- [x] Memory profiler shows no leaks after 2 hours
- [x] All existing tests pass
- [x] Manually tested reconnection scenarios

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```

**After creating the PR, print the URL so the user can open it!**
