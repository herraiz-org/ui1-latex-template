# Plan: GitHub Actions CI Workflow

## Phase 1: Red Phase — Write Failing CI Config Tests [checkpoint: 319cf00]

- [x] Task: Write BATS test `tests/shell/test_ci_workflow.bats` — assert `.github/workflows/ci.yml` exists (3550a4c)
- [x] Task: Extend test — assert workflow triggers on `push` and `pull_request` (3550a4c)
- [x] Task: Extend test — assert `shellcheck` job/step is present in the workflow (3550a4c)
- [x] Task: Extend test — assert BATS test job/step is present in the workflow (3550a4c)
- [x] Task: Extend test — assert LaTeX `make test` job/step is present in the workflow (3550a4c)
- [x] Task: Run `bash tests/run_tests.sh tests/shell/test_ci_workflow.bats` and confirm all tests **fail** (Red) (3550a4c)
- [x] Task: Conductor - User Manual Verification 'Phase 1: Red Phase' (Protocol in workflow.md) (319cf00)

## Phase 2: Green Phase — Implement CI Workflow [checkpoint: ff41a8e]

- [x] Task: Create `.github/workflows/ci.yml` with correct `on:` triggers (`push`, `pull_request`) (3eee0d6)
- [x] Task: Add `shellcheck` step — runs `shellcheck bin/*` inside the Docker container (3eee0d6)
- [x] Task: Add BATS step — initialises git submodules and runs `bash tests/run_tests.sh tests/shell/*.bats` (3eee0d6)
- [x] Task: Add LaTeX step — runs `make test` and fails on non-zero exit (3eee0d6)
- [x] Task: Run `bash tests/run_tests.sh tests/shell/test_ci_workflow.bats` and confirm all tests **pass** (Green) (3eee0d6)
- [x] Task: Conductor - User Manual Verification 'Phase 2: Green Phase' (Protocol in workflow.md) (ff41a8e)

## Phase 3: Validate on GitHub

- [x] Task: Commit and push the workflow file to trigger the first real CI run (e7bc755)
- [x] Task: Confirm all three jobs pass on GitHub Actions (green build on `main`) (e7bc755)
- [ ] Task: Conductor - User Manual Verification 'Phase 3: Validate on GitHub' (Protocol in workflow.md)
