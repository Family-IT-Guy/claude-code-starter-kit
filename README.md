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
```

## Installation

Clone this repo, then let Claude Code install the files for you. Start a Claude Code session in the cloned directory and paste one of these prompts:

**If you don't have any existing ~/.claude/ configuration:**
```
Read all the files in this repo. Copy them into ~/.claude/ preserving the
directory structure (core/, workflows/, commands/ subdirectories). Make
statusline-script.sh executable.
```

**If you already have a ~/.claude/CLAUDE.md and want to merge:**
```
Read all the files in this repo and read my existing ~/.claude/CLAUDE.md.
Merge the rules from this kit's CLAUDE.md into mine without duplicating
anything. Then copy the remaining files (preferences.yml, lessons-learned.yml,
statusline-script.sh, core/, workflows/, commands/) into ~/.claude/, skipping
any files I already have. Make statusline-script.sh executable.
```

After the files are in place, edit `~/.claude/preferences.yml` to set your own name in the greeting/signoff sections.

## Post-Install Setup

### 1. Disable auto-compact

This is the single most important configuration change. Run this in a terminal:

```bash
claude config set --global autoCompact false
```

**Why:** Auto-compact triggers when Claude decides it's running low on context. The problem is that it compresses your conversation *without* running the session-end workflow first, which means:
- No recovery guide gets created
- No lessons get captured
- No SESSION_HANDOFF.xml gets updated
- The next session starts cold

By disabling auto-compact, you stay in control. You watch the context %, run `/session-end` when you're ready, and then manually compact. The next session picks up cleanly from the recovery guide.

### 2. Enable the status line

The status line shows your git branch, context window usage %, and model name. Run this in a terminal:

```bash
claude config set --global statusline '~/.claude/statusline-script.sh'
```

Requires `jq` installed (`brew install jq` on macOS).

### 3. Install plugins

These can be installed from a terminal or from within a Claude Code session.

**From a terminal:**
```bash
claude plugin install claude-mem@thedotmack
claude plugin install superpowers@superpowers-marketplace
claude plugin install context7@claude-plugins-official
```

**From within a Claude Code session:**
```
/plugin install claude-mem@thedotmack
/plugin install superpowers@superpowers-marketplace
/plugin install context7@claude-plugins-official
```

| Plugin | What it does |
|--------|-------------|
| claude-mem | Cross-session structured memory. The session-recovery workflow saves lessons here and searches past work. |
| superpowers | Brainstorming, debugging, TDD, and planning skills. |
| context7 | Library documentation lookup. |

## How to Use It

### Context Window Management

Your status line now shows something like: `main | 42% | Opus 4.6`

That `42%` is your context window usage. When you're ready to wrap up, run `/session-end`. The workflow is designed to handle this at any context level. It builds the recovery guide first (the most valuable artifact), then captures lessons and updates SESSION_HANDOFF.xml. If context runs out partway through, the recovery guide is already written.

The recommended target is **80% or below** -- this gives the session-end workflow plenty of room to complete all its steps. But even at 90%+, just run `/session-end` and let it do what it can. The workflow prioritizes the right things.

After `/session-end` completes (or partially completes), run `/compact` manually. The next session uses `/session-start`, which reads the recovery guide and the compact summary. No additional context needs to be provided.

### Starting a Session

Type `/session-start` at the beginning of each session. Claude will:

1. Re-read CLAUDE.md and all @included files
2. Read SESSION_HANDOFF.xml to understand where you left off
3. Check for relevant guides in .claude/guides/
4. Validate project state (git status, etc.)
5. Check for CLOSED hypotheses (things already tested and ruled out)
6. Surface any pending lessons from last session for your review

### Ending a Session

Type `/session-end` when you're ready to wrap up. Claude will:

1. Create a recovery guide in `.claude/guides/` with everything the next session needs
2. Capture any lessons learned (mistakes, corrections, insights)
3. Update SESSION_HANDOFF.xml with current status and next priorities
4. Commit work in progress

After the workflow completes, run `/compact` to compress the conversation. Start a fresh session with `/session-start` whenever you're ready to continue.

### The Self-Improvement Loop

This is how Claude gets better over time:

1. **During work:** Claude makes a mistake or you correct it
2. **Session end:** The correction gets captured in `lessons-learned.yml` as a pending lesson
3. **Next session start:** Claude surfaces the pending lesson and asks you:
   - **Accept** -- The fix gets written into CLAUDE.md, preferences.yml, or a workflow. The lesson is removed from the queue.
   - **Reject** -- You explain why. The lesson is removed.
   - **Defer** -- It stays pending for next session.
4. **Future sessions:** The fix is now part of Claude's rules. It won't make that mistake again.

Over time, your CLAUDE.md accumulates hard-won rules specific to how you work. Every correction becomes permanent.

### The Hypothesis Protocol

When debugging across sessions, Claude tracks what it has tested:

- **OPEN** -- Not yet tested
- **CLOSED** -- Tested conclusively. Do not revisit.
- **INCONCLUSIVE** -- Test was invalid. May revisit with better setup.
- **SUPERSEDED** -- Replaced by a different theory.

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

This forces Claude to think through changes before making them and gives you both sides before approving.

## Philosophy

- **Corrections are data.** Every time you fix Claude, that's a signal. Capture it or it repeats.
- **Rules are earned.** Don't add rules speculatively. Add them when something goes wrong. Each rule in CLAUDE.md should trace back to a real incident.
- **Static vs dynamic.** Rules go in CLAUDE.md (loaded every session). Status goes in SESSION_HANDOFF.xml (changes every session). Mixing them creates staleness.
- **Evidence over analogy.** Claude defaults to pattern-matching. The methodologies.yml forces it to reason from first principles and cite evidence.
- **Manual over automatic for session management.** Auto-compact loses context silently. Manual session boundaries with `/session-end` preserve everything.
