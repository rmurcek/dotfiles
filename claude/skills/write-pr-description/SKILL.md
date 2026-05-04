---
name: write-pr-description
description: Generate a PR description from the current branch diff against main, using the repo's PR template. Use when the user asks to write, draft, or generate a PR description.
allowed-tools: Bash, Read, Glob, Grep, Write
---

# Write PR Description

## 1. Gather context

Run these commands to understand the full scope of changes:

```bash
git branch --show-current
git log main..HEAD --oneline
git diff main...HEAD --stat
git diff main...HEAD
```

Also read the PR template:

```bash
cat .github/pull_request_template.md
```

## 2. Analyze the diff

Review every file in the diff. Categorize changes into:

- **New features** — new files, new endpoints, new UI components
- **Bug fixes** — corrected behavior, error handling
- **Refactors / chores** — renames, code movement, cleanup
- **Tests** — new or updated test coverage

For each category, note the _why_ not just the _what_.

## 3. Write the PR description

Fill in the PR template with:

### Description section

- Lead with a 1–2 sentence summary of the change's purpose (tied to the ticket/goal).
- Follow with a **Key changes** bullet list covering the important changes across backend, frontend, data layer, tests, etc.
- Mention any non-obvious decisions, trade-offs, or follow-ups.

### Screenshots/Stats section

- Leave placeholder comments for the user to add screenshots or Loom links.

### Type of change section

- Check the appropriate box(es) based on the diff analysis.

### Checklist section

- Leave all items unchecked for the author to verify.

### Footer

- If the branch name contains a ticket ID (e.g. `gro-664`, `ENG-123`), add it as a comment at the bottom: `<!-- GRO-664 -->`.

## 4. Save the output

First, get the current branch name and create the output directory:

```bash
BRANCH_NAME=$(git branch --show-current)
mkdir -p ".notes/$BRANCH_NAME"

## Style guidelines

- Be concise but thorough — reviewers should understand the full scope without reading every line of diff.
- Use precise verbs: "add" for new features, "fix" for bugs, "rename/refactor" for cleanup.
- Bold sub-labels in the key-changes list (e.g. **Backend**, **Frontend**, **GraphQL**).
- Don't repeat the template boilerplate comments in the final output — replace them with real content.
```
