---
name: gh-code-review
description: Use when doing code reviews on GitHub PRs.
argument-hint: "<pr_number>"
allowed-tools: Bash(gh:*), Skill(github-cli)
---

# Code Review Workflow

Usage: `/gh-code-review <pr_number>`

## Step 1: PR Summary
```bash
# Get PR metadata
gh pr view <pr_number> --json title,body,author,additions,deletions,changedFiles,baseRefName,headRefName

# Get list of changed files
gh pr diff <pr_number> --name-only

# Get the diff for analysis
gh pr diff <pr_number>
```

Present to user:
- PR title and author
- Base/head branches
- Stats: +additions/-deletions across N files
- Key files changed (grouped by directory/component)

## Step 2: Create Plan File

Create a plan file at `~/.claude/plans/pr-<NUMBER>-code-review.md`:

For each file, analyze the diff and list the major changes as nested checklist items. This allows tracking review progress at a granular level.

```markdown
# Code Review: PR #<NUMBER> - <title>

## Files to Review

- [ ] path/to/file1.py
  - [ ] Add new `process_data()` function (lines 15-42)
  - [ ] Modify error handling in `fetch_results()` (lines 58-65)
  - [ ] Update imports
- [ ] path/to/file2.py
  - [ ] Refactor `UserManager` class constructor
  - [ ] Add validation logic in `create_user()`
- [ ] path/to/file3.py
  - [ ] Minor formatting changes

## Review Comments

<!-- Comments will be added here as the review progresses -->
```

When analyzing the diff for each file, identify distinct logical changes:
- New functions/methods/classes added
- Modified existing functions (name the function and summarize the change)
- Structural changes (imports, exports, class definitions)
- Configuration or constant changes
- Minor changes (formatting, comments) can be grouped

## Step 3: Automated Code Review

Use the `superpowers:code-reviewer` agent (if available) or perform your own analysis:
- Look for bugs, logic errors, security issues
- Check for code style violations
- Identify missing error handling
- Note any architectural concerns

**Do NOT mark files as checked during this step.** The checklist tracks USER manual review, not automated scanning.

For each finding, present the issue details and use `AskUserQuestion` to ask whether to add it:

```
─────────────────────────────────────────
Issue 1/N: path/to/file.py:42
─────────────────────────────────────────
Type: suggestion

Description: [Explain the issue found]

Suggested comment:
> Consider using a context manager here for better resource handling.
> The current approach may leak resources if an exception occurs.
```

Then use `AskUserQuestion` with:
- header: "Add comment?"
- question: "Add this comment to the review? (select Other to re-phrase)"
- options:
  - "Yes" - Add the suggested comment as-is
  - "Skip" - Don't add this comment

After all issues are presented, show a summary:
> "Added N comments to the review. M issues were skipped."

## Step 4: Review Mode Selection

Ask the user:
> "How would you like to proceed with the remaining unreviewed files?"
> 1. **File-by-file**: Review each file sequentially
> 2. **Flow-based**: Review a specific code flow across files (specify the flow)
> 3. **Skip to submission**: Skip remaining files and prepare review

Show the unchecked files from the plan checklist.

## Step 5: Collect Changes

Based on user's choice:
- **File-by-file**: Get diff for the next unchecked file
- **Flow-based**: Identify and collect relevant hunks across files for the specified flow

```bash
# For a specific file
gh pr diff <pr_number> -- <file_path>
```

## Step 6: Interactive Hunk Review

**Show EVERY hunk to the user.** Never skip code or decide what to show. No exceptions.

Present changes piece-by-piece (similar to `git add -p`):

For each hunk/section:
```
─────────────────────────────────────────
File: path/to/file.py (hunk 1/3)
─────────────────────────────────────────
@@ -10,6 +10,8 @@ def example():
    existing_code()
+    new_line_1()
+    new_line_2()
    more_existing()
─────────────────────────────────────────
```

Then use `AskUserQuestion` with:
- header: "Comment?"
- question: "Comment on this change?"
- options:
  - "Yes" - Add a comment on this hunk
  - "No" - Continue to next hunk
  - "Skip file" - Mark file as skipped and move to next file
  - "Quit" - Stop reviewing and go to submission

## Step 7: Capture Comments

When user wants to comment:
- Ask for comment text and severity (question / suggestion / issue / praise)
- **Never rephrase without explicit consent** - record exactly what they wrote
- Record in plan file:

```markdown
## Review Comments

### path/to/file.py

**Line 42** (suggestion): Consider using a context manager here for better resource handling.

**Line 58** (issue): This could raise an unhandled exception if `data` is None.
```

## Step 8: Update Checklist

Mark nested items as reviewed after each hunk/section is reviewed. Mark the parent file as complete when all its nested items are done:

```markdown
- [x] path/to/file1.py ✓ reviewed
  - [x] Add new `process_data()` function (lines 15-42)
  - [x] Modify error handling in `fetch_results()` (lines 58-65)
  - [x] Update imports
- [x] path/to/file2.py ⊘ skipped
  - [ ] Refactor `UserManager` class constructor
  - [ ] Add validation logic in `create_user()`
- [ ] path/to/file3.py
  - [ ] Minor formatting changes
```

Update the checklist in real-time as each change block is reviewed, providing clear progress visibility.

## Step 9: Check Remaining Files

Read the plan file and check for unchecked items. If files remain:
> "The following files haven't been reviewed yet:"
> - path/to/file3.py
>
> "Would you like to continue reviewing, or proceed to submission?"

If user wants to continue, go back to Step 4.

## Step 10: Final Check

Ask user:
> "Before submitting, is there anything else you'd like to check or any additional comments to add?"

Allow user to:
- Add general comments
- Re-review specific files
- Edit existing comments in the plan

## Step 11: Submit Review

When user approves submission, use the github-cli skill to post the review:

1. Ask user for review type:
   - **COMMENT**: General feedback, no explicit approval
   - **APPROVE**: Approve the PR
   - **REQUEST_CHANGES**: Request changes before merge

2. **Review body handling:** Use empty body by default for all review types. Only add body if user explicitly requests it.

3. Submit the review:

**Post EXACT text from plan file.** Never rephrase when submitting.

```bash
# Get commit SHA
COMMIT_SHA=$(gh pr view <pr_number> --json headRefOid --jq '.headRefOid')

# Submit review with inline comments
# NOTE: Do NOT include comment types (suggestion/issue/etc) - just the exact comment text as written
cat > /tmp/review.json << 'EOF'
{
  "body": "",
  "event": "COMMENT",
  "comments": [
    {"path": "file.py", "line": 42, "body": "Consider using..."},
    {"path": "file.py", "line": 58, "body": "This could raise..."}
  ]
}
EOF

gh api --method POST "/repos/{owner}/{repo}/pulls/<pr_number>/reviews" --input /tmp/review.json
```

## Plan File Location

Plans are stored in `~/.claude/plans/pr-<NUMBER>-code-review.md` and persist across sessions, allowing you to:
- Resume interrupted reviews
- Reference previous review notes
- Track which files have been reviewed
