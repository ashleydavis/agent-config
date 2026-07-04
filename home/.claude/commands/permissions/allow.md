---
description: Allow the command in a highlighted audit-log or pending-approval snippet by adding allow rules.
---

Allow the command (or sub-commands) in a highlighted snippet from an audit log or a pending permissions approval file, by adding allow rules to the permissions config. This is the quick path: configure without the full back-and-forth of `/permissions:review`.

Follow the workflow in [REVIEWING-DECISIONS.md](~/claude-permissions/docs/REVIEWING-DECISIONS.md). It links onward to every doc you need (reading the snippet, the safety rubric, and how to write rules). Do not rely on memory for any of that detail: read the docs, since they change.

1. Get the snippet from the selection or the user's message. If there is none, ask the user to paste it or point you at the file.
2. Identify the sub-commands that are currently denied, asked, or NOMATCH (the ones that stopped the command running). These are what you will allow.
3. Classify each with the safety rubric (step 4 of the workflow). If any falls in the **Dangerous** class, do not silently allow it: warn the user with the concrete risk and ask them to confirm before writing an allow rule. Safe/routine sub-commands can be allowed without a prompt.
4. Apply an allow rule for each (step 5 of the workflow), scoped as tightly as is reasonable, in the right file under `~/claude-config/home/.claude/permissions.d/` (see its [README](~/claude-config/home/.claude/permissions.d/README.md) for the existing file layout).
5. Finish up (step 6): report what changed and remind the user to run `/reload-plugins`.

Note: a `deny` rule in any file beats an allow. If a sub-command stays blocked, an existing deny rule is the cause: identify it for the user rather than adding more allow rules.
