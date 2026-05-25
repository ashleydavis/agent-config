Break the current plan into discrete implementation steps.

Use the plan from the current conversation, or read the most recent 5 files in `docs/plans/new/` and ask the user which to use.

## Steps

1. Read the plan and identify logical, self-contained chunks of work. Each chunk should be small enough to implement and verify independently, but large enough to be meaningful.

2. The **first step** is always "Write documentation": draft the documentation for the feature or change as it is intended to work, so the user can read it and understand what they are getting before any code is written. Save it to `docs/plans/<plan-name-without-extension>/1-write-documentation.md`.

3. For each middle step (the actual implementation steps):
   - If it involves adding or changing code, it must include writing or updating unit tests and/or smoke tests covering the change.
   - End each step with: "Run all tests and confirm they pass before marking this step complete."
   - Save the step to its own markdown file at `docs/plans/<plan-name-without-extension>/<N>-<short-slug>.md`, where `<N>` is the 1-based step number and `<short-slug>` is a kebab-case summary of the step (e.g. `2-add-auth-middleware.md`).

4. The **last step** is always "Update documentation": revise the documentation written in step 1 to reflect the final state of the code, including anything that changed during implementation. Save it to `docs/plans/<plan-name-without-extension>/<N>-update-documentation.md`.

5. Every step file (first, middle, and last) must end with an empty `## Summary` section to be filled in when the step is implemented, recording what was actually done. Format:

```
## Summary

_To be completed when this step is implemented._
```

6. Prepend a numbered implementation steps checklist to the **top** of the original plan file. Format:

```
## Implementation Steps

- [ ] 1. <Step title> — `<plan-name>/<N>-<short-slug>.md`
- [ ] 2. <Step title> — `<plan-name>/<N>-<short-slug>.md`
...
```

Each checkbox lets the user mark the step complete as they work through it.

7. Report back with the list of files created and a one-line summary of each step.
