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

The `home/` subdirectory is the GNU Stow "package" — its contents are symlinked into `$HOME`.

## Prerequisites

GNU Stow:

```bash
# Ubuntu/Debian
sudo apt install stow

# macOS
brew install stow
```

## Install

```bash
git clone <repo-url> ~/claude-config
cd ~/claude-config
./bootstrap.sh
```

This runs `stow --adopt -t "$HOME" home`, which symlinks everything under `home/` into `$HOME` (so `~/.claude/CLAUDE.md` → `~/claude-config/home/.claude/CLAUDE.md`, etc.).

If `~/.claude/` already contains real files (not symlinks), `--adopt` will move them into this repo rather than overwriting them — review with `git status` after.

## Uninstall

```bash
cd ~/claude-config
stow -D -t "$HOME" home
```

Removes the symlinks but leaves the files in this repo.
