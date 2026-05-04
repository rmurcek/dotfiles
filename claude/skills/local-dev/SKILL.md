---
name: local-dev
description: "Start, stop, and manage the local development environment. Use when the user says 'start dev', 'p dev', 'run the server', or needs to test changes locally in a browser."
argument-hint: "[start|stop|status|restart]"
allowed-tools: Bash, Read, Grep, Glob, mcp__chrome-devtools__navigate_page, mcp__chrome-devtools__take_screenshot, mcp__chrome-devtools__take_snapshot, mcp__chrome-devtools__fill, mcp__chrome-devtools__click, mcp__chrome-devtools__wait_for
---

# Local Dev Environment

## Starting the dev server

The local dev environment requires both Rails AND Webpack running together. Use:

```bash
p dev
```

This is an alias that runs `pnpm dev`, which executes:
- Rails server (Puma) on port 3000
- Webpack dev server (with HMR) on port 3035

Both must be running for pages to render. Rails serves the app, Webpack compiles and serves JS assets (including server_rendering.js for SSR).

**Do NOT** start `bundle exec rails server` alone — pages will fail with `Errno::ENOENT: No such file or directory @ rb_file_s_mtime - public/packs-dev/server_rendering.js`.

If `p dev` is not available (e.g., in a worktree), use `pnpm dev`.

## Checking if the server is ready

After starting, webpack takes 1-3 minutes for initial compilation. Check readiness:

```bash
curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/
```

- 302 = server up (redirect to login)
- 500 with PendingMigrationError = run `bundle exec rails db:migrate`
- 500 with ENOENT server_rendering.js = webpack still compiling, wait
- Connection refused = server not running

## Logging in for testing

1. Navigate to http://localhost:3000
2. Enter email and password
3. If no password set: `bundle exec rails runner "u = User.find_by(email: 'EMAIL'); u.password = u.password_confirmation = 'devpassword123'; u.save!(validate: false)"`

### Testing as a student (impersonation)

The admin user typically has no enrollments, so visiting `/courses/:slug` will 404. To test student flows:

1. Log in as admin first
2. Find the student user in ActiveAdmin: `/activeadmin/users/:id`
3. Click the **"Impersonate"** button on their profile page
4. You'll be redirected to the student's classroom view
5. To stop: visit `/activeadmin/users/stop_impersonating`

**Note:** Some student pages require Socratease credentials configured. If you see a `TypeError` about `nil into String` from `Socratease.generate_init_payload`, that's a missing credential issue — not a bug in your code.

## Seeding test data

Check `.notes/<branch>/tmp_seed_*.rb` for existing seed scripts.
Run: `bundle exec rails runner .notes/<branch>/tmp_seed_<name>.rb`

### Seeding a review app

Review apps have fresh databases. Seed them by piping a script via stdin:
```bash
cat .notes/<branch>/tmp_seed_<name>.rb | \
  heroku run --app <review-app-name> --no-tty -- \
  bash -c 'cd /approot && bundle exec rails runner -'
```
The Heroku container working directory is `/approot`. Always use `--no-tty` when piping.

## Worktree database sharing

**Important:** Worktrees share the same local database. Migrations run in one worktree affect all others. If you create new tables in a feature branch worktree, those tables will exist when you switch back to main. This is usually fine — Rails ignores extra tables — but be aware that:
- `db:rollback` in one worktree can break another
- Seed data created in one worktree is visible in all others

## Stopping the server

```bash
kill $(lsof -ti:3000) $(lsof -ti:3035) 2>/dev/null
```

## Browser testing with Chrome DevTools MCP

1. `mcp__chrome-devtools__navigate_page` — go to URL
2. `mcp__chrome-devtools__take_snapshot` — get a11y tree for uids
3. `mcp__chrome-devtools__fill` — type into inputs (use uid from snapshot)
4. `mcp__chrome-devtools__click` — click elements (use uid from snapshot)
5. `mcp__chrome-devtools__wait_for` — wait for text to appear after navigation
6. `mcp__chrome-devtools__take_screenshot` — capture visual state

Always take a snapshot before interacting to get uid values.
