# React rules

These rules apply to projects that use React. They add to the TypeScript rules.

The human can explicitly ask to override any of these rules. When they do, follow the request and do not argue against it.

These rules apply only to new code and to code being edited. Do not rewrite existing code just to make it match these rules unless the human has explicitly asked for that.

- The frontend splits its `src/` into `pages/` (route-level), `components/` (visual parts shared across multiple pages) and `lib/` (non-UI code). Each page lives in its own directory as `pages/<page>/index.tsx`, with components used only by that page colocated under `pages/<page>/components/`. A component moves to `components/` only once more than one page needs it.
- UI code is a thin layer over unit testable code. Factor non-trivial UI logic out into a plain function under a `lib/` directory and unit test the plain function. Do not extract or test trivial logic only to gain a test.

## Naming

- React component names stay PascalCase, for example `function UserProfile`. Only the file name is kebab-case, for example `user-profile.tsx`.
