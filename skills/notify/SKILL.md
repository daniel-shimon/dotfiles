---
name: notify
description: Use when needing persistent macOS notifications for task completion or alerts
argument-hint: "[message] [title] [beeps]"
allowed-tools: Bash(osascript:*)
---

# macOS Persistent Notifications

Create floating notifications that stay on top of all windows until dismissed, with optional sound alerts.

## Quick Usage

### Basic notification with default title and 2 beeps (non-blocking)
```bash
osascript -e 'beep 2' -e 'tell application "System Events" to display dialog "Your message here" buttons {"Dismiss"} default button "Dismiss" with title "Notification" giving up after 0' &
```

Note: The `&` at the end makes the command return immediately without waiting for dismissal.

### Custom title and message
```bash
osascript -e 'beep 1' -e 'tell application "System Events" to display dialog "Build completed successfully!" buttons {"OK"} default button "OK" with title "Build Status" giving up after 0'
```

### Silent notification (no beep)
```bash
osascript -e 'tell application "System Events" to display dialog "Silent notification" buttons {"Dismiss"} default button "Dismiss" with title "Info" giving up after 0'
```

### Multiple buttons for user choice
```bash
osascript -e 'beep 2' -e 'tell application "System Events" to display dialog "Task completed! What next?" buttons {"Done", "View Details", "Continue"} default button "Done" with title "Success" giving up after 0'
```
