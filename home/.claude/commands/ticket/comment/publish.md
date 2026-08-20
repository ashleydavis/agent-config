Post a drafted comment to its Jira ticket after approval, then open the ticket in Chrome.

`/ticket:comment:draft` writes the draft. This command posts it.

## Steps

1. **Find the draft.** Prefer the one produced or discussed in this conversation. Otherwise look in `docs/tickets/` for a `*-comment.md` whose header says `Status: draft`. If several match, list them and ask which one. Never guess.

2. **Read it in full.** Take the ticket key from the header block. If the header is missing or the key is not there, ask rather than inferring one from the filename.

3. **Check it before it goes out.** The comment is outward facing and other people will read it. Confirm there are no secrets, credentials, internal hostnames, account ids or personal details in the body, and that every URL is in `[label](url)` form. If anything is wrong, stop, say what, and let the human fix the draft.

4. **Show the exact comment and wait for approval.** Print the ticket key, the ticket URL, and the full body as it will be posted. Ask the human to reply `a` (approve) or `d` (deny).

   - **`a`:** post it with Atlassian MCP `addCommentToJiraIssue` and `contentFormat: "markdown"`. Resolve `cloudId` via `getAccessibleAtlassianResources` if needed.
   - **`d`:** stop. Post nothing. Say what would need to change.
   - Anything else: ask again for `a` or `d`.

5. **Open the ticket in Chrome.** Run `google-chrome --new-window <ticket url>` so the human can see the posted comment rendered. Jira markdown does not always render the way the draft reads, and a broken link or a mangled code block is worth catching immediately.

6. **Record it.** Change the draft's header to `Status: published`, and add the date and a link to the comment. The local file is the record of what was said, so it should not still claim to be unposted.

## Hard stops

- Never post without an explicit `a` in this turn sequence.
- Never post a comment containing secrets, credentials, internal hostnames, account ids or personal details.
- Never post bare or backtick-wrapped URLs. Always `[label](url)`.
- If the human revises the draft after you have shown it, show the whole body again and wait for `a` or `d` again.
- A posted comment is visible to everyone on the ticket and its edit history keeps the original. Treat posting as final.
