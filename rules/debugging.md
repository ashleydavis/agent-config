# Debugging rules

These rules apply when debugging, finding the cause of a problem or fixing a bug.

The human can explicitly ask to override any of these rules. When they do, follow the request and do not argue against it.

- Never claim a root cause is "confirmed" until it is proven by running tests. Reading code and reasoning about a failure produces a hypothesis, not a confirmation. Say "I suspect" or "my hypothesis is" until you have reproduced the failure and verified the fix by running the relevant tests.
- When fixing a bug, make the minimal working fix and do not overreach.
