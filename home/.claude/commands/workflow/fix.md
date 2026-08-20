---
description: Fix the failing CI workflow run at the link given. Works in a worktree, one problem per commit, and proves each fix by getting the workflow green several times in a row.
---

# Fix a failing workflow run

A CI workflow run has failed. The human gives you the link to it: `$ARGUMENTS`. Find out why it failed, fix the cause, and prove the fix by running the workflow again until it passes several times in a row.

The run may have failed for a reason that is always there, or for one that only shows up now and again. You will not know which until you have read it, so do not assume either.

The commands below are for GitHub Actions through the `gh` CLI. If this project's CI is something else, find the equivalent way to list runs, list the failing jobs in a run, read a job's log, and start a run on a branch, and use those instead. Everything else in this command stays the same.

## When this is finished

The job is not done when you have made a fix. It is done when the workflow has passed **five times in a row** on the same commit, unless the human names a different number.

So this is a loop, and you stay in it:

- Read a failure, find its cause, fix it, push, and start the count.
- Every red run puts you back to the start of the loop with a new failure to read, and the count back to zero.
- Every new commit puts the count back to zero as well, because the runs have to be of the same code.
- Keep going until the count is reached. Do not stop and hand back a fix that has not been proved, and do not stop because the run that failed was "only" an outside service or "not really" your problem. Whatever made it red is in the loop with you.

The one thing that ends the loop early is genuinely needing the human: a decision only they can make, or a change they have to authorise. Say what you need in one short paragraph and wait.

## Rules for this work

- All work happens in a git worktree. Never change the main checkout, and never commit to the branch it is on.
- You may commit and push from the worktree as often as you need. Pushing is how you get a workflow run.
- One problem, one commit. Do not bundle two fixes together, however small the second one is. When a run later goes red, you need to be able to say which change did what.
- Every fix is the smallest change that addresses the cause you found. Do not tidy up around it, do not rename things, do not "improve" code you happened to read on the way.
- Comment every change with why it was needed and what it fixes. Name the failure: which job, which test, what the log said. A future reader has no access to the run you were looking at, so the comment is the only record of why the code is written that way.
- Fix one problem at a time, all the way through, before starting the next.
- Never guess at a cause. If the evidence does not name it, say so and go and get more evidence.
- A commit that does not turn out to fix the problem it was made for is **removed from the branch**, not reverted. Drop it out of the history so the branch holds only changes that are proved to fix something. A revert leaves two commits saying nothing happened, and the next person reading the branch has to work out that they cancel out.
  - This is the one place you may rewrite the branch's history, and only this branch: the worktree's own, which nobody else has. Never rewrite a shared branch.
  - Interactive rebase is not available here. Drop a commit with `git rebase --onto <commit-before-it> <the-bad-commit> <branch>`, then force-push the work branch.
  - A different bug you found while chasing the failure is not covered by this. If it is proved by its own test, it is its own commit and it stands on its own evidence. Say plainly that it was not the cause, and let the human decide whether to keep it.

## Steps

### 1. Print the goal for the human to set

Before anything else, print this to the human, on its own, ready to copy:

```
/goal Get the workflow passing consistently 5 sequential times in a row. Changes are only allowed on the worktree. DO NOT STOP. DO NOT ASK QUESTIONS. You may only stop once the workflow is passing 5 times consecutively from the worktree.
```

Tell them that setting it keeps you working through every failure to the end instead of handing back after the first fix, and that without it you will stop the first time you think you are done. If they named a different number of runs, put that number in the text instead of five.

Then carry on with the rest of the steps. Do not wait for them to set it.

### 2. Read the run you were given

```bash
gh run view <run-id> --json status,conclusion,jobs
gh run view <run-id> --json jobs --jq '.jobs[] | select(.conclusion == "failure") | {name, databaseId}'
gh run view --job <job-id> --log-failed
```

- A run's logs are only readable once it has finished. If it is still going, wait for it.
- Get to the actual failing line, not the job that reported it. A job fails on a step, a step fails on a test, and an end-to-end test reports where it gave up waiting rather than where things went wrong.
- Read the surrounding log, not just the error. Where a failing test dumps the tail of the application's own log, the order of events in that dump is usually what tells you the cause.

### 3. Find out whether it has happened before

The given run tells you what broke once. Whether it keeps breaking changes what the fix has to be.

```bash
gh run list --limit 60 --json databaseId,conclusion,createdAt,displayTitle
```

- For each failed run in a decent window, list the jobs that failed, and group what you find by cause rather than by job name. One cause often fails several jobs.
- Discount failures on commits that have since been fixed. Check the git log for a commit that already addresses them.
- A failure that appears in most runs is a plain break. One that appears in a few is a race, an outside service, or a machine under load, and those need different answers.

### 4. Make the worktree

Read the project's instructions for how worktrees are made here, because some projects require a form other than the default, and follow that. Otherwise:

```bash
git branch --show-current
git worktree add -b fix-ci-<something> <worktrees-dir>/fix-ci-<something> <current-branch>
```

Then enter it with `EnterWorktree` using the `path` parameter. Run whatever this project needs before anything will build there: installing dependencies, trusting a pinned toolchain, generating code. Find those steps in the project's setup docs rather than assuming.

### 5. Take one failure and find its cause

For each cause on your list, in order of how often it fails:

- Read the whole failing test and the code it drives.
- Reproduce it locally if you can. Running the suite locally is cheap compared to a workflow run.
- If reading does not tell you, instrument. Add temporary logging to the application or the test, run it, read the log, and take the instrumentation out again. This is faster and more honest than a theory.
- Sort the cause into one of these, because they need different answers:
  - A product bug. The application is wrong and the test is right. Fix the application.
  - A test bug. The test waits for something that is not guaranteed, or drives the application while it is still busy. Fix the test.
  - An outside service. A package feed returned 503, a runner image changed. There is nothing here to fix; make the retry survive it, or remove the dependency.
  - Your own machine. See the note on load below.

Two things to watch for, because both hide the real cause:

- Code that returns an empty value instead of failing. A reader that cannot read what it was asked for and answers "" makes every wait on it time out saying the field was empty when it was not.
- Code that catches an error, logs it, and carries on. The work did not happen, the caller was told it did, and the only trace is a log line nobody reads.

### 6. Fix it, minimally

- Fix the cause, not the symptom. A wait added to dodge a race leaves the race in the product for a user to hit.
- If you cannot fix the cause because it is upstream (a compiler crash, a package feed), say so plainly to the human in that message, and work around it in the smallest way that does not hide anything. A retry that only retries the crash, and still fails an ordinary failure on the first attempt, is a workaround worth having.
- Every function you add or change needs a unit test, following whatever this project's instructions say about what is and is not unit tested.
- Watch the new test fail first. Break the fix, run the test, see it go red, put the fix back. A test that has only ever passed has not been shown to test anything.
- Run the project's full test command before committing. If a pre-commit hook runs it anyway, a failure here just saves you the round trip.

### 7. Commit and push

- One commit per problem, with a message that explains the failure, the cause, and the fix.
- Push. Each push starts a run.

### 8. Get the consecutive green runs

A full workflow run is usually long, so this is mostly waiting. Automate it rather than watching:

- Write a small script in the project's `tmp/` directory that waits for a run to finish, starts the next one with `gh workflow run <workflow-file> --ref <branch>` when it passes, and stops at the first failure naming the jobs that failed.
- Run it with the `Monitor` tool so each outcome arrives as a notification and you can work in between.
- Any failure restarts the count, whatever caused it. So does any new commit, because the runs have to be of the same code.

### 9. When a run goes red again, go round again

This is the loop, and most of the work happens on the second and third time round it. The first failure you fix is rarely the last one in the workflow.

- Read the failure before touching anything. It is usually a different cause from the last one, and fixing what you fixed last time harder will not help.
- If the evidence is not there (the logs were truncated, the job timed out and the CI kept nothing), your next fix is to make it readable: keep the log the test overwrote, upload the test logs as an artifact on failure. Diagnostics are worth a run.
- Go back to step 4 with the new cause, fix it, push, and start counting again from zero.
- Repeat until the workflow has passed the required number of times in a row. Report only then.

## Things that will waste your time if you do not know them

- Check the machine load before believing a local failure. `uptime` and `free -g`. If the human runs several suites at once, a load average several times the core count makes an application fail to start inside its timeout. That is not an intermittent test and fixing it is not your job.
- Do not build or commit while a local test loop is running. A pre-commit hook that rebuilds the application's bundled assets will pull them out from under a run that is mid-launch.
- Do not edit a shell script while a loop is executing it. Bash reads the file as it goes. Stop the loop, edit, restart.
- A helper that waits for a line in a log usually tracks a cursor, so it only sees lines written after the previous match. A wait for an event that already happened never returns. Put such a wait where the event is guaranteed to be still ahead of the cursor, which usually means right after the thing that causes it.
- A test harness that truncates the application's log on start destroys the previous instance's log, and with it any error that explains the failure. Check for this before concluding a restart left no trace.
- A job that hits its own timeout is hard-killed and the CI often keeps no log for it at all. A step that hits a step timeout fails normally and its log survives. So cap the long steps, not just the job.

## Finish

- Tell the human how many consecutive green runs you got and on which commit.
- List each fix in one line: what failed, and what you changed.
- Say plainly which failures you could not explain, and what you did about them. A bug you found while looking for a cause is not the same as the cause, and must not be reported as one.
