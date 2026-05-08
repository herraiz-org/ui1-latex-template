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

## Phase 2: Reorganize Source Files [checkpoint: 3a2be23]

- [x] Task 2.1: Establish baseline — run install BATS tests (Red baseline) — 4/4 pass
  - [x] Run `bash tests/run_tests.sh tests/install.bats` and confirm current state

- [x] Task 2.2: Move `new-activity` to `bin/`
  - [x] Create `bin/` directory
  - [x] `git mv new-activity bin/new-activity`

- [x] Task 2.3: Update `Makefile` install/uninstall targets for `bin/` path
  - [x] Update `$(PROJECT_ROOT)/new-activity` → `$(PROJECT_ROOT)/bin/new-activity`

- [x] Task 2.4: Check `.claude/skills/new-activity.md` for any root-path references and update

- [x] Task 2.5: Move example files to `examples/`
  - [x] `git mv plantilla.tex examples/plantilla.tex`
  - [x] `git mv referencias.bib examples/referencias.bib`

- [x] Task 2.6: Update `Makefile` for `examples/` path
  - [x] Update `MAIN` and compilation targets to reference `examples/plantilla.tex`
  - [x] Update `clean` target if it produces artifacts relative to root
  - [x] Verify `make all` compiles successfully

- [x] Task 2.7: Run install BATS tests to verify (Green) — 4/4 pass
  - [x] Run `bash tests/run_tests.sh tests/install.bats`
  - [x] All tests must pass before proceeding

- [x] Task 2.8: Commit Phase 2 changes [cfa06e4]
  - [x] Commit: `chore(structure): move new-activity to bin/, move examples to examples/`
  - [x] Attach git note with task summary

- [x] Task: Conductor - User Manual Verification 'Phase 2: Reorganize Source Files' [3a2be23]

## Phase 3: Reorganize Tests [checkpoint: 1b3a832]

- [x] Task 3.1: Establish baseline — run all BATS tests (Red baseline) — 5/19 pass (14 fail due to Phase 2 new-activity path change; fixed in 3.7)
  - [x] Run all `.bats` files and record current pass/fail state

- [~] Task 3.2: Create `tests/shell/` and `tests/latex/` subdirectories

- [~] Task 3.3: Move shell test files to `tests/shell/`
  - [ ] `git mv` all `.bats` files from `tests/` to `tests/shell/`
  - [ ] `git mv` all `.sh` files (except `run_tests.sh`) to `tests/shell/`

- [~] Task 3.4: Move LaTeX fixture files to `tests/latex/`
  - [ ] `git mv` all `.tex` files in `tests/` to `tests/latex/`

- [x] Task 3.5: Update `tests/run_tests.sh` for new paths — no changes needed (uses $@)
  - [x] Update any hardcoded file paths

- [~] Task 3.6: Update `Makefile` test target
  - [ ] Update `TESTS = $(wildcard tests/*.tex)` → `tests/latex/*.tex`
  - [ ] Update `TEST_PDFS` pattern accordingly

- [x] Task 3.7: Audit `.bats` files for hardcoded paths referencing old locations
  - [x] Grep for paths and update any broken references

- [x] Task 3.8: Run all BATS tests to verify (Green) — 19/19 pass
  - [x] Run all files in `tests/shell/`
  - [x] All previously passing tests must still pass

- [x] Task 3.9: Commit Phase 3 changes [2d27b43]
  - [x] Commit: `chore(structure): reorganize tests into shell/ and latex/ subdirectories`
  - [x] Attach git note with task summary

- [x] Task: Conductor - User Manual Verification 'Phase 3: Reorganize Tests' [1b3a832]

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
