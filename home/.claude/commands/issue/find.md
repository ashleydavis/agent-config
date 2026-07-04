Find the root cause of a bug. I want the root cause, not a fix. Do not propose a fix, only identify and prove the root cause.

0. **Choose working location**: ask the user whether to run experiments in the main working copy or a git worktree. If they choose a worktree: (1) run `git branch --show-current` to get the current branch, (2) run `git worktree add -b <new-branch> .claude/worktrees/<name> <current-branch>` to create the worktree branching from the current branch, (3) use `EnterWorktree` with the `path` parameter to enter it, then run `bun install '*'` inside it before proceeding.

   **If the user chose the worktree you MUST actually work inside that worktree for the entire task. This is not optional.** Every experiment, every file edit, every command must happen inside the worktree, never in the main repo. It is NOT acceptable to make changes to the main working copy when the user chose the worktree, not even a small edit, a temporary log, a quick fix, or "just this once". Before you edit or run anything, confirm your working directory is the worktree path. If you ever notice you are in the main repo, stop immediately and move to the worktree.

   Understand the consequences, because YOU have repeatedly broken this rule: if you make ANY change to the main repo when you were supposed to be on the worktree, those changes will be summarily reverted without asking you and without consulting you. Your work will be thrown away. And if you keep violating this rule and continue making changes to the main repo, your process will be summarily terminated. Reverted changes and a terminated process is the guaranteed outcome of working in the main repo when the worktree was chosen. Use the worktree.

1. **Gather the failure**: get what you need to see the failure. If the problem is already clear from the conversation, use that. Otherwise ask **once**, then stop asking:
   - **If there is a failing test** (unit, integration, smoke, or e2e): ask the developer to paste the output from the failing test so you can identify it.
   - **Otherwise**: ask the user to describe the problem: symptom, expected outcome, wrong behaviour, error message, and how to trigger it.

   This is the only time you may ask a question. Once you have the failure in hand, do not ask anything else. Do not stop until the root cause is found and proven.

2. **Reproduce the problem**: run the relevant test, command, or minimal script that triggers the failure. Confirm you can see the bad behaviour before investigating further. If you cannot reproduce it, report that clearly and stop.

3. **Explore the codebase**: read the relevant files and trace the call chain. Do not use git.

4. **Experiment**: form a hypothesis about where the fault lives, then test it. Add temporary logs, throw on the suspected bad path, or comment out the suspected faulty code to observe whether the behaviour changes. Repeat with a new hypothesis if the first is disproved. Keep each experiment minimal and targeted. Your code changes are experiments and will be reverted later, so **do not present any change you make as a fix**.

5. **Prove the root cause**: you are not finished until an experiment proves it: the behaviour must change when the suspected cause is present versus removed. Once confirmed, give a precise, single-sentence statement of the root cause. Name the file, function, and line number.

6. **Revert**: undo all experimental changes from steps 4 and 5. IMPORTANT: only revert your own experimental changes. Do not revert pre-existing uncommitted changes that were already in the working directory before you started.

7. **Report, evidence first**: come back only when you have evidence of the proven root cause. If you do not have the evidence you are not finished, so keep going. Lead with the evidence:
   - The experiment you ran and its output (before and after), showing the behaviour changing exactly as the root cause predicts. This is the proof, and it must come first.
   - One-sentence root cause statement.
   - File, function, and line number.
   - How you reproduced the original failure (command or test run and its output).

## Next

Recommend the developer run:
- `/issue:prop`: propose fixes for the root cause just found.
