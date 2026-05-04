---
name: prod-replica-query
description: Run a read-only SQL query against the Stepful production follower (read replica) database. Use when the user asks to check production data, investigate a bug, or compare records against prod.
argument-hint: "<SQL query or description of what to look up>"
allowed-tools: Bash
---

# Query the Production Read Replica

## Get the connection URL

```bash
heroku config:get FOLLOWER_1_DATABASE_URL --app stepful
```

Save the result as `$FOLLOWER_URL`.

## Run the query

```bash
psql "$FOLLOWER_URL" -c "<SQL>"
```

- This is a **read-only follower** — SELECT only, no writes.
- The database is `postgres` (PostgreSQL 15), standard Rails schema.
- Table names are plural snake_case: `curricula`, `cohorts`, `enrollments`, `users`, etc.
- Always add a `LIMIT` when scanning large tables unless a full count is explicitly needed.

## Key tables

| Table | Notes |
|---|---|
| `curricula` | slug, curriculum_type, didactic_hours, standard_program_num_weeks |
| `cohorts` | name, start_date, curriculum_id |
| `enrollments` | user_id, cohort_id, learning_status, sponsor_type |
| `users` | email, first_name, last_name |
| `course_content_schedules` | cohort_id, publish_status, version |
| `scheduled_lesson_containers` | course_content_schedule_id, week_index, namespace |
| `scheduled_lessons` | scheduled_lesson_container_id, content_lesson_id, deliver_date, deadline_date |
| `content_lessons` | name, lesson_type, details (jsonb), content_lesson_container_id |
| `content_lesson_containers` | name, depth_type (0=module, 1=container), content_lesson_container_id |

## Report results

Present query results as a table or summary. If the result is large, summarize the key findings rather than dumping all rows.
