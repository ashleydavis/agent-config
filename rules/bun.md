---
paths:
  - "**/package.json"
  - "**/bun.lock"
  - "**/bunfig.toml"
---

# Bun rules

These rules apply to projects that use Bun. They add to the TypeScript rules.

The human can explicitly ask to override any of these rules. When they do, follow the request and do not argue against it.

These rules apply only to new code and to code being edited. Do not rewrite existing code just to make it match these rules unless the human has explicitly asked for that.

- In a Bun project with workspaces, one `bun install` at the root installs every nested TypeScript project reached by the root `package.json` workspace globs, and there is one `bun.lock` at the root. Never add a second install anywhere. When adding a directory with a `package.json`, check that the globs cover it, in the same commit. Nothing fails when they do not: it surfaces as a missing module somewhere unrelated.
