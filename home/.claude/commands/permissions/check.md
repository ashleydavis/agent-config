---
description: Check a shell command for safety: explain which parts are safe (and why) and which are potentially dangerous, then suggest allowing the safe parts.
---

Check a shell command and report which parts of it are safe and which are potentially dangerous, with the concrete reason for each. This does not change any config: it is an assessment plus a suggestion. Use it before allowing a command, or any time you want to understand the risk of running something.

Use the safety rubric in [REVIEWING-DECISIONS.md](~/claude-permissions/docs/REVIEWING-DECISIONS.md) (step 4, "Judge whether a sub-command is safe"). Do not rely on memory for the rubric: read the doc, since it changes.

1. Get the command from the selection, a command-line argument, or the user's message. If there is none, ask the user to paste it.
2. Break it into leaf sub-commands the way the permissions engine would (split on pipes, `&&`, `||`, `;`, and command substitutions like `$(...)`). Judge the specific invocation, including its flags and path arguments, not just the binary name.
3. Classify each sub-command with the safety rubric:
   - **Safe / read-only**: say why it only observes state (no writes, no network, no arbitrary code, no destructive flags).
   - **Mutating but routine**: say what local, recoverable state it changes.
   - **Dangerous**: name the concrete risk (destructive, hard to reverse, exfiltrates data, hits the network, escalates privilege, or runs arbitrary code).
4. Report the breakdown: lead with a one-line verdict for the whole command (its class is the most dangerous of its parts), then one line per sub-command giving its class and the reason.
5. (Optional) To show what the live engine currently decides for the command without running it, use the `analyze_permission` MCP tool ([MCP-SERVER.md](~/claude-permissions/docs/MCP-SERVER.md)) or the offline [REPL](~/claude-permissions/docs/REPL.md).

## Next

If any parts are **Safe / read-only**, suggest the developer run:
- `/permissions:allow`: to add allow rules for those safe parts (it re-checks the safety rubric before writing anything).

Do not suggest allowing parts you classified as **Dangerous**. For those, suggest `/permissions:deny` if they should be blocked outright.
