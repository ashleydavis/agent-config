Work through every item in the "Todo" section of `readme.md`, resolving each one on its own branch using sub agents.

**Step 1: Find the items**

Read `readme.md` in the project root and extract every item from its "Todo" section. If the section is empty or missing, say so and stop.

**Step 2: Build the list**

Create a todo list with TodoWrite, one entry per item found. You will work through them one by one, marking each done as you complete it.

**Step 3: Resolve each item**

Work through the items one at a time. For each item, spawn a sub agent (use the Agent tool) to implement it, so the main context stays clean. Give the sub agent the item and these instructions to follow:

1. Make its own todo list (with TodoWrite) from the steps below.
2. Create a new branch off `main` with a name derived from the content of the item (short, kebab-case).
3. Make the changes needed to resolve the item.
4. Write whatever tests are needed and make sure they work.
5. Re-read the project's `CLAUDE.md` and check that all of its rules were followed. Fix any rule violations found.
6. Confirm tests were updated or added in line with the project's testing rules.
7. Run the full test suite to check that all tests pass.
8. If tests do not pass, fix them and return to step 3. If the tests pass, proceed.
9. Commit the changes on the branch. (Do not push.). Do not include the name of the feature branch in the commit title or description. The commit title and description should only say what was done and the intention of it.
10. Return to the `main` branch.

The sub agent should report back to the main agent: the branch name, what it changed, whether tests pass, and any problems it could not resolve.

Once a sub agent returns, mark that item done and move on to spawn the sub agent for the next item. Do not start the next item until the current one has returned.

**Step 4: Summarise**

After all items are done, write a summary document that briefly records, for each item:
- The item text.
- What was done to resolve it.
- The branch it is waiting on for review.
- Any caveats or unresolved problems.

Save it under `docs/` (e.g. `docs/todos-summary.md`) if that directory exists, otherwise in the project root.

**Step 5: Hand off**

Tell the user the work is complete and that each branch is ready for them to inspect before merging. List the branches.
