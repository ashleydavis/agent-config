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

Only if a single Jira ticket key is **obvious** (for example the branch is clearly named with it, the commit already carries it, or the user stated it in this conversation), prefix the PR title with that key and a colon, for example `PROJ-1234: Fixed the flaky login retry`.

- Detect keys like `PROJ-1234` (uppercase project key, hyphen, digits).
- If the subject already starts with that ticket prefix, do not duplicate it.
- **Do not infer, guess, or pick among candidates.** If the ticket is unclear, missing, or there are multiple plausible keys, omit the prefix.

## Create and open

1. Create the PR with `gh pr create --title "..." --body "..."` (HEREDOC for the body). Base branch as appropriate.
2. Open the PR URL in a **new Chrome window**: `google-chrome --new-window <pr-url>`
3. Report the PR URL when done.
