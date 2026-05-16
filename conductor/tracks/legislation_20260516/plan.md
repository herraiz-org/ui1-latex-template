# Plan: Custom Legislation Bibliography Support

## Phase 1: Legislation Driver and Bibliography List in `ui1activity.cls`

### Task 1.1: Write Failing LaTeX Fixture — Legislation Entry Rendering [497c49c]
- [x] Sub-task: Create `tests/latex/test_legislation.tex` — a minimal document
      using `ui1activity` with one `@legislation` entry in a `.bib` file
- [x] Sub-task: Create `tests/latex/test_legislation.bib` with a sample entry
      (`Ley 16/1987...`, number=182, eid=23546, year=1987)
- [x] Sub-task: Confirm fixture fails to compile (driver not yet defined)

### Task 1.2: Write Failing LaTeX Fixture — Empty Legislation Guard [497c49c]
- [x] Sub-task: Create `tests/latex/test_legislation_empty.tex` — a document
      with no `@legislation` entries; confirm no empty section is emitted
- [x] Sub-task: Confirm fixture fails or produces wrong output before implementation

### Task 1.3: Write Failing BATS Test — Legislation Feature in `.cls`
- [ ] Sub-task: Add `tests/shell/legislation.bats` with tests that:
      - Assert `ui1activity.cls` contains `DeclareBibliographyDriver{legislation}`
      - Assert `test_legislation.tex` compiles without errors under `pdflatex` + `biber`
      - Assert output PDF contains the string "BOE número"
      - Assert output PDF contains "Legislación" (Spanish babel active)
- [ ] Sub-task: Run `bash tests/run_tests.sh tests/shell/legislation.bats` —
      confirm tests fail (Red phase)

### Task 1.4: Implement `legislation` Driver in `ui1activity.cls`
- [ ] Sub-task: Add `\DeclareBibliographyDriver{legislation}{...}` block to
      `ui1activity.cls` using the driver format from the spec
- [ ] Sub-task: Run failing tests — confirm driver-related tests now pass

### Task 1.5: Implement Dedicated Legislation Bibliography Category
- [ ] Sub-task: Declare a `biblatex` bibliography category `legislation` via
      `\DeclareBibliographyCategory` in `ui1activity.cls`
- [ ] Sub-task: Add `\addtocategory{legislation}{*}` assignment for all
      `@legislation` type entries (using `\AtEveryBibitem` or equivalent filter)
- [ ] Sub-task: Define `\defbibfilter{legislation}` or use category-based
      `\printbibliography[category=legislation, ...]` approach
- [ ] Sub-task: Run tests — confirm legislation entries are isolated correctly

### Task 1.6: Implement Localized Heading via Babel
- [ ] Sub-task: Define `\iflanguage{spanish}` (and variants) to set the
      legislation list title to "Legislación" or "Legislation"
- [ ] Sub-task: Create `tests/latex/test_legislation_english.tex` — same fixture
      with `\usepackage[english]{babel}` — verify heading becomes "Legislation"
- [ ] Sub-task: Add assertion to `legislation.bats` for English heading
- [ ] Sub-task: Run full BATS suite — confirm localization tests pass

### Task 1.7: Implement Print Order — Legislation Before Main Bibliography
- [ ] Sub-task: Ensure the legislation `\printbibliography` call is emitted
      before the main `\printbibliography` call within the class
- [ ] Sub-task: Add BATS assertion: in the compiled PDF text stream, "Legislación"
      appears before "Referencias" (or the main heading)
- [ ] Sub-task: Run full BATS suite — all tests green

### Task 1.8: Run Full Test Suite and Verify
- [ ] Sub-task: Run `bash tests/run_tests.sh tests/shell/*.bats`
- [ ] Sub-task: Confirm all tests pass with no regressions

- [ ] Task: Conductor - User Manual Verification 'Phase 1' (Protocol in workflow.md)

---

## Phase 2: CLI Scaffold Update (`bin/new-activity`)

### Task 2.1: Write Failing BATS Test — Legislation Sample in `referencias.bib`
- [ ] Sub-task: Add test to `tests/shell/file_generation.bats` (or a new
      `legislation_scaffold.bats`) that:
      - Runs `new-activity` with required flags
      - Asserts `referencias.bib` contains `% @legislation{`
      - Asserts the commented entry contains `title`, `number`, `eid`, `year` fields
- [ ] Sub-task: Run test — confirm it fails (Red phase)

### Task 2.2: Implement Commented Legislation Example in `bin/new-activity`
- [ ] Sub-task: Locate the `referencias.bib` generation block in `bin/new-activity`
- [ ] Sub-task: Append the commented-out `@legislation` example block after the
      existing content (see spec FR-5 for exact text)
- [ ] Sub-task: Run the BATS test — confirm it passes (Green phase)

### Task 2.3: Run Full Test Suite and Verify No Regressions
- [ ] Sub-task: Run `bash tests/run_tests.sh tests/shell/*.bats`
- [ ] Sub-task: Confirm all tests pass

- [ ] Task: Conductor - User Manual Verification 'Phase 2' (Protocol in workflow.md)
