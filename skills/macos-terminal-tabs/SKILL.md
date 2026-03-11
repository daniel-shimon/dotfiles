---
name: macos-terminal-tabs
description: Use when spawning a new terminal tab, launching Claude in a new tab, or opening a directory in a separate tab.
argument-hint: "[command to run in new tab]"
allowed-tools: Bash(osascript:*)
---

# macOS Terminal Tabs

Spawn new Terminal.app tabs and execute commands in them using AppleScript.

**Note**: Requires `dangerouslyDisableSandbox: true` - the sandbox blocks inter-process communication with Terminal.app.

## Open a new tab and run a command

```bash
osascript -e 'tell application "Terminal" to activate' \
  -e 'tell application "System Events" to keystroke "t" using {command down}' \
  -e 'delay 0.5' \
  -e 'tell application "Terminal" to do script "<command>" in front window'
```

## Example: command with quoted arguments

When the command itself contains quotes, escape them for the AppleScript string:

```bash
osascript -e 'tell application "Terminal" to activate' \
  -e 'tell application "System Events" to keystroke "t" using {command down}' \
  -e 'delay 0.5' \
  -e 'tell application "Terminal" to do script "echo \"hello world\"" in front window'
```
