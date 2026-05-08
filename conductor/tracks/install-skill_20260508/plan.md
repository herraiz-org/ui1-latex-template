# Plan: Install Claude Skill via Makefile

## Phase 1: Write Failing Tests

- [x] Task: Examine existing BATS tests to determine naming conventions and test structure
- [~] Task: Write — BATS test that asserts `make install` copies `new-activity.md` to `$(INSTALL_SKILLS)/`
- [ ] Task: Write — BATS test that asserts `make uninstall` removes `$(INSTALL_SKILLS)/new-activity.md`
- [ ] Task: Run tests and confirm they fail (Red phase)
- [ ] Task: Conductor - User Manual Verification 'Phase 1: Write Failing Tests' (Protocol in workflow.md)

## Phase 2: Implement Makefile Changes

- [ ] Task: Add `INSTALL_SKILLS ?= $(HOME)/.claude/skills` variable to Makefile
- [ ] Task: Update `install` target — add `mkdir -p` and `cp` steps for the skill file
- [ ] Task: Update `uninstall` target — add `rm -f` step for the skill file
- [ ] Task: Run full BATS test suite and confirm all tests pass (Green phase)
- [ ] Task: Conductor - User Manual Verification 'Phase 2: Implement Makefile Changes' (Protocol in workflow.md)
