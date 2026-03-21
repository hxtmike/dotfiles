# Claude Working Rules

## Most Important Thing

- After completing each task, always end your response with: "[🔥事毕🔥]"

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
- Use ruff (managed by uv) for linting and formatting
- Max line length: **110 characters**
- Write comments and docstrings in **British English (en-GB)**

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

The following Rust-based CLI tools are installed via Homebrew and aliased in `.zshrc`.
Always use these instead of the traditional counterparts:

- `rg` instead of `grep`
- `fd` instead of `find`
- `bat` instead of `cat`
- `eza` instead of `ls`
- `zoxide` (`z`) instead of `cd`
- `btop` instead of `top`
- `fzf` for fuzzy finding/filtering

## Testing

(To be added)

---
