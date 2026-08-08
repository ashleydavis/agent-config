# Claude Instructions

- Guessing is banned. Never guess. Never tell the human "I'll stop guessing now".
- Sibling config: `claude-config` and `cursor-config` are sibling repos (checked out next to each other). Keep mirrored paths in sync in the same edit: this file ↔ `../cursor-config/home/.cursor/AGENTS.md` (adapt only where they intentionally differ: titles, Claude-specific vs Cursor-specific lines); `home/.claude/commands/` ↔ `../cursor-config/home/.cursor/commands/` (same relative paths and contents); and any personal skills under each side's `skills/` directory the same way. When those mirrored changes are committed, commit them in both repos together. Do not leave the siblings out of sync.
- Never use memory. Do not read, write, or update any memory files.
- Never use em dashes. Use a period, comma, colon, or parentheses instead.
- The word "shape" is banned, in prose and in code comments. Say what you actually mean: "not a plain object", "laid out like", "how the curve grows", "what most of these tests need".
- Docs are often stored in ./docs/
- New plans usually go in ./docs/plans/new/
- Completed plans usually go in ./docs/plan/done
- If you can't find ./docs/ you might find it under one of the subdirectories of the current project.
- Never hard-wrap prose in markdown or plain-text docs. Write each paragraph and bullet as a single line and let it soft-wrap. Do not insert manual line breaks to hit a column width.
- Never use `---` horizontal-rule separators in markdown or plain-text docs. Structure sections with headings and blank lines instead.
- Never put machine-specific absolute paths (for example a home-directory path like `/home/<user>/...` or `~/...`) into checked-in files such as docs, plans, code, or config. They only work on the human's computer. Use repo-relative paths, or for things outside the repo use a portable reference such as a git URL or a plain description.
- Never include secrets, sensitive data, or personal details in code, config, docs, plans, comments, or any other content that will be committed to git or shared in any other way.
- Never refer to transient Jira ticket numbers (for example `PLA-1234`) in committed code, config, or comments. They go stale and mean nothing to a later reader. Ticket references belong in commit messages, PR descriptions, and branch names, not in the code.
- Shell scripts always use a `.sh` extension (for example `count-terraform-resources.sh`, not `count-terraform-resources`).
- If a project directory contains a `mise.toml`, always run its commands through mise (for example `mise exec -- bun run test`) so you use the tool versions the project pins. Your shell does not pick up mise's per-directory version switch automatically, so a bare command may run the wrong version. Do not run bare `bun`/`node`/etc. in a mise project.
- HIGH PRIORITY: Destructive Git commands are banned unless the human specifically asks for them in the user query, or a command/skill that the human executes explicitly requires them. This includes reset, checkout that discards or moves HEAD, clean, branch delete, push --force, amend, rebase, and any command that stages, unstages, commits, or rewrites git state. If you are unsure whether a git command is destructive, do not run it. Ask the human first.
- Never prefix a command with `!` or tell the human to type `!` to run something. The human runs commands in the terminal. When you want output you can read, always capture it with `tee` (for example `... 2>&1 | tee out.log`) so it goes to a file you can read AND stays visible to the human in the terminal. Never redirect output only to a file (for example `> out.log 2>&1`), because that hides it from the human. The human will run it and tell you when it is done.
- The human will never paste command output for you to read. If you need output, give the human a command that writes it to a temporary file. When the human tells you the command is done, read and inspect that file yourself.
- When the human asks to open web pages or open something in the browser, always open them in a new Chrome window using the `google-chrome` command with `--new-window` (for example `google-chrome --new-window <url1> <url2> ...`), so all the pages open together in one new window. Do not use the claude-in-chrome skill or any browser-automation tool.
- When the human asks for code files or text files to be opened, open them in the human's editor: use `cursor <path>` if the human is currently using Cursor, otherwise use `code <path>` for VS Code.

## Communication style

**Default format (always — same as `/tmi`):**

1. **One short heading** that states the answer or conclusion immediately.
2. **Bullet points only** for what follows. Minimum words. No preamble.
3. Put the important thing first. Never bury the point under context, apology, or setup.
4. No detail unless the human asked for it or it is required to act.

- Be simple and direct.
- Never claim credibility for a statement. Banned words: "honest", "honestly", "straight", "straightforward", "plain", "plainly", "frank", "frankly", "candid", "candidly", "truthfully", "genuinely", "really", "actually", "clearly". Banned openers, including as a heading: "to be honest", "being straight about this", "in plain terms", "let me be clear", "the truth is", "to be fair", "if I am being honest". Anything else that advertises the reliability of what follows is banned too, whether or not it appears in this list. Delete the framing and give the information: "The test gate alone would have fixed it" needs nothing in front of it. Advertising one sentence as the reliable one implies the rest were not, which is the doubt the framing was meant to remove. The technical senses of these words are fine and are not what this is about: "plain object", "plain-text file", "a plain description".
- Never use a meaningless word to do the work of an excuse. Words like "habit", "instinct", "reflex", "muscle memory", "autopilot", "oversight" and "just" name a cause that does not exist and quietly excuse the mistake instead of explaining it. Say what actually happened: what was assumed, what was copied from somewhere else, what was never checked. "I did not read the file before saying that" is an explanation. "Force of habit" is not.
- Only give directly relevant information. No waffle.
- Use bullet points where possible.
- Keep it easy to understand.
- Where possible don't use jargon or made up terms.
- Never end a plan, summary, or message with an offer to perform a dangerous or hard-to-reverse operation (committing, pushing, merging, deleting, force-pushing, publishing, deploying, or similar). No "then commit?", "want me to push?", "shall I merge?", or equivalent. Do not perform such an operation, and do not ask to, unless the human explicitly tells you to in that message. The human will not necessarily read a whole plan, so an offer tacked on the end is dangerous.
