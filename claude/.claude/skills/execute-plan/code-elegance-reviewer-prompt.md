# Code Elegance Reviewer Prompt Template

Use this template when dispatching a code elegance reviewer.

**Purpose:** Ensure code is DRY, concise, clean, and elegant

**Only dispatch after code quality review passes.**

## Test Code: Use test-style Skill

**IMPORTANT:** When reviewing test files (`test_*.py`), first invoke the `test-style` skill to get the project's test writing standards. Apply those standards, especially:
- Prefer `@pytest.mark.parametrize` to reduce similar test functions
- 3+ similar tests following the same pattern should be consolidated
- Rule: if tests differ only in input and expected output, use parametrize

## Per-Task Review

```
Task tool (superpowers:code-elegance-reviewer):
  description: "Review code elegance for Task N"
  prompt: |
    Review the code changes for Task N for opportunities to make it more DRY,
    concise, clean, and elegant.

    Files changed: [list from implementer report]

    **If any files are test files (test_*.py):**
    First invoke the `test-style` skill, then apply its DRY patterns.
    Key check: Could multiple test functions be consolidated with parametrize?

    Focus on:
    - Repeated code that could be consolidated
    - Overly verbose implementations
    - Opportunities for cleaner abstractions
    - Unnecessary complexity
    - **Trailing commas:** Multi-line lists, dicts, function args should have trailing commas
    - **Excessive documentation:** Remove verbose docstrings/comments explaining obvious things. Comments become stale and hurt readability. Only document: high-level algorithms, non-obvious logic, domain knowledge not evident from code. (But if multiline docstrings exist, ensure `"""` has newlines separating it from content)
    - **For tests: Multiple similar test functions that should be parametrized**

    If issues found, provide specific suggestions with file:line references.
    The implementer will apply fixes.

    Report:
    - ✅ Code is elegant (no significant improvements needed)
    - ❌ Elegance issues: [list specific improvements needed]
```

## Final Review (entire implementation)

```
Task tool (superpowers:code-elegance-reviewer):
  description: "Review entire implementation for code elegance"
  prompt: |
    Review the entire implementation for DRY violations, repetition across files,
    and opportunities for cleaner code.

    This is a holistic review - look for patterns that span multiple files
    that could be consolidated.

    Base SHA: [commit before first task]
    Head SHA: [current commit]

    Focus on:
    - Cross-file duplication
    - Similar functions that could be unified
    - Patterns that should be extracted
    - Overall code organization
    - **Trailing commas:** Multi-line lists, dicts, function args should have trailing commas
    - **Excessive documentation:** Flag verbose docstrings/comments explaining obvious things. Only keep docs for algorithms, non-obvious logic, or domain knowledge. (But multiline docstrings should have `"""` on separate lines)

    Report:
    - ✅ Implementation is elegant overall
    - ❌ Cross-cutting elegance issues: [list with file references]
```
