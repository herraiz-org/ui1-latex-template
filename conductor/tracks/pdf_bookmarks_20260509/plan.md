# Plan: PDF Bookmarks and Metadata via hyperref

## [~] Phase 1: Test Infrastructure (Red Phase)

- [x] Task: Write failing BATS test — PDF metadata
  - [x] Sub-task: Create `tests/shell/test_pdf_metadata.bats`
  - [x] Sub-task: Add a LaTeX fixture (or reuse an existing one) compiled
        with known `\activitytitle`, `\alumno`, and `\asignatura` values
  - [x] Sub-task: Assert `pdfinfo` output contains the expected Title,
        Author, and Subject strings
  - [x] Sub-task: Confirm the test fails (Red phase verified)

- [x] Task: Write failing BATS test — PDF bookmark/outline presence
  - [x] Sub-task: Assert the compiled PDF contains bookmark/outline data
        (e.g. via `pdfinfo` reporting bookmarks or `mutool show` output)
  - [x] Sub-task: Confirm the test fails (Red phase verified)

- [~] Task: Conductor - User Manual Verification 'Phase 1: Test
      Infrastructure (Red Phase)' (Protocol in workflow.md)

## [ ] Phase 2: Implementation (Green Phase)

- [ ] Task: Update `tech-stack.md` — document `hyperref` addition
  - [ ] Sub-task: Add `hyperref` entry with a one-line description of its
        role (PDF bookmarks + metadata, `hidelinks`, depth 3)

- [ ] Task: Integrate `hyperref` into `ui1activity.cls`
  - [ ] Sub-task: Load `hyperref` with `hidelinks` and `bookmarksdepth=3`
        after all other `\RequirePackage` calls to avoid conflicts
  - [ ] Sub-task: Add an `\AtBeginDocument` hook that calls `\hypersetup`
        to bind `pdftitle`, `pdfauthor`, and `pdfsubject` from the
        class's internal metadata storage fields

- [ ] Task: Run new BATS tests and confirm they pass (Green phase)
  - [ ] Sub-task: Execute `bash tests/run_tests.sh tests/shell/test_pdf_metadata.bats`
  - [ ] Sub-task: Confirm all new assertions pass

- [ ] Task: Conductor - User Manual Verification 'Phase 2: Implementation
      (Green Phase)' (Protocol in workflow.md)

## [ ] Phase 3: Regression & Final Verification

- [ ] Task: Run the full existing BATS test suite
  - [ ] Sub-task: Execute `bash tests/run_tests.sh tests/shell/*.bats`
  - [ ] Sub-task: Confirm all pre-existing tests still pass

- [ ] Task: Visual regression check
  - [ ] Sub-task: Compile a complete test activity PDF
  - [ ] Sub-task: Open in a PDF viewer and confirm bookmarks appear in
        the outline/sidebar at all three section levels
  - [ ] Sub-task: Confirm no colored links or boxes appear in the
        document body
  - [ ] Sub-task: Confirm PDF Document Properties shows the correct
        Title, Author, and Subject

- [ ] Task: Conductor - User Manual Verification 'Phase 3: Regression &
      Final Verification' (Protocol in workflow.md)
