# Agent Working Rules

## Most Important Thing

- After completing each task, always end your response with: "[🔥事毕🔥]"
- Always respond in Chinese or English only.
- **Automode is not commit permission.** Even in automode / auto-accept / bypass-permissions, complete the work then **stop before committing**: present the final result (diff or summary) and wait for my explicit approval. Autonomous edits, tests, and tooling are fine; `git commit`/`git push` always need a fresh, explicit go-ahead.

## Response Style

- Prefer **concise, precise bullet points** over long stretches of continuous prose
- Keep each bullet to a single claim; put detail in a nested bullet or a table rather than a paragraph
- If the content genuinely does not fit bullet points (e.g. a narrative walkthrough, a chain of reasoning that only reads correctly in order), **say so and ask me to confirm** switching to prose before writing it out

## File Operation Permissions

- **Only operate on** files under `~/Development` directory
- Strictly forbidden to access or modify other directories

## Environment and Dependency Management

- **Must use uv** for Python environment and dependency management
- **Never use** native `python`, `pip`, or `pip3` commands
- **Must ask for confirmation** before installing any new dependencies
- **Must ask for confirmation** before running any `brew install` command

## Code Style Guidelines

### Python

- Use **4 spaces** for indentation
- Follow **PEP 8** and related official Python standards
- Keep comments and docstrings **concise and practical**
- Max line length: **110 characters**
- Write comments and docstrings in **British English (en-GB)**
- Do not reassign variable names within a function (no shadowing or reuse)
- Avoid unnecessary intermediate variables; assign only when it aids clarity or reuse
- Use ruff for linting and formatting
- Use pyright for checking
- Before giving the final response on any coding task, **resolve all ruff and pyright errors** in modified files (must pass both ruff and pyright checks)

#### Pandas

- Prefer **method chaining** over intermediate assignments

#### Plotting

- Prefer **plotly** over matplotlib/seaborn unless the project already standardises on another library
- Prefer **method chaining** here too, e.g. `go.Figure(...).update_layout(...).update_xaxes(...)`

### SQL

- Follow existing SQL code style in the project

## Code Modification Rules

### Basic Principles

- By default: **Only modify explicitly instructed areas**
- Do not optimize or refactor without confirmation

### Operations Requiring Confirmation

- Optimizing surrounding code
- Refactoring existing code structure
- Adding unrequested features

### Confirmation Method

Explicitly ask for approval before making additional changes — via the
`AskUserQuestion` tool where available (Claude Code), otherwise just ask.

### Instruction File Sync

This is a deliberate exception to "only modify explicitly instructed areas" above.

- Keep repository instruction pairs synchronized automatically: whenever you
  create, edit, move, rename, or delete a `CLAUDE.md` or `AGENTS.md`, make the
  semantically equivalent change to its counterpart in the same directory
  during the same task, creating it if necessary. Translate only tool-specific
  names and cross-references (`CLAUDE.md`/Claude Code ↔ `AGENTS.md`/Codex),
  preserve all shared guidance, and verify both files before finishing. Do not
  wait for a separate request.
- If the counterpart is a symlink to the file you just changed, the pair is
  already in sync — say so and do not replace the link with a copy.

## File Operation Preferences

- Evaluate necessity before creating new files

## Environment Variables

- Environment variables are managed via **direnv** and `.env` files
- Do not hardcode credentials or env values in code; use `.env` + direnv

## Git Operations

- **Never amend published commits** or force-push unless explicitly asked
- **Always create new commits** rather than amending, especially after hook failures
- **Stage specific files** by name; avoid `git add -A` or `git add .`
- **Do not commit** without explicit user instruction
- **Do not push** without explicit user instruction
- **Before opening a glab MR or gh PR**, check whether the branch needs to be rebased onto `main` (e.g. `main` has advanced or the branch is behind); if so, flag it and rebase before submitting

## Worktrees and Agent Orchestration (Herdr)

### When to Create a Worktree

- Any task needing a **working copy** gets its own new worktree: development, running
  tests/builds, reviewing someone else's branch, and any change made on a branch other
  than the current one
- Read-only git queries (`git log`, `git show`, `gh pr diff`): **do not decide alone**
  whether to create a worktree — ask via `AskUserQuestion` and follow the answer
- Already inside the target worktree: do not create another one
- **Never** switch branches in the main checkout to do the work above

### How to Create One

- Use `herdr worktree create` only. Never `git worktree add`, never Claude Code's
  built-in worktree tooling
- Outside a Herdr pane (`HERDR_ENV` is not 1 — e.g. VS Code terminal, CI, remote):
  **do not substitute another method**. Say the current environment cannot create a
  Herdr worktree, recommend returning to Herdr, and stop
- Run `herdr worktree list` first; reuse an existing worktree for the same branch
  instead of creating a duplicate
- Do not pass `--label` to `herdr worktree create`. Without it the workspace label
  defaults to the branch name, which keeps the Herdr sidebar aligned with `git branch`.
  A hand-written label hides which branch the workspace is on. If a worktree needs extra
  context, rename it afterwards as `<branch> · <purpose>` with `herdr workspace rename`,
  keeping the branch name as the prefix

### Who Does the Work

- **The agent that creates the worktree does not work inside it.** Its only job is:
  create the worktree, prepare an idle shell pane, `herdr agent start`, deliver one
  self-contained prompt, report back, and finish
- The report must include: worktree path, branch name, agent name, pane ID
- **Do not wait** for the child agent: no polling, no `herdr agent wait`, no relaying
  its results. Herdr notifications cover state changes
- Already inside the target worktree: do the work directly, no nesting

### The Prompt Handed to the Child Agent Must Be Self-Contained

- Task goal, acceptance criteria (which tests to run, passing ruff and pyright), and
  the boundaries of the change
- Restate explicitly: no `git commit` or `git push` without my explicit approval
- The child agent owns its worktree and does not report back to the agent that
  started it

### Cleanup

- Remove a worktree with `herdr worktree remove` once the work is merged or abandoned
- When `herdr worktree list` shows more than **15** worktrees for the same repo, prompt
  me to clean up; prompt only, never delete automatically, and never delete a worktree
  I have not confirmed

## Shell Command Preferences

<!--
  Deliberately trimmed to only the tools that help an agent in non-interactive Bash.
  Dropped from the old list and why:
    - bat / eza : add paging/colour/decoration that pollutes the plain-text output
                  the agent parses; Read/Glob cover this anyway.
    - btop / fzf: interactive TUIs that need a human at a TTY — unusable non-interactively.
    - zoxide (z): relies on a learned dir database, and the Bash tool resets cwd every
                  call (cd doesn't persist), so jumps are unreliable and pointless here.
  My terminal still uses the full rust toolset via .zshrc; that's unrelated to this file.
-->

When dropping to Bash, prefer these over the traditional counterparts:

- `rg` instead of `grep`
- `fd` instead of `find`
- `jq` for JSON processing

Note: for reading/searching files, prefer the built-in Read/Grep/Glob tools over shelling out.

### Compound Commands

Never use `;` to chain read-only commands into a single Bash call. Instead, issue multiple parallel Bash tool calls. Each individual command matches the allow list; compound commands do not, causing unnecessary permission prompts.

### Working Directory Reset

The agent's Bash tool resets the working directory to the primary project directory between every tool call. cd does not persist across calls.
Fix: Always use git -C /absolute/path/to/repo when operating on a repo other than the primary working directory.  Never rely on cd persisting.

## Testing

(To be added)

---
