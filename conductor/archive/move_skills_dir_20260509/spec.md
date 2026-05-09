# Spec: Move Skills Directory to Top-Level `skills/`

## Overview

The AI skill file(s) currently live in `.claude/skills/`, a convention inherited from Claude
Code's local project skills path. This track moves the source location to a top-level
`skills/` directory, making the skills a first-class part of the project rather than a
hidden tooling artifact. All references across the codebase are updated to match.

## Functional Requirements

1. **Move skill file:** `git mv .claude/skills/new-activity.md skills/new-activity/SKILL.md`.
2. **Remove old directory:** Delete `.claude/skills/` entirely (the `.claude/` directory
   itself may also be removed if it becomes empty after the move, excluding
   `.claude/settings.local.json` which is gitignored).
3. **Update `Makefile`:** Change the `install` target to copy from
   `$(PROJECT_ROOT)/skills/new-activity/SKILL.md` (instead of
   `$(PROJECT_ROOT)/.claude/skills/new-activity.md`) for both the Claude and Gemini
   install destinations. No change to install destinations.
4. **Update `README.md`:** Replace `.claude/skills/new-activity.md` with
   `skills/new-activity/SKILL.md` in the Project Structure section.
5. **Update `conductor/tech-stack.md`:** Replace any reference to the repo-side
   `.claude/skills/` path with `skills/`.
6. **Update tests:** Update all assertions in `tests/shell/install.bats` and
   `tests/shell/test_install_gemini_skill.bats` that reference the source path
   `.claude/skills/` to reference `skills/new-activity/SKILL.md`.

## Acceptance Criteria

- `skills/new-activity/SKILL.md` exists at the repo root.
- `.claude/skills/` no longer exists.
- `make install` copies from `skills/new-activity/SKILL.md` without errors.
- All 40 BATS tests pass after the change.
- No remaining references to `.claude/skills/` in tracked files (excluding the
  `conductor/archive/` historical documents).

## Out of Scope

- Changing install destinations (`~/.claude/skills/`, `~/.gemini/skills/`).
- Updating `conductor/archive/` documents (historical records, not living code).
- Changes to the skill content itself (`SKILL.md`).
