# Implementation Plan: Use Helvetica in Cover Table

## Phase 1: Test Updates
- [ ] Task: Write/Update failing tests for Cover Table
    - [ ] Review existing tests (e.g., `tests/test_cover.tex`) and ensure they fully exercise the `\makecustomcover` command.
    - [ ] Add assertions or compilation checks to ensure the document builds successfully with the font changes.
- [ ] Task: Conductor - User Manual Verification 'Test Updates' (Protocol in workflow.md)

## Phase 2: Implementation
- [ ] Task: Update header cell typography in `ui1activity.cls`
    - [ ] Locate the `\makecustomcover` command.
    - [ ] Apply `\sffamily` to the text in the red header cell (`\@grado` and `Curso académico...`).
    - [ ] Adjust font sizing (e.g., tweaking `\fontsize{11}{13}`) if necessary for visual balance.
- [ ] Task: Update field labels typography in `ui1activity.cls`
    - [ ] Apply `\textsf{\textbf{...}}` (or equivalent) to the labels (e.g., "Asignatura:") in the gray cells.
    - [ ] Ensure the corresponding values (`\@asignatura`, etc.) remain outside the sans-serif scope.
- [ ] Task: Local manual verification
    - [ ] Compile the test files and visually verify the PDF output to ensure correct font families and visual balance.
- [ ] Task: Conductor - User Manual Verification 'Implementation' (Protocol in workflow.md)