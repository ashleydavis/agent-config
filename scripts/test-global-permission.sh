#!/usr/bin/env bash
#
# Checks the global permission rules in this repo against the examples written into them.
#
# The rules live in home/.claude, which stows into $HOME, so they are not this repo's own project
# rules and /permissions:examples:test does not reach them. This runs the same check the engine
# provides, pointed at them.
#
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

usage() {
    cat <<USAGE
Checks the global permission rules in home/.claude against the examples written into them.

Usage:
  scripts/test-global-permission.sh <engine-dir> [options]

<engine-dir> is a checkout of https://github.com/ashleydavis/expressive-permissions, normally
~/expressive-permissions.

Options:
  --filter <text>   check only the examples whose command or file contains the text
  --list            print the collected examples without deciding them
  --help            print this

Runs from anywhere and leaves the working directory as it found it.
USAGE
}

if [ "$#" -eq 0 ] || [ "${1:-}" = "--help" ] || [ "${1:-}" = "-h" ]; then
    usage
    exit 0
fi

engine_dir="$1"
shift

if [ ! -f "$engine_dir/package.json" ]; then
    echo "No permissions engine at $engine_dir" >&2
    exit 1
fi

# The cd happens in a subshell, so the calling shell stays where it was.
(cd "$engine_dir" && bun run check-config "$repo_dir/home" "$@")
