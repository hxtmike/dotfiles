---
name: git-commit
description: 'Execute git commit with conventional commit message analysis, intelligent staging, and message generation. Use when user asks to commit changes, create a git commit, or mentions "/commit". Supports: (1) Auto-detecting type and scope from changes, (2) Generating conventional commit messages from diff, (3) Interactive commit with optional type/scope/description overrides, (4) Intelligent file staging for logical grouping'
license: MIT
---

# Git Commit with Conventional Commits

## Overview

Create standardized, semantic git commits using the Conventional Commits specification. Analyze the actual diff to determine appropriate type, scope, and message.

## Conventional Commit Format

```md
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

## Commit Types

| Type       | Purpose                        |
| ---------- | ------------------------------ |
| `feat`     | New feature                    |
| `fix`      | Bug fix                        |
| `docs`     | Documentation only             |
| `style`    | Formatting/style (no logic)    |
| `refactor` | Code refactor (no feature/fix) |
| `perf`     | Performance improvement        |
| `test`     | Add/update tests               |
| `build`    | Build system/dependencies      |
| `ci`       | CI/config changes              |
| `chore`    | Maintenance/misc               |
| `revert`   | Revert commit                  |

## Breaking Changes

```md
# Exclamation mark after type/scope
feat!: remove deprecated endpoint

# BREAKING CHANGE footer
feat: allow config to extend other configs

BREAKING CHANGE: `extends` key behaviors changed
```

## Workflow

### 1. Analyze Diff

```bash
# If files are staged, use staged diff
git diff --staged

# If nothing staged, use working tree diff
git diff

# Also check status
git status --porcelain
```

### 2. Stage Files (if needed)

If nothing is staged or you want to group changes differently:

```bash
# Stage specific files
git add path/to/file1 path/to/file2

# Stage by pattern
git add *.test.*
git add src/components/*

# Interactive staging
git add -p
```

**Never commit secrets** (.env, credentials.json, private keys).

### 3. Resolve Linear ID

Determine the Linear ID using this priority:

1. Otherwise, inspect the current branch name for a Linear-style pattern (e.g., `PROJ-123`, `ABC-42`). Extract the first match.
2. If neither yields a Linear ID, do NOT include a `Resolves:` line.

When a Linear ID is found, append it at the very end of the commit message, separated by a blank line:

```txt
Subject line here

Body text here, if needed.

Resolves: PROJ-123
```

### 4. Generate Commit Message

Analyze the diff to determine:

- **Type**: What kind of change is this?
- **Scope**: What area/module is affected?
- **Description**: One-line summary of what changed (present tense, imperative mood, <72 chars)

### 5. Execute Commit

```bash
# Single line
git commit -m "<type>[scope]: <description>"

# Multi-line with body/footer
git commit -m "$(cat <<'EOF'
<type>[scope]: <description>

<optional body>

<optional footer>
EOF
)"
```

### 6. Optional Push (with guardrails)

Only run this step when the user explicitly opts in by passing one of these as a skill argument. Without that opt-in, stop after step 5.

- `--push` (or equivalent: `push`, `推送`) → push, but **refuse** if the current branch is protected (see check 2)
- `--push-to-main` (or equivalent: `--push to main`, `push to main`, `--push main`, `推送到 main`) → push **and** waive the protected-branch check for the branch you are currently on

`--gh-pr` and `--glab-mr` (step 7) **imply `--push`** — if either is passed, run this step first. They do **not** imply `--push-to-main`.

Run these checks **in order** and abort on the first failure — do NOT auto-resolve, just report the failure and stop:

1. **Commit must have succeeded** in step 5. If it failed (e.g., pre-commit hook), do not push.
2. **Protected-branch check**: get the current branch with `git rev-parse --abbrev-ref HEAD`. If it is `main`, `master`, `develop`, `release`, or matches `release/*`:
   - With plain `--push` → abort and report. Do not offer to override; the user must re-run with the explicit argument.
   - With `--push-to-main` → proceed, but state in the report which protected branch is being pushed to, so the override is visible rather than silent.

   This override waives **only** this check. It never relaxes check 4 below: no `--force`, no `--force-with-lease`, no `--no-verify`, no retry-with-force on rejection.
3. **Upstream check**: run `git rev-parse --abbrev-ref --symbolic-full-name @{u}` to detect upstream.
   - If it exists: `git push`
   - If it does not (exits non-zero): `git push -u origin <current-branch>` to set upstream on first push
4. **Never** pass `--force`, `--force-with-lease`, or `--no-verify`. If push is rejected (non-fast-forward, hook failure, etc.), stop and report — do not retry with force.

After a successful push, **always** check for an existing PR/MR on the current branch and surface its URL as the **final line of the response**:

- GitHub (if `gh` is available): `gh pr view --json url,state -q '.url'`
- GitLab (if `glab` is available): `glab mr view --output json | jq -r '.web_url'`

If neither CLI is available, or no PR/MR exists for the branch, report that explicitly along with the push result. If step 7 (PR/MR creation) is going to run next, defer the URL reporting to step 7 instead of duplicating it here.

Report the push result (success, remote URL, or the specific error) to the user, followed by the PR/MR URL when applicable.

### 7. Optional PR/MR Creation (with guardrails)

Only run this step when the user explicitly opts in by passing one of:

- `--gh-pr` (or `gh-pr`, `pr`) → create a GitHub pull request via `gh pr create`
- `--glab-mr` (or `glab-mr`, `mr`) → create a GitLab merge request via `glab mr create`

Run these checks **in order** and abort on the first failure:

1. **Mutual exclusivity**: `--gh-pr` and `--glab-mr` cannot both be passed. If both, abort and ask the user which one.
2. **Push must have succeeded** in step 6. If push was skipped or failed, do not create a PR/MR.
3. **CLI availability**: verify the required tool is installed (`command -v gh` or `command -v glab`). If missing, abort and report.
4. **Remote sanity check** (best effort): inspect `git remote get-url origin` and warn if it does not match the chosen platform (e.g., `--gh-pr` against a `gitlab.com` remote). Ask the user before proceeding.
5. **Existing PR/MR check**: before creating, check if one already exists for the current branch:
   - GitHub: `gh pr view --json url,state` — if it exists and is open, report the URL and stop (do not create a duplicate)
   - GitLab: `glab mr view` — same behaviour
6. **Resolve base branch**: detect the default branch with `git symbolic-ref --short refs/remotes/origin/HEAD` (strip the `origin/` prefix). Fall back to `main` then `master` if that fails. If the current branch **equals** the resolved base branch, abort and report — there is nothing to open a PR/MR against. (This is the expected outcome when `--push-to-main` was used.)
7. **Count commits on branch**: `git rev-list --count <base>..HEAD`.
   - **If 1 commit** → use the simple `--fill` path:
     - GitHub: `gh pr create --fill`
     - GitLab: `glab mr create --fill --remove-source-branch=false`
   - **If >1 commits** → synthesize title + body, then pass via `--title` / `--body`:
     - Read all commits: `git log <base>..HEAD --reverse --pretty=format:'%h %s%n%b%n---'`
     - **Title**: a single concise line (<72 chars) summarizing the branch's overall change. Prefer a conventional-commit prefix if all commits share the same type/scope; otherwise pick the most descriptive subject and tighten it.
     - **Body**: use this template:

       ```md
       ## Summary

       - <bullet per logical change, grouped — not one bullet per commit>

       ## Commits

       - <short-sha> <subject>
       - ...

       ## Test plan

       - [ ] <derive from the diff: what should be verified manually or in CI>
       ```

     - Pass via heredoc to preserve formatting:

       ```bash
       gh pr create --title "<title>" --body "$(cat <<'EOF'
       <body>
       EOF
       )"
       # or
       glab mr create --remove-source-branch=false --title "<title>" --description "$(cat <<'EOF'
       <body>
       EOF
       )"
       ```
8. **Never** pass `--draft` unless the user explicitly asks, and never pass flags that bypass review (e.g., auto-merge).

**Always** report the resulting PR/MR URL as the **final line of the response**, whether the PR/MR was newly created in this step or already existed (detected in check 5). The URL must be the last thing the user sees, so they can click through immediately.

## Best Practices

- One logical change per commit
- Present tense: "add" not "added"
- Imperative mood: "fix bug" not "fixes bug"
- Reference issues: `Closes #123`, `Refs #456`
- Keep description under 72 characters

## Git Safety Protocol

- NEVER update git config
- NEVER run destructive commands (--force, hard reset) without explicit request
- NEVER skip hooks (--no-verify) unless user asks
- NEVER force push to main/master — the `--push-to-main` opt-in permits an ordinary push only, never a forced one
- If commit fails due to hooks, fix and create NEW commit (don't amend)
