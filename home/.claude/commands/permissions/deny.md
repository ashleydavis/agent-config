---
description: Deny the command in a highlighted audit-log or pending-approval snippet by adding deny rules.
---

Deny the command (or sub-commands) in a highlighted snippet from an audit log or a pending permissions approval file, by adding deny rules to the permissions config. This is the quick path: configure without the full back-and-forth of `/permissions:check`.

Follow the workflow in [REVIEWING-DECISIONS.md](/home/ash/claude-permissions/docs/REVIEWING-DECISIONS.md). It links onward to every doc you need (reading the snippet and how to write rules). Do not rely on memory for any of that detail: read the docs, since they change.

1. Get the snippet from the selection or the user's message. If there is none, ask the user to paste it or point you at the file.
2. Identify the offending sub-command(s). By default deny only the specific sub-command(s) that prompted this, not the whole command line. If it is ambiguous which one the user means, ask.
3. Apply a deny rule (with a short `reason:`) for each (step 5 of the workflow) in the right file under `/home/ash/claude-config/home/.claude/permissions.d/` (see its [README](/home/ash/claude-config/home/.claude/permissions.d/README.md) for the existing file layout). A `deny` in any file wins over every allow, so just add the deny: do not remove existing allow rules.
4. Finish up (step 6): report what changed and remind the user to run `/reload-plugins`.
