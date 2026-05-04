---
name: remove-worktree
description: Remove the current git worktree
disable-model-invocation: true
allowed-tools: Bash
---

Remove the current git worktree. This should be run from within the worktree you want to remove.

## Steps

1. Get the repo root and the main worktree path:
   ```
   git worktree list
   ```
2. Determine the current working directory. If it matches the main worktree (the first entry in `git worktree list`), refuse and tell the user this command should only be run from a secondary worktree.
3. Remove the current worktree from the main repo:
   ```
   git -C <main-worktree-path> worktree remove <current-worktree-path>
   ```
   If git refuses because there are modified or untracked files, inform the user and ask if they want to force removal with `--force`.
4. Confirm the worktree was removed and the branch is now free to check out from the main repo.
