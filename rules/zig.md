---
paths:
  - "**/*.zig"
  - "**/build.zig.zon"
---

# Zig coding rules

The human can explicitly ask to override any of these rules. When they do, follow the request and do not argue against it.

These rules apply only to new code and to code being edited. Do not rewrite existing code just to make it match these rules unless the human has explicitly asked for that.

- Watch for buffer bleeds: a buffer that is not fully used, with its padding not zeroed, which can leak data.
- Show your intent with division: use `@divExact()`, `@divFloor()` or `std.math.divCeil()` so the reader knows you have thought about rounding.
- Assert the relationships between compile-time constants, to check and document invariants and type sizes before the program runs.

## Project layout

To be added.

## Imports and exports

- Every `@import` goes in a `const` declaration at the top of the file. Never write `@import` anywhere else: not inside a function, a type, a parameter list or an expression.

## Functions

- When a function calls a helper or callback of its own, prefix the helper with the caller's name: `read_sector()` and `read_sector_callback()`.
- Callbacks go last in the list of parameters, because they are invoked last.
- Use an options struct when arguments can be mixed up. A function taking two `u64`s must use one. If an argument can be `null`, name it so `null` at the call site is clear. Pass dependencies like an allocator positionally, most general first.
- If an argument over 16 bytes should not be copied, pass it as `*const`, to catch accidental copies on the stack.
- Construct larger structs in place by passing an out pointer to `init`, rather than returning them by value. If any field is built in place, build the whole containing struct in place too.

## Types

- When porting a TypeScript interface to Zig, never hand-roll a vtable (a struct of two or more function pointers). In order of preference, use the standard library's own interface, a plain struct of values, one function pointer with a context or a tagged union.
- Use explicitly sized types like `u32` for everything. Avoid architecture-specific `usize`.

## Formatting

- Run `zig fmt` only on code that is already formatted with it. Never let it cause large formatting-only changes to existing code.
- Hard limit all lines to at most 100 columns. To wrap a signature, call or data structure, add a trailing comma and let `zig fmt` do the rest.
- Use blank lines to group a resource allocation with its `defer`: a blank line before the allocation and after the `defer`, so leaks are easier to spot.

## Naming

- Use `snake_case` for function, variable and file names.
- Give names meaning beyond their type. `gpa: Allocator` and `arena: Allocator` say more than `allocator: Allocator`.

## Error handling

To be added.

## Testing

- Tests go in their own file beside the code: `config.zig` is tested by `config.test.zig`. This keeps code changes and test changes apart in a diff.
- The code file imports its test file at the bottom, or the tests never run:

  ```zig
  test {
      _ = @import("config.test.zig");
  }
  ```

  A package root that re-exports its modules must also reference each one in its own `test` block, or their tests never run.
- Every Zig test uses `std.testing.allocator`, so a leak fails the test rather than being invisible, and everything that can fail to allocate gets a `std.testing.checkAllAllocationFailures` test.
