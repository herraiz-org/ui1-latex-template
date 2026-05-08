# Spec: Install new-activity Skill for Gemini CLI

## Overview

Extend the project's `Makefile` `install` and `uninstall` targets to also
deploy the `new-activity` skill for Gemini CLI, in addition to the existing
Claude Code installation.

Gemini CLI discovers user-level skills at `~/.gemini/skills/<name>/SKILL.md`
(Agent Skills open standard). The Claude Code install path is
`~/.claude/skills/<name>/SKILL.md`. Both platforms use the same `SKILL.md`
format, so the same source file is installed to both destinations.

## Functional Requirements

1. The `install` target MUST create `$(INSTALL_GEMINI_SKILLS)/new-activity/`
   and copy `$(PROJECT_ROOT)/.claude/skills/new-activity.md` to
   `$(INSTALL_GEMINI_SKILLS)/new-activity/SKILL.md`.
2. `INSTALL_GEMINI_SKILLS` MUST default to `$(HOME)/.gemini/skills` and be
   overridable via environment variable (consistent with the existing
   `INSTALL_SKILLS` variable pattern).
3. The `install` target MUST create the destination directory unconditionally
   (`mkdir -p`), regardless of whether Gemini CLI is installed.
4. The `uninstall` target MUST remove `$(INSTALL_GEMINI_SKILLS)/new-activity`
   in addition to the existing Claude Code removal.
5. No new source files are required — the existing
   `.claude/skills/new-activity.md` is the single source of truth.

## Non-Functional Requirements

- The change MUST be backward-compatible: existing `make install` behavior for
  Claude Code is unchanged.
- Makefile variable naming MUST follow the existing convention
  (`INSTALL_SKILLS`, `INSTALL_BIN`, etc.).

## Acceptance Criteria

- [ ] `make install` creates `~/.gemini/skills/new-activity/SKILL.md` with the
  correct content.
- [ ] `make uninstall` removes `~/.gemini/skills/new-activity/`.
- [ ] `make install` still installs the Claude Code skill to
  `~/.claude/skills/new-activity/SKILL.md` (no regression).
- [ ] Running `make install` on a system without `~/.gemini` succeeds without
  error.
- [ ] The `INSTALL_GEMINI_SKILLS` variable can be overridden
  (`make install INSTALL_GEMINI_SKILLS=/custom/path`).

## Out of Scope

- Creating a Gemini-specific variant of the skill file.
- Installing workspace-level skills (`.gemini/skills/` inside the project).
- Any changes to the `new-activity.md` skill content itself.
- Modifying `make test` or the BATS test suite (no shell behavior changes).
