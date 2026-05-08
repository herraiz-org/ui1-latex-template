# Plan: Fix `open` Makefile Target to Depend on `pdf`

## [ ] Phase 1: Fix Generated Activity Makefile

- [x] Task: Write failing BATS test — verify the `open` target in the generated `Makefile` lists `pdf` as a prerequisite (Red) [71605e5]
  - [ ] Sub-task: Inspect existing BATS tests in `tests/shell/` to match naming and style conventions
  - [ ] Sub-task: Write a test that scaffolds an activity with `new-activity` and parses the generated `Makefile` to assert `open` depends on `pdf`
  - [ ] Sub-task: Run tests and confirm the new test fails (Red phase confirmed)
- [x] Task: Update `bin/new-activity` to declare `open: pdf` in the generated `Makefile` (Green) [62d06a3]
  - [ ] Sub-task: Change `open:` to `open: pdf` in the heredoc Makefile template inside `bin/new-activity`
  - [ ] Sub-task: Run the full BATS test suite and confirm all tests pass
- [ ] Task: Conductor - User Manual Verification 'Phase 1: Fix Generated Activity Makefile' (Protocol in workflow.md)

## [ ] Phase 2: Fix Root Makefile

- [ ] Task: Write failing BATS test — verify the root `Makefile` contains an `open` target that depends on `$(MAIN).pdf` (Red)
  - [ ] Sub-task: Write a test that inspects the root `Makefile` and asserts an `open` target exists with the correct prerequisite and `xdg-open` command
  - [ ] Sub-task: Run tests and confirm the new test fails (Red phase confirmed)
- [ ] Task: Add `open` target to root `Makefile` (Green)
  - [ ] Sub-task: Add `open` to the `.PHONY` declaration
  - [ ] Sub-task: Add `open: $(MAIN).pdf` target with `xdg-open $(MAIN).pdf` recipe
  - [ ] Sub-task: Run the full BATS test suite and confirm all tests pass
- [ ] Task: Conductor - User Manual Verification 'Phase 2: Fix Root Makefile' (Protocol in workflow.md)
