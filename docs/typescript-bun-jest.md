# How to set up TypeScript, Bun and Jest

Bun installs the packages and runs the scripts. Jest runs the tests, and ts-jest turns each TypeScript file into CommonJS before Jest loads it. Jest starts through its own `#!/usr/bin/env node` line, so it runs on whatever Node is on the PATH; nothing in the project pins Node for it.

## `package.json`

```json
{
    "type": "module",
    "scripts": {
        "test": "jest"
    },
    "devDependencies": {
        "@jest/globals": "<exact version>",
        "@types/node": "<exact version>",
        "jest": "<exact version>",
        "ts-jest": "<exact version>"
    }
}
```

- The test script is `jest` and nothing else: no `NODE_OPTIONS`, no `--experimental-vm-modules`, no `bun --bun`.
- Run it with `bun run test`.
- No `jest` key: the config is in `jest.config.js`.

## `tsconfig.json`

```json
{
    "compilerOptions": {
        "target": "ES2022",
        "module": "ESNext",
        "moduleResolution": "bundler",
        "esModuleInterop": true,
        "strict": true,
        "skipLibCheck": true
    }
}
```

- `module` is `ESNext` and `moduleResolution` is `bundler`. Never `NodeNext` or `Node16`: ts-jest switches `ESNext` to CommonJS when Jest is not in ES module mode, but leaves `NodeNext` as ES modules, and every suite then fails with "Must use import to load ES Module".
- `esModuleInterop` is on, so `import fs from "node:fs"` works once the file is CommonJS.

## `jest.config.js`

```js
export default {
    preset: "ts-jest",
    testEnvironment: "node",
    modulePathIgnorePatterns: [
        "dist",
    ],
    testMatch: [
        "**/src/**/*.test.ts",
    ],
    testPathIgnorePatterns: [
        "/node_modules/",
        "/dist/",
    ],
};
```

- No `useESM`, no `extensionsToTreatAsEsm` and no `tsconfig` override inside the Jest config.
- When relative imports carry their `.ts` extension and the tsconfig sets `rewriteRelativeImportExtensions`, ts-jest writes them as `.js`. Add this so Jest finds the TypeScript file:

  ```js
  moduleNameMapper: {
      "^(\\.{1,2}/.*)\\.js$": "$1",
  },
  ```

## Code

- No `import.meta` in any file a test loads. It is a syntax error in CommonJS. Pass a directory in as an argument, or in a test use `__dirname` and `__filename`.
- No dynamic `import()`. It needs Jest's ES module mode, which this setup does not use.

## Never

- `bunfig.toml` for Jest.
- `bun --bun jest`: Jest under Bun's own runtime breaks on stack formats, timers and values made in another realm.
- `--experimental-vm-modules` or any other Node flag in the test script.
