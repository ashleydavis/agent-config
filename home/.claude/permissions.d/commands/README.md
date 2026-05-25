# commands

Command descriptor YAML files for the Claude Code permissions plugin. Each file describes the flag arity and positional kinds for one or more shell commands, allowing the Bash parser to correctly identify which flags consume the next token as a value.

## Why this exists

Without a descriptor, every flag defaults to arity 0 (boolean). This means `--context prod-cluster` would be parsed as flag `--context` with no value and `prod-cluster` as a separate positional — causing `options: {context: prod-cluster}` rules to silently not match. Descriptor files fix the parsing so permission rules work correctly.

## File format

```yaml
mycommand:
  description: Human-readable summary
  source: https://link-to-official-docs
  flags:
    n|long-name:       # pipe separates short and long forms
      arity: 1         # 1 = consumes next token as value; 0 = boolean
      kind: string     # string = opaque value; path = file path (matched by cmd rules)
      description: What this flag does
  positionals:
    - kind: path       # kind of the first positional argument
      description: What it is
    - kind: path
      description: What the rest are
      variadic: true   # captures all remaining positionals from this index onward
```

Only value-taking flags (arity 1) need to be listed. Boolean flags can be omitted; they default to arity 0.

## Files

| File | Commands | Source |
|---|---|---|
| `bun.yaml` | `bun` | https://bun.sh/docs/cli |
| `cat.yaml` | `cat` | https://www.gnu.org/software/coreutils/manual/html_node/cat-invocation.html |
| `find.yaml` | `find` | https://www.gnu.org/software/findutils/manual/html_mono/find.html |
| `gh.yaml` | `gh` | https://cli.github.com/manual/gh |
| `git.yaml` | `git` | https://git-scm.com/docs/git |
| `grep.yaml` | `grep` | https://www.gnu.org/software/grep/manual/grep.html |
| `head.yaml` | `head` | https://www.gnu.org/software/coreutils/manual/html_node/head-invocation.html |
| `helm.yaml` | `helm` | https://helm.sh/docs/helm/helm/ |
| `jq.yaml` | `jq` | https://jqlang.github.io/jq/manual/ |
| `kubectl.yaml` | `kubectl` | https://kubernetes.io/docs/reference/kubectl/ |
| `sed.yaml` | `sed` | https://www.gnu.org/software/sed/manual/sed.html |
| `sort.yaml` | `sort` | https://www.gnu.org/software/coreutils/manual/html_node/sort-invocation.html |
| `tail.yaml` | `tail` | https://www.gnu.org/software/coreutils/manual/html_node/tail-invocation.html |
| `tee.yaml` | `tee` | https://www.gnu.org/software/coreutils/manual/html_node/tee-invocation.html |
| `wc.yaml` | `wc` | https://www.gnu.org/software/coreutils/manual/html_node/wc-invocation.html |

## Layer order

Home descriptors (`~/.claude/permissions.d/commands/`) are loaded first. Project descriptors (`.claude/permissions.d/commands/`) are merged on top and win on any conflicting flag.
