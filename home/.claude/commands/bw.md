You have used a banned word. Find it, fix it, and check whether you used it anywhere else.

The banned words and the reasons for them are in `CLAUDE.md`. Read the list there rather than working from memory: it changes, and it covers more than single words. The credibility words ("honest", "frankly", "plainly", "actually", "clearly" and the rest), "shape", the "gate" family, em dashes, the meaningless excuse words ("habit", "instinct", "just"), horizontal rules, hard-wrapped prose, Jira keys in code, and machine-specific absolute paths are all the same class of problem and all in scope here.

**What matters is permanent text.** A banned word in the terminal is noise. A banned word in a commit message, a document, a code comment, a Jira ticket, a pull request body, a config file or a slash command is going to be read by someone who was not here, possibly for years. Fix that first and care about it most.

**Step 1: Find it**

If the human named the word, take that. If they did not, work out which one it is yourself from what you most recently wrote. Do not ask them which word unless you genuinely cannot tell.

Then look wider than the one place they noticed. If you used it once you have probably used it several times, so search everything you wrote or edited in this conversation: the working repo, any other repo you touched, notes, slash commands, and any ticket or pull request you created or edited.

**Step 2: Separate your writing from theirs**

Fix what you wrote. Leave alone what was already there before this conversation, and text the human wrote themselves, including in their own notes. If a pre-existing use is in a file you are editing anyway and it looks like it should go, say so and let them decide rather than changing it.

**Step 3: Fix it properly**

Delete the framing and say what you meant. Do not swap one banned word for another, and do not reach for a synonym that does the same job: "candidly" for "honestly" is not a fix, and neither is "in truth". If the sentence still advertises the reliability of what follows, the word was not the problem, the sentence was.

Re-read the replacement against the list before you finish.

**Step 4: Where it cannot be edited**

- **Working tree, uncommitted:** fix it.
- **Committed but not pushed, or pushed:** the text is in history. Do not rewrite history to fix wording. Fix any copy still in the working tree, and say plainly that the commit message keeps the wording.
- **A Jira ticket, a pull request body or anything else with an edit API:** edit it.
- **Something already sent that cannot be edited:** say so and stop. Do not send a correction message about a word.

**Step 5: Report in two lines**

Where it was, and what you changed it to. If it survives in a commit message, say that. No apology, no explanation of why you wrote it, no account of the rule. Fix it and move on.
