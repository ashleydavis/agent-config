---
description: Review an automatic permissions decision from an audit-log or pending-approval snippet, explain it, and configure permissions for any gaps.
---

Review a highlighted snippet from an audit log or a pending permissions approval file: explain why it got the decisions it did, advise on any unconfigured sub-commands, and configure permissions based on the user's choices.

Follow the workflow in [REVIEWING-DECISIONS.md](~/expressive-permissions/docs/REVIEWING-DECISIONS.md). It links onward to every doc you need (reading the snippet, the safety rubric, and how to write rules). Do not rely on memory for any of that detail: read the docs, since they change.

This command runs the full workflow interactively:

1. Get the snippet from the selection or the user's message. If there is none, ask the user to paste it or point you at the file.
2. Do steps 1–4 of the workflow: identify the source, explain each decision, find the NOMATCH gaps, and classify each gap with the safety rubric, giving a one-line recommendation per gap.
3. For each gap, ask the user whether to allow, ask, or deny it (use AskUserQuestion; put your recommendation first). If there are no gaps, say so and stop.
4. Apply each choice (step 5 of the workflow) by editing the right file under `~/agent-config/home/.claude/permissions.d/` (see its [README](~/agent-config/home/.claude/permissions.d/README.md) for the existing file layout).
5. Finish up (step 6): report what changed and remind the user to run `/reload-plugins`.

## Next

Recommend the developer run:
- `/permissions:allow`: to allow the command in question.
- `/permissions:deny`: to deny it.
