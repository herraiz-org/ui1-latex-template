# Spec: Install Claude Skill via Makefile

## Overview

The project includes a Claude Code skill at `.claude/skills/new-activity.md` that
guides users in scaffolding new LaTeX activity directories. Currently the `make install`
target deploys the `new-activity` CLI binary and the LaTeX class files, but does not
install the skill. As a result, the skill is only available when Claude Code is run from
inside the `ui1_template/` project directory, not from the activity directories where
`new-activity` is actually used.

This track adds `make install` / `make uninstall` support for the skill file.

## Functional Requirements

1. A new configurable Makefile variable `INSTALL_SKILLS` shall default to
   `$(HOME)/.claude/skills`.
2. The `install` target shall copy `.claude/skills/new-activity.md` into
   `$(INSTALL_SKILLS)/`, creating the directory if it does not exist.
3. The `uninstall` target shall remove `$(INSTALL_SKILLS)/new-activity.md`.
4. The install step shall be idempotent (safe to run multiple times).

## Non-Functional Requirements

- The change must not break any existing `make install` / `make uninstall` behavior.
- The new variable must follow the same naming and defaulting convention as `INSTALL_BIN`
  and `TEXMF_DIR`.

## Acceptance Criteria

- [ ] Running `make install` copies `new-activity.md` to `~/.claude/skills/`.
- [ ] Running `make uninstall` removes `~/.claude/skills/new-activity.md`.
- [ ] A BATS test verifies the skill file is present after install and absent after
      uninstall.
- [ ] All existing BATS tests continue to pass.

## Out of Scope

- Installing any other files into `~/.claude/skills/`.
- Modifying the skill content itself.
- Adding the skill path to any shell config file.
