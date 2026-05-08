# Plan: New Activity CLI + Claude Code Skill

## Phase 1: Test Infrastructure Setup [checkpoint: 3d66e9e]

- [x] Task: Install and configure BATS (Bash Automated Testing System) [402b507]
  - [x] Sub-task: Add `bats-core` as a git submodule under `tests/bats`
  - [x] Sub-task: Create `tests/` directory with a `run_tests.sh` helper
  - [x] Sub-task: Write a smoke test (`tests/smoke.bats`) that asserts `true`
    and confirm it passes — establishes the harness works
- [x] Task: Conductor - User Manual Verification 'Phase 1: Test Infrastructure Setup' (Protocol in workflow.md) [3d66e9e]

## Phase 2: CLI Argument Parsing & Validation (TDD)

- [x] Task: Write failing tests for argument parsing [aefd38d]
  - [x] Sub-task: Test `--help` prints usage and exits 0
  - [x] Sub-task: Test missing `--asignatura` exits 1 with error message
  - [x] Sub-task: Test missing `--alumno` exits 1 with error message
  - [x] Sub-task: Test missing positional directory argument exits 1
  - [x] Sub-task: Test default values are applied for `--grado`, `--fecha`, `--options`
  - [x] Sub-task: Confirm all tests fail (Red phase)
- [x] Task: Implement argument parsing in `new-activity` [805fdef]
  - [x] Sub-task: Create `new-activity` bash script with `#!/usr/bin/env bash`
  - [x] Sub-task: Implement flag parsing (manual loop over `"$@"`)
  - [x] Sub-task: Implement required-flag validation with usage message
  - [x] Sub-task: Implement default values for optional flags
  - [x] Sub-task: Run tests and confirm all pass (Green phase)
- [ ] Task: Conductor - User Manual Verification 'Phase 2: CLI Argument Parsing & Validation' (Protocol in workflow.md)

## Phase 3: File Generation (TDD)

- [ ] Task: Write failing tests for file generation
  - [ ] Sub-task: Test target directory is created
  - [ ] Sub-task: Test script aborts if target directory already exists
  - [ ] Sub-task: Test `.tex` file is created and contains the correct metadata fields
  - [ ] Sub-task: Test `referencias.bib` is created (empty)
  - [ ] Sub-task: Test generated `Makefile` contains `pdf`, `clean`, and `open` targets
  - [ ] Sub-task: Confirm all tests fail (Red phase)
- [ ] Task: Implement file generation
  - [ ] Sub-task: Implement directory creation with existence check
  - [ ] Sub-task: Implement `.tex` file generation via heredoc
  - [ ] Sub-task: Implement `referencias.bib` generation (empty file)
  - [ ] Sub-task: Implement `Makefile` generation with all three targets
  - [ ] Sub-task: Implement success message with next-steps instructions
  - [ ] Sub-task: Run tests and confirm all pass (Green phase)
- [ ] Task: Conductor - User Manual Verification 'Phase 3: File Generation' (Protocol in workflow.md)

## Phase 4: Installation & Claude Code Skill (TDD)

- [ ] Task: Write failing tests for install/uninstall behaviour
  - [ ] Sub-task: Test `make install` copies `new-activity` to `~/bin/` and makes it executable
  - [ ] Sub-task: Test `make install` appends `PATH` export to `~/.zshrc` when not present
  - [ ] Sub-task: Test `make install` is idempotent (running twice does not duplicate PATH line)
  - [ ] Sub-task: Test `make uninstall` removes `new-activity` from `~/bin/`
  - [ ] Sub-task: Confirm all tests fail (Red phase)
- [ ] Task: Add `install` / `uninstall` targets to project `Makefile`
  - [ ] Sub-task: Add `install` target: copy script + chmod + idempotent `~/.zshrc` update
  - [ ] Sub-task: Add `uninstall` target: remove `~/bin/new-activity`
  - [ ] Sub-task: Run tests and confirm all pass (Green phase)
- [ ] Task: Create Claude Code skill file
  - [ ] Sub-task: Create `.claude/skills/new-activity.md`
  - [ ] Sub-task: Document trigger conditions and all CLI flags
  - [ ] Sub-task: Add example invocations and expected output
  - [ ] Sub-task: Verify skill is discoverable (appears in `/skills` list)
- [ ] Task: Conductor - User Manual Verification 'Phase 4: Installation & Claude Code Skill' (Protocol in workflow.md)
