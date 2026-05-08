# Plan: Fix Page Numbering for First Content Page

## Phase 1: Fix Page Counter Reset [checkpoint: 7ae0b14]

- [x] Task: Inspect existing tests to determine fixture location and naming
  conventions
  - [x] Read `tests/shell/` to identify naming patterns
  - [x] Read an existing fixture in `tests/latex/` to understand structure

- [x] Task: Write failing BATS test — assert first section's page number in
  `.toc` is "1" (Red Phase) 1ac0115
  - [x] Create a minimal LaTeX fixture (e.g.,
        `tests/latex/page_numbering.tex`) using `\makecustomcover`,
        `\tableofcontents`, `\clearpage`, and one `\section`
  - [x] Write a BATS test in `tests/shell/` that compiles the fixture with
        `pdflatex`/`biber` and greps the `.toc` file to confirm the first
        section entry records page `1`
  - [x] Run the test suite and confirm the new test **fails** (Red confirmed)

- [x] Task: Replace page-counter background condition with a boolean flag 97728f5
  - [x] Add `\newif\ifui@coverpage` and `\ui@coverpagetrue` near the top of
        `ui1activity.cls`
  - [x] Replace `\ifthenelse{\value{page}=1}{...portada...}{...interior...}`
        with `\ifui@coverpage ... \else ... \fi`

- [x] Task: Register one-shot shipout hook inside `\makecustomcover` to reset
  the page counter after the cover page ships 0d89d10
  - [x] Inside `\makecustomcover`, add
        `\AddToHook{shipout/after}[ui1activity/coverreset]{...}` that:
        calls `\setcounter{page}{1}`, calls `\ui@coverpagefalse`, and
        removes itself via `\RemoveFromHook`

- [x] Task: Run full test suite and confirm Green Phase 0d89d10
  - [x] Run `bash tests/run_tests.sh tests/shell/*.bats`
  - [x] Confirm new test passes and all existing tests still pass

- [x] Task: Commit implementation 0d89d10
  - [x] Stage `ui1activity.cls` and new test/fixture files
  - [x] Commit with message `fix(cls): Reset page counter after cover page so content starts at page 1`
  - [x] Attach git note with task summary

- [x] Task: Conductor - User Manual Verification 'Phase 1: Fix Page Counter
  Reset' (Protocol in workflow.md) 7ae0b14
