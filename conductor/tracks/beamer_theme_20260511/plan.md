# Plan: UI1 Beamer Theme

## [ ] Phase 1: Theme Foundation

- [ ] Task: Write failing LaTeX compilation test for `\usetheme{ui1beamer}`
  - [ ] Create `tests/latex/test_beamer_loads.tex` — minimal Beamer doc that
        loads the theme and compiles; verify it fails without the theme file.
- [ ] Task: Implement `ui1beamer.sty` skeleton
  - [ ] Create `ui1beamer.sty` declaring colors (`uired`, `uigray`), setting
        `\sfdefault` (Helvetica), loading `amsmath`, `babel` (spanish),
        `icomma`, and configuring the 16:9 aspect ratio via
        `\RequirePackage[aspectratio=169]{beamer}` pass-through.
  - [ ] Confirm compilation test now passes.
- [ ] Task: Write failing test for title slide background
  - [ ] Add a test fixture that calls `\titlepage` and inspect the resulting
        PDF for presence of `portada.png` background (via `pdfinfo` or
        checking for image XObject in the PDF).
- [ ] Task: Implement title slide (`portada.png` background + layout)
  - [ ] Set `portada.png` as the full-page background on frames using the
        `plain` or `title` Beamer frame option.
  - [ ] Style `\title`, `\subtitle`, `\author`, `\date` placeholders in
        Helvetica; title colored uired, remaining text appropriately legible.
  - [ ] Add optional `\asignatura` command.
  - [ ] Confirm title slide test passes.
- [ ] Task: Write failing tests for content slide header/footer bands
  - [ ] Fixture with a regular content frame; assert uired header band and
        uigray footer band appear (via PDF color inspection or visual diff
        against a reference PDF).
- [ ] Task: Implement content slide layout
  - [ ] Set `interior.png` as full-page background for all non-title frames.
  - [ ] Implement uired header band: section name (left, white bold Helvetica)
        and UI1 branding placeholder (right).
  - [ ] Implement uigray footer band: presentation title (left) + slide
        number (right).
  - [ ] Style frame titles: bold Helvetica, uired color.
  - [ ] Style Beamer block environments (block, exampleblock, alertblock)
        with UI1 colors.
  - [ ] Confirm content slide tests pass.
- [ ] Task: Conductor - User Manual Verification 'Phase 1: Theme Foundation' (Protocol in workflow.md)

## [ ] Phase 2: CLI Scaffolding (`bin/new-slides`)

- [ ] Task: Write failing BATS tests for `bin/new-slides`
  - [ ] Test: script exits non-zero when `--titulo` or `--autor` are missing.
  - [ ] Test: script creates the expected directory structure with `.tex`,
        `Makefile`, and `imgs` symlink.
  - [ ] Test: generated `.tex` contains `\usetheme{ui1beamer}` and the
        supplied `--titulo` and `--autor` values.
  - [ ] Test: script is idempotent — re-running with same args warns and does
        not overwrite.
  - [ ] Run BATS and confirm all new tests fail.
- [ ] Task: Implement `bin/new-slides`
  - [ ] Write POSIX-compatible Bash script modelled on `bin/new-activity`.
  - [ ] Parse flags: `--titulo` (required), `--autor` (required),
        `--asignatura`, `--subtitulo`, `--fecha` (optional with defaults).
  - [ ] Scaffold output directory: `.tex`, `Makefile` (pdf/clean/open
        targets), and `imgs` symlink pointing back to the repo's `imgs/`.
  - [ ] Run BATS and confirm all new tests pass.
- [ ] Task: Conductor - User Manual Verification 'Phase 2: CLI Scaffolding' (Protocol in workflow.md)

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
  - [ ] Test: `make install` installs skill files to `~/.claude/skills/` and
        `~/.gemini/skills/`.
  - [ ] Test: `make uninstall` removes all of the above.
  - [ ] Run BATS and confirm new tests fail.
- [ ] Task: Update `Makefile` install/uninstall targets
  - [ ] Add `ui1beamer.sty` to the texmf install step (alongside
        `ui1activity.cls`).
  - [ ] Add `bin/new-slides` copy to `~/bin/` (idempotent `~/.zshrc` PATH
        entry already exists from `new-activity`).
  - [ ] Add `skills/new-slides/SKILL.md` install to `~/.claude/skills/` and
        `~/.gemini/skills/`.
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
