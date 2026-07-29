Create a pull request from **multiple commits** on the current branch.

## Preconditions

1. Determine the base branch (usually `main` or `master` from `origin`). Count commits on the current branch that are not on the base: `git rev-list --count <base>..HEAD`.
2. If that count is **less than 2**, stop. Tell the user this branch does not have multiple commits and they should use `/pr:single-commit` instead (when there is exactly one commit). Do not create a PR.
3. If the working tree has unpushed commits, push the branch with `git push -u origin HEAD` (create upstream if needed). Do not force-push.

## Title and body

1. Read the full commit range with `git log <base>..HEAD --format='%s%n%n%b'` (and `git diff <base>...HEAD` only if the subjects are not enough to summarize).
2. **PR title** = one short plain-English summary of the work across the commits (past tense where natural). Keep it under 72 characters.
3. **PR body** = bullet points only. Brief. Cover what changed and why at a high level. Do not write essays or exhaustive file lists.
4. **Do not** use any other PR template. Do not add Summary, Test plan, checklists, or any other sections or elaboration beyond the title and those bullets.

## Jira ticket prefix

If the commits or branch relate to a Jira ticket (branch name, commit subjects/bodies, or clear conversation context), prefix the PR title with the ticket key and a colon, for example `PROJ-1234: Fixed login retry and cleaned up error handling`.

- Detect keys like `PROJ-1234` (uppercase project key, hyphen, digits).
- If the drafted title already starts with that ticket prefix, do not duplicate it.
- Prefer the ticket from the branch name when present; otherwise from the commits; otherwise from conversation context.

## Create and open

1. Create the PR with `gh pr create --title "..." --body "..."` (HEREDOC for the body). Base branch as appropriate.
2. Open the PR URL in a **new Chrome window**: `google-chrome --new-window <pr-url>`
3. Report the PR URL when done.
