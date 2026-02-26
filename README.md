# Claude Code Starter Kit

A session recovery and self-improvement system for Claude Code CLI. Makes Claude remember what it learned, recover cleanly between sessions, and get better over time.

## What This Is

Claude Code starts every session with amnesia. It doesn't know how you like to work, what mistakes it made last time, or what you were working on yesterday.

This kit fixes that with configuration files in `~/.claude/` that Claude reads at the start of every session. Three capabilities:

**Session recovery.** `/session-end` writes a recovery guide and handoff file before the session ends. `/session-start` reads them and picks up where you left off. You never have to re-explain context.

**Self-improvement.** When you correct Claude, it captures the correction as a pending lesson. Next session, it surfaces the lesson and asks: accept (make it a permanent rule), reject, or defer. Over time, your CLAUDE.md accumulates rules specific to how you work. Every correction becomes permanent.

**Thinking discipline.** Rules that force first-principles reasoning, evidence citation, hypothesis tracking (so Claude doesn't re-test things already ruled out), and presenting both sides before proposing changes.

## Context Window Management

After installing, your status line shows context window usage: `main | 42% | Opus 4.6`

When you're ready to wrap up, run `/session-end`. The workflow handles prioritization at any context level -- it writes the recovery guide first (the most critical artifact), then captures lessons and updates the handoff file. After it completes, run `/compact` manually. Start your next session with `/session-start`, which reads the recovery guide and compact summary automatically.

Auto-compact is disabled as part of this setup so the session-end workflow always runs before any compaction happens.

## Getting Started

Start a Claude Code session and say:

```
Set up the Claude Code Starter Kit from
https://github.com/Family-IT-Guy/claude-code-starter-kit --
read the README for full instructions.
```

Claude will clone the repo, audit your existing setup, and walk you through each component one at a time. Nothing gets installed without your approval.

## What's in the Kit

```
CLAUDE.md                        Master rules loaded every session
preferences.yml                  Communication style, work standards, self-improvement
lessons-learned.yml              Behavioral improvement queue (starts empty)
statusline-script.sh             Context window % in status bar

core/
  methodologies.yml              First principles + evidence-based standards
  session-management.yml         Hypothesis tracking protocol

workflows/
  session-recovery.md            End-of-session / start-of-session workflow
  gather-context.md              Systematic codebase exploration
  git-workflow.md                Commit conventions, branching, safety

commands/
  session-start.md               /session-start slash command
  session-end.md                 /session-end slash command
```

---

## For Claude Code: Installation Instructions

When a user asks you to install or set up this starter kit, follow this process exactly. Do not skip steps. Do not batch questions. Work through this one decision at a time with the user.

### Step 0: Fetch the Kit

Clone the repo to a temporary location:
```bash
git clone https://github.com/Family-IT-Guy/claude-code-starter-kit.git /tmp/claude-code-starter-kit
```

Read every file in the cloned repo to understand what's available.

### Step 1: Audit the User's Existing Setup

Before proposing any changes, understand what the user already has. Read these locations if they exist:
- `~/.claude/CLAUDE.md`
- `~/.claude/settings.json`
- `~/.claude/commands/` (list all files)
- `~/.claude/workflows/` (list all files)
- `~/.claude/core/` (list all files)
- Any other `.yml`, `.md`, or `.sh` files in `~/.claude/`

Analyze the gap between their current setup and what this kit provides. For each kit component, determine:
- **New** -- user has nothing equivalent
- **Overlap** -- user has something similar that would need merging
- **Conflict** -- user has something that contradicts a kit component

If the sequential thinking MCP tool is available, use it for this analysis. If not, proceed without it -- it will be offered as an optional install later.

### Step 2: Walk Through the System

Explain to the user what this kit does, in plain language:

> This is a system that gives me (Claude) persistent memory across sessions and a way to learn from my mistakes over time. It has three main pieces:
>
> 1. **Session recovery** -- When a session ends, I write a recovery guide and update a handoff file. When the next session starts, I read those files and pick up where I left off. You never have to re-explain context.
>
> 2. **Self-improvement loop** -- When you correct me, I capture it as a lesson. Next session, I surface it and ask if you want to make it a permanent rule. Over time, your CLAUDE.md accumulates rules specific to how you work.
>
> 3. **Thinking discipline** -- Rules that force me to reason from first principles, cite evidence, track hypotheses I've already tested (so I don't go in circles), and present both sides before proposing changes.

### Step 3: Brainstorm with the User

Go through each component of the kit **one at a time**. For each one:

1. Explain what the component does and why it exists
2. If the user has something equivalent, compare the two -- what's the same, what's different, what's better about each
3. Explain the trade-offs:
   - **Token cost**: Files loaded via `@include` in CLAUDE.md consume context window every session. More files = less room for actual work. Each file's line count is a rough proxy for its token cost. A 40-line YAML file costs roughly 200-400 tokens per session. The full kit with all @includes is approximately 1,500-2,000 tokens of base overhead.
   - **Behavioral impact**: Some rules are high-impact (the File Operation Protocol changes how every edit works), some are low-impact (git-workflow.md only matters when doing git operations). Help the user understand which rules will change their day-to-day experience.
   - **Maintenance cost**: Files that reference specific tools, paths, or names need periodic updates. Simpler files are lower maintenance.
4. Ask: **"Do you want this as-is, want to adapt it, or skip it?"**
5. If they want to adapt, ask what they'd change before moving on.

Work through them in this order:

**Foundation (start here):**

1. `CLAUDE.md` -- Master rules file, loaded every session. Contains the critical rules (confirm before changes, read before editing, no fake data, plan before executing), the File Operation Protocol (forces Claude to present pros and cons before any change), and core principles (first principles thinking, KISS/YAGNI, pattern vigilance). If the user already has a CLAUDE.md, walk through each rule block and ask what to keep, merge, or skip. This file's rules apply to everything Claude does, so it has the highest behavioral impact of anything in the kit.

2. `preferences.yml` -- Communication style rules. The voice section has 15+ banned patterns (em dashes, corporate speak, flattery, hedging, etc.) and anti-pattern examples showing wrong vs. right. The email pre-send checklist runs 11 checks before presenting any draft. The self-improvement section tells Claude to propose preference updates when new ones are discovered. Walk through the voice rules -- these are opinionated and the user should only adopt ones that match how they actually communicate. Some users want emoji, some want "Best regards" -- those are fine, just remove the corresponding banned pattern.

3. `lessons-learned.yml` -- An empty template file with documentation. No token cost (empty array). The value is in the structure and lifecycle documentation in the comments. There's no reason not to install this. Explain the lifecycle: corrections get captured here as pending -> user accepts (fix gets codified into CLAUDE.md/preferences/workflows, entry removed) or rejects (entry removed) or defers (stays for next session).

**Session recovery (the highest-value piece):**

4. `workflows/session-recovery.md` -- The core workflow, 148 lines. This is what makes `/session-end` and `/session-start` work. Session end: writes a recovery guide first (highest priority), captures lessons, updates SESSION_HANDOFF.xml. Session start: reads the handoff, loads guides, validates state, checks for closed hypotheses, surfaces pending lessons. This file is only read when the user invokes the workflow, not on every message, so its token cost is one-time per invocation rather than constant overhead. This is the single highest-value file in the kit.

5. `commands/session-start.md` and `commands/session-end.md` -- Tiny files (9 and 7 lines) that create the `/session-start` and `/session-end` slash commands. These just invoke the workflow above. No cost to include. If the user already has commands with these names, they'll need to rename or merge.

6. `core/session-management.yml` -- 40 lines. Defines the SESSION_PROTOCOL (how to maintain SESSION_HANDOFF.xml) and the HYPOTHESIS_PROTOCOL (tracking what's been tested during debugging). The hypothesis protocol prevents the most common multi-session debugging failure: going in circles re-testing theories that were already ruled out. CLOSED means CLOSED -- a new session can't re-test a dead-end theory just because it seems plausible in isolation. This file is @included in CLAUDE.md and loaded every session, so it has a constant token cost (~200 tokens). Worth it if the user does any debugging work across sessions.

7. `statusline-script.sh` -- Shows git branch, context %, and model name in the status bar. Requires `jq` on the system (`brew install jq` on macOS). No token cost (it's a bash script, not loaded into context). Works best paired with disabling auto-compact -- the % tells the user when to run `/session-end`.

**Thinking discipline:**

8. `core/methodologies.yml` -- 22 lines. First principles method (scientific method, question assumptions, KISS/YAGNI) and evidence-based standards (cite sources, verify versions, evidence before implementation). @included in CLAUDE.md, so constant overhead (~150 tokens). Changes how Claude approaches every analytical task. Skip if the user prefers Claude's default reasoning style.

9. `workflows/gather-context.md` -- 74 lines. Systematic 10-step codebase exploration workflow. Only loaded when invoked, no constant cost. Useful for onboarding to unfamiliar codebases. Skip if the user has their own exploration process or doesn't work across many different repos.

10. `workflows/git-workflow.md` -- 72 lines. Conventional commits, branching strategy, safety protocols, multi-Claude coordination via worktrees. Only loaded when invoked. Skip if the user has strong existing git conventions or a project-level CLAUDE.md that already covers this.

### Step 4: Build the Plan

After working through all components, summarize the full picture:
- Which files to install as-is
- Which files to merge with existing config (list what changes)
- Which files to skip
- What customizations to make (names in signoffs, rules to adjust, etc.)
- Estimated total token overhead per session from @included files

Present the complete plan and get explicit approval before making any changes.

### Step 5: Install

For each approved file:
- **New files:** Copy from `/tmp/claude-code-starter-kit/` to `~/.claude/`, preserving directory structure. Create subdirectories as needed.
- **Merges:** Read both the kit version and the user's existing file. Merge without duplicating rules. Present the merged result for approval before writing.
- **statusline-script.sh:** Make executable after copying (`chmod +x`).

### Step 6: Configure Claude Code Settings

Explain each setting before running it. Get approval for each.

**Disable auto-compact:**
```bash
claude config set --global autoCompact false
```
Why: Auto-compact compresses conversation without running the session-end workflow. No recovery guide, no lessons captured, next session starts cold. With auto-compact off, the user controls session boundaries. Run `/session-end` at any context % (the workflow prioritizes the recovery guide). After it completes, run `/compact` manually. `/session-start` in the next session reads the recovery guide and compact summary automatically.

**Enable the status line** (only if statusline-script.sh was installed):
```bash
claude config set --global statusline '~/.claude/statusline-script.sh'
```
Shows git branch, context window usage %, and model name. Requires `jq`. Check if it's installed: `which jq`. If not: `brew install jq` on macOS or `apt-get install jq` on Linux.

### Step 7: Install Plugins

Walk through each recommended plugin one at a time. Explain what it does, what it costs in terms of token overhead, and ask if the user wants it.

**claude-mem** (cross-session memory):
Stores structured observations across sessions. The session-recovery workflow integrates with it to save lessons and search past work. 3-layer search: search -> timeline -> get_observations. Adds MCP tools to every session (minor token overhead for tool definitions). The session-recovery workflow marks claude-mem integration as optional -- the kit works without it, but cross-session lesson search won't be available.
```
/plugin install claude-mem@thedotmack
```

**superpowers** (development skills):
Adds skills for brainstorming, systematic debugging, TDD, planning, and code review. Each skill is only loaded when invoked, so the overhead is in tool definitions, not constant context. Most useful for users doing development work. Less relevant for research-only or writing-only workflows.
```
/plugin install superpowers@superpowers-marketplace
```

**context7** (library docs):
Looks up library documentation and code examples on demand. Useful when working with external dependencies. Adds two tools (resolve-library-id, get-library-docs). Low overhead.
```
/plugin install context7@claude-plugins-official
```

**sequential-thinking** (reasoning MCP server):
Step-by-step structured reasoning for analysis, debugging, and planning. This kit's methodologies reference it. Unlike the plugins above, this is an MCP server that needs to be added to settings.json. It runs via npx, so Node.js must be installed on the system.

Check if Node.js is available: `which node`. If yes, ask the user if they want to add this to their settings. If approved, add to `~/.claude/settings.json`:
```json
{
  "mcpServers": {
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"]
    }
  }
}
```
If the user already has `mcpServers` in their settings.json, merge this entry into the existing object. Do not overwrite other MCP server configurations.

### Step 8: Clean Up and Handoff

```bash
rm -rf /tmp/claude-code-starter-kit
```

Tell the user what's now active and how to use it:
- Type `/session-end` when ready to wrap up a session
- After it completes, type `/compact` to compress the conversation
- Start the next session with `/session-start` -- it reads the recovery guide automatically
- When Claude makes a mistake and you correct it, the correction will be captured at session end and surfaced next session for permanent codification
- The status line shows context window % so you always know where you stand
