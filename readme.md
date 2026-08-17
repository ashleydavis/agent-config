# agent-config

Personal Claude Code and Cursor global configuration: instructions, settings, slash commands, and permissions rules.

## Layout

```
home/
├── .claude/
│   ├── CLAUDE.md          # Global Claude instructions
│   ├── settings.json      # Claude Code settings (permissions, hooks)
│   ├── permissions.yaml   # Top-level permissions config
│   ├── permissions.d/     # Modular permissions rules (compiled into settings)
│   └── commands/          # Shared slash commands (single copy)
└── .cursor/
    ├── AGENTS.md          # Global Cursor instructions
    └── commands/          # Symlink -> ../.claude/commands
```

The `home/` subdirectory is the GNU Stow "package". Its contents are symlinked into `$HOME`.

Edit slash commands only under `home/.claude/commands/`. `home/.cursor/commands` is a relative symlink to that tree, so both tools get the same commands after bootstrap.

Built-in Cursor skills live in `~/.cursor/skills-cursor/` and are managed by Cursor. Do not put personal skills there. Put them under `home/.cursor/skills/` in this repo instead.

## Prerequisites

GNU Stow:

```bash
# Ubuntu/Debian
sudo apt install stow

# macOS
brew install stow
```

### Companion plugins

`settings.json` wires in hooks that shell out to two other repos. Both must be cloned into `$HOME` (the paths are hard-coded in the hook commands) and have their dependencies installed before Claude Code will run cleanly:

- [`claude-permissions`](https://github.com/ashleydavis/claude-permissions): provides the `PreToolUse` and `PostToolUse` hooks (`~/claude-permissions/src/pre-hook.ts`, `post-hook.ts`).
- [`claude-tools-runner`](https://github.com/ashleydavis/claude-tools-runner): provides the `Stop` hook (`~/claude-tools-runner/src/stop-hook.ts`).

Both hooks are invoked via `bun`, so `bun` must be on `PATH` as well.

## Install

```bash
git clone <repo-url> ~/agent-config
cd ~/agent-config
./bootstrap.sh
```

`bootstrap.sh` symlinks the individual config entries under `home/.claude/` and `home/.cursor/` into `~/.claude/` and `~/.cursor/` (so `~/.claude/CLAUDE.md` → `~/agent-config/home/.claude/CLAUDE.md`, `~/.cursor/AGENTS.md` → `~/agent-config/home/.cursor/AGENTS.md`, etc.).

### Why bootstrap doesn't just run `stow home`

The stow package contains `home/.claude` and `home/.cursor`. If either `~/.claude` or `~/.cursor` does not already exist, stow performs **tree folding** and makes that path itself a single symlink into this repo. The tool then writes all of its runtime state through that symlink, dumping it into the repo working tree.

To prevent this, `bootstrap.sh` ensures both targets are **real directories** before stowing, so only the individual config files/dirs are symlinked and runtime state stays in the real home dirs. The script is idempotent and self-healing: if it finds either path already folded into a single symlink, it un-folds it and moves any non-tracked runtime state back out of the repo. It also replaces stale package-entry symlinks that point outside this repo (e.g. leftovers after a directory rename) and `--adopt`s plain-file conflicts so a re-run does not abort.

## Uninstall

```bash
cd ~/agent-config
stow -D -t "$HOME" home
```

Removes the symlinks but leaves the files in this repo.

## Cursor troubleshooting

Notes from hardening Agent shell approvals. Prefer Cursor's docs over memory when something drifts.

### Agent runs `git commit` (and similar) with no approval card

**1. Clear the Command Allowlist cruft**

Path in the UI: **Settings → Agents → Executions and Approvals → Allowlist Options → Command Allowlist**.

A long list builds up over time from "add to allowlist" approvals. Matching is by **prefix** ([permissions.json reference](https://cursor.com/docs/reference/permissions)): an entry like `git -C` matches `git -C <path> commit ...`, so a broad prefix silently auto-runs dangerous git writes.

Action taken: removed all accumulated Command Allowlist entries there so the list is empty again.

That list is IDE state, not a file in this repo. Cursor stores it in app state (`composerState.yoloCommandAllowlist` in the Cursor `state.vscdb` under the user config directory). Optional file override: `~/.cursor/permissions.json` with `terminalAllowlist` (see the same docs). When that file is absent, the IDE list is what counts.

**2. Turn off Auto-review (use Allowlist Run Mode)**

After clearing the allowlist, `git commit` can still run with no card under **Auto-review**: non-allowlisted shell calls may be approved by the classifier without showing you a prompt ([Run Modes](https://cursor.com/docs/agent/security/run-modes)). Auto-review is not a hard security boundary; the docs say the classifier can allow calls you would have blocked.

Path in the UI: **Settings → Agents → Approvals & Execution** → **Run Mode**.

Action taken: set Run Mode to **Allowlist** (classifier: no). With an empty Command Allowlist, non-allowlisted commands should prompt. Docs note that **Ask Every Time** was deprecated; empty Allowlist is the replacement for that behavior.

**3. Do not confuse this with `~/.cursor/cli-config.json`**

That file is the **CLI** permissions allowlist. The IDE Agent Command Allowlist is separate. Editing only `cli-config.json` does not fix IDE Agent auto-run of `git commit`.

**4. Disable Cursor importing Claude config**

Path in the UI: **Settings → Rules, Skills, Subagents** → turn off **Include Third-Party Plugins, Skills, and Other Configs**.

Action taken: disabled that toggle so Cursor does not automatically load Claude configuration (including Claude `PreToolUse` / `PostToolUse` hooks from `~/.claude/settings.json`). Those hooks are built for Claude Code's allow/deny/ask model. Cursor can mishandle `ask` and fail open, which can let commands (for example `git commit`) run without a real approval prompt. See Cursor's [third-party hooks](https://cursor.com/docs/reference/third-party-hooks) docs.

Claude Code itself is unaffected; it still loads `~/.claude/settings.json` as usual.
