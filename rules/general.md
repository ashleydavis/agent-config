# General coding rules

These rules apply to code in every language. The language rules files add to them.

The human can explicitly ask to override any of these rules. When they do, follow the request and do not argue against it.

These rules apply only to new code and to code being edited. Do not rewrite existing code just to make it match these rules unless the human has explicitly asked for that.

- Before planning, writing docs or writing code in a project, read its marker files with the Read tool: every `package.json`, `tsconfig.json`, `bun.lock`, `build.zig` and `build.zig.zon` at the project root. Reading one loads the matching language rules. When starting a new project, write its marker file first.
- After making changes, always compile or build the code in the way that suits the language and the project, following the rules the project defines. Make sure the compile or build exits with code 0. If you have created compile errors, you must fix them.

## Baseline

Inspired by [Tiger Style](https://github.com/tigerbeetle/tigerbeetle/blob/main/docs/TIGER_STYLE.md).

- Design goals, in order: safety, performance, developer experience.
- Zero technical debt. Do it right the first time.
- Zero overengineering. Simplicity rules.
- Get the nouns and verbs just right. Take time to find the name that captures what a thing is or does.

## Assertions

- Assertions catch programmer errors. The only correct response to a failed assertion is to crash. Assert function arguments, return values, preconditions, postconditions and invariants. Average at least two assertions per function.
- Where possible, assert every property you enforce in at least two different code paths. For example, assert data is valid right before writing it to disk and again right after reading it back.
- Split compound assertions: prefer `assert(a); assert(b);` over `assert(a and b);`.
- Where a condition is critical and surprising, you may use an assertion instead of a comment, as stronger documentation.
- Assert what you expect and also what you do not expect. Bugs hide where data crosses from valid to invalid. Tests cover valid data, invalid data and data becoming invalid.

## Performance

- Except within event-driven UI code, do not act directly in reaction to external events. The program runs at its own pace and processes events in batches, which keeps control flow in its hands and bounds the work done per period.
- Think about performance from the start, in the design phase, where the biggest wins are. Sketch rough numbers for network, disk, memory and CPU (bandwidth and latency) before building.
- Optimise for the slowest resources first: network, then disk, then memory, then CPU, after allowing for how often each is used.
- Batch network, disk, memory and CPU work to spread its cost, and give the CPU large, predictable chunks of work. Keep the control plane (decisions) separate from the data plane (bulk work).

## Making changes

- Prefer to minimize the size of code changes.
- No overengineering. Write the simplest code that does what was asked. No unneeded abstraction, configurability or features for later.
- Never reformat or rewrite entire files. Only edit the specific lines that need to change.

## Code structure

- No re-exports. A module exports only the symbols it defines. Never re-export another module's symbol, in any form. Every call site imports a symbol directly from the module that defines it. The one exception is a package's main entry file (such as `index.ts` or `root.zig`), which may re-export to expose the package's types and code.
- Do not introduce a constant that is used once. A value used in one place goes inline at that place, where the reader can see it. A constant earns its name when the value is used in more than one place, or when the literal does not explain itself and the name is what says why that value.
- Write beside every named constant why its value is what it is.
- A function that takes no arguments and always returns the same value should be a constant instead.
- Global variables are generally frowned on. Do not add one (a module-level mutable variable, a Zig top-level or struct-level `var` or a `threadlocal`) unless the human explicitly asks for it. Pass the value down from whoever owns it instead. Where a global is needed, put a comment beside it saying what was tried and why nothing else worked.
- Every file, module, type and function has a single responsibility: one job. When something does two jobs, split it.
- Every file starts with a comment block that states its single responsibility, before any import or declaration.
- Functions should be deterministic and have a functional style where possible. Dependencies are injected. Side effects are minimized or eliminated and only introduced at the topmost level. Prefer a function over a class when a function will do.
- Use only simple, explicit control flow. Prefer not to use recursion, unless it is much simpler and more elegant to use recursion.
- Put a limit on everything. Every loop and every queue has a fixed upper bound. Where a loop must never end (such as an event loop), assert that.
- Declare variables in the smallest possible scope, close to where they are used. Do not introduce a variable before it is needed, or keep it around after.
- Split compound conditions into simple nested `if`/`else` branches, and complex `else if` chains into `else { if { } }` trees, so every case is easy to check. Consider whether each `if` needs a matching `else`.
- State invariants positively. Prefer `if (index < count)` to `if (index >= count)`.
- Pass options to library functions explicitly at the call site instead of relying on the defaults, so a change to the library's defaults cannot change your code's behaviour.
- Do not duplicate variables or take aliases to them, so state cannot get out of sync.
- Prefer simpler return types, so callers have fewer cases to handle: nothing beats a yes/no, a yes/no beats a value, a value beats a value that may be missing. That in turn beats a value that may be an error.
- Treat an index, a count and a size as distinct types, even though all three are integers. Index to count: add one. Count to size: multiply by the unit. Most off-by-one errors come from mixing them up.

## Formatting

- Never write an object literal (or a Zig struct literal) on one line. Open the brace, put each property and each spread on its own line ending in a comma and close the brace on its own line. The only exception is an empty `{}` (or `.{}` in Zig).
- Never put multiple statements on one line. Each statement should be on its own line.
- Never write an `if` or an `else` without braces. Every body goes on its own lines, whatever it does and however short it is: a bare `continue`, a `return`, a `break`. An `if` used as a value (Zig's `return if (icons) mark else "OK"`) is an expression, not a statement body, and may stay on one line. An `if` whose body is a single assertion may also stay on one line, to assert an implication: `if (a) assert(b)`.

## Comments

- **Comments**: Line comments with `//` preceded by blank line, method docs above function. Use `//` comments for method docs. Never use `///` doc comments or trailing comments on the same line as code. Wrap comments at 100 columns. Write every comment block with an empty `//` line above and below the text:

  ```
  //
  // <comment line 1>
  // ...
  // <comment line x>
  //
  ```

- Every top-level function, variable and type has a comment block above it saying what it is for, what the intention is with it and why it is done this way rather than another way. Every field of a struct, interface or class has the same kind of comment. Comments state intent, not how the code works. Do not restate the type. Do not put a function's name in its own comment.
- Comments describe the code as it is, never its history (what it used to be, what was removed or why it changed). History goes in the commit message.

## Dependencies

- Avoid vendoring third-party tools, libraries or code where possible, unless there is a significant benefit (justify it in a comment or doc) or the human requests it. Anything vendored comes with a script that updates the vendored copy to the latest version. Anything vendored also comes with a `.md` file next to it that explains what it is, why it is needed, how to update it (pointing to the update script) and the justification for vendoring it.
- When a dependency or tool is added or updated, pin it to the latest version as an exact version, so every machine and every run uses the same one. Never pin to the string `latest`, in `mise.toml`, `package.json`, workflows, scripts or anywhere else. Do not update dependencies to new versions unless there is a significant benefit (document it in a comment or doc) or the human has requested it.
- Never patch, reimplement or reinvent third-party tools, libraries or code unless the human requests it.

## Naming

- Never use single-character variable names, including arrow function parameters (e.g. use `fileName => ...` not `f => ...`). Use long descriptive identifiers.
- Name a function that does something with a verb and the thing it acts on (`readSources`). Name a function that answers yes or no starting with `is`, `has`, `was`, `can` or `may` (`isEmpty`). Name a function that only works something out after what it returns, with no preposition glued on (`pathCounts`, not `countsFor`). Use the exact verb (`print`, not `say`; `read`, not `get`) and never `handle`.
- Name a type for what it is, never for a metaphor such as "sink", "pipeline", "bucket", "pump", "harness" or "hook": `AnnotationWriter`, not `AnnotationSink`. Do not invent a term where a plain one exists, and do not abbreviate unless the abbreviation is already the domain's own word.
- A name that needs `and` in it is two functions. Split it and the two names come out on their own.
- Prefer not to give code a generic name such as `utils`, `helpers`, `support`, `common`, `misc`, `shared` or `manager`, for a file, module, directory, type or function. A generic name says only that something was put there, not what it is. Name what it holds or does.
- Put units and qualifiers last in a name, most significant word first: `latencyMsMax`, not `maxLatencyMs`.
- Use proper capitalisation for acronyms: `VSRState`, not `VsrState`.
- Where possible, give related names the same number of characters so they line up: `source` and `target`, not `src` and `dest`.
- Prefer nouns to adjectives or "-ing" words in names, because a noun can be used directly in docs and conversation: `pipeline`, not `preparing`.

## Error handling

- Failures must be noisy. Never silently do nothing, discard an error, drop data or report success when the work did not happen. Prefer a loud crash over a quiet wrong answer. Never swallow an error: no empty `catch`, no discarded return, no unreported or silent failures. A mechanism that absorbs an error reports it. A retry logs what it retried and why, and one that runs out fails with the last error attached rather than a message about attempts.
- Every error reaching a person says what it was, where it came from and what to do. A type name, a code or the word "failed" makes the next reader guess.
- Our code may occasionally hit runtime errors, such as a crash or a panic. Treat each one as a bug to eliminate, not as something to catch.
- All errors must be handled. Handling means fixing the problem it reports (where possible), retrying (where appropriate) or reporting it to the user. Where you can do none of these, pass it up to the caller.

## Testing

- After making changes, always run the tests in the way that suits the language and the project, following the rules the project defines. Make sure the test run exits with code 0. If you have caused tests to fail, you must fix them.
- When working on a specific test or tests, run whatever command runs only the tests that need to run. Do not run the whole test suite when only some tests are affected.
- Never skip a failing test. Fix the production code or the test code properly. Never delete a failing test or its failing assertion, comment it out, loosen an assertion or catch the error to make it pass. Avoid adding a wait or retry to make it pass, unless one is required.
- Add new tests for new code. Every function that is new, that you edit, or that the user asks you about should have unit tests.
- New or edited code must have at least 95% test coverage.
- Do not force all tests to run, and do not use the `--force` argument. If the test script caches results and skips tests that do not need to run, those tests do not have to run, so do not force them.
- A unit test reaches nothing outside the process: no network, no cloud account, no emulator. External dependencies must be mocked. Do not use real external dependencies. Put every external service behind an interface, with a real implementation, a mock and a way to inject faults, so tests can make the service fail.
- When writing a test, put a description at the top explaining its goal and method.
- Product code never references test code. Test helpers, fixtures and fakes live in test files, never in product files. The one exception is the Zig block that imports a code file's test file.
- Never fake a test. Tests should always validly test the prod code they are testing. They should fail if that prod code is broken.
- Unit tests must run in seconds, not minutes.
- All tests must be capable of running in parallel with themselves, otherwise we can't do parallel work in worktrees.
- If multiple test runs need to happen, divide the work up into subagents to get through it in parallel where possible.

## Shell scripts

- Give every shell script `#!/usr/bin/env bash`, a `.sh` extension, `bash -n` run over it, the executable bit set and usage printed when it is run with no arguments.
- Every new shell script comes with a markdown file beside it, named after the script, covering what it is for, how it is invoked and what each argument means. Keep it current. When you edit an existing shell script that has no such file, add one. Do not add one for existing shell scripts you are not touching.
- Do not write tests for shell scripts, however you can and should manually test every shell script you create or edit.

## Git pre-commit hook

- If the repo has a script that installs a Git pre-commit hook, run that script once to install the hook.
- Conform to the hook. Do not bypass it and do not work around it.
- The hook compiles and tests the code and refuses to commit broken code. When it refuses a commit, fix the code and try to commit again.
