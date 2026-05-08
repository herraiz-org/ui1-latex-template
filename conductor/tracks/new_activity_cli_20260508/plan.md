# Plan: New Activity CLI + Claude Code Skill

## Phase 1: Test Infrastructure Setup [checkpoint: 3d66e9e]

- [x] Task: Install and configure BATS (Bash Automated Testing System) [402b507]
  - [x] Sub-task: Add `bats-core` as a git submodule under `tests/bats`
  - [x] Sub-task: Create `tests/` directory with a `run_tests.sh` helper
  - [x] Sub-task: Write a smoke test (`tests/smoke.bats`) that asserts `true`
    and confirm it passes — establishes the harness works
- [x] Task: Conductor - User Manual Verification 'Phase 1: Test Infrastructure Setup' (Protocol in workflow.md) [3d66e9e]

## Phase 2: CLI Argument Parsing & Validation (TDD) [checkpoint: 532f259]

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
- [x] Task: Conductor - User Manual Verification 'Phase 2: CLI Argument Parsing & Validation' (Protocol in workflow.md) [532f259]

## Phase 3: File Generation (TDD) [checkpoint: a6e1def]

- [x] Task: Write failing tests for file generation [a7f2238]
  - [x] Sub-task: Test target directory is created
  - [x] Sub-task: Test script aborts if target directory already exists
  - [x] Sub-task: Test `.tex` file is created and contains the correct metadata fields
  - [x] Sub-task: Test `referencias.bib` is created (empty)
  - [x] Sub-task: Test generated `Makefile` contains `pdf`, `clean`, and `open` targets
  - [x] Sub-task: Confirm all tests fail (Red phase)
- [x] Task: Implement file generation [0858e90]
  - [x] Sub-task: Implement directory creation with existence check
  - [x] Sub-task: Implement `.tex` file generation via heredoc
  - [x] Sub-task: Implement `referencias.bib` generation (empty file)
  - [x] Sub-task: Implement `Makefile` generation with all three targets
  - [x] Sub-task: Implement success message with next-steps instructions
  - [x] Sub-task: Run tests and confirm all pass (Green phase)
- [x] Task: Conductor - User Manual Verification 'Phase 3: File Generation' (Protocol in workflow.md) [a6e1def]

## Phase 4: Installation & Claude Code Skill (TDD)

- [x] Task: Write failing tests for install/uninstall behaviour [9308a2a]
  - [x] Sub-task: Test `make install` copies `new-activity` to `~/bin/` and makes it executable
  - [x] Sub-task: Test `make install` appends `PATH` export to `~/.zshrc` when not present
  - [x] Sub-task: Test `make install` is idempotent (running twice does not duplicate PATH line)
  - [x] Sub-task: Test `make uninstall` removes `new-activity` from `~/bin/`
  - [x] Sub-task: Confirm all tests fail (Red phase)
- [x] Task: Add `install` / `uninstall` targets to project `Makefile` [ade1839]
  - [x] Sub-task: Add `install` target: copy script + chmod + idempotent `~/.zshrc` update
  - [x] Sub-task: Add `uninstall` target: remove `~/bin/new-activity`
  - [x] Sub-task: Run tests and confirm all pass (Green phase)
- [ ] Task: Create Claude Code skill file
  - [ ] Sub-task: Create `.claude/skills/new-activity.md`
  - [ ] Sub-task: Document trigger conditions and all CLI flags
  - [ ] Sub-task: Add example invocations and expected output
  - [ ] Sub-task: Verify skill is discoverable (appears in `/skills` list)
- [ ] Task: Conductor - User Manual Verification 'Phase 4: Installation & Claude Code Skill' (Protocol in workflow.md)
