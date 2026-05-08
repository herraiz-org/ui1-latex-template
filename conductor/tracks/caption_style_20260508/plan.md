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

## Phase 2: Implement Caption Styling

- [ ] Task: Update `ui1activity.cls` with `\captionsetup`
  - [ ] Set `font={small,it}` — applies italic + small size to the full caption
  - [ ] Set `labelfont={bf}` — adds bold to the label, yielding bold-italic
  - [ ] Set `margin=1cm` — indents caption 1 cm on each side
  - [ ] Confirm settings are global (no per-environment overrides needed)

- [ ] Task: Verify tests pass (Green Phase)
  - [ ] Run the new BATS test file
  - [ ] Confirm all new tests pass
  - [ ] Run full test suite to check for regressions

- [ ] Task: Conductor - User Manual Verification 'Phase 2: Implement Caption Styling' (Protocol in workflow.md)

## Phase 3: Regression & Final Verification

- [ ] Task: Run full test suite
  - [ ] Execute `bash tests/run_tests.sh tests/shell/*.bats`
  - [ ] Confirm all existing and new tests pass

- [ ] Task: Manual PDF verification
  - [ ] Compile a document with figure, table, and lstlisting captions using the
        Palatino option
  - [ ] Verify: bold-italic label + italic descriptive text in PDF
  - [ ] Verify: caption is visually narrower than body paragraphs (1 cm each side)
  - [ ] Verify: List of Figures / List of Tables entries are visually unchanged
  - [ ] Repeat compilation with the Times New Roman font option and confirm same style

- [ ] Task: Conductor - User Manual Verification 'Phase 3: Regression & Final Verification' (Protocol in workflow.md)
