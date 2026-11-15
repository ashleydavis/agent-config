# Evidence rules

These rules apply whenever the human asks for evidence or proof, and whenever a claim has to be proven: a root cause, a fix, a passing test, a finished step.

The human can explicitly ask to override any of these rules. When they do, follow the request and do not argue against it.

## What evidence is

- Evidence is the recorded output of something that was run and observed: a command's output, a log, a trace, a test run, a screenshot, a measurement. It shows the thing the claim is about, on the code, version and environment the claim is about.
- It records how it was made: the command or steps, the commit, the machine or CI run (with its link), the date, and anything about the environment the result depends on (OS or runner image, tool versions, devices).
- It is the raw output, copied verbatim. An extract is fine when it says where it came from and the full output is kept beside it.
- It is saved where it will last: a file committed or kept in the place the task names (such as `tmp/evidence/` for a plan, `root-cause/` in an experiment worktree). A link to a CI run or a chat message alone is not enough; logs expire and messages scroll away.
- It could have shown the opposite. A check that cannot fail when the claim is false proves nothing.

## What each kind of claim needs

- **A root cause:** an experiment showing both sides: with the cause present the failure happens, and with only the cause taken away (or only the cause added) it does not. Nothing else changes between the two sides.
- **An intermittent failure:** the number of runs that counts as a pass, stated before the runs (such as "10 passes in a row"), and that many runs on each side. One pass proves nothing; one failure is a failure.
- **A fix:** the test or reproduction that failed before the fix, failing on the code before it and passing on the code after it, and the rest of the relevant tests passing after it.
- **"It works" or "it passes":** the run itself, of the code as it now stands, read in this session.
- **A GUI or visible behaviour:** screenshots or recordings of the behaviour, not of the code.
- **A CI-only failure:** a run on CI, or a local run whose environment is shown to match the runner in the respect that matters.

## What is not evidence

- Reasoning, a reading of the code, a plan, an intention, or what "should" happen. These are hypotheses: say "I think" or "I suspect" until an experiment shows it.
- A compile or build that succeeded, offered as proof of behaviour.
- A skipped test, a test that did not run, or a test of something other than the claim.
- A run of different code, an older commit, or a different environment from the one the claim is about.
- A summary, by you or another agent, in place of the output it summarises.
- An extract chosen to hide a failure, a warning or a contradicting line.
- A result remembered from earlier in the conversation, before the code changed.

## Reporting it

- Lead with the evidence, then the claim it supports.
- Say where the full evidence is saved.
- Say plainly what was not checked, and which parts are inference rather than observation.
