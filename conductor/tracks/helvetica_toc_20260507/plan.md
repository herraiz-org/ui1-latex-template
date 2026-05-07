# Implementation Plan: Apply Helvetica to Table of Contents Entries

## Phase 1: Test Updates [checkpoint: dc952b0]
- [x] Task: Write failing tests for TOC Helvetica typography `836d4ce`
    - [ ] Create `tests/test_toc.tex` — a minimal document with sections,
          subsections, subsubsections, and `\tableofcontents`.
    - [ ] Create `tests/test_helvetica_toc.sh` — a shell script that:
          - Greps `ui1activity.cls` for `titletoc` being loaded.
          - Greps for `\sffamily\bfseries` applied to section TOC entries.
          - Greps for `\sffamily` applied to subsection/subsubsection TOC entries.
          - Compiles `tests/test_toc.tex` and confirms a PDF is produced.
    - [ ] Run the script and confirm all grep assertions fail (Red phase).
- [x] Task: Conductor - User Manual Verification 'Test Updates' (Protocol in workflow.md) `dc952b0`

## Phase 2: Implementation
- [x] Task: Load `titletoc` package in `ui1activity.cls` `a87e401`
    - [ ] Add `\RequirePackage{titletoc}` after the `titlesec` require line.
- [x] Task: Style section TOC entries `ab5dc85`
    - [ ] Use `\titlecontents{section}` to apply `\sffamily\bfseries` to the
          entry text, preserving indentation and dot leaders.
- [x] Task: Style subsection TOC entries `855c79e`
    - [ ] Use `\titlecontents{subsection}` to apply `\sffamily` (no bold).
- [x] Task: Style subsubsection TOC entries `ffc4106`
    - [ ] Use `\titlecontents{subsubsection}` to apply `\sffamily` (no bold).
- [~] Task: Local manual verification
    - [ ] Compile `tests/test_toc.tex` and visually verify that section entries
          are bold Helvetica and subsection/subsubsection entries are regular
          Helvetica, with all spacing and leaders unchanged.
- [ ] Task: Conductor - User Manual Verification 'Implementation' (Protocol in workflow.md)
