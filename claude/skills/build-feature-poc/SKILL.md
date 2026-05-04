---
name: build-feature-poc
description: "Build a feature end-to-end: research → plan → self-review → TDD implement → local verify → self-review code → PR → CI green → review app → Playwright E2E → PM review → iterate. Fully autonomous."
argument-hint: "[feature description or reference to a plan/proposal file]"
allowed-tools: "*"
---

# Build Feature POC

Autonomous loop for building a feature from research through a verified, reviewed PR. Each phase has explicit entry/exit criteria and a gate that must pass before proceeding. Do NOT stop to ask for approval between phases — run the full loop, make judgment calls, and present the finished result.

## Phase 1: Research (read-only)

**Goal:** Understand the problem, existing code, and constraints before writing anything.

**Steps:**
1. Read any referenced PRDs, RFCs, proposals, or design docs
2. Launch 2-3 Explore agents IN PARALLEL to map:
   - **Agent 1:** Backend models, migrations, associations, and conventions for the area being changed
   - **Agent 2:** Frontend components, routes, data flow, and TypeScript types
   - **Agent 3:** Test patterns, factories, and fixtures for relevant models
3. Read critical files directly to verify agent findings (agents summarize — you need exact code)
4. Identify:
   - Extension points (where new code plugs into existing code)
   - Blast radius (what existing code could break)
   - Conventions to follow (naming, patterns, file locations)
   - Seed data needed for local testing (existing seeds, factories, or scripts required)

**Exit criteria:** You can name every file you'll create/modify, every model association you'll add, and every test you'll write.

## Phase 2: Plan

**Goal:** Create a concrete, ordered implementation plan.

**Steps:**
1. Launch a Plan agent with full context from Phase 1 (file paths, code patterns, model relationships)
2. Write the plan to the plan file with:
   - Tasks ordered by dependency (what blocks what)
   - Parallel opportunities identified
   - Size estimate per task (S/M/L)
   - Specific files to create/modify (absolute paths)
   - TDD order: test file → factory → implementation
   - Seed data or scripts needed for local manual testing
   - Playwright E2E test scenarios (happy path + key edge cases)
3. Create a TaskList tracking each task with dependencies (blockedBy)

**Exit criteria:** Plan file written, task list created, user has approved (via ExitPlanMode).

## Phase 3: Self-Review Plan (as PM + Staff Eng)

Before implementing, review your own plan from two perspectives:

**PM Review:**
- Does the plan cover all requirements from the PRD/spec?
- Is the UX coherent? Will users understand the navigation flow?
- Are there missing edge cases (empty states, error states, permissions)?
- Is there a testable happy path from the user's perspective?

**Staff Eng Review:**
- Does the architecture minimize blast radius on existing code?
- Are there N+1 query risks in the data loading paths?
- Is the migration safe and reversible?
- Are nullable FKs used correctly for backwards compatibility?
- Are new endpoints authorized correctly?

**Fix issues found** before proceeding. Update the plan file.

## Phase 4: Implement with TDD

**Goal:** Build each layer with tests first, verify as you go.

**Loop for each task:**
1. Mark task `in_progress`
2. **Write the test first** — model validations, associations, business logic
3. **Run the test** — confirm it fails (red)
4. **Write the factory** — sensible defaults, traits for common scenarios
5. **Write the implementation** — model, migration, controller, component
6. **Run the test** — confirm it passes (green)
7. **Run adjacent tests** — check for regressions in related models
8. Mark task `completed`

**Layer order (dependencies flow down):**
```
Layer 1: Migrations + Models + Factories + Tests
Layer 2: Admin UI (ActiveAdmin pages)
Layer 3: Backend API (controllers + GraphQL types + routes)
Layer 4: Frontend (types → hooks → routes → components)
Layer 5: Business logic (calculators, services)
```

**Parallelism:** After Layer 1 is done, Layers 2-5 can often be built in parallel since they depend on the models but not on each other.

**After each layer:** Run `pnpm typecheck`, `pnpm lint-fix-modified`, and the full test suite for changed files. Fix any failures before proceeding to the next layer.

## Phase 4.5: Deploy Safety (new tables only)

**Goal:** Ensure new models can be deployed without crashing the app boot.

**Why this matters:** Heroku's release task runs `boot_health_check` BEFORE migrations. Rails eager-loads all models in production. If a new model references a table that doesn't exist yet, the app crashes during boot and migrations never run. This is a chicken-and-egg problem specific to new tables.

**Checklist for every new model with a new table:**

1. **Wrap the model body in a `table_exists?` guard:**
   ```ruby
   class MyNewModel < ApplicationRecord
     if (table_exists? rescue false)
       has_paper_trail
       belongs_to :parent
       has_many :children
       enum :status, [...]
       validates :name, presence: true
     end
   end
   ```
   The `rescue false` handles both missing tables AND no DB connection (Docker build).

2. **Wrap new GraphQL types in the same guard:**
   ```ruby
   if (MyNewModel.table_exists? rescue false)
     class Objects::MyNewModelType < Types::BaseObject
       field :id
       # ...
     end
   end
   ```
   GraphQL's `BaseObject.infer_model_types!` introspects columns at class load.

3. **Wrap new ActiveAdmin registrations:**
   ```ruby
   begin
     return unless MyNewModel.table_exists?
   rescue StandardError
     return
   end
   ActiveAdmin.register MyNewModel do
     # ...
   end
   ```

4. **Guard any method on existing models that queries the new table:**
   ```ruby
   def complex?
     MyNewModel.table_exists? && my_new_models.exists?
   end
   ```

5. **Add `attribute :col, :string` before any `enum` on a new column** (per project convention for enum deploy safety).

**All guards are no-ops after first deploy when the table exists.** They can be removed in a follow-up PR after the migration has run in production.

## Phase 5: Local Verification

**Goal:** Prove the feature works in a running local environment, not just in tests.

### 5a. Seed data

Create or extend seed data so the feature is exercisable locally:
- Write a seed script or Rails runner script (prefix with `tmp_`, place in `.notes/<branch>/`)
- The script should create a realistic scenario: e.g., a complex cohort with semesters, courses, enrolled students, and grades
- Run it: `bundle exec rails runner .notes/<branch>/tmp_seed_complex_classroom.rb`

### 5b. Backend API verification

Start the dev server if not running. Use the `/local-dev` skill or:
```bash
p dev          # alias for pnpm dev — starts Rails + Webpack together
# or in a worktree:
pnpm dev
```
**Important:** Do NOT start `rails server` alone — webpack must also be running for pages to render. Wait 1-3 minutes for initial webpack compilation. Check readiness: `curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/` should return 302.

If you get 500 with PendingMigrationError: run `bundle exec rails db:migrate`.

Then:
- `curl` each new REST endpoint and verify the JSON shape matches the TypeScript types
- For GraphQL: use the GraphiQL interface or `curl` with a query body
- Check for: correct data, proper authorization (try without auth, try as wrong user), empty states (no semesters → returns null)

### 5c. Frontend verification

Open the local app in a browser and manually test:
- Navigate to the new pages (ProgramHomePage, CoursePage, etc.)
- Verify the golden path: the primary user flow works end-to-end
- Check edge cases: empty states, missing data, error handling
- Verify existing pages are NOT broken (load a simple-program classroom, confirm nothing changed)

### 5d. Playwright E2E tests (local)

Write Playwright tests that cover the golden path:
- Place in the project's Playwright test directory (check for existing patterns: `.playwright-mcp/`, `test/system/`, or `e2e/`)
- Test against the local dev server with seeded data
- Cover: page loads, key interactions (click course card → course page loads), data displays correctly
- Run: `npx playwright test <test-file>` or the project's Playwright runner

**Exit criteria:** Feature works in the browser. API returns correct data. Playwright tests pass locally. Existing pages unaffected.

## Phase 6: Self-Review Code (as Senior + Staff Eng)

**Goal:** Catch bugs before the PR.

**Steps:**
1. Launch a `feature-dev:code-reviewer` agent with the full file list. Ask it to focus on:
   - Bugs and logic errors
   - N+1 query risks
   - Security (authorization on new endpoints)
   - Missing edge cases
   - Test coverage gaps
   - Architecture concerns (blast radius)
2. For each critical/important finding:
   - Verify the issue is real (read the code yourself)
   - Fix it
   - Update or add a test that covers the fix
3. Run the full test suite again after fixes
4. Run `pnpm typecheck && pnpm lint-fix-modified` — must be clean

**Exit criteria:** All critical issues fixed, all tests pass, lint clean.

## Phase 7: Pre-PR Gate (all checks green locally)

**Goal:** Nothing is pushed until ALL local checks pass. This is a hard gate.

Run these in sequence and fix any failures before proceeding:

```bash
# 1. Unit tests (Ruby)
bundle exec rails test <all test files you created or modified>

# 2. Unit tests (JS, if applicable)
pnpm unit -- --testPathPattern="<relevant test files>"

# 3. TypeScript type checking
pnpm typecheck

# 4. Lint + format (all modified files)
pnpm lint-fix-modified

# 5. Playwright E2E (if written in Phase 5d)
npx playwright test <test-file>
```

**Every single one must pass.** If any fails, fix the issue, re-run all checks, and only proceed when everything is green.

**CRITICAL: Run `pnpm lint-fix-modified` before EVERY push, not just at this gate.** This runs eslint, rubocop, AND prettier on all modified files. We've seen CI fail on prettier for Ruby files that eslint doesn't check — `lint-fix-modified` catches all three.

**Exit criteria:** All unit tests pass. TypeScript compiles cleanly. Lint/format clean. Playwright E2E passes.

## Phase 8: Commit + PR

**Steps:**
1. `git add` only the files you changed (not -A, avoid secrets/screenshots)
2. Commit with a descriptive message covering what was built and key design decisions
3. If the self-review found and fixed bugs, commit those as a separate commit explaining what was caught
4. Push and create a **draft** PR with:
   - Summary: what was built, architecture decisions, what's NOT included
   - Test plan: checkboxes for automated tests + manual verification steps
   - Link to the Playwright test file(s) added

## Phase 9: CI Green + Review App

**Goal:** The PR passes all CI checks and is testable on a review app.

### 9a. Mark PR ready + trigger review app

1. Take the PR out of draft so CI runs:
   ```bash
   gh pr ready <pr-number> --repo <owner/repo>
   ```
2. Add the review app label to trigger a Heroku review app deployment:
   ```bash
   gh pr edit <pr-number> --repo <owner/repo> --add-label "review app"
   ```
   To find the correct label name: `gh label list --repo <owner/repo> | grep -i "review\|deploy\|heroku"`

### 9b. CI checks — poll autonomously

**CRITICAL: Use ScheduleWakeup to poll CI status automatically.** Do NOT stop and wait for the user to tell you to check. The loop is:

1. Check `gh pr checks <pr> --repo <repo>`
2. If still pending: `ScheduleWakeup` with 60-90s for deploy pipeline, 270s for ruby_tests
3. If any check fails: diagnose, fix locally, re-run pre-PR gate, push, restart polling
4. If all pass: immediately proceed to next step (don't report and wait)

```bash
# Track the deploy pipeline specifically:
gh pr checks <pr> --repo <repo> | grep -E "build_image|tag_review|deploy_review"
```

The deploy pipeline is sequential: `build_image` → `tag_review_app_image` → `deploy_review_app`. The fix is live when `deploy_review_app` shows `pass`. Verify by hitting the app URL.

### 9c. Review app

1. Wait for the review app deployment (check the PR for a Heroku deploy preview link — it usually appears as a PR comment or check)
2. The review app name follows the pattern `stepful-<branch>-<hash>.herokuapp.com`. Find it from the deploy job logs:
   ```bash
   gh api repos/<owner/repo>/actions/jobs/<deploy_job_id>/logs 2>&1 | grep "HEROKU_APP_NAME"
   ```
3. Once deployed, verify the review app URL is accessible:
   ```bash
   curl -s -o /dev/null -w "%{http_code}" https://<review-app-name>.herokuapp.com/
   ```

### 9d. Seed the review app

The review app has a fresh database — it won't have your test data. Seed it:

```bash
# Pipe a seed script via stdin (avoids shell escaping issues with inline Ruby):
cat .notes/<branch>/tmp_seed_<name>.rb | \
  heroku run --app <review-app-name> --no-tty -- \
  bash -c 'cd /approot && bundle exec rails runner -'
```

The working directory on Heroku Docker containers is `/approot` (not `/app`). Always use `--no-tty` when piping stdin. Verify the output shows your seed data was created.

### 9e. Playwright E2E on review app

Run Playwright tests against the review app URL:
```bash
PLAYWRIGHT_BASE_URL=<review-app-url> npx playwright test <test-file>
```

If the review app needs seed data, run the seed script against the review app's database or use an API-based seeding approach.

**Exit criteria:** CI fully green. Review app deployed and accessible. Playwright E2E passes on review app.

## Phase 10: PM + Designer Review

**Goal:** The feature looks and works correctly from a product perspective.

Review the feature on the review app as if you are a PM and designer:

**PM lens:**
- Does the feature match the PRD requirements?
- Is the information hierarchy correct? (most important info is most visible)
- Are empty states handled gracefully? (no broken layouts, helpful messages)
- Does the navigation flow make sense? (can the user get back, forward, to related pages?)

**Designer lens:**
- Does it follow the design system? (correct colors, spacing, typography from SDS)
- Is it responsive? (check mobile viewport via browser dev tools or Playwright `--viewport`)
- Are interactive elements obviously interactive? (hover states, cursor changes)
- Is loading state handled? (skeleton/shimmer, not blank page)

For each issue found:
1. Fix it
2. Re-run the pre-PR gate (Phase 7)
3. Push and verify CI stays green

**Exit criteria:** Feature matches requirements. UI is clean and responsive. No broken states.

## Phase 11: Finalize

1. Update the PR description with any changes made during review
2. Mark the PR as ready for review (remove draft status) if the user wants it reviewed by the team
3. Summarize: what was built, what was caught in self-review, what's still TODO

---

## Key Principles

### TDD is not optional
Write the test before the code. Every time. The test proves the requirement, the code satisfies the requirement, and the test catches regressions. Skipping TDD to "go faster" creates bugs that take longer to find than the test took to write.

### Tests pass locally before push — always
Never push code that hasn't passed `rails test`, `pnpm typecheck`, and `pnpm lint-fix-modified` locally. CI is a safety net, not the first line of defense. Pushing broken code wastes CI minutes and blocks other PRs.

### Local dev verification is not optional
Unit tests verify code correctness. Local dev verification verifies feature correctness. A test can pass while the feature is broken (wrong data shape, missing route, authorization misconfiguration). Start the server, seed data, and use the feature before creating the PR.

### Playwright E2E tests run twice
First against local dev (Phase 5d) to catch issues fast. Then against the review app (Phase 9c) to catch environment-specific issues (missing env vars, different DB state, CDN differences). Both must pass.

### Fix bugs in the review, not after the PR
The self-review (Phase 6) is the highest-leverage step. A bug caught here costs 5 minutes to fix. The same bug caught in CI costs 30 minutes. In production, it costs hours. Invest in the review.

### Blast radius over elegance
When extending an existing system, prefer nullable FKs and optional associations over type columns and STI. The goal is: existing code paths are unchanged, new code paths are additive. If a simple program student's page loads the same queries as before your change, you've succeeded.

### Conventions over invention
Read 3 examples of how the codebase does X before writing your version of X. Match the naming, file location, test structure, and error handling patterns. The codebase is the style guide.

### Self-review prompts
When launching the code-reviewer agent, give it:
- The complete file list with paths
- What the code is supposed to do (so it can check correctness, not just style)
- Explicit focus areas: "focus on N+1 queries, authorization, and blast radius"
- Confidence threshold: "only report issues with >80% confidence"

### Parallelism
- Use parallel Explore agents in Phase 1
- Use parallel Bash calls for independent commands (migrations, file creation)
- After Layer 1, Layers 2-5 are often independent — build them in parallel batches
- Run typecheck and lint in parallel with each other
