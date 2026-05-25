Create a new plan and save it to `docs/plans/`.

**Important:** You are drafting this plan for an AI agent (Claude) to execute later — not for a human. Do not write steps a human would follow. Write steps as precise AI actions: file edits, function changes, tool calls, and code modifications with exact file paths and names. The exception is the **Human Verification** section at the end, which lists checks a human can perform after the AI has executed the plan to confirm everything works as expected.

1. **Gather intent** — if the user has described the feature or change in this conversation, use that. Otherwise ask: "What do you want to plan?" Wait for their answer before continuing.

2. **Research** — explore the relevant parts of the codebase to understand the current structure, affected files, and any existing patterns that the plan should follow. Use file reads, grep, and directory listings as needed.

3. **Draft the plan** — produce a complete plan using the structure below. Be specific: name actual files, functions, types, and interfaces. Steps should be small enough to implement one at a time. **Write all steps as instructions for an AI agent to execute, not a human** — steps should describe precise code changes, file edits, and tool actions, not manual UI interactions or things a person would do. Plans may include interface, class, and function signatures where helpful. Do not include actual implementation code unless describing a particularly difficult algorithm. Requirements should be described as text or bullet points, not code.

```
# <Plan Title>

## Overview
<One paragraph describing the intent and why the change is needed>

## Issues
<Leave empty — populated later by plan:check>

## Steps
<Numbered list of concrete implementation steps, each naming the file and function to change>

## Unit Tests
<List of unit tests to write or update, one per new or changed function>

## Smoke Tests
<List of end-to-end checks, preferably captured as automated tests in a shell script>

## Verify
<Concrete, observable checks the AI agent can run after implementation — must always include running all unit tests and all smoke tests, plus any additional compile checks or assertions>

## Human Verification
<Steps a human can take after AI execution to confirm the feature works as expected — e.g. run the app, check UI behaviour, observe outputs>

## Notes
<Decisions, trade-offs, open questions, or constraints discovered during research>
```

4. **Choose a filename** — derive a short kebab-case name from the plan subject (e.g. `plan-add-user-auth.md`). If a file with that name already exists in `docs/plans/new/`, choose a different name.

5. **Save** — write the plan to `docs/plans/new/<filename>`.

6. **Report** — print the path of the saved file and a one-line summary of what the plan covers.
