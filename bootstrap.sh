#!/bin/bash

# Claude Config Bootstrap
# Symlinks Claude configuration into ~/.claude using GNU Stow, while keeping
# Claude Code's runtime state (sessions, projects, caches, credentials, ...)
# OUT of this repo.
#
# Why this is not just "stow home":
# The stow package contains a single directory (home/.claude). If ~/.claude does
# not already exist, stow "folds" the tree and makes ~/.claude a single symlink
# pointing into this repo. Claude Code then writes ALL of its runtime state
# through that symlink, dumping it into the repo working tree. To prevent that we
# ensure ~/.claude is a REAL directory first, so stow only links the individual
# config files/dirs and runtime state stays in the real ~/.claude.
#
# Usage: ./bootstrap.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_DIR="$SCRIPT_DIR/home/.claude"

if ! command -v stow &> /dev/null; then
    echo "ERROR: GNU Stow is not installed." >&2
    echo "Install it with: sudo apt install stow   (or: brew install stow)" >&2
    exit 1
fi

if [[ ! -d "$PKG_DIR" ]]; then
    echo "ERROR: Expected directory not found: $PKG_DIR" >&2
    exit 1
fi

# If ~/.claude is a single symlink, stow previously folded the whole tree.
# Un-fold it: replace the symlink with a real directory and move any runtime
# state (everything git does NOT track) back out of the repo.
if [[ -L "$HOME/.claude" ]]; then
    echo "Detected folded ~/.claude symlink; un-folding..."

    # Tracked top-level entries under home/.claude are the config we KEEP in the
    # repo. Everything else in the package dir is runtime state to evict.
    mapfile -t KEEP < <(git -C "$SCRIPT_DIR" ls-files 'home/.claude' \
        | awk -F/ 'NF>=3 {print $3}' | sort -u)
    if [[ ${#KEEP[@]} -eq 0 ]]; then
        echo "ERROR: could not determine tracked config entries; aborting so we" >&2
        echo "       don't accidentally move config out of the repo." >&2
        exit 1
    fi

    rm "$HOME/.claude"
    mkdir -p "$HOME/.claude"

    shopt -s dotglob nullglob
    for path in "$PKG_DIR"/*; do
        name="$(basename "$path")"
        keep=false
        for k in "${KEEP[@]}"; do
            [[ "$name" == "$k" ]] && { keep=true; break; }
        done
        if ! $keep; then
            echo "  evicting runtime state from repo -> ~/.claude/: $name"
            mv "$path" "$HOME/.claude/"
        fi
    done
    shopt -u dotglob nullglob
fi

# Ensure ~/.claude exists as a REAL directory so stow links individual entries
# instead of folding the whole tree into one symlink.
mkdir -p "$HOME/.claude"

echo "Stowing $PKG_DIR into $HOME/.claude ..."
cd "$SCRIPT_DIR"
# --adopt resolves conflicts where a config target already exists as a real file
# (e.g. Claude Code rewrote settings.json in place, replacing the symlink): stow
# moves the live file's content into the repo and recreates the symlink, so
# nothing is lost. Review/keep/discard the adopted content afterwards with git.
stow --adopt --target="$HOME" home

echo "Done."
echo "Config files are symlinked from this repo; runtime state lives in the real"
echo "~/.claude and is never written into the repo."
