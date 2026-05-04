---
name: new-worktree
description: Create a new git worktree with a new branch and open it in your editor
disable-model-invocation: true
argument-hint: <branch-name>
allowed-tools: Bash
---

Create a new git worktree based off a new branch from main, install dependencies, and open it in your editor.

## Steps

1. The branch name is `$ARGUMENTS`. If no argument was provided, ask the user for a branch name.
2. Get the repo root: `git rev-parse --show-toplevel`
3. Derive a directory name from the branch (replace `/` with `-`). The worktree directory should be a sibling of the repo root, e.g. if the repo is at `/Users/me/stepful`, create the worktree at `/Users/me/stepful-<sanitized-branch-name>`.
4. Create the worktree:
   - First check if the branch already exists: `git rev-parse --verify <branch-name>`
   - If the branch exists, create the worktree from the existing branch:
     ```
     git worktree add <worktree-path> <branch-name>
     ```
   - If the branch does not exist, create a new branch from main:
     ```
     git worktree add <worktree-path> -b <branch-name> main
     ```
5. Symlink gitignored config files from the original repo into the new worktree:
   - `.env`
   - `.env.development.local`
     Only symlink files that exist in the original repo.
6. Install dependencies in the new worktree:
   ```
   cd <worktree-path> && bundle install && pnpm install
   ```
7. Open the new worktree in the user's editor:
   - Use `$VISUAL` if set, otherwise fall back to `code`
   - Run: `${VISUAL:-code} <worktree-path>`
8. Report the worktree path and confirm everything is ready. Remind the user that the database is shared across worktrees.
