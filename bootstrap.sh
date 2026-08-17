#!/bin/bash

# Agent Config Bootstrap
# Symlinks Claude and Cursor configuration into ~/.claude and ~/.cursor using
# GNU Stow, while keeping each tool's runtime state OUT of this repo.
#
# Why this is not just "stow home":
# The stow package contains home/.claude and home/.cursor. If ~/.claude or
# ~/.cursor does not already exist, stow "folds" the tree and makes that path a
# single symlink pointing into this repo. The tool then writes ALL of its runtime
# state through that symlink, dumping it into the repo working tree. To prevent
# that we ensure each target is a REAL directory first, so stow only links the
# individual config files/dirs and runtime state stays in the real home dirs.
#
# Usage: ./bootstrap.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v stow &> /dev/null; then
    echo "ERROR: GNU Stow is not installed." >&2
    echo "Install it with: sudo apt install stow   (or: brew install stow)" >&2
    exit 1
fi

# Un-fold a target dir if it is a single symlink into this package, then ensure
# it exists as a real directory before stow.
unfold_if_needed() {
    local tool_name="$1"   # e.g. claude
    local home_target="$2" # e.g. $HOME/.claude
    local pkg_dir="$3"     # e.g. $SCRIPT_DIR/home/.claude
    local git_prefix="$4"  # e.g. home/.claude

    if [[ ! -d "$pkg_dir" ]]; then
        echo "ERROR: Expected directory not found: $pkg_dir" >&2
        exit 1
    fi

    if [[ -L "$home_target" ]]; then
        echo "Detected folded $home_target symlink; un-folding..."

        mapfile -t KEEP < <(git -C "$SCRIPT_DIR" ls-files "$git_prefix" \
            | awk -F/ 'NF>=3 {print $3}' | sort -u)
        if [[ ${#KEEP[@]} -eq 0 ]]; then
            echo "ERROR: could not determine tracked config entries for $tool_name; aborting so we" >&2
            echo "       don't accidentally move config out of the repo." >&2
            exit 1
        fi

        rm "$home_target"
        mkdir -p "$home_target"

        shopt -s dotglob nullglob
        for path in "$pkg_dir"/*; do
            name="$(basename "$path")"
            keep=false
            for k in "${KEEP[@]}"; do
                [[ "$name" == "$k" ]] && { keep=true; break; }
            done
            if ! $keep; then
                echo "  evicting runtime state from repo -> $home_target/: $name"
                mv "$path" "$home_target/"
            fi
        done
        shopt -u dotglob nullglob
    fi

    mkdir -p "$home_target"
}

# Remove package-entry symlinks that point outside this repo. --adopt only
# handles plain files; leftovers from a previous install path (e.g. the repo
# was renamed from claude-config -> agent-config) are "not owned by stow" and
# abort the whole run. Runtime dirs/files that are not package entries are
# left alone.
clear_foreign_package_symlinks() {
    local home_subdir="$1" # e.g. .claude
    local git_prefix="$2"  # e.g. home/.claude

    mapfile -t ENTRIES < <(git -C "$SCRIPT_DIR" ls-files "$git_prefix" \
        | awk -F/ 'NF>=3 {print $3}' | sort -u)
    if [[ ${#ENTRIES[@]} -eq 0 ]]; then
        return 0
    fi

    for name in "${ENTRIES[@]}"; do
        local dest="$HOME/$home_subdir/$name"
        [[ -L "$dest" ]] || continue

        local resolved
        resolved="$(realpath -m "$dest")"
        if [[ "$resolved" != "$SCRIPT_DIR"/* ]]; then
            echo "  removing stale symlink $dest (-> $(readlink "$dest"))"
            rm "$dest"
        fi
    done
}

unfold_if_needed "claude" "$HOME/.claude" "$SCRIPT_DIR/home/.claude" "home/.claude"
unfold_if_needed "cursor" "$HOME/.cursor" "$SCRIPT_DIR/home/.cursor" "home/.cursor"

echo "Clearing stale package symlinks (if any) ..."
clear_foreign_package_symlinks ".claude" "home/.claude"
clear_foreign_package_symlinks ".cursor" "home/.cursor"

echo "Stowing $SCRIPT_DIR/home into $HOME ..."
cd "$SCRIPT_DIR"
# --adopt resolves conflicts where a config target already exists as a real file
# (e.g. a tool rewrote settings.json or AGENTS.md in place, replacing the symlink):
# stow moves the live file's content into the repo and recreates the symlink, so
# nothing is lost. Review/keep/discard the adopted content afterwards with git.
stow --adopt --target="$HOME" home

echo "Done."
echo "Config files are symlinked from this repo; runtime state lives in the real"
echo "~/.claude and ~/.cursor and is never written into the repo."
