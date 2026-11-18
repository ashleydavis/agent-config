# Goal rules

How to write a goal: the text the human sets so the agent keeps working until a condition is met.

- A goal names the work and states the condition that ends it. Nothing else.
- A goal is an outcome to achieve, never a rule or an instruction.
- Never put instructions in a goal: how to do the work, what order to do it in, which tools to use or which rules to follow. Those belong in the command or the plan.
- Never put reporting rules in a goal. What to write in the report is not part of the end condition.
- Never repeat a rule from a rules file or a command in a goal. The agent already has them.
- Use this form: one sentence naming the work, then "This is achieved when the transcript shows, after the last edit:" followed by the conditions, then "Stopping for any reason other than achieving this is unacceptable."
- Every condition is a specific item to check off, a fact the transcript can show: a named command that exited 0, a named file in a given place, a named box ticked, a named run that passed.
- Never use a word that needs a judgement to settle, such as "proven", "implemented", "verified", "done", "works" or "fixed". Name the run, file, test or box that shows it instead.
- Name a fixed target: the plan file by name, the step by number and title. Never write "the next step" or any other wording that moves, because the goal is checked again at every stop and a moving target is never met.
- Every condition must stay reachable by later work. Never add a condition about order, about something that happens before something else, or about anything the machine cannot do, because once it is missed no work can meet it and the agent loops forever.
- Keep each condition to the fewest words that still make it checkable. A goal the human cannot read in one look is too long.
- Print a goal in a code fence, without a `/goal ` prefix, which does not survive pasting. Never put it in a blockquote (`>`), or anything else that draws a vertical bar on its left.
