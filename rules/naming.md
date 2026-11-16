# Naming rules

These rules apply to names in every language: variables, functions, types, files, modules and directories. The language rules files add to them.

- Get the nouns and verbs just right. Take time to find the name that captures what a thing is or does.
- Never use single-character variable names, including arrow function parameters (e.g. use `fileName => ...` not `f => ...`). Use long descriptive identifiers.
- Name a function that does something with a verb and the thing it acts on (`readSources`). Name a function that answers yes or no starting with `is`, `has`, `was`, `can` or `may` (`isEmpty`). Name a function that only works something out after what it returns, with no preposition glued on (`pathCounts`, not `countsFor`). Use the exact verb (`print`, not `say`; `read`, not `get`) and never `handle`.
- Naming a function `find` when it does not search for anything is unacceptable. Use `find` only for a function that searches for something that may not be there.
- Name a type for what it is, never for a metaphor such as "sink", "pipeline", "bucket", "pump", "harness" or "hook": `AnnotationWriter`, not `AnnotationSink`. Do not invent a term where a plain one exists, and do not abbreviate unless the abbreviation is already the domain's own word.
- A name that needs `and` in it is two functions. Split it and the two names come out on their own.
- Prefer not to give code a generic name such as `utils`, `helpers`, `support`, `common`, `misc`, `shared` or `manager`, for a file, module, directory, type or function. A generic name says only that something was put there, not what it is. Name what it holds or does.
- Put units and qualifiers last in a name, most significant word first: `latencyMsMax`, not `maxLatencyMs`.
- Use proper capitalisation for acronyms: `VSRState`, not `VsrState`.
- Where possible, give related names the same number of characters so they line up: `source` and `target`, not `src` and `dest`.
- Prefer nouns to adjectives or "-ing" words in names, because a noun can be used directly in docs and conversation: `pipeline`, not `preparing`.
