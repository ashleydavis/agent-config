Post a drafted comment to its Jira ticket, then open the ticket in Chrome.

`/ticket:comment:draft` writes the draft for review. Running this command is the approval to post — do not ask for a second `a`/`d` confirmation.

## Steps

1. **Find the draft.** Prefer the one produced or discussed in this conversation. Otherwise look in `docs/tickets/` for a `*-comment.md` whose header says `Status: draft`. If several match, list them and ask which one. Never guess.

2. **Read it in full.** Take the ticket key from the header block. If the header is missing or the key is not there, ask rather than inferring one from the filename.

3. **Check it before it goes out.** The comment is outward facing and other people will read it. Confirm there are no secrets, credentials, internal hostnames, account ids or personal details in the body, and that every URL is in `[label](url)` form. If anything is wrong, stop, say what, and let the human fix the draft. Do not post until they fix it and re-run this command.

4. **Post.** Post with Atlassian MCP `addCommentToJiraIssue` and `contentFormat: "markdown"`. Resolve `cloudId` via `getAccessibleAtlassianResources` if needed. Use the body below the header block exactly as written.

5. **Open the ticket in Chrome.** Run `google-chrome --new-window <ticket url>` so the human can see the posted comment rendered. Jira markdown does not always render the way the draft reads, and a broken link or a mangled code block is worth catching immediately.

6. **Record it.** Change the draft's header to `Status: published`, and add the date and a link to the comment. The local file is the record of what was said, so it should not still claim to be unposted.

## Hard stops

- Never post a comment containing secrets, credentials, internal hostnames, account ids or personal details.
- Never post bare or backtick-wrapped URLs. Always `[label](url)`.
- Never ask for a second approval (`a`/`d` or similar) after this command is invoked — drafting was the review step; publishing is the approval.
- A posted comment is visible to everyone on the ticket and its edit history keeps the original. Treat posting as final.
