# Session Recovery Workflow

Execute these steps when recovering from session limits or starting fresh. Announce each step before executing it.

## When Approaching Context Limits

**Priority: Create recovery guide FIRST.** If context runs out mid-workflow, the guide is the most valuable artifact for the next session. SESSION_HANDOFF.xml update is secondary.

### Step 1: Create Recovery Guide
- **Project Root Confirmation Required**:
  - Current directory: $(pwd)
  - Git root (if available): $(git rev-parse --show-toplevel 2>/dev/null || echo "No git repository")
  - **STOP**: Confirm project root for .claude/ storage
  - **WAIT**: For explicit user confirmation of project root
- Create comprehensive guide in $PROJECT_ROOT/.claude/guides/ with descriptive name
- Include:
  - Problems encountered and overcome this session
  - Current progress and key insights
  - What you wish you knew ahead of time
  - All relevant context and decisions made
- Create directory if it doesn't exist

### Step 1.5: Capture Lessons Learned
- Reflect on the full session: were you corrected by the user? Did you notice recurring friction, suboptimal patterns, or inefficiency?
- A lesson is a pattern that produces suboptimal outputs or errors that can be addressed to prevent recurrence
- For each lesson identified, append a full entry to `~/.claude/lessons-learned.yml`:
  - **pattern**: What happened - full narrative with enough context for a fresh session to understand
  - **root_cause**: Why it happened - structural analysis, not surface-level
  - **impact**: What went wrong - concrete consequences (wasted effort, broken output, user intervention)
  - **example**: Specific incident from this session that illustrates the pattern
  - **proposed_fix**: What should change systemically (CLAUDE.md rules, skills, workflows, process)
  - Set status: pending, resolution: null
- **Optional (if claude-mem installed):** Also save each lesson via claude-mem for searchable cross-session reference
- No caps on number of lessons or verbosity - thoroughness of capture is more valuable than speed
- If no lessons were observed this session, skip this step entirely

### Step 2: Update Session Management
- Update SESSION_HANDOFF.xml with current status
- Document next priorities and action items
- Record any assumptions or technical decisions
- **Update `<tested_hypotheses>` section:**
  - Add any hypotheses tested this session
  - Mark CLOSED if conclusively proven/disproven
  - Include sessions tested and configuration used
  - This prevents future sessions from re-testing

### Step 3: Clean Exit
- Commit any work in progress
- Document stopping point clearly
- Set up clear re-entry instructions

## When Starting New Session

### Step 0: Refresh Key Documents
- Re-read ~/.claude/CLAUDE.md to refresh global rules
- Use sequential thinking for systematic recovery
- If session notes are provided (pasted after workflow invocation), read and integrate them as primary context

### Step 1: Context Reconstruction
- Read SESSION_HANDOFF.xml first
- Check ~/.claude/guides/ for relevant guides
- **Project Root Confirmation Required**:
  - Current directory: $(pwd)
  - Git root (if available): $(git rev-parse --show-toplevel 2>/dev/null || echo "No git repository")
  - **STOP**: Confirm project root for .claude/ storage
  - **WAIT**: For explicit user confirmation of project root
- Load project-specific context from $PROJECT_ROOT/.claude/ if available

### Step 2: State Validation
- Verify current working directory and project state
- Check git status and recent commits
- Validate tool availability and configuration

### Step 3: Priority Assessment
- Review next priorities from SESSION_HANDOFF.xml
- Assess what context might have been lost
- Plan context gathering if needed

### Step 3.5: Hypothesis Deduplication Check (CRITICAL)
- Check `<tested_hypotheses>` section in SESSION_HANDOFF.xml
- Review all CLOSED hypotheses - these are OFF LIMITS for re-testing
- If current priorities involve debugging/investigation:
  - Cross-reference proposed tests against tested_hypotheses
  - Do NOT propose tests that match CLOSED hypotheses
  - If tempted to "try X again", check if X was already tested
- This step prevents wasted effort from re-investigation loops

### Step 4: Knowledge Integration & Improvement Review
- Read `~/.claude/lessons-learned.yml`
- If any items have status `pending`, surface ALL of them to the user:
  - Present each lesson with its pattern, root cause, impact, and proposed fix
  - For each, ask the user: **Accept** (codify now), **Reject** (with reason), or **Defer** (keep pending)?
  - For **accepted** items: implement the proposed fix immediately (update CLAUDE.md, skills, workflows, etc.), then remove the entry from lessons-learned.yml (the fix lives in its target doc now)
  - For **rejected** items: remove the entry from lessons-learned.yml (no ongoing value)
  - For **deferred** items: leave as `pending` for next session
  - After processing all pending items, the file should contain only deferred (pending) entries
- **Optional (if claude-mem installed):** Search for related historical lessons for patterns across past sessions
- Apply learnings from previous session
- Use stored insights to avoid repeated mistakes

## Compaction Avoidance Strategies

### Break Down Large Changes
- Identify if current task can be split into smaller pieces
- Plan incremental delivery approach

### Context-Efficient Planning
- Use stored guides instead of re-gathering context
- Reference previous analysis rather than re-analyzing
- Build on documented insights

### Strategic Session Boundaries
- Plan natural stopping points in advance
- Don't start complex tasks near context limits
- Complete logical units before ending sessions

## Emergency Recovery Procedures

### When Session Corrupted
- Start completely fresh session
- Read CLAUDE.md first to restore rules
- Use SESSION_HANDOFF.xml as primary recovery source

### When Context Lost
- Execute gather-context workflow systematically
- Use stored guides as starting points
- Validate understanding before proceeding

### When Rules Forgotten
- Explicitly read CLAUDE.md contents
- Re-establish tool preferences and methodologies

## Session Continuity Best Practices

### Regular Checkpoints
- Update SESSION_HANDOFF.xml every 10-15 messages
- Store incremental insights in guides
- Commit work frequently with descriptive messages

### Cross-Session Learning
- Document patterns that work well
- Store workflow improvements in guides
- Build institutional memory over time

### Quality Maintenance
- Verify rule adherence periodically
- Check that methodologies are being applied
- Maintain tool preference consistency
