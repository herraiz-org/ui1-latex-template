# Plan: UI1 Beamer Theme

## [ ] Phase 1: Theme Foundation

- [x] Task: Write failing LaTeX compilation test for `\usetheme{ui1beamer}` 738bdc6
  - [x] Create `tests/latex/test_beamer_loads.tex` — minimal Beamer doc that
        loads the theme and compiles; verify it fails without the theme file.
- [x] Task: Implement `ui1beamer.sty` skeleton 2e2ce99
  - [x] Create `beamerthemeui1beamer.sty` (beamer resolves `\usetheme{ui1beamer}`
        to this filename) declaring colors (`uired`, `uigray`), setting
        `\sfdefault` (Helvetica), and loading `amsmath`, `babel` (spanish),
        `icomma`.
  - [x] Warn when the document is not 16:9; `aspectratio=169` is a beamer
        *class* option supplied by the document, not by the theme.
  - [x] Confirm compilation test now passes.
- [x] Task: Write failing test for the title slide decoration cbdded8
  - [x] Add a test fixture that calls `\titlepage` and inspect the resulting
        PDF for the cropped logo XObject and 16:9 page geometry.
- [x] Task: Implement title slide (decorative frame + cropped logo + layout) 5286064
  - [x] Draw the gray border and red accent bars natively with TikZ
        rectangles; place the UI1 logo cropped from `imgs/portada.png` via
        `\includegraphics[trim=…,clip]` so its aspect ratio is preserved.
  - [x] Style `\title`, `\subtitle`, `\author`, `\date` placeholders in
        Helvetica; title colored uired, remaining text appropriately legible.
  - [x] Add optional `\asignatura` command.
  - [x] Confirm title slide test passes.
- [x] Task: Write failing tests for content slide header/footer bands e2e68ce
  - [x] Fixture with a regular content frame; assert uired header band and
        uigray footer band appear (via PDF color inspection or visual diff
        against a reference PDF).
- [x] Task: Implement content slide layout d1264e1
  - [x] Draw the decorative frame on all non-title frames.
  - [x] Implement uired header band: section name (left, white bold Helvetica)
        and the UI1 wordmark (right, set as text: the logo artwork is dark
        gray on transparent and is illegible over uired).
  - [x] Implement uigray footer band: presentation title (left) + slide
        number (right).
  - [x] Style frame titles: bold Helvetica, uired color.
  - [x] Style Beamer block environments (block, exampleblock, alertblock)
        with UI1 colors.
  - [x] Confirm content slide tests pass.
- [~] Task: Conductor - User Manual Verification 'Phase 1: Theme Foundation' (Protocol in workflow.md)

## [ ] Phase 2: CLI Scaffolding (`bin/new-slides`)

- [x] Task: Write failing BATS tests for `bin/new-slides` 5c5fe7f
  - [x] Test: script exits non-zero when `--titulo`, `--autor`, or the
        positional directory are missing.
  - [x] Test: script creates the expected directory structure with `.tex`
        and `Makefile`.
  - [x] Test: generated `.tex` contains `\documentclass[aspectratio=169]{beamer}`,
        `\usetheme{ui1beamer}`, and the supplied `--titulo` and `--autor` values.
  - [x] Test: script aborts with a non-zero status when the target directory
        already exists, leaving it untouched.
  - [x] Run BATS and confirm all new tests fail.
- [x] Task: Implement `bin/new-slides` 4736d6c
  - [x] Write POSIX-compatible Bash script modelled on `bin/new-activity`.
  - [x] Parse flags: `--titulo` (required), `--autor` (required),
        `--asignatura`, `--subtitulo`, `--fecha` (optional with defaults),
        plus `--dry-run` and `--help`.
  - [x] Scaffold output directory: `.tex` and `Makefile` (pdf/clean/open
        targets). Images resolve through the texmf tree, so no symlink.
  - [x] Run BATS and confirm all new tests pass.
  - [ ] Confirm `shellcheck bin/*` is clean — shellcheck is not installed on
        this machine; the CI lint job is the first place it runs.
- [~] Task: Conductor - User Manual Verification 'Phase 2: CLI Scaffolding' (Protocol in workflow.md)

## [ ] Phase 3: AI Skill

- [ ] Task: Create `skills/new-slides/SKILL.md`
  - [ ] Model it on `skills/new-activity/SKILL.md`.
  - [ ] Document all flags, describe scaffolded output, and provide example
        invocations for Claude Code and Gemini CLI.
- [ ] Task: Conductor - User Manual Verification 'Phase 3: AI Skill' (Protocol in workflow.md)

## [ ] Phase 4: Makefile Integration

- [ ] Task: Write failing BATS tests for install/uninstall targets
  - [ ] Test: `make install` creates symlink for `ui1beamer.sty` in the local
        texmf tree.
  - [ ] Test: `make install` copies `new-slides` to `~/bin/`.
  - [ ] Test: `make install` installs the canonical skill and creates all
        configured compatibility links.
  - [ ] Test: `make uninstall` removes all of the above.
  - [ ] Run BATS and confirm new tests fail.
- [ ] Task: Update `Makefile` install/uninstall targets
  - [ ] Add `ui1beamer.sty` to the texmf install step (alongside
        `ui1activity.cls`).
  - [ ] Add `bin/new-slides` copy to `~/bin/` (idempotent `~/.zshrc` PATH
        entry already exists from `new-activity`).
  - [ ] Add `skills/new-slides/SKILL.md` to the shared canonical skill install
        and compatibility-link loop.
  - [ ] Mirror all additions in the `uninstall` target.
  - [ ] Run BATS and confirm all tests pass.
- [ ] Task: Conductor - User Manual Verification 'Phase 4: Makefile Integration' (Protocol in workflow.md)

## [ ] Phase 5: Regression & Final Verification

- [ ] Task: Run full test suite
  - [ ] Execute `bash tests/run_tests.sh tests/shell/*.bats` and confirm no
        regressions in existing `new-activity` tests.
  - [ ] Compile all LaTeX test fixtures and confirm no new errors.
- [ ] Task: Compile example presentation end-to-end
  - [ ] Run `bin/new-slides --titulo "Prueba" --autor "Estudiante"` and
        confirm `make pdf` produces a valid, visually correct PDF.
- [ ] Task: Conductor - User Manual Verification 'Phase 5: Regression & Final Verification' (Protocol in workflow.md)
