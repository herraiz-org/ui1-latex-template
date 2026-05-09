# Plan: Move Skills Directory to Top-Level `skills/`

## Phase 1: Update Tests (Red Phase) [checkpoint: d38a2ff]

- [x] Task: Update `tests/shell/install.bats` — change all assertions referencing
  `.claude/skills/new-activity.md` to `skills/new-activity/SKILL.md` [41953f3]
- [x] Task: Update `tests/shell/test_install_gemini_skill.bats` — change all assertions
  referencing `.claude/skills/` to `skills/new-activity/SKILL.md` [79d92f4]
- [x] Task: Run test suite and confirm updated tests now fail as expected (Red) [0bb237c]
- [x] Task: Conductor - User Manual Verification 'Phase 1: Update Tests (Red Phase)'
  (Protocol in workflow.md) [d38a2ff]

## Phase 2: Implement Changes (Green Phase)

- [x] Task: Move skill file — `git mv .claude/skills/new-activity.md skills/new-activity/SKILL.md` [7746287]
- [x] Task: Remove `.claude/skills/` directory [e350a1c]
- [x] Task: Update `Makefile` install target — change source path from
  `.claude/skills/new-activity.md` to `skills/new-activity/SKILL.md` [a03c2e5]
- [x] Task: Update `README.md` — replace `.claude/skills/new-activity.md` with
  `skills/new-activity/SKILL.md` in Project Structure section [15e2bc8]
- [x] Task: Update `conductor/tech-stack.md` — replace repo-side `.claude/skills/`
  reference with `skills/` [da402da]
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
