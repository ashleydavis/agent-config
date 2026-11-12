# Error handling

- **Swallowing an error is banned.** An error is never discarded, ignored or turned into a success. That covers an empty `catch`, `catch (error) { }`, `.catch(() => undefined)`, `.catch(() => {})`, `try` with no handling, a discarded error return, and any other path that lets a failure pass as if it had not happened.
- Failures must be noisy. Never silently do nothing, discard an error, drop data or report success when the work did not happen. Prefer a loud crash over a quiet wrong answer. A mechanism that absorbs an error reports it. A retry logs what it retried and why, and one that runs out fails with the last error attached rather than a message about attempts.
- Every error reaching a person says what it was, where it came from and what to do. A type name, a code or the word "failed" alone makes the next reader guess.
- All errors must be handled: fix the problem it reports (where possible), retry (where appropriate), or report it to the user or the caller. Where none of those is possible, pass it up to the caller.
- Never return a success value, an empty result or the input when the work did not happen. Never drop data. Prefer a loud crash or a thrown error to a quiet wrong answer.
- Our code may occasionally hit runtime errors, such as a crash or a panic. Treat each one as a bug to eliminate, not as something to catch.
- A catch that exists only to silence an error is removed, and the error's cause is fixed instead.
- A test must not catch and ignore an error to keep a run green. The same rule applies to a retry that hides a failure.
- A comment that says an error is expected does not make ignoring it acceptable.
