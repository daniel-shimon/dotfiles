---
name: main-md
description: Write or update a main.md project log in claude/main.md. Tracks work phases chronologically.
---

Maintain the project log at `claude/main.md`. Either create a new one or append a phase to an existing one.

## When creating a new main.md

1. Determine the feature name and branch from git context
2. Create `claude/main.md` with this structure:

```
# <Feature Name> — Project Log

Branch: `<branch-name>`

## Phase 1: <Short Label>

<1-2 sentence summary of what was done.> Key files: `file.py`, `other.py`.

- Detail bullet
- Detail bullet

## Directory Layout

claude/
├── main.md
├── scripts/
├── data/
└── generated/
```

## When appending a phase

1. Read the existing `claude/main.md`
2. Determine the next phase number
3. Summarize recent work into a new `## Phase N: <Label>` section
4. Update the Directory Layout if the `claude/` folder changed

## Format rules

- **Title**: `# <Feature Name> — Project Log`
- **Branch**: `` Branch: `<branch-name>` ``
- **Phases**: `## Phase N: <Short Label>` — numbered, chronological, append-only
- Each phase opens with 1-2 sentence prose summary mentioning key files
- Bullet points are short, high-level only: check results, numbers, key concepts. No implementation details or explanations.
- **Bold** notable techniques/concepts: `**concept** — explanation`
- Inline quantitative results with bold labels
- Last section is always `## Directory Layout` with a tree of `claude/`
- Keep everything terse — filenames, params, thresholds. No lengthy prose.

## Optional: Operational Notes

For debugging logs, environment quirks, workarounds, and other operational notes that don't belong in the phase log, use `claude/op-notes.md`. This is a scratchpad — no required format. Use it for things like:

- Commands that worked (or didn't) on a specific machine
- Environment-specific setup steps
- Temporary workarounds and their context
- Observations useful for the next session but not worth a phase entry
