Bring the main repository's current branch into the current worktree, without losing any work in the worktree, then prove the worktree's own changes still pass on top of what arrived.

This is the opposite direction to `/worktree:merge`, which takes a finished worktree back into the main repo. Use this one while the worktree is still being worked on and the main branch has moved on underneath it.

Steps:

1. Establish where everything is. Run `git worktree list --porcelain`. The first entry is the main worktree; the rest are linked worktrees. Record the main repository path, the current worktree's path, and the branch each is on. Show this to the user before doing anything.

2. Stop if this is not being run from a linked worktree. If the current directory is the main worktree, there is nothing to bring in and the command does not apply. Report that and stop.

3. Read the main repository's current branch with `git -C <main-repo-path> branch --show-current`. Whatever branch it is on is what gets brought in. Do not assume `main` or `master`: the point of this command is to follow wherever the main checkout actually is. If the main repo is on a detached HEAD, report it and stop, since there is no branch to bring in.

4. Back up everything uncommitted in the worktree to `/tmp` before touching anything. This runs before the stash, not instead of it, because a stash can fail to restore and the backup is what makes that survivable. Create a directory `/tmp/worktree-update-<branch>-<timestamp>/` and write into it:
   - `git -C <worktree-path> diff HEAD --binary > changes.patch`, which captures both staged and unstaged changes to tracked files.
   - `git -C <worktree-path> diff --cached --binary > staged.patch`, so the split between staged and unstaged can be put back if the stash flattens it.
   - The untracked files, listed with `git -C <worktree-path> ls-files --others --exclude-standard` and copied into `untracked/` preserving their relative paths. Skip anything ignored, which is what `--exclude-standard` does, so build output and dependency directories are not copied.
   - `git -C <worktree-path> status --short > status-before.txt` and `git -C <worktree-path> rev-parse HEAD > head-before.txt` for comparison afterwards.
   Report the backup directory path to the user. Do not delete it at the end of this command: leave it for the human to remove once they are satisfied.

5. Commit or stash the worktree's uncommitted work. If `git -C <worktree-path> status --short` is empty, skip to step 6. Otherwise prefer committing over stashing when the changes are a coherent piece of work: run `/commit:detz`, show the message to the user, and wait for approval before `/commit:do`. A commit is safer than a stash because it is in the object database and survives anything that happens next. When the changes are not ready to commit, stash them instead with `git -C <worktree-path> stash push --include-untracked --message "worktree-update <timestamp>"`, and record the stash reference that produced.

6. Choose rebase or merge, and say which and why before running it.
   - **Rebase is the default.** It replays the worktree's own commits on top of the incoming branch, which keeps the history linear and matches what `/worktree:merge` will do when this branch eventually goes back. Use it whenever the worktree branch exists only locally.
   - **Merge instead** when the worktree branch has been pushed or is shared with anyone, because rebasing rewrites commits that somebody else may already have. Check with `git -C <worktree-path> rev-parse --abbrev-ref '@{upstream}'`; if that succeeds, the branch has an upstream and merge is the safer choice.

7. Run it from the worktree:
   - Rebase: `git -C <worktree-path> rebase <main-branch>`
   - Merge: `git -C <worktree-path> merge <main-branch>`
   If it produces conflicts, resolve them by editing the conflicted files into a correct result, then stage them and continue with `git -C <worktree-path> rebase --continue` or by committing the merge. Always attempt to resolve conflicts yourself rather than stopping to ask. Resolving means understanding both sides: read the incoming commits with `git -C <worktree-path> log <old-head>..<main-branch>` so the resolution is based on what actually changed rather than on picking a side.

8. Restore the stashed work, if step 5 stashed anything. Run `git -C <worktree-path> stash pop`. If that conflicts, resolve the conflicts the same way, and note that a `pop` which conflicts does not drop the stash, so the stash entry is still there as a second safety net. If the pop cannot be resolved at all, restore from the backup instead: `git -C <worktree-path> apply /tmp/worktree-update-.../changes.patch` and copy the untracked files back.

9. Prove nothing was lost. Compare the working tree against the backup taken in step 4:
   - `git -C <worktree-path> status --short` should list the same files as `status-before.txt`, allowing for files that the incoming commits legitimately changed.
   - Every file in `untracked/` should be present in the worktree again.
   - If anything is missing, restore it from the backup before going any further, and tell the user exactly what was missing and where it came from.
   Report any difference rather than passing over it. A file that quietly did not come back is the failure this whole command is built to avoid.

10. Rerun the tests. Bringing in other people's commits can break the worktree's changes in ways that neither side breaks alone, and the only thing that shows that is running the suite after the two are combined. Use the repository's own canonical command, whichever its `CLAUDE.md` or `AGENTS.md` names, run from the worktree rather than from the main checkout. Where that command skips work based on what has changed since the last passing run, force it to run everything: a rebase moves the ground that comparison is made against, so the skip logic is answering a question about a tree that no longer exists. In the photosphere repository, for example, the command is `bun run test:everything` and the way to force it is `bun run test:everything -- --force`. If a repository names no canonical command, run its full test script rather than a subset.

11. Fix what the merge broke, if anything failed. A test that passed before this command and fails after it is a genuine interaction between the incoming commits and the worktree's own, not a flake, and it is this command's job to leave the worktree green. Diagnose it properly rather than retrying. If it cannot be fixed, report the failure with the test output and say plainly that the worktree is now broken, rather than reporting the update as done.

12. Report what happened: which branch was brought in and from where, how many commits arrived, whether it was a rebase or a merge and why, whether anything was stashed and restored, the result of the loss check in step 9, the test result, and the path of the `/tmp` backup that is still there to be deleted by hand.

If any step fails, stop and report the error to the user rather than continuing. Never use `git reset --hard`, `git checkout -- .`, `git clean`, or `git stash drop` anywhere in this command: every one of them can destroy the work this is supposed to protect, and none of them is needed to bring a branch in.
