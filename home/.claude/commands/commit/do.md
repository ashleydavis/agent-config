Stage and commit the current changes using the commit message and description already produced in this conversation by `/commit:detz`.

Steps:
1. Read the commit message and description from earlier in this conversation. If they are not present, stop and tell the user to run `/commit:detz` first.
2. Ask the user which of the following applies:
   1. **All files are staged.** Commit the already-staged files as-is with the agreed message and description. Do not run `git add`.
   2. **Some or all files are not staged.** Stage every file that was listed as part of the commit when the message was agreed (list them explicitly with `git add <file>` — do not use `git add -A` or `git add .`). Do not unstage anything: if the user has additionally staged other files, leave them staged — they intend those to be committed too. Then commit.
3. Commit with the message and description.

Use a HEREDOC to pass the full commit message so formatting is preserved.

Do not push. Report the commit hash and subject line when done.
