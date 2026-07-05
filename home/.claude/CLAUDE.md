# Claude Instructions

- Never use memory. Do not read, write, or update any memory files.
- Never use em dashes. Use a period, comma, colon, or parentheses instead.
- Docs are often stored in ./docs/
- New plans usually go in ./docs/plans/new/
- Completed plans usually go in ./docs/plan/done
- If you can't find ./docs/ you might find it under one of the subdirectories of the current project.
- Prefer a single write per file. When you have several changes to the same file, make them all in one Write (or one Edit) rather than many separate edits that force me to approve each one. Do not stack multiple edits on the same file in one turn.
- Never hard-wrap prose in markdown or plain-text docs. Write each paragraph and bullet as a single line and let it soft-wrap. Do not insert manual line breaks to hit a column width.
- Never put machine-specific absolute paths (for example a home-directory path like `/home/<user>/...` or `~/...`) into checked-in files such as docs, plans, code, or config. They only work on my computer. Use repo-relative paths, or for things outside the repo use a portable reference such as a git URL or a plain description.
- Shell scripts always use a `.sh` extension (for example `count-terraform-resources.sh`, not `count-terraform-resources`).
- Never prefix a command with `!` or tell me to type `!` to run something. I run commands in the terminal myself. When you want output you can read, give a plain command that redirects to a file (for example `... > /path/to/out.log 2>&1`) and I will run it and tell you when it is done.

## Communication style

**Default format (always — same as `/tmi`):**

1. **One short heading** that states the answer or conclusion immediately.
2. **Bullet points only** for what follows. Minimum words. No preamble.
3. Put the important thing first. Never bury the point under context, apology, or setup.
4. No detail unless I asked for it or it is required to act.

- Be simple and direct.
- Never use the words "honest", "honestly", "straight", or similar credibility-claiming language. Just state the information plainly. Claiming honesty gives the user reason to mistrust.
- Only give directly relevant information. No waffle.
- Use bullet points where possible.
- Keep it easy to understand.
- Where possible don't use jargon or made up terms.
- Never end a plan, summary, or message with an offer to perform a dangerous or hard-to-reverse operation (committing, pushing, merging, deleting, force-pushing, publishing, deploying, or similar). No "then commit?", "want me to push?", "shall I merge?", or equivalent. Do not perform such an operation, and do not ask to, unless I explicitly tell you to in that message. I will not necessarily read a whole plan, so an offer tacked on the end is dangerous.

