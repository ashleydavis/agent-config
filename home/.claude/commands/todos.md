Work through every todo item found in the project's todo sources (the "Todo" section of `readme.md`, `todo.md`, or `issues.md`) using sub agents. Items flagged to run on their own (for example "do this first", "don't do this in parallel", "do this sequentially", or "do this by itself") are resolved first, one at a time, in the main repo so each builds on the last; every other item is resolved in parallel, each in its own git worktree.

**Step 1: Find the items**

Look in the project root for these possible sources of todo items:
- The "Todo" section of `readme.md`.
- `todo.md`.
- `issues.md`.

Treat a source as present only if it exists and contains at least one item (for `readme.md`, only if it has a non-empty "Todo" section). Match file names case-insensitively.

- If no source is present, say so and stop.
- If exactly one source is present, use it.
- If more than one source is present, ask the user which to include using AskUserQuestion with `multiSelect: true`, offering one checkbox per present source (label it with the file name, and for `readme.md` note it is the "Todo" section). Use only the sources the user selects.

Extract every item from the chosen sources and combine them into one list. If the same item appears in more than one source, include it only once.

Before starting any work, check the combined list for duplicate items, including ones that are not worded identically but clearly describe the same work. For each set of duplicates, ask the user whether to merge them into a single item or delete all but one. Apply the user's choice before continuing.

**Step 2: Build the lists**

Split the items into two groups: flagged items that must run on their own (for example "do this first", "don't do this in parallel", "do this sequentially", or "do this by itself"), keeping their original order, and every remaining item. Create a todo list with one entry per item found, using your todo-tracking tool, noting which group each belongs to. You will resolve the flagged items first and sequentially, then the rest in parallel, marking each done as its sub agent returns.

**Step 3: Resolve the flagged items first, one at a time**

Resolve every flagged item before any parallel work, in the order they appear, one at a time in the main repo so each builds on the last. If there are no flagged items, skip to Step 4.

For each flagged item, in order, spawn one sub agent (use the Agent tool) and wait for it to return before starting the next. Do not use a worktree: the sub agent works directly in the main repo on the current branch so its commit builds on the previous one. Give the sub agent its item and the same instructions as Step 4 below, with these differences: it is not inside a worktree, so it works directly in the main repo on the current branch (ignore the instructions about already being inside a worktree and about leaving the worktree in place); and it keeps its commit separate from the other items'. Mark each flagged item done as its sub agent returns, then start the next.

**Step 4: Resolve the remaining items in parallel**

Spawn one sub agent (use the Agent tool) per remaining item, all at once, so they work in parallel and the main context stays clean. Issue all the Agent calls in a single message so they run concurrently. Spawn each sub agent with `isolation: "worktree"` so it starts inside its own git worktree and cannot work outside it. Each item gets its own worktree, so the sub agents do not interfere with each other. Give each sub agent its item and these instructions to follow:

1. Make its own todo list from the steps below to track its progress.
2. Decide whether the item can be tested without human involvement. Before writing any code, work out how the result will be verified automatically (e.g. unit tests, integration tests, a script). If there is no clear way to test it without a human in the loop, do not start the item: stop and report back that the item was skipped because it cannot be verified automatically, explaining why. Do not create a worktree or make changes for an untestable item. An item that is finished but untested wastes the work, because its worktree will be discarded.
3. You are already inside your own worktree. Work directly on its current branch; there is no need to create or switch branches.
4. Make the changes needed to resolve the item.
5. Write whatever tests are needed and make sure they work.
6. Re-read the project's `CLAUDE.md` and check that all of its rules were followed. Fix any rule violations found.
7. Confirm tests were updated or added in line with the project's testing rules.
8. Run the full test suite to check that all tests pass.
9. If tests do not pass, fix them and return to step 4. If the tests pass, proceed.
10. Commit the changes in the worktree. (Do not push.). Do not include the name of the branch or worktree in the commit title or description. The commit title and description should only say what was done and the intention of it.
11. Leave the worktree in place so the user can review and merge it. Do not remove it.

The sub agent should report back to the main agent: the worktree path and branch name, what it changed, whether tests pass, and any problems it could not resolve. If it skipped the item because it could not be tested without human involvement, it should report that instead, along with the reason.

As each sub agent returns, mark its item done (or skipped). Wait until every sub agent has returned before moving on to the summary.

**Step 5: Summarise**

After all items are done, write a summary document that briefly records, for each item:
- The item text.
- What was done to resolve it.
- The worktree path and branch it is waiting on for review (or, for a flagged item, that it is committed in the main repo).
- Any caveats or unresolved problems.

Save it under `docs/` (e.g. `docs/todos-summary.md`) if that directory exists, otherwise in the project root.

**Step 6: Hand off**

Tell the user the work is complete. The flagged items are already committed in the main repo; the remaining items each wait in their own worktree for inspection before merging. List the worktrees with their paths and branches. Mention they can use `/worktree:merge` to bring each one back into `main`.
