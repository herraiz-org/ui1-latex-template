# Plan: Move Skills Directory to Top-Level `skills/`

## Phase 1: Update Tests (Red Phase)

- [x] Task: Update `tests/shell/install.bats` — change all assertions referencing
  `.claude/skills/new-activity.md` to `skills/new-activity/SKILL.md` [41953f3]
- [x] Task: Update `tests/shell/test_install_gemini_skill.bats` — change all assertions
  referencing `.claude/skills/` to `skills/new-activity/SKILL.md` [79d92f4]
- [ ] Task: Run test suite and confirm updated tests now fail as expected (Red)
- [ ] Task: Conductor - User Manual Verification 'Phase 1: Update Tests (Red Phase)'
  (Protocol in workflow.md)

## Phase 2: Implement Changes (Green Phase)

- [ ] Task: Move skill file — `git mv .claude/skills/new-activity.md skills/new-activity/SKILL.md`
- [ ] Task: Remove `.claude/skills/` directory
- [ ] Task: Update `Makefile` install target — change source path from
  `.claude/skills/new-activity.md` to `skills/new-activity/SKILL.md`
- [ ] Task: Update `README.md` — replace `.claude/skills/new-activity.md` with
  `skills/new-activity/SKILL.md` in Project Structure section
- [ ] Task: Update `conductor/tech-stack.md` — replace repo-side `.claude/skills/`
  reference with `skills/`
- [ ] Task: Run test suite and confirm all tests pass (Green)
- [ ] Task: Conductor - User Manual Verification 'Phase 2: Implement Changes (Green Phase)'
  (Protocol in workflow.md)

## Phase 3: Regression & Final Verification

- [ ] Task: Run full test suite (`bash tests/run_tests.sh tests/shell/*.bats`) and confirm
  all 40 tests pass
- [ ] Task: Confirm no remaining references to `.claude/skills/` in tracked files
  (excluding `conductor/archive/`)
- [ ] Task: Conductor - User Manual Verification 'Phase 3: Regression & Final Verification'
  (Protocol in workflow.md)
