# Plan: Styled Captions for Float Environments

## Phase 1: Write Failing Tests [checkpoint: d995b44]

- [x] Task: Analyze existing test structure
  - [x] Read existing BATS test files in `tests/shell/`
  - [x] Read existing LaTeX fixture files in `tests/latex/`
  - [x] Identify naming conventions for new test and fixture files

- [x] Task: Create LaTeX test fixture
  - [x] Create a fixture `.tex` file containing a `figure`, a `table`, and a
        `lstlisting` environment, each with a `\caption`
  - [x] Confirm the fixture compiles cleanly against the current `ui1activity.cls`
        (baseline — no new styling yet)

- [x] Task: Write failing BATS tests (Red Phase) [dcb60f5]
  - [x] Create a new `.bats` test file following existing naming conventions
  - [x] Write test: fixture compiles without errors or warnings
  - [x] Write test: PDF output is produced
  - [x] Run tests and confirm they fail as expected (caption style not yet applied)

- [x] Task: Conductor - User Manual Verification 'Phase 1: Write Failing Tests' (Protocol in workflow.md) [d995b44]

## Phase 2: Implement Caption Styling [checkpoint: 4539ad8]

- [x] Task: Update `ui1activity.cls` with `\captionsetup`
  - [x] Set `font={small,it}` — applies italic + small size to the full caption
  - [x] Set `labelfont={bf}` — adds bold to the label, yielding bold-italic
  - [x] Set `margin=1cm` — indents caption 1 cm on each side
  - [x] Confirm settings are global (no per-environment overrides needed)

- [x] Task: Verify tests pass (Green Phase) [3aafa6a]
  - [x] Run the new BATS test file
  - [x] Confirm all new tests pass
  - [x] Run full test suite to check for regressions

- [x] Task: Conductor - User Manual Verification 'Phase 2: Implement Caption Styling' (Protocol in workflow.md) [4539ad8]

## Phase 3: Regression & Final Verification [checkpoint: 26fd871]

- [x] Task: Run full test suite
  - [x] Execute `bash tests/run_tests.sh tests/shell/*.bats`
  - [x] Confirm all existing and new tests pass

- [x] Task: Manual PDF verification
  - [x] Compile a document with figure, table, and lstlisting captions using the
        Palatino option
  - [x] Verify: bold-italic label + italic descriptive text in PDF
  - [x] Verify: caption is visually narrower than body paragraphs (1 cm each side)
  - [x] Verify: List of Figures / List of Tables entries are visually unchanged
  - [x] Repeat compilation with the Times New Roman font option and confirm same style

- [x] Task: Conductor - User Manual Verification 'Phase 3: Regression & Final Verification' (Protocol in workflow.md) [26fd871]
