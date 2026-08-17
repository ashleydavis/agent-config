---
description: Add one example command, with the decision it should produce, to the permission rule that decides it.
---

Record one command as an example on the rule that decides it, so the rule is tested on that command from now on. The user supplies the command and the decision they expect (`allow`, `deny` or `ask`). The format is documented in [Rule examples](~/expressive-permissions/docs/CONFIGURATION.md#rule-examples).

It records what a rule already does. When the engine disagrees with the expectation, it reports that and leaves the rules alone.

The one file to edit is the permissions file holding the rule the example goes onto.

The engine is at `~/expressive-permissions`. Run the commands below as they are written. If one fails because the engine is missing, stop and tell the user to set it up:

```bash
git clone https://github.com/ashleydavis/expressive-permissions.git ~/expressive-permissions
(cd ~/expressive-permissions && bun install)
```

1. Get the command and the expected decision from the arguments, the selection, or the user's message. Ask for whichever is missing.
2. Ask the engine what it decides today, in this project.

   ```bash
   project="$PWD"; (cd ~/expressive-permissions && bun run decide "$project" "<command>")
   ```

   `decide` takes the project directory and one command. It prints the trace, which names the rule that decided with the file and line it lives on, and then the last line is the decision and its reason.
3. Compare the decision with the expected one:
   - **They match**: continue to step 4.
   - **They differ**: stop and report it. The rules do not do what the user expects, so an example written now would be false. Say what decided it (or that nothing matched, which is why it asks), and offer `/permissions:allow` or `/permissions:deny` to change the rules, or `/permissions:review` to work through the decision first. Only continue if the user says to record current behaviour anyway.
4. Find the rule to write it on:
   - For `allow` and `deny`, use the rule the trace names, at that file and line.
   - For `ask`, nothing matched, so pick the rule the command is a near miss of: the rule for the same command or subcommand family that deliberately leaves this form alone. Name the rule you picked when you report back, and ask the user if more than one is a reasonable home for it.
5. Add the command to that rule's `examples` block, under the expected decision, creating the block or the decision list when either is missing. Keep it a plain string, unless the command needs a specific working directory, in which case use the entry form:

   ```yaml
       examples:
         ask:
           - cmd: terraform plan
             cwd: infra
   ```

   Examples are checked against a stand-in project directory, `/project`, which does not have to exist. Write paths inside a bash command relative, and `cwd` relative too, since a relative `cwd` resolves against that stand-in project. For `Read`, `Write` and `Edit` examples write an absolute path under it (`read /project/src/index.ts`), because those rules are matched against `file_path` exactly as given. A path belonging to one machine decides the same way only on that machine.

   Add a short comment when the reason the example lands on that decision is not obvious from the command itself.
6. Check that the new example passes.

   ```bash
   bun run --cwd ~/expressive-permissions check-config "$PWD" --filter "<part of the command>"
   ```

   `check-config` takes one path, the project whose `.claude` holds the rule you wrote on, and `--filter` narrows it to the examples whose command or file contains that text. Add `--list` to see the examples it collected without deciding them.

## Next

- `/permissions:examples:test`: to run every example, not only this one.
- `/permissions:examples:setup`: to cover the rules that still have no examples.
