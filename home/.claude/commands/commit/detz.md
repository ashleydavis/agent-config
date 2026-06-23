Produce a commit message and description for the current work.

Gather context in priority order, stopping as soon as you have enough to write a good commit message and description:

1. **Conversation context** — if the current conversation clearly describes what was just done, use that and stop here.
2. **Plan file** — if there is a plan file in the working directory (e.g. plan.md, PLAN.md, or similar), read it. If it describes the completed work well enough, use that and stop here.
3. **Git** — as a last resort, run `git diff --cached`, `git diff`, and `git status` to understand what changed.

Then produce two things:

**Commit message** — one short line, plain English, past tense (e.g. "Added", "Fixed", "Removed", "Updated"), no period at the end. Should convey the intent of the change, not just describe what files changed. Keep it under 72 characters.

**Commit description** — a summary of what changed, why, and any notable decisions or trade-offs. Aim for 3 to 5 paragraphs — substantially longer than the title, but not exhaustive. Do not list every file in the commit. This goes in the body of the commit, separated from the subject by a blank line.

Output all three clearly labelled so the user can review them. Do not commit anything — just produce the text.

**Files to be committed** — discover all relevant git repos (the current repo plus any others involved in the work), then for each repo run `git diff --cached --name-only` and `git diff --name-only` to get staged and unstaged tracked changes. Group the results by repo, showing the repo root path as a header and listing each file beneath it on its own line. Skip repos with no changes.

When you are done, tell the user they can run `/commit:do` to have Claude stage and commit the changes using these details.

## Next

Recommend the developer run:
- `/commit:do`: stage and commit using the message and description just produced.
