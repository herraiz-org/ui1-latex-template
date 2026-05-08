# Plan: Project Structure Refactor

## Phase 1: Fix Immediate Issues and Migrate Legacy Docs [checkpoint: fa90ee6]

- [x] Task 1.1: Remove `imgs/imgs` circular symlink [58fe35c]
  - [x] Run `git rm imgs/imgs` to remove the symlink from git tracking
  - [x] Verify `imgs/` contains only `portada.png`, `interior.png`, `.gitkeep`

- [x] Task 1.2: Add "Design Constraints" section to `conductor/product-guidelines.md` [58fe35c]
  - [x] Append section documenting cover table width = 144mm (8154 docx twips)
  - [x] Append note that page margins were derived from docx twip measurements
  - [x] Append background image source paths from the original docx:
        `word/media/image2.png` → `imgs/portada.png`,
        `word/media/image1.png` → `imgs/interior.png`

- [x] Task 1.3: Delete `docs/` directory [58fe35c]
  - [x] Run `git rm -r docs/` to remove from git tracking

- [x] Task 1.4: Commit Phase 1 changes [58fe35c]
  - [x] Commit: `chore(structure): remove circular symlink, migrate legacy docs, delete docs/`
  - [x] Attach git note with task summary

- [x] Task: Conductor - User Manual Verification 'Phase 1: Fix Immediate Issues and Migrate Legacy Docs' [fa90ee6]

## Phase 2: Reorganize Source Files

- [ ] Task 2.1: Establish baseline — run install BATS tests (Red baseline)
  - [ ] Run `bash tests/run_tests.sh tests/install.bats` and confirm current state

- [ ] Task 2.2: Move `new-activity` to `bin/`
  - [ ] Create `bin/` directory
  - [ ] `git mv new-activity bin/new-activity`

- [ ] Task 2.3: Update `Makefile` install/uninstall targets for `bin/` path
  - [ ] Update `$(PROJECT_ROOT)/new-activity` → `$(PROJECT_ROOT)/bin/new-activity`

- [ ] Task 2.4: Check `.claude/skills/new-activity.md` for any root-path references and update

- [ ] Task 2.5: Move example files to `examples/`
  - [ ] `git mv plantilla.tex examples/plantilla.tex`
  - [ ] `git mv referencias.bib examples/referencias.bib`

- [ ] Task 2.6: Update `Makefile` for `examples/` path
  - [ ] Update `MAIN` and compilation targets to reference `examples/plantilla.tex`
  - [ ] Update `clean` target if it produces artifacts relative to root
  - [ ] Verify `make all` compiles successfully

- [ ] Task 2.7: Run install BATS tests to verify (Green)
  - [ ] Run `bash tests/run_tests.sh tests/install.bats`
  - [ ] All tests must pass before proceeding

- [ ] Task 2.8: Commit Phase 2 changes
  - [ ] Commit: `chore(structure): move new-activity to bin/, move examples to examples/`
  - [ ] Attach git note with task summary

- [ ] Task: Conductor - User Manual Verification 'Phase 2: Reorganize Source Files' (Protocol in workflow.md)

## Phase 3: Reorganize Tests

- [ ] Task 3.1: Establish baseline — run all BATS tests (Red baseline)
  - [ ] Run all `.bats` files and record current pass/fail state

- [ ] Task 3.2: Create `tests/shell/` and `tests/latex/` subdirectories

- [ ] Task 3.3: Move shell test files to `tests/shell/`
  - [ ] `git mv` all `.bats` files from `tests/` to `tests/shell/`
  - [ ] `git mv` all `.sh` files (except `run_tests.sh`) to `tests/shell/`

- [ ] Task 3.4: Move LaTeX fixture files to `tests/latex/`
  - [ ] `git mv` all `.tex` files in `tests/` to `tests/latex/`

- [ ] Task 3.5: Update `tests/run_tests.sh` for new paths
  - [ ] Update any hardcoded file paths

- [ ] Task 3.6: Update `Makefile` test target
  - [ ] Update `TESTS = $(wildcard tests/*.tex)` → `tests/latex/*.tex`
  - [ ] Update `TEST_PDFS` pattern accordingly

- [ ] Task 3.7: Audit `.bats` files for hardcoded paths referencing old locations
  - [ ] Grep for paths and update any broken references

- [ ] Task 3.8: Run all BATS tests to verify (Green)
  - [ ] Run all files in `tests/shell/`
  - [ ] All previously passing tests must still pass

- [ ] Task 3.9: Commit Phase 3 changes
  - [ ] Commit: `chore(structure): reorganize tests into shell/ and latex/ subdirectories`
  - [ ] Attach git note with task summary

- [ ] Task: Conductor - User Manual Verification 'Phase 3: Reorganize Tests' (Protocol in workflow.md)

## Phase 4: Add README

- [ ] Task 4.1: Write `README.md` at project root with all required sections:
  - [ ] Project overview and purpose
  - [ ] Prerequisites (TeX Live / MacTeX with required packages, biber, BATS)
  - [ ] Installation (`make install`)
  - [ ] Quick start — full `new-activity` example command
  - [ ] Project structure table (post-refactor layout)
  - [ ] All CLI flags — required and optional, with descriptions and defaults
  - [ ] Running the BATS test suite
  - [ ] Contributing notes

- [ ] Task 4.2: Commit Phase 4
  - [ ] Commit: `docs: add comprehensive README.md`
  - [ ] Attach git note with task summary

- [ ] Task: Conductor - User Manual Verification 'Phase 4: Add README' (Protocol in workflow.md)
