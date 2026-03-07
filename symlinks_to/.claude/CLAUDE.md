# Claude Working Rules

## File Operation Permissions

- **Only operate on** files under `~/Development` directory
- Strictly forbidden to access or modify other directories

## Environment and Dependency Management

- **Must use uv** for Python environment and dependency management
- **Never use** native `python`, `pip`, or `pip3` commands
- **Must ask for confirmation** before installing any new dependencies

## Code Style Guidelines

### Python

- Use **4 spaces** for indentation
- Follow **PEP 8** and related official Python standards
- Keep comments and docstrings **concise and practical**
- Use ruff (managed by uv) for linting and formatting

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

## Git Operations

(To be added)

## Testing

(To be added)

---
