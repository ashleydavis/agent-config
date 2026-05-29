Check the current plan for overengineering and propose ways to simplify it.

Use the plan from the current conversation, or read the most recent 5 files in `docs/plans/new/` and ask the user which to use.

Analyse the plan for overengineering. Look for:

**Premature abstraction** — Interfaces, base classes, factories, or generics introduced before there is a second use case. Configuration or extension points nothing needs yet.

**Unnecessary scope** — Steps that solve problems the plan does not actually have. Features, options, or edge cases that were never asked for. Gold-plating.

**Excess indirection** — Layers, wrappers, or pass-through functions that add no behaviour. Splitting things across many files or modules when one would do.

**Premature optimization** — Caching, indexing, batching, parallelism, or hand-tuned code added for performance the plan has not shown it needs. Optimising paths that are not hot, or before there is a measurement showing a problem.

**Heavyweight choices** — New dependencies, frameworks, services, or patterns where a few lines of plain code would suffice. Caching, queues, or async where it is not needed.

**Speculative generality** — "We might need this later" design. Handling inputs or states that cannot occur. Knobs and flags no one will turn.

**Unnecessary testing** — Tests for trivial code, getters, or framework behaviour. Exhaustive cases where one or two would do. Testing implementation details rather than behaviour. Mocking so heavily the test no longer proves anything.

**Unnecessary DRYing** — Extracting shared helpers, base classes, or utilities to remove duplication that is incidental rather than real. Some duplication is fine and often clearer than a forced abstraction. Prefer leaving two similar pieces of code separate unless they genuinely change together.

**Future proofing** — Building for requirements that do not exist yet. Versioning, plugin systems, or migration paths for a future that may never arrive. Designing for scale, platforms, or use cases no one has asked for.

**Duplication of existing functionality** — Building something the codebase, language, or standard library already provides.

Produce a numbered list of simplification options. For each option give:

1. A short title.
2. What in the plan is overengineered and why.
3. The simpler alternative and what is lost or gained by it.

If the plan is already appropriately simple, say so and do not invent options.

Then ask the user (using the question tool) which options they want to apply: some, all, or none. Do not change the plan until they confirm.

Once confirmed, apply the chosen simplifications and update the plan accordingly.
