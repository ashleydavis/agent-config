# Writing rules

These rules apply to everything written in code (comments and text the code displays), commit messages and docs.

The human can explicitly ask to override any of these rules. When they do, follow the request and do not argue against it.

These rules apply only to new writing and to writing being edited. Do not rewrite existing comments, commit messages or docs just to make them match these rules unless the human has explicitly asked for that.

- Always say why. Code alone is not documentation.
- Never use em dashes, or double hyphens standing in for them. Use a period, comma, colon, or parentheses instead.
- Banned words:
  - "shape". Say what you actually mean: "not a plain object", "laid out like", "how the curve grows", "what most of these tests need".
  - "gate", "gated", "gating", "gates on" and "ungated". Say what the code does and what it does it to: "waits for the modal to finish loading", "runs only the suites whose files changed", "blocks until the device is on the bridge", "refuses to start when no emulator is attached". "Gate" names none of those, so a reader has to already know which one is meant, and it hides whether the thing waits, skips, blocks or refuses.
  - "by hand". Say what the reader does instead, or what it is done without: "without the command", "yourself", "from the Actions tab".
  - "pin", "pins", "pinned" and "pinning" for a version. Say "lock" and "locked": "locked in `mise.toml`", "locks Zig to an exact version".
  - "nothing" and "nobody" in docs. Name the thing that is absent: "no call reached it", "no list refers to it".
- Never hard-wrap prose in markdown or plain-text docs. Write each paragraph and bullet as a single line and let it soft-wrap. Do not insert manual line breaks to hit a column width.
- Never use `---` horizontal-rule separators in markdown or plain-text docs. Structure sections with headings and blank lines instead.
- Never hard-code a count or other changing number into docs, comments, plans or commit messages. "all 12 of them", "seven settings", "400 files", "twenty concurrent calls": each is right on the day it is written and wrong as soon as something is added or removed, and nothing fails when it goes stale, so it rots silently while a later reader trusts it. Say what the number is derived from instead: "every one in the set", "one per name per target", "one call per item on top of its own". A reader who needs the actual figure can count, and the command that counts it is worth more than the figure. A number recording a point-in-time event is fine, because it does not claim to stay true: "the scan covered 400 files" describes a run that happened, "the project has 400 files" goes stale. Measurements and counts go in the commit message, not the docs. Where one has to sit in a doc because it carries the reasoning for a decision, write the date it was taken beside it.
- Text our code displays to the user, such as messages and errors, reads as a proper sentence: a capital letter at the start and a full stop at the end.
- Comments are sentences: a space after the slashes, a capital letter and a full stop (or a colon if they lead into what follows).
- In comments, commit messages and docs, say only what a thing is and does, never what it is not, does not do or does not support. No "X is not Y", "this is not an environment variable", "not supported", "does not use", "no longer", "accepts no other". There is an endless number of things that are not there or not supported, so listing even one is the start of an infinite list. Do not write any of them unless the human has asked you to call out that particular one. This holds when editing an existing line too: a line you touch comes out saying only what is true.
- Never write `mise exec --` in docs, READMEs, comments or script help text. Users run commands without it. It is only for commands Claude runs itself.
- Plans are temporary and get deleted. Never reference a plan from anything that stays: docs, code, comments or commit messages.
- No serial comma. Write "Linux, Windows and macOS", never "Linux, Windows, and macOS". Where a list reads ambiguously without it, rephrase the sentence.
- Never use invented jargon. Only widely used jargon is allowed. Project-specific jargon is allowed only when the project's glossary defines it. No filler and no made-up examples.
- Write every document as though everything already exists, including all planned features. No "will", "once this is built", "the plan is to", "eventually", "not yet implemented". The human uses the docs to judge whether a project plan will work, so they must read as though the plan is finished.
- Plain words and short sentences. One idea per sentence, no clauses stacked on the end, and the same word for the same thing every time it appears.
- Say what a thing does rather than characterising it. A sentence a reader has to decode is worse than no sentence.
- Never reference a file or document outside this repo by path. A reader of this repo cannot open it. Link to it as a URL instead, for example `https://github.com/<owner>/<repo>/blob/HEAD/<path>`.
