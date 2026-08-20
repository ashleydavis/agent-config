Create a Jira issue from a local ticket draft file.

This is the second half of `/ticket:draft`. It publishes what that produced. It does not write or improve the draft.

**Invoking this command is the approval.** The human has read the draft and asked for it to go on Jira, so do not ask them to confirm again. Print the payload, then create it. The only reasons to stop are the ones listed below, where the answer is genuinely not in the draft.

## Steps

1. **Find the draft.** Prefer the one produced or discussed in this conversation. Otherwise look in the current ticket working directory for a `*-ticket-draft.md`. If several match, list them and ask which one. Never guess.

2. **Read it in full**, including the Notes section. Anything still marked TBC is a blocker: list every one and ask the human to resolve them before going further. Do not fill them in yourself.

3. **Resolve the target.** Get the `cloudId` (try the site hostname first, fall back to `getAccessibleAtlassianResources`). Confirm the project key and issue type from the draft's Fields section, then call `getJiraProjectIssueTypesMetadata` to confirm that issue type exists in that project.

4. **Map every field.** Call `getJiraIssueTypeMetaWithFields` with `requiredFieldsOnly: false` for that project and issue type. The response is large, so grep the saved tool output rather than reading it whole. Then:

   - Confirm every field the metadata marks required has a value in the draft. If one does not, stop and ask.
   - Match each Fields entry and each dedicated section in the draft to a real field id. Acceptance Criteria and Story Points are usually custom fields, not description text. If the draft names a `customfield_*` id, check it against the metadata rather than trusting it.
   - Anything without its own parameter on `createJiraIssue` goes in `additional_fields`, keyed by field id or name: priority, labels, components, story points, and every custom field.
   - Resolve the assignee with `lookupJiraAccountId` and use the account id. If the search returns more than one person, show the matches and ask which.

5. **Build the description.** Take the draft's body sections in order, and **remove**:

   - the Fields section, it is metadata and now lives in real fields,
   - the Acceptance criteria section, if it is going in its own field,
   - the "Notes for me, not for the ticket" section, always,
   - any remaining TBC markers or internal asides.

   Keep every URL as `[label](url)`. Send it with `contentFormat: "markdown"`.

6. **Create it.** Do not print the payload first. The human has read the draft and asked for it to be published, so reprinting it back at them is noise. Call `createJiraIssue`, then create any links the Related work section calls for, using `getIssueLinkTypes` first if the link type is not obvious, and set the parent epic if the draft names one. Report the issue key and its browse URL, nothing more.

   A custom field declared as a plain text area may still be rejected unless it is sent as Atlassian Document Format. If the create fails with "not valid Atlassian Document Format (ADF) content", resend that field as an ADF document object rather than a string. Do not drop the field to make the call succeed.

7. **Open it in Chrome.** Run `google-chrome --new-window <browse url>` so the human can check the created issue straight away. The fields that were mapped by id are worth seeing rendered, and a mistake is far easier to fix in the first minute than later.

8. **Record it.** Add the created issue key and URL to the top of the draft file so the local file and the Jira issue stay connected.

## When to stop and ask

Only when the answer is not in the draft and picking one would be a guess:

- The draft still contains a TBC.
- A required field has no value in the draft.
- More than one draft file matches, or the assignee lookup returns more than one person.
- A field value in the draft is not valid for that project, for example a priority name the project does not have. Say what the valid values are and let the human choose.

Everything else proceeds without asking.

## Hard stops

- Never publish a draft that still contains TBC, or the "Notes for me" section, or anything from it.
- Never invent a field value, an account id, an epic or a link. Look it up or ask.
- Never guess a `customfield_*` id from memory. Read it from the issue type metadata for that project.
- Never post bare or backtick-wrapped URLs. Always `[label](url)`.
