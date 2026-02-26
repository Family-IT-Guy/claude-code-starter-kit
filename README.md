# Claude Code Starter Kit

A session recovery and self-improvement system for Claude Code CLI. Makes Claude remember what it learned, recover cleanly between sessions, and get better over time.

## What This Solves

Claude Code starts every session with amnesia. It doesn't remember:
- How you like to work
- What mistakes it made last time
- What you were working on yesterday
- What hypotheses it already tested and ruled out

This kit fixes that with a set of configuration files that Claude reads at the start of every session.

## What's Included

```
claude-code-starter-kit/
|
|-- CLAUDE.md                        # Master rules loaded every session
|-- preferences.yml                  # Communication style, work standards
|-- lessons-learned.yml              # Behavioral improvement queue
|-- statusline-script.sh             # Context window % in status bar
|
|-- core/
|   |-- methodologies.yml            # First principles + evidence-based standards
|   |-- session-management.yml       # Hypothesis tracking protocol
|
|-- workflows/
|   |-- session-recovery.md          # End-of-session / start-of-session workflow
|   |-- gather-context.md            # Systematic codebase exploration
|   |-- git-workflow.md              # Commit conventions, branching, safety
|
|-- commands/
|   |-- session-start.md             # /session-start slash command
|   |-- session-end.md               # /session-end slash command
|
|-- install.sh                       # Copies files to ~/.claude/
```

## Installation

```bash
# Preview what will be installed (no changes made)
./install.sh --dry-run

# Install
./install.sh
```

The installer will NOT overwrite existing files. If you already have a `~/.claude/CLAUDE.md`, it will be skipped.

After install, follow the "Next Steps" printed by the installer (also listed below).

## Post-Install Setup

### 1. Enable the status line

The status line shows your git branch, context window usage %, and model name. This is critical for knowing when to end your session.

```bash
claude config set --global statusline '~/.claude/statusline-script.sh'
```

Requires `jq` installed (`brew install jq` on macOS).

### 2. Disable auto-compact

This is the single most important configuration change.

```bash
claude config set --global autoCompact false
```

**Why:** Auto-compact triggers when Claude decides it's running low on context. The problem is that it compresses your conversation *without* running the session-end workflow first, which means:
- No recovery guide gets created
- No lessons get captured
- No SESSION_HANDOFF.xml gets updated
- The next session starts cold

By disabling auto-compact, you stay in control. The status line shows your context %, and you decide when to wrap up.

### 3. Install claude-mem (optional but recommended)

```bash
claude plugin add thedotmack/claude-mem
```

This gives Claude persistent memory across sessions. The session-recovery workflow integrates with it to save lessons and search past work.

### 4. Customize your files

Edit these two files for your own name and preferences:

- `~/.claude/CLAUDE.md` - Add project-specific rules, remove anything that doesn't apply
- `~/.claude/preferences.yml` - Change greeting/signoff names, adjust voice rules, add your own anti-patterns

## How to Use It

### Context Window Management

Your status line now shows something like: `main | 42% | Opus 4.6`

That `42%` is your context window usage. Here's how to manage it:

| Context % | What to do |
|-----------|------------|
| 0-70%     | Work normally |
| 70-80%    | Start wrapping up current task. Don't begin new complex work. |
| 80-85%    | Run `/session-end` now. This is the ideal window. |
| 85-90%    | Run `/session-end` immediately. You need room for the workflow itself. |
| 90%+      | Emergency. Tell Claude to create a recovery guide and stop. Skip the full workflow if needed. |

**Why 80% and not 90%?** The session-end workflow itself consumes context. It reads files, writes guides, captures lessons, and updates SESSION_HANDOFF.xml. If you wait until 90%, the workflow might not complete before hitting limits. At 80%, you have plenty of room for thorough session documentation.

### Starting a Session

Type `/session-start` at the beginning of each session. Claude will:

1. Re-read CLAUDE.md and all @included files
2. Read SESSION_HANDOFF.xml to understand where you left off
3. Check for relevant guides in .claude/guides/
4. Validate project state (git status, etc.)
5. Check for CLOSED hypotheses (things already tested and ruled out)
6. Surface any pending lessons from last session for your review

If you have notes from the previous session, paste them after the command:
```
/session-start Here's where I left off: the auth system is half-done, middleware is working but the token refresh logic needs testing.
```

### Ending a Session

Type `/session-end` when your context window reaches 80%. Claude will:

1. Create a recovery guide in `.claude/guides/` with everything the next session needs
2. Capture any lessons learned (mistakes, corrections, insights)
3. Update SESSION_HANDOFF.xml with current status and next priorities
4. Commit work in progress

### The Self-Improvement Loop

This is how Claude gets better over time:

1. **During work:** Claude makes a mistake or you correct it
2. **Session end:** The correction gets captured in `lessons-learned.yml` as a pending lesson
3. **Next session start:** Claude surfaces the pending lesson and asks you:
   - **Accept** - The fix gets written into CLAUDE.md, preferences.yml, or a workflow. The lesson is removed from the queue.
   - **Reject** - You explain why. The lesson is removed.
   - **Defer** - It stays pending for next session.
4. **Future sessions:** The fix is now part of Claude's rules. It won't make that mistake again.

Over time, your CLAUDE.md accumulates hard-won rules specific to how you work. This is the system's real value: every correction becomes permanent.

### The Hypothesis Protocol

When debugging across sessions, Claude tracks what it has tested:

- **OPEN** - Not yet tested
- **CLOSED** - Tested conclusively. Do not revisit.
- **INCONCLUSIVE** - Test was invalid. May revisit with better setup.
- **SUPERSEDED** - Replaced by a different theory.

The critical rule: **CLOSED means CLOSED.** A new session doesn't get to re-test a theory just because it seems plausible in isolation. This prevents the most common multi-session debugging failure: going in circles.

### SESSION_HANDOFF.xml

This file lives in your project root and tracks dynamic state:
- Current phase and progress
- Next priorities
- Tested hypotheses
- Active assumptions

CLAUDE.md is for rules (static). SESSION_HANDOFF.xml is for state (dynamic). Don't duplicate one in the other.

## The File Operation Protocol

Every time Claude proposes a change, it must present:

```
PLAN: [what it wants to do]
IMPACT: [what this affects]
WHY YOU SHOULD APPROVE: [reasons for]
WHY YOU SHOULD NOT APPROVE: [reasons against]
SUGGESTED NEXT STEPS: [objective assessment]
```

This forces Claude to think through changes before making them and gives you both sides before approving. It also means Claude will sometimes argue against its own proposal, which is the point.

## Recommended Plugins

These are Claude Code marketplace plugins that complement this kit:

| Plugin | What it does | Install |
|--------|-------------|---------|
| claude-mem | Cross-session structured memory | `claude plugin add thedotmack/claude-mem` |
| superpowers | Brainstorming, debugging, TDD, planning skills | `claude plugin add superpowers` |
| context7 | Library documentation lookup | `claude plugin add context7` |

## Customization Guide

### Adding Your Own Rules

When Claude does something you don't like, tell it. Then at session end, it will capture the correction as a lesson. At next session start, you can accept it, which writes the rule into CLAUDE.md or preferences.yml permanently.

You can also edit the files directly. Common additions:
- Project-specific architecture notes in CLAUDE.md
- New banned_patterns in preferences.yml when Claude writes something you hate
- New anti_patterns with wrong/right examples
- Tool-specific rules (e.g., "always use pytest, never unittest")

### Creating Project-Level Configs

For project-specific rules, create a `.claude/CLAUDE.md` in the project root. Claude reads both global (~/.claude/CLAUDE.md) and project-level CLAUDE.md files.

### Adding New Workflows

Create new `.md` files in `~/.claude/workflows/`. Reference them from CLAUDE.md or invoke them directly: "Execute the workflow in ~/.claude/workflows/my-workflow.md"

### Adding Slash Commands

Create new `.md` files in `~/.claude/commands/`. They become available as `/command-name` in Claude Code.

## Philosophy

The system is built on a few principles:

- **Corrections are data.** Every time you fix Claude, that's a signal. Capture it or it repeats.
- **Rules are earned.** Don't add rules speculatively. Add them when something goes wrong. Each rule in CLAUDE.md should trace back to a real incident.
- **Static vs dynamic.** Rules go in CLAUDE.md (loaded every session). Status goes in SESSION_HANDOFF.xml (changes every session). Mixing them creates staleness.
- **Evidence over analogy.** Claude defaults to pattern-matching. The methodologies.yml forces it to reason from first principles and cite evidence.
- **Manual > automatic for session management.** Auto-compact loses context silently. Manual session boundaries with the /session-end workflow preserve everything.
