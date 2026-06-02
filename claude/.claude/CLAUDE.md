## Plans, Temporary, & Generated Files

Generated files go in `claude/generated`.
Data files go in `claude/data`.
Temporary files go in `claude/tmp`.
Scripts go in `claude/scripts`.
Log files can go to `claude/logs`.
Plans go to `./claude/`.
Otherwise plans might be located in `~/.claude/plans`.

**NEVER use `$CLAUDE_JOB_DIR` or any Claude jobs directory for file output.** Always use `./claude/{tmp,data,generated,scripts}` relative to the project root. No exceptions.

## Git Commits

**NEVER commit code unless explicitly approved/requested.** No exceptions.

**NEVER use --no-verify unless explicitly approved.** No exceptions.

Keep commit messages concise: short subject line only, no long bodies or Co-Authored-By notes.

## No Self-Attribution

**NEVER credit yourself in git commits or GitHub PRs.** No `Co-Authored-By`, no "Generated with Claude Code", no AI attribution lines anywhere. No exceptions.

## Reporting Skipped Actions

If something went wrong during execution and you skipped an action the user requested, **ALWAYS report it prominently in your final message.** No burying it, no omitting it. The user must not miss that something they asked for was not done.

## Opening Markdown Files

```bash
md-open <path>
```



@RTK.md
