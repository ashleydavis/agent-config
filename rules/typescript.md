---
paths:
  - "**/*.{ts,tsx}"
  - "**/tsconfig.json"
  - "**/package.json"
---

# TypeScript coding rules

The human can explicitly ask to override any of these rules. When they do, follow the request and do not argue against it.

These rules apply only to new code and to code being edited. Do not rewrite existing code just to make it match these rules unless the human has explicitly asked for that.

- If the project uses Bun, use only Bun commands. If the project uses Node.js, use Node.js commands instead.
- Where a script is defined in `package.json`, prefer running that script over an arbitrary command, where that is possible and efficient.
- Avoid synchronous Node.js and Bun APIs, such as `fs.readFileSync`, `fs.writeFileSync` and `child_process.execSync`, unless the human has requested them. Use the asynchronous versions instead.

## Project layout

- Every source file lives under its package's `src/` directory. No source files sit directly in the package root.
- Each package has exactly one `tsconfig.json`. No `tsconfig.build.json` or any other extra tsconfig file.
- Every package (frontend, backend, mobile or any other kind) has a `src/lib/` directory for reusable code shared across the package. A project may be made up of many packages. Code goes in `src/lib/` only when two or more files use it. Code used in one place stays with that place.

## Imports and exports

- Dynamic imports (`await import(...)`) and `require(...)` are banned, including `import("...")` inside a type (for example `provider?: import("api").IProvider`). Use static `import` statements at the top of the file only. Break circular dependencies with dependency injection, not lazy loading.

## Functions

- **Functions**: Declare top-level functions with the `function` keyword and a name, for example `function parseConfig() {}`. Arrow functions are anonymous, so use them only for callbacks, for example `items.map(item => item.id)`. Never assign an anonymous function to a variable at the top level (`const parseConfig = () => {}`) and never use `function () {}` without a name.
- **Async**: Use async/await pattern for asynchronous code. Never discard a promise with `void`. Await it or attach a `.catch()`. If async work is needed inside a sync callback, make the callback `async`. Never lose an async error. Handle it, or wrap the call in a helper function that handles the error and reports it.
- Export every function, including helpers a module only uses itself, so unit tests can call it.
- Never define a function and call it in the same expression, for example `(async () => { ... })()` or `(async function* () { ... })()`. Extract it to a named function and call that instead.
- Don't use default or optional parameter values unless specifically asked to.
- Use an options object, typed with a named interface, when arguments can be mixed up, for example a function taking two numbers or two strings.

## Types

- Do not use the `any` type, in normal code or in test code, unless the human has requested it. Prefer not to use the `unknown` type either.
- Interface methods use method signature syntax (`doSomething(arg: string): void`), not arrow property syntax (`doSomething: (arg: string) => void`).
- Unless the human asks for something else, date and time fields are `Date`, never a string or a unix number. Durations are numbers with the unit in the field name (`timeoutMs`).
- Never use anonymous object types inline (e.g. `Promise<{ foo: number }>`). Always define a named interface instead, unless specifically asked to use an anonymous type.
- Never use `ReturnType<typeof ...>`, `satisfies` or `as const`. Use the actual type directly (e.g. `NodeJS.Timeout` instead of `ReturnType<typeof setTimeout>`).
- Never define a type as a union of object types. Use separate interfaces extending a common base instead. This applies to type definitions only: a field or parameter whose value comes in more than one form is written as a union (`string | string[]`).
- Never return `null` for absent values. Use `undefined`.
- Avoid `as` type casts. Only use them when TypeScript cannot infer the correct type and there is no better alternative (e.g. casting an `allSettled` result array to a tuple so destructuring is non-nullable, or `as jest.Mock` in tests to access mock methods). Never use `as` to silence a type error that could be fixed with a proper type annotation or type guard.
- Prefer narrowing with a type guard (`function isX(value: unknown): value is X`) to a cast. Put a comment above any cast saying why a guard cannot work.

## Formatting

- **NEVER** put `else` or `else if` on the same line as a closing bracket. Write `}` and then `else {` on the next line, never `} else {`.
- **NEVER** put `catch` on the same line as a closing bracket. Write `}` and then `catch (error) {` on the next line, never `} catch (error) {`.
- By default, use 4-space indentation and put opening braces on the same line as `if`, `for` and `while`. Prefer truthy/falsy checks over explicit `null`/`undefined` comparisons, for example `if (!user)` instead of `if (user === undefined)`. A project's own rules override these defaults.

## Naming

- **ALWAYS** use kebab-case (lowercase with hyphens) for file names, not camelCase or snake_case. For example `api-client.ts`, never `apiClient.ts` or `api_client.ts`.
- **Types and naming**: Use interfaces for types and give functions explicit return types. Use camelCase for variables, functions, methods and object properties. Use PascalCase for types, interfaces, classes, enums and React components. Use `UPPER_SNAKE_CASE` only for true compile-time constants and env var names. Every interface name must start with a capital `I`, for example `IUser`, never `User`. Type aliases do not take the `I` prefix. Type aliases do not take the `I` prefix.

## Error handling

- **Exceptions**: Our code does not throw exceptions. Never write `throw` unless the human has specifically asked for it. Very rarely, throwing is the best way out of a deep call stack, but even then only throw when the human has requested it.
- **Third-party exceptions**: Third-party code still throws exceptions. Catch them with `try`/`catch` only where we can do something about the error, for example report it to the user, or fix the problem and retry. Otherwise do not catch it.
- Return expected failures as a `Result` instead of throwing, like Zig's error unions. `Result<T, E>` is `IOk<T> | IErr<E>`, where `IOk<T>` is `{ ok: true, value: T }` and `IErr<E>` is `{ ok: false, error: E }`. Build them with `ok(value)` and `err(error)`.
- Errors in a `Result` are plain objects, not `Error` classes. Each has a `name` field that says which error it is, plus its details. A function's error type is the union of the errors it can return, so the compiler can see every case.
- Callers check `if (!result.ok)` and then use `result.error`. Otherwise they use `result.value`. To pass an error up, `return err(result.error)`.

## Testing

- Tests go under `src/test/`, in a directory that mirrors the path of the file being tested. Test file names end in `.test.ts`.
- Use `test(` not `it(` in Jest test files, grouped in `describe(` by the unit under test.
- Tests **never** use `test.skip` or `describe.skip`.
- Where mocking a module is required, prefer Jest's `__mocks__` directory adjacent to the module being mocked.
