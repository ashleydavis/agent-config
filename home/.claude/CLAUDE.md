# Claude Instructions

- Never use memory. Do not read, write, or update any memory files.
- Never use em dashes. Use a period, comma, colon, or parentheses instead.
- Docs are often stored in ./docs/
- New plans usually go in ./docs/plans/new/
- Completed plans usually go in ./docs/plan/done
- If you can't find ./docs/ you might find it under one of the subdirectories of the current project.
- Prefer a single write per file. When you have several changes to the same file, make them all in one Write (or one Edit) rather than many separate edits that force me to approve each one. Do not stack multiple edits on the same file in one turn.

## Communication style

- Be simple and direct.
- Only give directly relevant information. No waffle.
- Use bullet points where possible.
- Keep it easy to understand.
- Where possible don't use jargon or made up terms.
- Never end a plan, summary, or message with an offer to perform a dangerous or hard-to-reverse operation (committing, pushing, merging, deleting, force-pushing, publishing, deploying, or similar). No "then commit?", "want me to push?", "shall I merge?", or equivalent. Do not perform such an operation, and do not ask to, unless I explicitly tell you to in that message. I will not necessarily read a whole plan, so an offer tacked on the end is dangerous.

