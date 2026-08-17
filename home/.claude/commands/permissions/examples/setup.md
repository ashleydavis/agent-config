---
description: Add example commands to every permission rule in this project so the rules can be tested, then run the tests until they all pass.
---

Add an `examples` block to every permission rule in this project, so each rule states the commands it is meant to decide and can be tested against the real engine. Work through one file at a time, checking each file before starting the next.

The field is documented in [Rule examples](~/expressive-permissions/docs/CONFIGURATION.md#rule-examples), and the command that checks it in [TESTING.md](~/expressive-permissions/docs/TESTING.md). Read both before starting: they change. The engine loads `examples` and ignores it, so the block never affects a decision.

The engine is at `~/expressive-permissions`. Run the commands below as they are written. If one fails because the engine is missing, stop and tell the user to set it up:

```bash
git clone https://github.com/ashleydavis/expressive-permissions.git ~/expressive-permissions
(cd ~/expressive-permissions && bun install)
```

`check-config` takes one argument: the project whose `.claude` holds the rules. The examples themselves are decided against a stand-in project directory, `/project`: that is what `${{PROJECT_DIR}}` expands to while checking, what a relative `cwd` resolves against, and the working directory an example runs in unless it names its own. It does not have to exist, so an example can name any file a normal project would have. `--filter <text>` narrows the run and `--list` prints the collected examples without deciding them. It uses the engine directly, so a decision it reports is the decision a live session would get.

## What a rule is

Any mapping carrying a `decide` string, at any depth, in `.claude/permissions.yaml` or any file directly under `.claude/permissions.d/` (`permissions.d/commands/` holds command descriptors, not rules). A rule needs at least one example listed under its own decision.

`examples` is a rule field, so it cannot sit beside subcommand names: it belongs on the nested entry that carries the `decide`, not on the block holding the subcommands.

## The format

```yaml
    tag:
      options:
        - l|list
      decide: allow
      reason: Readonly git access (listing tags only)
      examples:
        allow:
          - git tag --list
        ask:
          - git tag v1.0.0
          - git tag -d v1.0.0
```

- `allow` / `deny`: commands this rule is meant to decide. At least one is required, under the rule's own decision.
- `ask`: the near misses this rule deliberately leaves alone, so nothing matches them and they fall through to a prompt. Write these against the rule's own conditions: the flag its `not:` excludes, the subcommand its `cmd` does not cover, a path outside its `cwd`. For a rule with no conditions, use the closest sibling command that no rule covers.
- An entry is either a command string or an object with `cmd` and the `cwd` the command runs in. `cwd` defaults to the stand-in project directory and a relative `cwd` resolves against it. It does not have to exist: name the directory the command would be run from in a real project.
- No machine-specific paths in an example. Write bash commands with paths relative to the project, and keep `cwd` relative, so the examples read the same on every machine.
- Non-Bash rules use the prefix syntax: `read <path>`, `write <path>`, `edit <path>`, `webfetch <url>`, `tool <name>` (MCP tools included, e.g. `tool mcp__server__operation`).
- Read, Write and Edit rules match `file_path` exactly as it is written, with no resolving against the working directory, so those examples name an absolute path under the stand-in project: `read /project/src/index.ts`, not `read src/index.ts`.

## Steps

1. List the rules that have no example yet.

   ```bash
   project="$PWD"; (cd ~/expressive-permissions && bun run check-config "$project")
   ```

   The tail of the report names every rule without a usable example, file by file. The one argument is this project, so its `.claude` rules are the ones being checked.
2. Take one file at a time. For each rule in it, write the commands a person would run, in their real forms. Prefer paths a normal project would have so the examples read as real usage.
3. Re-run after each file, narrowed to it, and fix what fails before moving on.

   ```bash
   project="$PWD"; (cd ~/expressive-permissions && bun run check-config "$project" --filter <file-name>)
   ```
4. When a run fails, work out which side is wrong before changing anything:
   - The rule's `reason` states its intent. When the engine's actual decision contradicts that text, the rule is the thing to fix, not the example. Tightening it with `not:` conditions is the usual repair.
   - Otherwise the expectation was wrong and the example moves to the decision the engine gave, with a comment saying why that is correct.
   - Check how a matcher behaves against the engine before writing an example around it: path-style `cmd` patterns resolve a relative argument against the working directory (so a bare argument lands inside the project and matches `${{PROJECT_DIR}}/**`), and a `cwd: <dir>/**` pattern matches that directory as well as anything under it.
5. Finish when `check-config` reports every example passing and no rules without a usable example.

## Next

- `/permissions:examples:test`: to re-run the whole check later, or in CI.
- `/permissions:examples:add`: to record one more command against the rule that decides it.
- Add a CI job that runs the same command on every push, so a rule cannot change behaviour unnoticed.
