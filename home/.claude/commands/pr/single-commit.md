Create a pull request from the **single commit** on the current branch.

## Preconditions

1. Determine the base branch (usually `main` or `master` from `origin`). Count commits on the current branch that are not on the base: `git rev-list --count <base>..HEAD`.
2. If that count is **not exactly 1**, stop. Tell the user this branch has multiple commits (or none) and they should use `/pr:multi-commit` instead. Do not create a PR.
3. If the working tree has unpushed commits, push the branch with `git push -u origin HEAD` (create upstream if needed). Do not force-push.

## Title and body

1. Read the single commit with `git log -1 --format='%s%n%n%b'`.
2. **PR title** = that commit's subject line, unchanged, except for the Jira prefix rule below.
3. **PR body** = that commit's body only (everything after the subject). If the body is empty, use an empty body. Do not invent text.
4. **Do not** use any other PR template. Do not add Summary, Test plan, checklists, or any other elaboration. Do not rewrite or expand the commit message.

## Jira ticket prefix

If the commits or branch relate to a Jira ticket (branch name, commit subject/body, or clear conversation context), prefix the PR title with the ticket key and a colon, for example `PROJ-1234: Fixed the flaky login retry`.

- Detect keys like `PROJ-1234` (uppercase project key, hyphen, digits).
- If the subject already starts with that ticket prefix, do not duplicate it.
- Prefer the ticket from the branch name when present; otherwise from the commit; otherwise from conversation context.

## Create and open

1. Create the PR with `gh pr create --title "..." --body "..."` (HEREDOC for the body). Base branch as appropriate.
2. Open the PR URL in a **new Chrome window**: `google-chrome --new-window <pr-url>`
3. Report the PR URL when done.
