---
name: kb
description: Use when listing KB entries, documenting codebase topics, or before exploring unfamiliar parts of the codebase. Check KB first for existing documentation on any concept, architecture, or pattern.
argument-hint: list | learn <topic>
---

KB entries are `kb-*` skills in the **repo-level** `.claude/skills/` directory, auto-invoked when relevant to queries.

**Important:** All `kb-*` entries live in the **repo-level** `.claude/skills/` directory only. **NEVER** create them in `~/.claude/skills/`. No exceptions. KB entries are repo-specific knowledge.

## Mode: List (when $ARGUMENTS is "list")

Scan `.claude/skills/` for all `kb-*` directories, read their SKILL.md frontmatter, and display a table:

| Entry | Topics |
|-------|--------|
| (discovered from `.claude/skills/kb-*/SKILL.md` description fields) |

Output this table and stop.

## Mode: Learn (when $ARGUMENTS starts with "learn")

Document a codebase topic into the KB:

1. Extract topic from arguments
2. Clarify if ambiguous
3. Explore the codebase thoroughly
4. Present findings with AskUserQuestion:
   - "Looks good, save it"
   - "Other" (for feedback)
5. Create `.claude/skills/kb-<topic>/SKILL.md` with:

```yaml
---
name: kb-<topic>
description: keyword1, keyword2, ... (auto-invocation triggers)
user-invocable: false
---
```

6. Confirm the entry was saved

### Entry Content Guide

Include relevant sections:
- **Overview**: What and why
- **Architecture**: Components and interactions
- **Key files**: Important locations
- **Code examples**: Patterns and APIs
- **Troubleshooting**: Gotchas and debugging
