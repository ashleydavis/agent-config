# Planning rules

These rules apply when writing, checking or implementing a plan.

## A plan runs start to finish with no human

- A plan is written for an agent to execute, as precise file edits, code changes and commands with exact paths and names.
- It has no stops, no questions and no step or note that needs a human. Every question, decision and permission is settled while the plan is written.
- It never says what the agent cannot do and never tells it to report, wait or stop. A step that would need that is rewritten.
- It never waits on anything outside the agent's reach: a release, a tag, a push, another person's change or a machine the agent may not have. A dependency across repositories is taken locally (a path or workspace link) and the plan says exactly how.
- Settled decisions and rejected approaches go in Notes, so the executing agent does not reopen them.

## External actions and deletions

- Nothing external goes in a plan (commit, push, release, tag, publish, running a workflow, any other call to an outside system) unless the human explicitly asked for it, or invoked a command that names that action. Each one is stamped "requested explicitly by the human".
- Those actions go in a "Release" step, second to last.
- No deletion of anything, real or temporary, goes in the body of the plan. Every deletion goes in a "Clean up" step, the very last step, after every edit, step, test and check.

## Research before writing

- Check every mechanism the plan relies on against the code or by running it. An assumption that was not checked is not put in a plan.
- For everything the plan removes or changes, find the existing tests and scripts that depend on it and deal with each one in the plan.
- Before saving, walk the steps in order and confirm the agent has everything each one needs at that point.

## Testing in a plan

- Testing follows `testing.md`: every affected test that can run on the machine implementing the plan, climbing the testing ladder.
- Verify lists only checks that can run on that machine. Any that cannot are named as CI-only, and the plan never depends on them.

## Implementing a plan

- First check that the plan, or the part being implemented, has no stops, no questions and no parts that need a human. If it has any, exit at once saying: THIS PLAN CANNOT BE COMPLETED WITHOUT A HUMAN, THE PLAN NEEDS FIXING
- The plan is not the implementer's to change. It ticks steps and records what was done under each.
