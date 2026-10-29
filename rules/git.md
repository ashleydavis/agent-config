# Git rules

These rules apply to every git command and every change to a remote repository.

The human can explicitly ask to override any of these rules. When they do, follow the request and do not argue against it.

- HIGH PRIORITY: A request to fix code or a problem is not a request to commit or push. Fix it, test it and stop. Commit or push only when the human's own words in that message name the commit or the push, and a "yes" or "fix it" in reply to a question you asked that named them does not count.
- When you create a remote repository or first push a local one, always add it as a git remote (`origin` unless one exists), using its SSH URL where possible, and set the upstream on the first push. Never push to a bare URL instead. This is the one git configuration change allowed without being asked.
- HIGH PRIORITY: Rewriting git history (amend, reword, squash, force-push) is never acceptable. Never do it, never ask about it and never stop work for it. A fault only a rewrite could fix stays as it is.
