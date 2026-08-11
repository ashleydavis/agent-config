Draft a Jira ticket comment summarizing recent work, show it for approval, then post only if the human approves.

## Steps

1. **Resolve the ticket.** Prefer a ticket key or URL from the conversation, branch name, workspace path, or recent commits (e.g. `PROJ-123`). If it is not obvious, ask the human for a Jira link or key and stop until they provide one.

2. **Gather what was done.** Prefer conversation context. If that is thin, inspect the ticket workspace and related repos/sub-repos (commits, open PRs, local docs) and summarize from that evidence. Do not invent work.

   When drafting, omit secrets, credentials, internal hostnames, account IDs, and other sensitive or org-specific details that do not belong in a ticket comment.

3. **Draft the comment.** Write a concise Jira-ready update in markdown: what changed, why it matters for the ticket, and links to PRs / docs when available. Show the full draft to the human. Do **not** post yet.

4. **Wait for approval.** Ask the human to reply `a` (approve) or `d` (deny).
   - **`a`:** Post the approved comment with Atlassian MCP `addCommentToJiraIssue` (`contentFormat: "markdown"`). Resolve `cloudId` via `getAccessibleAtlassianResources` if needed. Report the issue key and that the comment was posted.
   - **`d`:** Stop. Do not post. Say we are not ready to comment yet.
   - Anything else: ask again for `a` or `d`; do not post.

## Hard stops

- Never post a comment without an explicit `a` in this turn sequence.
- Never invent a ticket key.
- If the human revises the draft, show the updated draft and wait for `a` / `d` again.
