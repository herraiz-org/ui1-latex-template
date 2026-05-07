# Implementation Plan: Use Helvetica in Cover Table

## Phase 1: Test Updates [checkpoint: 1ad91da]
- [x] Task: Write/Update failing tests for Cover Table [b09b470]
    - [x] Review existing tests (e.g., `tests/test_cover.tex`) and ensure they fully exercise the `\makecustomcover` command.
    - [x] Add assertions or compilation checks to ensure the document builds successfully with the font changes.
- [x] Task: Conductor - User Manual Verification 'Test Updates' (Protocol in workflow.md)

## Phase 2: Implementation [checkpoint: 57e61b8]
- [x] Task: Update header cell typography in `ui1activity.cls` [1fe998a]
    - [x] Locate the `\makecustomcover` command.
    - [x] Apply `\sffamily` to the text in the red header cell (`\@grado` and `Curso académico...`).
    - [x] Adjust font sizing (e.g., tweaking `\fontsize{11}{13}`) if necessary for visual balance.
- [x] Task: Update field labels typography in `ui1activity.cls` [1fe998a]
    - [x] Apply `\textsf{\textbf{...}}` (or equivalent) to the labels (e.g., "Asignatura:") in the gray cells.
    - [x] Ensure the corresponding values (`\@asignatura`, etc.) remain outside the sans-serif scope.
- [x] Task: Local manual verification
    - [x] Compile the test files and visually verify the PDF output to ensure correct font families and visual balance.
- [x] Task: Conductor - User Manual Verification 'Implementation' (Protocol in workflow.md)