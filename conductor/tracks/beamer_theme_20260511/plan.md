# Plan: UI1 Beamer Theme

## [x] Phase 1: Theme Foundation [checkpoint: b525ccc]

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
- [x] Task: Conductor - User Manual Verification 'Phase 1: Theme Foundation' (Protocol in workflow.md)

## [x] Phase 2: CLI Scaffolding (`bin/new-slides`) [checkpoint: c271a2b]

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

## [x] Phase 3: AI Skill [checkpoint: c7560ed]

- [x] Task: Create `skills/new-slides/SKILL.md` 0e88eaa
  - [x] Model it on `skills/new-activity/SKILL.md`.
  - [x] Document all flags, describe scaffolded output, and provide example
        invocations for Claude Code and Gemini CLI.
- [x] Task: Conductor - User Manual Verification 'Phase 3: AI Skill' (Protocol in workflow.md)

## [ ] Phase 4: Makefile Integration

- [x] Task: Write failing BATS tests for install/uninstall targets 6d4a4e3
  - [x] Test: `make install` creates symlink for `beamerthemeui1beamer.sty`
        in the local texmf tree.
  - [x] Test: `make install` copies `new-slides` to `~/bin/`.
  - [x] Test: `make install` installs the canonical skill and creates all
        configured compatibility links.
  - [x] Test: `make uninstall` removes all of the above.
  - [x] Run BATS and confirm new tests fail.
- [x] Task: Update `Makefile` install/uninstall targets 72ba8e8
  - [x] Add `ui1beamer.sty` to the texmf install step (alongside
        `ui1activity.cls`).
  - [x] Add `bin/new-slides` copy to `~/bin/` (idempotent `~/.zshrc` PATH
        entry already exists from `new-activity`).
  - [x] Add `skills/new-slides/SKILL.md` to the shared canonical skill install
        and compatibility-link loop.
  - [x] Mirror all additions in the `uninstall` target.
  - [x] Run BATS and confirm all tests pass.
- [~] Task: Conductor - User Manual Verification 'Phase 4: Makefile Integration' (Protocol in workflow.md)

## [ ] Phase 5: Regression & Final Verification

- [x] Task: Run full test suite 1f653b5
  - [x] Execute `bash tests/run_tests.sh tests/shell/*.bats` and confirm no
        regressions in existing `new-activity` tests — 111 tests, 0 failures.
  - [x] Compile all LaTeX test fixtures and confirm no new errors —
        `make test` exits 0; the legacy shell tests pass 8/8 and 6/6.
- [x] Task: Compile example presentation end-to-end 1f653b5
  - [x] Installed into a sandbox HOME with `make install`, scaffolded with
        `new-slides`, and compiled with `make pdf` — 2 pages, 453.5 x 255.1 pt,
        no LaTeX errors, images resolved through the texmf tree with no local
        `imgs` symlink. `make uninstall` left nothing behind.
- [~] Task: Conductor - User Manual Verification 'Phase 5: Regression & Final Verification' (Protocol in workflow.md)
