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

**Result**: Final outcome in 1 sentence.

**Decisions**: Key threshold/config values chosen.

**Files**: `data_file.json`, `test_file.py`

Plan: [plan-file.md](plan-file.md)
```

## When appending a phase

1. Read the existing `claude/main.md`
2. Determine the next phase number
3. Summarize recent work into a new `## Phase N: <Label>` section

## Format rules

- **Title**: `# <Feature Name> — Project Log`
- **Branch**: `` Branch: `<branch-name>` ``
- **Phases**: `## Phase N: <Short Label>` — numbered, chronological, append-only
- **ONLY include**: description (1 line), results (tables/numbers), decisions (config values/thresholds), file references, plan link (bottom)
- **NO process/history**: omit bugs found, failed attempts, iteration steps, implementation details, test failures, rewrites
- Each phase structure:
  - **Description**: 1 sentence what was done
  - **Results**: tables/numbers/metrics
  - **Decisions**: final threshold/config values chosen
  - **Files**: data files, test paths, key impl files
  - **Plan**: link at bottom (`Plan: [file.md](file.md)`)
- **Bold** section headers: `**Result**:`, `**Decisions**:`, `**Tests**:`, `**Files**:`
- Tables for comparative data (variants, scales, benchmarks)
- Keep terse — no explanations, no narrative, final state only

## Optional: Operational Notes

For debugging logs, environment quirks, workarounds, and other operational notes that don't belong in the phase log, use `claude/op-notes.md`. This is a scratchpad — no required format. Use it for things like:

- Commands that worked (or didn't) on a specific machine
- Environment-specific setup steps
- Temporary workarounds and their context
- Observations useful for the next session but not worth a phase entry
