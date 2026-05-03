# Implementation Plan: Configurable Fonts (Palatino & Times New Roman)

## Phase 1: Setup and Test Definitions [checkpoint: 933eb15]
- [x] Task: Create tests for font options 4ac8cd9
    - [x] Create `test_fonts.tex` to test `palatino`, `times`, and default class options.
    - [x] Ensure the tests fail since the options and packages aren't implemented yet (Red Phase).
- [x] Task: Conductor - User Manual Verification 'Phase 1: Setup and Test Definitions' (Protocol in workflow.md)

## Phase 2: Implementation of Font Options [checkpoint: c7a5280]
- [x] Task: Implement Font Class Options in `ui1activity.cls` 30ea036
    - [x] Add `\DeclareOption{palatino}{...}` to handle Palatino selection.
    - [x] Add `\DeclareOption{times}{...}` to handle Times New Roman selection.
    - [x] Set Palatino as the default using `\ExecuteOptions{palatino}`.
    - [x] Update `\ProcessOptions\relax`.
- [x] Task: Load Font Packages based on Selection 30ea036
    - [x] Implement logic to load `newpxtext` and `newpxmath` with 95% scaled Helvetica for Palatino.
    - [x] Implement logic to load `newtxtext` and `newtxmath` with 92% scaled Helvetica for Times New Roman.
    - [x] Load `titlesec` package.
    - [x] Configure `\section`, `\subsection`, and `\subsubsection` to use `\sffamily`, `\bfseries`, and standard black.
- [x] Task: Make Tests Pass (Green Phase) 30ea036
    - [x] Run test suite on `test_fonts.tex` and ensure successful compilation with correct fonts.
- [x] Task: Conductor - User Manual Verification 'Phase 2: Implementation of Font Options' (Protocol in workflow.md)

## Phase 3: Verification and Refactoring [checkpoint: d6cdb78]
- [x] Task: Ensure all existing tests pass 4107bed
    - [x] Run the complete test suite (e.g., `make test`) to ensure no regressions in existing templates.
- [x] Task: Refactor code (if necessary) 4107bed
    - [x] Organize font loading conditionals within `ui1activity.cls` for readability.
- [x] Task: Conductor - User Manual Verification 'Phase 3: Verification and Refactoring' (Protocol in workflow.md)