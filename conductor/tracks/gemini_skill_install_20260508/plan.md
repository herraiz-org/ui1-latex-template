# Plan: Install new-activity Skill for Gemini CLI

## Phase 1: Implement Makefile Changes (TDD)

- [x] Task 1.1: Write Failing Tests (Red Phase) [0b2fd86]
  - [ ] Sub-task: Examine existing BATS tests in `tests/shell/` to understand
        naming conventions and test style.
  - [ ] Sub-task: Write a new BATS test file
        `tests/shell/test_install_gemini_skill.bats` that:
    - Tests `make install INSTALL_GEMINI_SKILLS=<tmp_dir>` creates
      `<tmp_dir>/new-activity/SKILL.md` with the correct content.
    - Tests `make uninstall INSTALL_GEMINI_SKILLS=<tmp_dir>` removes
      `<tmp_dir>/new-activity/`.
    - Tests `make install INSTALL_GEMINI_SKILLS=<tmp_dir>` succeeds even when
      `<tmp_dir>` does not pre-exist.
  - [ ] Sub-task: Run tests and confirm they fail as expected (Red).

- [x] Task 1.2: Implement Makefile Changes (Green Phase) [51cbb7e]
  - [ ] Sub-task: Add `INSTALL_GEMINI_SKILLS ?= $(HOME)/.gemini/skills` variable
        to `Makefile`, following the `INSTALL_SKILLS` pattern.
  - [ ] Sub-task: Append two lines to the `install` target:
    - `mkdir -p "$(INSTALL_GEMINI_SKILLS)/new-activity"`
    - `cp "$(PROJECT_ROOT)/.claude/skills/new-activity.md" "$(INSTALL_GEMINI_SKILLS)/new-activity/SKILL.md"`
  - [ ] Sub-task: Append one line to the `uninstall` target:
    - `rm -rf "$(INSTALL_GEMINI_SKILLS)/new-activity"`
  - [ ] Sub-task: Run tests and confirm all pass (Green).

- [ ] Task 1.3: Conductor - User Manual Verification 'Phase 1: Implement Makefile Changes (TDD)' (Protocol in workflow.md)
