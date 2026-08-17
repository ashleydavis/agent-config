permissions:examples

Commands for the `examples` blocks on permission rules: the real tool calls a rule records under the decision each one should produce.

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

The permissions engine loads the block and ignores it, so it never changes a decision. It is there so a rule states what it covers, and so those calls can be replayed through the engine to prove the rule still does it. `allow` and `deny` list what the rule decides; `ask` lists the near misses it deliberately leaves alone, which nothing matches and which therefore fall through to a prompt.

This file is plain text, not markdown, because Claude Code registers every .md file under commands/ as a slash command, and a readme is documentation rather than something to run.

The commands

  /permissions:examples:setup   Adds examples to every rule that has none, one file at a time,
                                testing as it goes. Run this once on a project.

  /permissions:examples:add     Records one command, and the decision it should produce, on the
                                rule that decides it. Run this when a new command comes up.

  /permissions:examples:test    Replays every example through the engine and reports any rule that
                                no longer decides what it says it decides. Run this after changing
                                rules, and in CI.

All three run the engine out of ~/expressive-permissions, which is where expressive-permissions (https://github.com/ashleydavis/expressive-permissions) is checked out on these machines. None of them clone or install it: if the directory is missing they say so and hand the clone command back to you.

They drive it only through the scripts in its package.json, `bun run check-config <config-dir>` for every example in a config and `bun run decide <project-dir> "<tool call>"` for a single tool call, never by running its source files or shell scripts. The field itself is documented in its CONFIGURATION.md: https://github.com/ashleydavis/expressive-permissions/blob/main/docs/CONFIGURATION.md#rule-examples

The rules in this repo are covered by all of the above, and a GitHub Actions workflow runs the test on every push.
