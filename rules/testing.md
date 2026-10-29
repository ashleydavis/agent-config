# Testing rules

These rules apply when writing or running tests.

- After making changes, always run the tests in the way that suits the language and the project, following the rules the project defines. Make sure the test run exits with code 0. If you have caused tests to fail, you must fix them.
- You are never expected to run a test that cannot run on this machine, but you must run every affected test that can run here for the platforms the project supports: on Linux, Linux and Android; on macOS, macOS and iOS; on Windows, Windows. A plan never assumes the platform it runs on and never depends on a test the machine running it may not be able to run, because a goal that can never be met loops all night.
- Climb the testing ladder; never start by running every suite:
  1. Run only the tests affected by your change. If there are many, first run one or two picked at random, in parallel.
  2. Then run every affected test. If that is more than half a suite, run the whole suite.
  3. Then run only the affected suites (for example, a change to Zig code does not run the TypeScript unit tests).
  4. Only when every suite is affected, run the "test everything" script if there is one. The pre-commit hook runs it anyway, so nothing is missed by skipping unaffected suites.
- When a test fails, go back down the ladder to individual tests. Investigate several failures at once with parallel subagents, fix them with subagents and resume the ladder once the affected tests pass.
- Always capture test output to a file in the project's `tmp/`, so a failure can be read without running the suite again.
- Never skip a failing test. Fix the production code or the test code properly. Never delete a failing test or its failing assertion, comment it out, loosen an assertion or catch the error to make it pass. Avoid adding a wait or retry to make it pass, unless one is required.
- Add new tests for new code. Every function that is new, that you edit, or that the user asks you about should have unit tests.
- New or edited code must have at least 95% test coverage.
- Do not force all tests to run, and do not use the `--force` argument, including on the "test everything" script. If the test script caches results and skips tests that do not need to run, those tests do not have to run, so do not force them.
- A unit test reaches nothing outside the process: no network, no cloud account, no emulator. External dependencies must be mocked. Do not use real external dependencies. Put every external service behind an interface, with a real implementation, a mock and a way to inject faults, so tests can make the service fail.
- When writing a test, put a description at the top explaining its goal and method.
- Product code never references test code. Test helpers, fixtures and fakes live in test files, never in product files. The one exception is the Zig block that imports a code file's test file.
- Never write tests for a mock, fake or stub. Write tests only for production code.
- Never fake a test. Tests should always validly test the prod code they are testing. They should fail if that prod code is broken.
- Unit tests must run in seconds, not minutes.
- All tests must be capable of running in parallel with themselves, otherwise we can't do parallel work in worktrees.
- If multiple test runs need to happen, divide the work up into subagents to get through it in parallel where possible.
