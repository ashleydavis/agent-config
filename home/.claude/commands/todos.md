Work through every todo item found in the project's todo sources (the "Todo" section of `readme.md`, `todo.md`, or `issues.md`), resolving each one in parallel, in its own git worktree, using sub agents.

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

**Step 2: Build the list**

Create a todo list with one entry per item found, using your todo-tracking tool. You will resolve them in parallel, marking each done as its sub agent returns.

**Step 3: Resolve each item**

Spawn one sub agent (use the Agent tool) per item, all at once, so they work in parallel and the main context stays clean. Issue all the Agent calls in a single message so they run concurrently. Each item gets its own worktree and branch, so the sub agents do not interfere with each other. Give each sub agent its item and these instructions to follow:

1. Make its own todo list from the steps below to track its progress.
2. Decide whether the item can be tested without human involvement. Before writing any code, work out how the result will be verified automatically (e.g. unit tests, integration tests, a script). If there is no clear way to test it without a human in the loop, do not start the item: stop and report back that the item was skipped because it cannot be verified automatically, explaining why. Do not create a worktree or make changes for an untestable item. An item that is finished but untested wastes the work, because its worktree will be discarded.
3. Create a new git worktree off `main` for the item, on a new branch named from the content of the item (short, kebab-case). For example: `git worktree add ../<repo-name>-worktrees/<item-name> -b <item-name> main`.
4. Do all work inside that worktree (run git commands against it with `git -C <worktree-path> ...`). Make the changes needed to resolve the item.
5. Write whatever tests are needed and make sure they work.
6. Re-read the project's `CLAUDE.md` and check that all of its rules were followed. Fix any rule violations found.
7. Confirm tests were updated or added in line with the project's testing rules.
8. Run the full test suite to check that all tests pass.
9. If tests do not pass, fix them and return to step 4. If the tests pass, proceed.
10. Commit the changes in the worktree. (Do not push.). Do not include the name of the branch or worktree in the commit title or description. The commit title and description should only say what was done and the intention of it.
11. Leave the worktree in place so the user can review and merge it. Do not remove it. Do not switch the branch of the main checkout.

The sub agent should report back to the main agent: the worktree path and branch name, what it changed, whether tests pass, and any problems it could not resolve. If it skipped the item because it could not be tested without human involvement, it should report that instead, along with the reason.

As each sub agent returns, mark its item done (or skipped). Wait until every sub agent has returned before moving on to the summary.

**Step 4: Summarise**

After all items are done, write a summary document that briefly records, for each item:
- The item text.
- What was done to resolve it.
- The worktree path and branch it is waiting on for review.
- Any caveats or unresolved problems.

Save it under `docs/` (e.g. `docs/todos-summary.md`) if that directory exists, otherwise in the project root.

**Step 5: Hand off**

Tell the user the work is complete and that each worktree is ready for them to inspect before merging. List the worktrees with their paths and branches. Mention they can use `/worktree:merge` to bring each one back into `main`.
