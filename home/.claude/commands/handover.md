Wrap up what you are working on and leave it ready for another agent to pick up.

This is a courtesy, not a report. Do not write a summary for the human, and do not run anything, check anything or gather anything for the purpose of telling them what you did. Everything you write here is for the next agent.

Assume the next agent starts with none of this conversation. Whatever matters and exists only in your head right now is what to write down.

**Step 1: Stop starting things**

Finish only what would be left broken or misleading if you stopped mid-way: an edit that leaves a file inconsistent, a half-renamed symbol, a test you changed but did not run. Do not begin new work, do not fix things you happened to notice, and do not tidy anything.

**Step 2: Write the notes where the next agent will look**

Prefer a document that already exists over a new one:

- **A plan with step files.** Put what was achieved and what is next in the step file's Summary, in the same voice as the rest of it. Do not tick a checklist item that is not actually done. If a step is part done, say which parts and which are outstanding.
- **A plan or design document with no step files.** Add or update a short section near the work it describes.
- **A runbook, a runsheet, or a document that records a baseline or a position.** Update it if the work moved that position, so it is not left claiming something untrue.
- **Nothing suitable exists.** Write one file under `docs/`, named for the work rather than for the handover, and say at the top that it is a working note rather than a finished document.

**Step 3: Cover what only you know**

The code and the diff speak for themselves. These do not, so write them down:

- **Decisions and why.** Especially where you considered another option and rejected it, and where the human overruled something. A later agent that does not know a decision was made will make it again, differently.
- **Anything deliberately not done.** Deferred, out of scope, or blocked, and what it is waiting on. Say who decided, if it was the human.
- **Traps.** Something that looks like a defect but is correct, something that will fail for a reason other than the obvious one, a check that reports a change on purpose. This is the most valuable thing you can leave.
- **Anything you inferred rather than confirmed.** A value read out of code rather than seen at runtime, an assumption a later step will test.
- **Where the work stands mechanically.** Which repos have uncommitted or unpushed changes, which branch each is on, what was left staged, what is running elsewhere and waiting on a result.

**Step 4: Leave the working tree explained**

Do not commit, push, merge or delete anything unless the human has told you to in this conversation. Uncommitted work is fine to hand over; unexplained uncommitted work is not, so make sure your notes say what it is.

Remove throwaway files you created that no longer serve anything. Keep anything the next agent needs, and say in the notes what it is for.

**Step 5: Say you are done, briefly**

One or two lines: where you wrote the notes, and the single most important thing the next agent should know. Nothing else. The notes are the handover, not this message.
