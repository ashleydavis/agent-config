# claude-config

Personal Claude Code global configuration: instructions (CLAUDE.md), settings, slash commands, and permissions rules.

## Layout

```
home/
└── .claude/
    ├── CLAUDE.md          # Global Claude instructions
    ├── settings.json      # Claude Code settings (permissions, hooks)
    ├── permissions.yaml   # Top-level permissions config
    ├── permissions.d/     # Modular permissions rules (compiled into settings)
    └── commands/          # Custom slash commands (/q, /verify, /plan/*, etc.)
```

The `home/` subdirectory is the GNU Stow "package". Its contents are symlinked into `$HOME`.

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
git clone <repo-url> ~/claude-config
cd ~/claude-config
./bootstrap.sh
```

`bootstrap.sh` symlinks the individual config entries under `home/.claude/` into `~/.claude/` (so `~/.claude/CLAUDE.md` → `~/claude-config/home/.claude/CLAUDE.md`, etc.).

### Why bootstrap doesn't just run `stow home`

The stow package contains a single directory (`home/.claude`). If `~/.claude` does not already exist, stow performs **tree folding** and makes `~/.claude` itself a single symlink into this repo. Claude Code then writes all of its runtime state (sessions, projects, shell snapshots, caches, credentials) through that symlink, dumping it into the repo working tree.

To prevent this, `bootstrap.sh` ensures `~/.claude` is a **real directory** before stowing, so only the individual config files/dirs are symlinked and runtime state stays in the real `~/.claude`. The script is idempotent and self-healing: if it finds `~/.claude` already folded into a single symlink, it un-folds it and moves any non-tracked runtime state back out of the repo.

## Uninstall

```bash
cd ~/claude-config
stow -D -t "$HOME" home
```

Removes the symlinks but leaves the files in this repo.
