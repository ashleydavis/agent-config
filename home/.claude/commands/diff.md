Show me the diff of all your changes.

I am often reading this on a mobile device where tool output does not render. Only the text of your reply reaches me. So: run the git command, read its output, and then WRITE THE DIFF OUT IN YOUR REPLY as fenced ```diff code blocks. Running the command is not showing me the diff. Printing it to the terminal is not showing me the diff. Pasting it into your reply is the only thing that counts.

Use `git diff HEAD` so I get staged and unstaged changes together. Never use bare `git diff`: it hides anything you have staged, and I will see nothing. Include untracked files you created too (`git status --porcelain`, then show their contents).

Cover every repository you have touched, not just the current one, with a heading per repo when there is more than one.

Do not:

- summarise the diff, describe it, or explain what it does
- tell me which command to run myself
- write it to a file, or offer to open it in an editor
- ask which files I want to see
- stop partway and ask if I want the rest

If it is long, truncate the least important hunks and say what you truncated at the end, but show every changed file.

Nothing else in the reply. No preamble, no conclusion, no summary of the work. Just a one-line heading per file and the diff.
