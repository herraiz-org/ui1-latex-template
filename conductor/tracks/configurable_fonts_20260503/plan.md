# Implementation Plan: Configurable Fonts (Palatino & Times New Roman)

## Phase 1: Setup and Test Definitions
- [x] Task: Create tests for font options 4ac8cd9
    - [x] Create `test_fonts.tex` to test `palatino`, `times`, and default class options.
    - [x] Ensure the tests fail since the options and packages aren't implemented yet (Red Phase).
- [ ] Task: Conductor - User Manual Verification 'Phase 1: Setup and Test Definitions' (Protocol in workflow.md)

## Phase 2: Implementation of Font Options
- [ ] Task: Implement Font Class Options in `ui1activity.cls`
    - [ ] Add `\DeclareOption{palatino}{...}` to handle Palatino selection.
    - [ ] Add `\DeclareOption{times}{...}` to handle Times New Roman selection.
    - [ ] Set Palatino as the default using `\ExecuteOptions{palatino}`.
    - [ ] Update `\ProcessOptions\relax`.
- [ ] Task: Load Font Packages based on Selection
    - [ ] Implement logic to load `newpxtext` and `newpxmath` with 95% scaled Helvetica for Palatino.
    - [ ] Implement logic to load `newtxtext` and `newtxmath` with 92% scaled Helvetica for Times New Roman.
    - [ ] Load `titlesec` package.
    - [ ] Configure `\section`, `\subsection`, and `\subsubsection` to use `\sffamily`, `\bfseries`, and standard black.
- [ ] Task: Make Tests Pass (Green Phase)
    - [ ] Run test suite on `test_fonts.tex` and ensure successful compilation with correct fonts.
- [ ] Task: Conductor - User Manual Verification 'Phase 2: Implementation of Font Options' (Protocol in workflow.md)

## Phase 3: Verification and Refactoring
- [ ] Task: Ensure all existing tests pass
    - [ ] Run the complete test suite (e.g., `make test`) to ensure no regressions in existing templates.
- [ ] Task: Refactor code (if necessary)
    - [ ] Organize font loading conditionals within `ui1activity.cls` for readability.
- [ ] Task: Conductor - User Manual Verification 'Phase 3: Verification and Refactoring' (Protocol in workflow.md)