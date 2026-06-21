# Claude Working Rules

## Most Important Thing

- After completing each task, always end your response with: "[🔥事毕🔥]"
- Always respond in Chinese or English only.
- **Automode is not commit permission.** Even in automode / auto-accept / bypass-permissions, complete the work then **stop before committing**: present the final result (diff or summary) and wait for my explicit approval. Autonomous edits, tests, and tooling are fine; `git commit`/`git push` always need a fresh, explicit go-ahead.

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

Use `AskUserQuestion` tool to explicitly ask user for approval before making additional changes

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

The Claude Code Bash tool resets the working directory to the primary project directory between every tool call. cd does not persist across calls.
Fix: Always use git -C /absolute/path/to/repo when operating on a repo other than the primary working directory.  Never rely on cd persisting.

## Testing

(To be added)

---
