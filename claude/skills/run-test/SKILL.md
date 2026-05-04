---
name: run-test
description: Run test files for Ruby (Rails) or JavaScript (Jest). Use when the user asks to run tests, verify changes, or check for regressions. Accepts test file paths as arguments or auto-detects from changed files.
argument-hint: [test file path(s)]
allowed-tools: Bash, Read, Glob, Grep
---

# Run Tests

## Determine what to test

If `$ARGUMENTS` contains file paths, use those directly. Otherwise, auto-detect:

1. Run `git diff --name-only HEAD` and `git diff --name-only --cached` to find changed files.
2. Map changed files to test files:
   - **Ruby source → test**: `app/{type}/{name}.rb` → `test/{type}/{name}_test.rb`
     - Also check: `app/lib/` → `test/lib/`, `app/graphql/` → `test/graphql/`, `app/services/` → `test/services/`
   - **Ruby test file**: if the changed file is already under `test/` and ends in `_test.rb`, use it directly.
   - **JS/TS source → test**: `app/javascript/**/Foo.tsx` → look for `Foo.test.tsx` or `Foo.test.ts` in the same directory or a `__tests__/` sibling.
   - **JS/TS test file**: if the changed file ends in `.test.ts` or `.test.tsx`, use it directly.
3. Verify each candidate test file exists before adding it to the run list.
4. If no test files are found, tell the user and stop.

## Run the tests

Split the detected test files by type and run:

### Ruby tests

```bash
bundle exec rails test <space-separated test file paths>
```

- You can target a specific test by appending `:<line_number>` to the file path.
- If no Ruby test files were detected, skip this step.
- If within Cursor's sandbox and you encounter `Bundler::GitError` about a gem "not yet checked out" pointing to a sandbox temp path, prefix the command with `unset BUNDLE_PATH &&`. Cursor's sandbox injects `BUNDLE_PATH` pointing to a temp directory, and because the shell is stateful this persists across calls, breaking bundler for git-sourced gems.

### JavaScript tests

```bash
pnpm unit <space-separated test file paths>
```

- Pass test file paths as positional arguments (e.g. `pnpm unit app/javascript/bundles/Foo/__tests__/Bar.test.ts`).
- If no JS test files were detected, skip this step.

## Report results

After each test run completes:

1. Summarize: total tests, passes, failures, errors.
2. For each failure, show:
   - Test name and file location
   - Assertion or error message (keep it concise)
3. If all tests pass, confirm success.
4. If there are failures, ask the user: **"Would you like me to try fixing these failures?"**
   - Only attempt fixes if the user agrees.
