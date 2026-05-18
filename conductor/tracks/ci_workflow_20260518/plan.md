# Plan: GitHub Actions CI Workflow

## Phase 1: Red Phase — Write Failing CI Config Tests [checkpoint: 319cf00]

- [x] Task: Write BATS test `tests/shell/test_ci_workflow.bats` — assert `.github/workflows/ci.yml` exists (3550a4c)
- [x] Task: Extend test — assert workflow triggers on `push` and `pull_request` (3550a4c)
- [x] Task: Extend test — assert `shellcheck` job/step is present in the workflow (3550a4c)
- [x] Task: Extend test — assert BATS test job/step is present in the workflow (3550a4c)
- [x] Task: Extend test — assert LaTeX `make test` job/step is present in the workflow (3550a4c)
- [x] Task: Run `bash tests/run_tests.sh tests/shell/test_ci_workflow.bats` and confirm all tests **fail** (Red) (3550a4c)
- [x] Task: Conductor - User Manual Verification 'Phase 1: Red Phase' (Protocol in workflow.md) (319cf00)

## Phase 2: Green Phase — Implement CI Workflow

- [ ] Task: Create `.github/workflows/ci.yml` with correct `on:` triggers (`push`, `pull_request`)
- [ ] Task: Add `shellcheck` step — runs `shellcheck bin/*` inside the Docker container
- [ ] Task: Add BATS step — initialises git submodules and runs `bash tests/run_tests.sh tests/shell/*.bats`
- [ ] Task: Add LaTeX step — runs `make test` and fails on non-zero exit
- [ ] Task: Run `bash tests/run_tests.sh tests/shell/test_ci_workflow.bats` and confirm all tests **pass** (Green)
- [ ] Task: Conductor - User Manual Verification 'Phase 2: Green Phase' (Protocol in workflow.md)

## Phase 3: Validate on GitHub

- [ ] Task: Commit and push the workflow file to trigger the first real CI run
- [ ] Task: Confirm all three jobs pass on GitHub Actions (green build on `main`)
- [ ] Task: Conductor - User Manual Verification 'Phase 3: Validate on GitHub' (Protocol in workflow.md)
