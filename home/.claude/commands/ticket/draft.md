Draft a Jira ticket as a local markdown file for review. Research the code first, map the content to the target project's real Jira fields, and create nothing in Jira.

The output of this command is a file, not a Jira issue. `/ticket:publish` is what puts it on Jira.

## Steps

1. **Find out what the ticket is about.** If the human has already described the problem or pasted the material in this conversation, use that and move on. If they have not, ask for it and stop until they answer. Ask for a dump rather than a summary, they can paste far more than they can retype:

   - The Slack thread, incident write-up, bug report or email where this came up, pasted in full, including who said what.
   - The failing thing itself: the error output, the broken rendered config, the failing workflow or CI run, the screenshot.
   - Related tickets, change requests and PRs, whether they fix part of it, caused it, or are just nearby.
   - Which repo or repos this lives in, and where a checkout is if it is not the current directory.
   - Which Jira project the ticket goes in, and the parent epic if there is one.
   - Whether anything has already been done about it, a workaround, a revert, a config change, and who owns that part.

   Do not ask these one at a time. Ask for the lot, take whatever comes back, and only chase the pieces you actually need.

2. **Read the dump, then ask what is missing.** Once you have the material, work out what you still cannot answer: who the ticket should be assigned to, whether this is a bug or a story, how urgent it is, whether the immediate problem is already worked around. Ask those in one go. Anything you can find in the code yourself, find it in the code yourself rather than asking.

3. **Treat all of it as the report, not as the truth.** Note who reported it, who asked for what, and any ticket keys, PR links or change requests mentioned, they become the Related work section.

4. **Verify every technical claim against the source before writing anything.** A pasted report is someone's reading of the code and is often partly wrong or incomplete. Find the relevant checkout (look in sibling ticket directories if the current one is empty), confirm the quoted code really says what the report says, and record the commit hash and date so staleness is visible. If you cannot find the source, say so in the draft rather than repeating the report as fact.

   While you are in there, look for the things a report almost never mentions:

   - **A second implementation of the same thing.** Grep for the function name across the tree. Duplicated resolvers, parsers and helpers drift, and a fix applied to one of them does not stop the bug.
   - **An existing precedent for the fix.** The codebase often already does the right thing somewhere. Point the ticket at it, it makes the fix concrete and consistent.
   - **The neighbouring code paths with the same defect.** If one branch falls through silently, check its siblings.
   - **Which command surfaces the problem to a user**, and whether it could surface it better.

5. **Check the test harness.** Find the unit tests and the smoke tests. Look for an existing fixture convention that new cases can slot into, for example a directory of error examples that a test discovers automatically. Read the assertions, not just the test names: a test that only checks an exit code and throws the output away does not prove the error message is any good, and if the ticket is about error messages that is worth calling out as part of the work.

6. **Find out what fields the target project actually has.** Do not assume a section in the description is the right home for something. Call `getJiraProjectIssueTypesMetadata` for the project to get the issue type id, then `getJiraIssueTypeMetaWithFields` with `requiredFieldsOnly: false`. That response is large, so grep the saved tool output for the field names you care about instead of reading it whole. Record the `customfield_*` ids for anything that turns out to be a dedicated field, Acceptance Criteria and Story Points commonly are. Note which fields are required, the publish step will need them.

7. **Write the draft to a markdown file** in the current ticket working directory, named after the subject in kebab case, ending `-ticket-draft.md`. Use these sections, dropping any that genuinely do not apply:

   - **Fields**: project, type, assignee, parent epic, priority, story points, and a note for each value that maps to a custom field, with its id.
   - **Summary**: the one-line issue title, as a block quote.
   - **Description**: what is wrong, with the offending code quoted and the file and line named.
   - **How this surfaced**: the real-world chain of events, numbered. Name what was *not* at fault as well as what was, it stops the ticket being re-litigated.
   - **Scope**: in scope and out of scope, with a pointer to whoever owns the out-of-scope part.
   - **Open decisions**: any choice that should be settled before implementation, with a recommendation and the risk of each option.
   - **Where the code needs to change**: one bullet per file, saying what that file does today and what it needs to do instead.
   - **Implementation notes**: constraints, things that will bite, follow-ups worth splitting out.
   - **Test plan**: unit tests, then a **Smoke tests** subsection. Cover the fix, the deploy or runtime path as well as the validation path, the message text and not just the failure, and a passing case that proves the new error is not over-eager.
   - **Acceptance criteria**: one bullet per observable outcome. Say plainly that this goes in the custom field rather than the description, when it does.
   - **Related work**: linked tickets, PRs and change requests, each as `[label](url)`.
   - **Notes for me, not for the ticket**: everything that must not be published. Source staleness and the commit you read, anything you could not verify, findings nobody in the thread has seen yet and should be told about first, and fields still marked TBC.

8. **Report.** Print the file path and a short summary of what you found that the original report did not. If the scope you uncovered is bigger than the story points suggest, say so rather than quietly resizing it.

## Hard stops

- Never create or edit anything in Jira from this command.
- Never state a line number, function name or behaviour you have not read in the source. If it comes from the report, attribute it to the report.
- Never leave a TBC unmarked, and never invent a project key, epic or assignee to fill one in.
- Never put secrets, credentials, internal hostnames or account ids in the draft.
- Every URL uses `[label](url)`. No bare URLs, no URLs in backticks.
