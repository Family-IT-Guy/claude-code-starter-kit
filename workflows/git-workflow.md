# Git Workflow

Execute these steps for git operations. Announce each step before executing it.

## Basic Git Operations

### Step 1: Status Check
- Run `git status` to see current state
- Check for uncommitted changes
- Verify current branch

### Step 2: Branch Management
**For new features:**
- Create feature branch: `git checkout -b feature/description`
- Use descriptive branch names

**For existing work:**
- Ensure you're on correct branch
- Pull latest changes if needed: `git pull origin main`

### Step 3: Commit Strategy
- Commit after each logical change
- Don't wait for completion to commit
- Use atomic commits (one logical change per commit)

### Step 4: Commit Message Format
Use conventional commit format:
- `feat: description` - new feature
- `fix: description` - bug fix
- `refactor: description` - code restructuring
- `docs: description` - documentation changes
- `test: description` - adding tests
- `style: description` - formatting changes
- `chore: description` - maintenance tasks

### Step 5: Multi-Claude Coordination
**When working with multiple Claude instances:**
- Use git worktrees: `git worktree add ../project-feature-name feature-name`
- Prefix commits with instance identifier
- Sync frequently with main branch
- Document handoff points in SESSION_HANDOFF.xml

## Advanced Git Operations

### Pull Request Creation
- Push branch: `git push -u origin branch-name`
- Create PR: `gh pr create --title "Description" --body "Details"`
- Include testing instructions in PR description
- Reference related issues if applicable

### Conflict Resolution
- When conflicts occur, understand both sides
- Apply first principles to determine correct resolution
- Test thoroughly after resolution
- Document resolution reasoning

## Git Safety Protocols

### Pre-commit Checks
- Uncommitted changes: Ask "Commit first?"
- Wrong branch: Ask "Feature branch?"
- No backup: Ask "Checkpoint?"

### Validation Commands
- `git log --oneline -10` - Review recent commits
- `git diff HEAD~1` - See last commit changes
- `git branch -v` - See all branches with status

### Recovery Procedures
- Undo last commit: `git reset --soft HEAD~1`
- Discard changes: `git checkout -- filename`
- Emergency stash: `git stash save "emergency backup"`
