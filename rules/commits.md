# Commit message rules

These rules apply to commit message titles and descriptions. The rules in `writing.md` apply to commit messages too.

The human can explicitly ask to override any of these rules. When they do, follow the request and do not argue against it.

- The subject line says what was done.
- Always write the commit message in the past tense, subject and description alike.
- The commit message description records why you made the change, what its intention was and the justification for it. You can give a summary of what is in the change, but you do not need to detail what changed in the code. The description is for "why" and "what", less for "how". Include what was tried and rejected. Include any measurement with the conditions it was taken under. Never restate the diff in prose.
- A pull request description is no replacement for a commit message: it is not stored in the repository and does not show in `git blame`.

## Template

```text
<TICKET-123: >Past-tense summary of the change

What changed and why. Any decision a later reader could not work out from the diff.
```

## How to use the template

- **Subject line:** one short line in plain English, past tense ("Added", "Fixed", "Removed", "Updated"), under 72 characters, with no full stop at the end. It conveys the intent of the change, not just which files changed. Never start it with a conventional-commits prefix such as `feat:` or `fix:`. Never make it a bare noun phrase such as "Login retry".
- **Ticket prefix:** only when a single Jira ticket key is obvious, for example the branch is named with it or the human stated it. Prefix the subject with the key and a colon: `PROJ-1234: Fixed the flaky login retry`. Do not infer, guess or pick among candidates. When the ticket is unclear, missing or there are several plausible keys, leave the prefix out. Never repeat a prefix the subject already has.
- **Description:** goes in the body, separated from the subject by a blank line. It says what changed and why. It also gives any decision a later reader could not work out from the diff. There is no length target: a one-line change gets a one-line description. A description that says nothing the subject did not is left out entirely. Do not list every file in the commit. Say what was run and read to check the change, such as which tests ran and that their output was checked.
- Never put open todos, future work, open items, decisions still to be made or test plans in a commit message. It records what was done, not what is left.
- Leave out anything restating a file that is in the commit, any explanation of how a tool or format works, background on why the general practice is good or any sentence that would be equally true of some other commit. If a paragraph could be deleted without the reader losing something they needed, delete it.
- Describe the change as it stands in this repository. Never mention another repository, project or directory the work came from. Never say a change was copied, moved, ported or brought in from anywhere. The exception is when the human asks for the other repository to be named.
- Never hard-wrap the description. Write one line per paragraph, with a blank line between paragraphs.
