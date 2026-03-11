---
name: sessions
description: Use when listing active Claude Code sessions and their status.
allowed-tools: Task
---

# Sessions Skill

Lists all active Claude Code sessions across terminals/worktrees.

## Usage

Dispatch a **sonnet subagent** to run the script and format the output (keeps raw data out of main context):

```
Task tool with:
  subagent_type: "general-purpose"
  model: "sonnet"
  prompt: |
    Run: ~/.claude/skills/sessions/claude-sessions (with dangerouslyDisableSandbox: true)

    Output has sections:
    === THIS SESSION === (the invoking session)
    === WAITING SESSION === (needs user input)

    Each section has: Name:, Dir:, LastMsg: (for waiting only)

    Format as markdown table (| Session | Location | Status |):
    - Session: **Name** (Title) - only add (Title) if different from Name; truncate title ~70 chars
    - Location: Dir value
    - Status:
      - "THIS SESSION" → ⏳ (this)
      - "WAITING SESSION": 👀 + summary (20-30 chars)
        - If LastMsg has "?" → **bold question** with context prefix from earlier in LastMsg
          Example: LastMsg="Implementation complete... What would you like?" → "**Complete. What next?**"
        - If no "?" → plain text summary

    End: "**X sessions waiting**"
    Output ONLY table + summary.
```

Display the subagent's result directly.

## Installation (one-time)

If hooks are not set up:

```bash
mkdir -p ~/.claude/hooks ~/.claude/sessions
cp ~/.claude/skills/sessions/hooks/*.sh ~/.claude/hooks/
chmod +x ~/.claude/hooks/session-*.sh
```

Then add to `~/.claude/settings.json` hooks:
- `SessionStart` → `bash $HOME/.claude/hooks/session-register.sh`
- `SessionEnd` → `bash $HOME/.claude/hooks/session-unregister.sh`
- `UserPromptSubmit` + `Stop` → `bash $HOME/.claude/hooks/session-status.sh`
