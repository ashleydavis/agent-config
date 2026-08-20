Open in Chrome. Open the URL we were just dealing with, without being told which one.

## Steps

1. **Work out which URL is meant.** Scan back through the conversation for URLs, most recent first, and take the one the work is currently about. That is usually the last one mentioned, but not always: prefer the thing just created, changed, reported or discussed over one that only appeared in passing, in a code sample, or in an example.

   If the human gave a hint after the command (`/oic the PR`, `/oic jira`, `/oic the failing build`), use it to pick.

   If two candidates are equally plausible, list them and ask which. Do not pick one and hope.

2. **Handle the case where there is no literal URL.** Sometimes the thing under discussion was named but never written as a URL, for example a Jira key, a PR number or a repo. Build the URL only when the conversation already established the host, for example the Jira site used earlier in the session. If the host is not established, ask for it. Never guess at a hostname or an organisation name.

3. **Open it.** Run `google-chrome --new-window <url>`. If several URLs belong together and the human asked for all of them, pass them in one command so they land in a single new window: `google-chrome --new-window <url1> <url2>`.

4. **Say what you opened.** One line, naming the URL, so it is obvious if the wrong one went to the browser.

## Hard stops

- Never guess between candidate URLs. Ask.
- Never invent a hostname, organisation or ticket key to build a URL from.
- Look at what the URL does before opening it. Most are harmless pages, but a link that performs an action on load (a delete, an unsubscribe, a one-click approval, a webhook trigger) is not a page view. Ask before opening one of those.
