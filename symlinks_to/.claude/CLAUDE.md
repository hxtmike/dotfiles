# Agent Working Rules

## Most Important Thing

- After completing each task, always end your response with: "[🔥事毕🔥]"
- Always respond in Chinese or English only.
- **Automode is not commit permission.** Even in automode / auto-accept / bypass-permissions, complete the work then **stop before committing**: present the final result (diff or summary) and wait for my explicit approval. Autonomous edits, tests, and tooling are fine; `git commit`/`git push` always need a fresh, explicit go-ahead. How I review, and the one exception: see "Review Before Commit".

## Response Style

- Prefer **concise, precise bullet points** over long stretches of continuous prose
- Keep each bullet to a single claim; put detail in a nested bullet or a table rather than a paragraph
- If the content genuinely does not fit bullet points (e.g. a narrative walkthrough, a chain of reasoning that only reads correctly in order), **say so and ask me to confirm** switching to prose before writing it out
- When explaining a code problem (bug, unexpected behaviour, review finding), show it with a
  **small concrete data example next to the relevant code snippet**: the input, what the code
  produces, and what it should produce
  - Use real values from the repo or an actual run where possible; say so when the example is made up
  - Skip this when the problem is obvious from one line (typo, wrong name)

## File Operation Permissions

- **Only operate on** files under `~/Development` directory
- Strictly forbidden to access or modify other directories

## Environment and Dependency Management

- **Must use uv** for Python environment and dependency management
- **Never use** native `python`, `pip`, or `pip3` commands
- **Must ask for confirmation** before installing any new dependencies
- **Must ask for confirmation** before running any `brew install` command

## Code Style Guidelines

### Design Preferences

- Simplest change that solves the stated problem; do not enumerate every conceivable case
- If I need to trace the logic to understand it, it is too clever: prefer a plain idiom
- Do not add guards for cases that cannot occur; ask if unsure whether one can
- Group related state and behaviour in a class; derived values are properties;
  prefer methods on the domain object over free functions
- Use what the library and the repo already provide; extend around them rather than
  hand-rolling, and keep downstream call sites unchanged where possible
- When a pattern will clearly recur, propose one small shared mechanism instead of
  per-site patches (propose first: this is a refactor)

### Naming

- Use the exact domain term and match names already used for the same concept
- Never coin words or abbreviations; a long explicit name beats a short vague one
- Do not take a generic word (e.g. "deploy") for something narrower

### Output

- Use the logger, not print; quiet on success, reason plus fix on failure

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
- Filter rows with `.query()` rather than `.loc` or `[]`; interpolate Python values with an f-string
  and `!r`, e.g. `query(f'col1 == {row["col1"]!r} and col2 == {row["col2"]!r}')`
- Select columns with `.filter()` rather than `df[[...]]`
- Add or change columns with `.assign()`, never `df["x"] = ...`

#### Plotting

- Prefer **plotly** over matplotlib/seaborn unless the project already standardises on another library
- Prefer **method chaining** here too, e.g. `go.Figure(...).update_layout(...).update_xaxes(...)`

### SQL

- Follow existing SQL code style in the project

## Decide Before Doing

- When a choice could reasonably go more than one way and changes the result
  (data source, how an ambiguous case is classified, which design), **ask me
  before implementing** via `AskUserQuestion`: options, what each implies, your
  recommendation. Never pick one "for now" and mention it in the summary —
  a silent default is a decision.
- Meanwhile, do everything that does not depend on the answer.
- Routine calls a careful colleague would make alone (naming, fixture shape,
  helper placement) need no question; when unsure, ask.

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

## Scripts vs Agents

- Anything that can be a deterministic script is a script; leave to an agent only the
  steps that need judgement

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

### Review Before Commit

The staging area is my review queue:

| Where | Meaning |
| -- | -- |
| Committed | I have reviewed it |
| Staged | The one part waiting for my review |
| Unstaged | Written, not yet up for review |

- **Small change**: stage all of it; I review once.
- **Large change**: finish the whole work, then split it into parts I can review one at a time.
  - Stage only the next part and leave the rest unstaged. Split a file by hunk if needed.
  - Say what the part is and how many are left.
  - I review the staged part and commit it myself. Then stage the next part.
  - If I ask for changes, fix and restage the same part before moving on.
- **Push** after the last part is committed, with my go-ahead.
- **Exception**: on a branch I have already reviewed, a commit that only fixes formatting or lint to get CI
  green may be committed and pushed without asking. Tell me afterwards.

## Tickets

- **Before creating one**, search for an existing ticket on the same problem. If it is not
  obvious that a ticket is the right one, name it and wait for my confirmation
- **A new ticket states the symptom, not a guess**: what is wrong, where it was seen, what
  is known so far
- **Several problems**: one parent ticket with one or more sub-tickets, one for each part
  that can be fixed and verified on its own. Split by what can be verified alone, not by
  file or repository. A sub-ticket can be split again the same way
- **A problem found later gets its own ticket**: a sub-ticket of the same parent if it
  belongs to the same whole, otherwise a related ticket
- **Relations**: `blocked by` / `blocks` when one ticket cannot go on before another,
  `related` otherwise. A comment saying "wait for X" is not enough
- **Show me a short summary before creating anything**, not the full draft
- **Assignee**: me, unless someone else clearly fits better; then name the person and why,
  and wait for my confirmation
- **Team or project unclear**: ask instead of guessing

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
  keeping the branch name as the prefix. Exception: a worktree working on a ticket is named
  by ticket and role, see "Owner and Helpers"

### Who Does the Work

- **The agent that creates the worktree does not work inside it.** Its only job is:
  create the worktree, prepare an idle shell pane, `herdr agent start`, deliver one
  self-contained prompt, report back, and finish
- The report must include: worktree path, branch name, agent name, pane ID
- **Do not wait** for the child agent: no polling, no `herdr agent wait`, no relaying
  its results. Herdr notifications cover state changes
- Already inside the target worktree: do the work directly, no nesting

### Owner and Helpers

- **Always know your role**: which ticket you are on, and whether you are its owner or a
  helper. If that is not clear, ask me before doing anything else
- **One ticket, one owner.** The owner moves the ticket forward, edits its description and
  status, and runs the tests that verify the whole fix. A sub-ticket is a ticket: it has
  its own owner
- **A helper does one bounded piece** of the same ticket, usually one repository. It takes
  its change up to a green MR, reports in a ticket comment, and leaves the rest to the owner
  - The piece has decisions that are mine (review, commit): a Herdr agent in its own worktree
  - Read-only investigation or an independent check: an in-process subagent
- **A problem that blocks the current ticket** may be fixed in the same MR, but ask me
  first; its own ticket still gets the result
- **Coordinate through the ticket and the MRs**, not by agents waiting on each other
- **Show the role in Herdr**: rename the workspace to `<ticket> <role>`, e.g.
  `PROJ-123 owner` or `PROJ-123 helper`. `<ticket>` is the identifier, never the title

### The Prompt Handed to the Child Agent Must Be Self-Contained

- Its ticket identifier and its role, as in "Owner and Helpers"
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

### Commands Handed to Me

The terminal hard-wraps long lines and pads them with spaces, so a command copied off the
screen arrives broken.

- Run the command yourself whenever possible; hand one to me only when it needs me
  (interactive login, sudo, another machine)
- Put the command on the clipboard with `pbcopy` rather than asking me to copy it off the
  screen. Pipe it with `printf '%s'` so there is no trailing newline and the paste does
  not run by itself
- Announce it on its own line, in bold, so I cannot miss it:
  **📋 已复制到剪贴板 — 直接粘贴运行**, then show the command below for review
- The clipboard holds one thing: hand over one command at a time, and never overwrite it
  again in the same reply
- No `pbcopy` (WSL, remote): fall back to a single line of **at most 120 characters**, no
  `\` continuation, no heredoc, one command per code block

## Testing

(To be added)

---
