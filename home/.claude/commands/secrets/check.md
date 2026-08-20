Check the current work for secrets, sensitive data and company-specific details before it goes anywhere. Report findings only, change nothing.

`/secrets:scrub` is what removes them. This command finds them and tells the human what it found.

## Steps

1. **Work out where this is going, because that decides what counts.** A private company repo and a public GitHub repo have very different rules. Check it rather than assuming:

   - For a git repo, get the visibility (`gh repo view --json visibility,isPrivate`) and the remote. A public remote raises the bar for everything in the last category below.
   - For a draft or a published artifact, ask where it is destined: an internal Jira ticket, a customer-facing page, a public repo, an open source PR, a blog post.
   - If the destination is not obvious and the human has not said, ask before reporting, since "company-specific" is only a finding when it is leaving the company.

2. **Agree the scope.** Default to the smallest scope that covers the work in front of you and say which one you picked. The ladder, cheapest first:

   1. **Uncommitted work.** The working tree and the index: `git status`, `git diff`, `git diff --staged`, plus untracked files.
   2. **This branch.** Every commit on the current branch that is not on trunk.
   3. **Drafts and artifacts.** Local ticket drafts, runsheets, plans, notes, and anything already published or about to be: a Jira comment or ticket, a Confluence page, a PR description, a release note.
   4. **The whole repo at HEAD.** Every tracked file, not just the changed ones.
   5. **The entire history.** Every commit, every branch, every deleted file that is still reachable.

   **Never go to 4 or 5 without asking first.** Both are slow, both produce a lot of noise, and 5 in particular usually ends in a history rewrite, which is a serious operation. Tell the human what each would involve and let them choose. If a finding at a lower level looks like it was probably committed earlier too, say so and offer to go deeper rather than doing it silently.

3. **Look for real secrets.** These are the findings that matter most, because the damage is done the moment they are committed or published:

   - Private keys and certificates, `BEGIN * PRIVATE KEY`, `.pem`, `.p12`, `.ppk`, SSH keys.
   - Cloud credentials: AWS access key ids and secret keys, session tokens, GCP service account JSON, Azure connection strings.
   - API tokens for anything: GitHub, Slack, Atlassian, PagerDuty, Stripe, npm, Docker registries, CI providers.
   - Passwords, database connection strings with credentials in the URL, basic-auth URLs.
   - `.env` files, `terraform.tfvars`, `credentials`, `kubeconfig`, and anything else that is tracked but should not be. Cross-check against `.gitignore` and flag anything that is already tracked despite matching an ignore rule, since ignoring it now does not untrack it.
   - Base64 blobs and long random-looking strings assigned to a suggestive name.

4. **Look for sensitive data.** Not a credential, but still should not be there:

   - Customer or employee personal data: names, email addresses, phone numbers, addresses, user ids tied to a real person.
   - Real production data pasted into a test fixture, a log excerpt or a bug report.
   - Internal hostnames, private IP ranges, cloud account ids, ARNs, resource ids, bucket names, internal URLs.
   - Security details that help an attacker: exact versions of internal services, network layout, a list of what is unprotected.

5. **Look for company-specific details, and judge them against the destination.** These are fine internally and a problem in public:

   - Organisation and team names, internal repo names, product codenames.
   - The Jira or Confluence host, real ticket keys, real PR links.
   - Real people's names in examples.
   - Internal process and terminology in something written for outside readers.

   In a public repo, generic placeholders belong in examples: `some-org/some-repo`, `your-site.atlassian.net`, `PROJ-123`.

6. **Check the artifacts as well as the code**, when they are in scope. A ticket draft, a Jira comment, a Confluence page or a PR body can carry all three categories, and a published one is already out. For anything already published, note that editing it later usually leaves the original in the page or comment edit history.

7. **Report.** Group findings by category, worst first, and for each give the file and line (or the artifact and where in it), what kind of thing it is, and why it counts given the destination. Mask the value: show enough to find it, never the whole secret. If nothing is found, say which scope you checked, so the human knows what the clean result covers.

   Finish with what should happen next, naming the actual next action rather than describing it:

   - Which findings need a credential **rotated**, and that this has to happen before anything else.
   - That **`/secrets:scrub`** is what removes the rest, and which scope it would need to run at. Say the command by name, every time there is a finding. A report that leaves the human working out what to run next has not finished the job.
   - Whether a deeper scope is worth running, and offer it as one plain question.

## Hard stops

- Report only. Never edit, never commit, never rewrite history from this command.
- Never scan the whole history or the whole repo without the human agreeing to it first.
- Never print a full secret value in the report, in a commit message, in a Jira comment, or anywhere else. Mask it.
- Never send a found secret to any external service. That includes pasting it into a ticket, a page, a search query or an issue.
- If a live credential has been committed or published, say plainly that it must be rotated. Removing it from the file or the history does not make it safe, it is already in clones, forks, caches and logs.
- Never declare something clean that you did not actually check. Name the scope.
- Never end a report that has findings without naming `/secrets:scrub` as the next step.
