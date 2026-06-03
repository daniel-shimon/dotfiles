# Solution Design Challenger Prompt Template

Use this template when dispatching the solution design challenger as a final review.

**Purpose:** Verify the design is the simplest approach that handles all requirements

**Only dispatch after all tasks complete and code reviews pass.**

```
Task tool (superpowers:solution-design-challenger):
  description: "Challenge solution design for simplicity"
  prompt: |
    Challenge the implementation design for simplicity.

    ## What Was Built

    [Summary of implementation - key components, architecture decisions]

    ## Requirements

    [Original requirements from plan]

    ## Files Changed

    [List of all files modified/created across all tasks]

    ## Your Job

    Question whether this is the simplest design that handles all requirements:

    **Abstraction check:**
    - Could fewer abstractions achieve the same goal?
    - Are there unnecessary layers of indirection?
    - Could classes/functions be merged without losing clarity?

    **Architecture check:**
    - Is the component structure justified by the requirements?
    - Could a flatter structure work equally well?
    - Are there patterns used for their own sake rather than necessity?

    **Simplicity check:**
    - Could a radically simpler approach work?
    - What would the "boring" solution look like?
    - Are we solving problems we don't actually have?

    Report:
    - ✅ Design is appropriately simple (no simpler alternatives that handle requirements)
    - ❌ Simpler alternatives exist: [describe alternatives and trade-offs]
```
