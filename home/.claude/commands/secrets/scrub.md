Remove secrets, sensitive data and company-specific details from the current work. Ask before anything that rewrites history or touches something already published.

`/secrets:check` finds them. This command removes them.

## Steps

1. **Know what you are removing.** Use the findings from `/secrets:check` in this conversation if they are there. If not, run that check first at the smallest scope that covers the work, and show what you found. Never scrub from a guess: you will either miss things or mangle code that only looked suspicious.

2. **Rotate before you scrub, if a real credential is involved.** This is the step people skip and it is the only one that actually stops the damage. A key that has been committed or published is compromised, and deleting the line does not un-compromise it. Tell the human which credentials need rotating and let them do it, then scrub. Say plainly that scrubbing without rotating leaves them exposed.

3. **Pick the scope, and be honest about what each one costs.** Cheapest first:

   1. **Uncommitted work.** Edit the files. No git operations needed. Do this now.
   2. **Committed on this branch, not yet pushed.** The content is in history already, so removing it needs the commits rewritten. That is a destructive git operation and needs the human to ask for it explicitly.
   3. **Already pushed.** Same rewrite, plus a force push, plus everyone with a clone has to deal with it. Open PRs on the branch may break.
   4. **Anywhere in the repo history.** A full history rewrite with `git filter-repo` or similar. Every commit hash after the touched commit changes, every clone and fork is stale, and the old objects can survive on the hosting side until support is asked to purge them. Forks keep the data regardless.
   5. **Already published outside the repo.** A Jira comment or ticket, a Confluence page, a PR description, a release note. Editing these leaves the original in the edit or version history, so removing the visible text is usually not enough.

   **Do levels 1 and 2 planning freely, but stop and ask before executing anything at level 2 or above.** For 4 and 5, lay out what the operation will do, what breaks, who has to be told, and what will still be left behind afterwards, then wait for an explicit yes. Do not start a history rewrite because it seemed implied.

4. **Scrub the uncommitted work.** For each finding:

   - **A real secret** comes out of the file entirely and moves to wherever this project keeps them: an environment variable, a secrets manager, an untracked local file. Leave a reference, not the value.
   - **A file that should never have been tracked** gets added to `.gitignore` and untracked. Note that ignoring it does not remove it from history, that is a separate scope.
   - **Sensitive data** is replaced with something obviously fake that keeps the example readable: `user@example.com`, `10.0.0.1`, `123456789012` for an account id.
   - **Company-specific detail** is replaced with a generic placeholder: `some-org/some-repo`, `your-site.atlassian.net`, `PROJ-123`, `Some Person`.

   Keep the surrounding text working. A scrubbed example that no longer makes sense is a different kind of damage.

5. **Handle published artifacts separately, and ask first.** Editing a Jira comment or a Confluence page is outward-facing and visible to other people. Show the human exactly what you would change it to, wait for approval, and tell them the old version stays in the history where they or an admin may need to remove it. Never edit a published artifact silently.

6. **Verify.** Re-run the check over the same scope and confirm each finding is gone. Then confirm you have not broken anything: the project still builds, the tests still pass, the docs still read correctly. Report both results.

7. **Report what is left.** Say what was scrubbed, what still needs doing by a human (rotations, admin deletion of page history, telling the team to re-clone), and which scopes you did not touch. Say all of this to the human in conversation, not in the commit message.

## Hard stops

- Never run a destructive git command without the human explicitly asking for it in this conversation. That covers rebase, amend, reset, filter-repo, force push, and anything else that rewrites or discards history.
- Never start a history rewrite or a force push without the human seeing the plan and saying yes to it.
- Never edit or delete a published Jira comment, ticket, Confluence page or PR description without explicit approval of the exact replacement text.
- Never treat scrubbing as a substitute for rotating a credential. Say so every time.
- Never print a full secret value anywhere, including in the commit message that removes it. The commit message is public too.
- Never advertise the scrub. A commit message, PR title or changelog entry saying that a secret or a company detail was removed is a signpost: it tells a reader there is something worth finding and roughly where to look, and it is published alongside the history that still contains it. Describe the change neutrally instead, by what the code or text now does, and keep the reason for it out of anything that ships. Say the real reason to the human, in conversation.
- Never claim the secret is gone when it has only been removed from the working tree, or only from HEAD. Say exactly which scope is clean.
