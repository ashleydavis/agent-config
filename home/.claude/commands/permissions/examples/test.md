---
description: Test the permission rules that apply to this project by checking the examples written into them against the permissions engine.
---

Test this project's permission rules, in `.claude/permissions.yaml` and `.claude/permissions.d/`. Every rule carrying a `decide` also carries an `examples` block listing real commands under the decision each one should produce, and `check-config` decides each command with the engine and compares the decision against the one it was listed under. See [Rule examples](~/expressive-permissions/docs/CONFIGURATION.md#rule-examples) for the format, and [TESTING.md](~/expressive-permissions/docs/TESTING.md) for the command.

Read the output of each command below as it comes back: that is the report.

The engine is at `~/expressive-permissions`. Run the commands below as they are written. If one fails because the engine is missing, stop and tell the user to set it up:

```bash
git clone https://github.com/ashleydavis/expressive-permissions.git ~/expressive-permissions
(cd ~/expressive-permissions && bun install)
```

`check-config` takes one argument: the project whose `.claude` holds the rules. The examples are decided against a stand-in project directory, `/project`: that is what `${{PROJECT_DIR}}` expands to, what a relative `cwd` resolves against, and the working directory an example runs in unless it names its own. It does not have to exist. It uses the engine directly, so a decision it reports is the decision a live session would get.

1. Check this project's rules.

   ```bash
   project="$PWD"; (cd ~/expressive-permissions && bun run check-config "$project")
   ```

   Narrow a run with `--filter <text>` (only examples whose command or file contains the text) or `--list` (print the collected examples without deciding them). A project with no `.claude/permissions.yaml` and no `.claude/permissions.d/` stops with `no permissions.yaml or permissions.d`: report that and stop, since it has no rules to test.
2. Read the output and report:
   - **Failures**: the rule decided something other than what its example says. Each one names the file, line, rule path, command, cwd, expected decision and actual decision.
   - **Rules without a usable example**: a rule that cannot be tested because it has no `examples` block, or none listed under its own decision.
3. For each failure, say which side is wrong, and report it rather than fixing it: the rule is not doing what it claims, or the example records the wrong expectation. Check the actual decision against the rule's `reason` text: when the two disagree, the rule is the thing to fix.

## Next

- Fix a rule that decides more than it says it does (an allow rule that also covers a mutating form is the common one), then re-run.
- `/permissions:examples:setup`: to add examples to the rules that have none.
- `/permissions:review`: to work through a single decision in detail.
