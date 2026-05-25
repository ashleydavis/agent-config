#!/bin/bash

# Claude Config Bootstrap
# Symlinks Claude configuration into $HOME using GNU Stow.
#
# Usage: ./bootstrap.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v stow &> /dev/null; then
    echo "ERROR: GNU Stow is not installed."
    echo "Install it with: sudo apt install stow"
    exit 1
fi

if [[ ! -d "$SCRIPT_DIR/home" ]]; then
    echo "ERROR: Expected directory not found: $SCRIPT_DIR/home"
    exit 1
fi

echo "Symlinking $SCRIPT_DIR/home/ into $HOME using stow..."

cd "$SCRIPT_DIR"

# --adopt moves any existing real files into home/ before symlinking,
# preserving their content rather than failing on conflicts.
stow --adopt -t "$HOME" home

echo "Done. ~/.claude/ now contains symlinks into $SCRIPT_DIR/home/.claude/"
