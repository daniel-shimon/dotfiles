---
name: handoff
description: Write or update a handoff document so the next agent with fresh context can continue this work.
---

Write or update a handoff document so the next agent with fresh context can continue this work.

Steps:
1. Check if handoff.md already exists in the project
2. If it exists, read it first to understand prior context before updating
3. Create or update the document with:
   - **Goal**: What we're trying to accomplish
   - **Current Progress**: What's been done so far
   - **What Worked**: Approaches that succeeded
   - **What Didn't Work**: Approaches that failed (so they're not repeated)
   - **Next Steps**: Clear action items for continuing
   - **Suggested Skills**: Skills the next agent should invoke (e.g. `kb-foreign-fields`, `running-tests`, `dev-workflows`). List only skills relevant to the next steps.

Do not duplicate content already captured in other artifacts (PRDs, plans, ADRs, issues, commits, diffs). Reference them by path or URL instead.

Save as handoff.md in the plans dir and tell the user the file path so they can start a fresh conversation with just that path.
