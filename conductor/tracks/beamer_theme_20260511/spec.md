# Spec: UI1 Beamer Theme

## Overview
Create a Beamer presentation theme (`ui1beamer.sty`) that mirrors the visual
identity of `ui1activity.cls` — same UI1 logo, colors, decorative frame, and
Helvetica typography — adapted for landscape slide format (16:9). Accompany it
with a `new-slides` CLI script and AI skill for scaffolding new presentations,
integrated into the existing `Makefile` install workflow.

### Design note (2026-08-09): portrait assets, landscape slides
`imgs/portada.png` and `imgs/interior.png` are A4 portrait (1240×1754 px at
150 dpi = 595.2 bp × 841.9 bp). Scaling them to fill a 16:9 slide stretches
their content ~26% horizontally, which visibly deforms the round UI1 logo and
the address line at the foot of `interior.png`. The theme therefore **redraws**
the decorative frame (gray border, red accent bars) natively with `eso-pic`
rectangles in `uired`/`uigray`, and reuses only the logo, cropped out of
`imgs/portada.png` with `\includegraphics[trim=…,clip]` so its aspect ratio is
preserved. No new image assets are introduced and no asset is distorted.

## Functional Requirements

### FR1: Theme File
- A Beamer outer/inner/color theme package (`ui1beamer.sty`) loaded via
  `\usetheme{ui1beamer}` in a standard `\documentclass{beamer}` document.
- 16:9 is selected by the document, not the theme:
  `\documentclass[aspectratio=169]{beamer}`. `aspectratio` is a beamer class
  option and cannot be set from a theme file. The theme issues a package
  warning when the paper is not 16:9.
- Reuses `imgs/portada.png` (logo region only) without duplicating assets.

### FR2: Title Slide
- Decorative frame drawn in UI1 colors, with the UI1 logo in the upper-left,
  matching the proportions of the `ui1activity.cls` cover.
- Standard Beamer layout: presentation title (prominent, centered or upper
  area), subtitle below, then author + date in smaller text toward the bottom.
- All text in Helvetica; title colored uired (#E4004F), remaining text white
  or dark as needed for legibility against the background.
- Metadata commands: `\title`, `\subtitle`, `\author`, `\date`; optionally
  `\asignatura` for subject line.

### FR3: Content Slides
- Decorative frame drawn natively on all non-title frames (see design note).
- **Header band:** Solid uired (#E4004F) strip across the top.
  - Left: current section name (Helvetica, white, bold).
  - Right: UI1 logo cropped from `imgs/portada.png`.
- **Footer band:** Solid uigray (#BFBFBF) strip across the bottom.
  - Left: presentation title (small, Helvetica, dark).
  - Right: slide number (small, Helvetica, dark).
- **Frame titles:** Bold Helvetica, colored uired.
- **Content area:** Main frame body between the two bands.

### FR4: Colors
- Same definitions as `ui1activity.cls`: `uired` (#E4004F), `uigray`
  (#BFBFBF).
- Beamer block environments (standard, example, alert) styled with UI1 colors.

### FR5: Typography
- All slide text in Helvetica (sans-serif); `\sfdefault` set globally.
- Spanish language support via `babel` (spanish) and `icomma`.
- `amsmath` included for math slides.
- `hyperref` is NOT explicitly loaded — Beamer handles it internally; use
  `\hypersetup` for any extra configuration.

### FR6: `bin/new-slides` CLI
- POSIX-compatible Bash script, following the same patterns as `bin/new-activity`:
  positional target directory, `--dry-run`, `--help`, and abort with a non-zero
  status if the target directory already exists.
- Required flags: `--titulo` (presentation title), `--autor` (author).
- Optional flags: `--asignatura`, `--subtitulo`, `--fecha` (with sensible
  defaults).
- Scaffolds a new directory containing:
  - A `.tex` file pre-filled with `\documentclass[aspectratio=169]{beamer}`,
    `\usetheme{ui1beamer}`, title frame, and one sample content frame.
  - A `Makefile` with `pdf`, `clean`, and `open` targets.
- No `imgs/` symlink is created: `make install` already symlinks `imgs/` into
  the local texmf tree next to the theme, so `\includegraphics{imgs/portada}`
  resolves through kpathsea exactly as it does for `ui1activity.cls`.

### FR7: AI Skill (`skills/new-slides/SKILL.md`)
- Portable Agent Skill definition enabling `new-slides` CLI invocation from
  Codex, Claude Code, Gemini CLI, and Antigravity CLI sessions.
- Lives at `skills/new-slides/SKILL.md` in the repo root (same structure as
  `skills/new-activity/SKILL.md`).
- Installed by the shared Agent Skill installer to the canonical
  `~/.agents/skills/new-slides/` directory and exposed through the configured
  compatibility destinations.

### FR8: Makefile Integration
- `make install` installs `ui1beamer.sty` to the user's local texmf tree
  (alongside `ui1activity.cls`), runs `texhash`/`mktexlsr`, copies
  `bin/new-slides` to `~/bin/` (idempotent PATH setup in `~/.zshrc`), and
  installs both canonical skills and their compatibility links.
- `make uninstall` reverses all of the above.

## Non-Functional Requirements

- Compiles with `pdflatex` (same toolchain as `ui1activity.cls`; no XeLaTeX
  or LuaLaTeX dependency introduced).
- No duplication of `imgs/` assets — the theme references them via a
  configurable path (defaulting to `imgs/`).
- `new-slides` never overwrites: running it against an existing directory
  fails with a clear error and a non-zero exit status.

## Acceptance Criteria

1. `\documentclass[aspectratio=169]{beamer}` + `\usetheme{ui1beamer}` compiles
   without errors using `pdflatex`, producing 16:9 pages.
2. Title slide renders with the UI1 decorative frame, an undistorted logo, and
   correct UI1-styled title/author/date layout.
3. Content slides render with the decorative frame, uired header band
   (section name left, logo right), uigray footer band (title left, slide
   number right).
4. All slide text uses Helvetica; frame titles are uired bold.
5. `make install` installs the theme to the local texmf tree, `new-slides`
   to `~/bin/`, and its portable skill through the shared Agent Skill
   installer.
6. `bin/new-slides --titulo "Foo" --autor "Bar"` scaffolds a directory that
   compiles to a valid PDF with `make pdf`.
7. All BATS tests for the new CLI pass.

## Out of Scope

- Alternative aspect ratios (only 16:9 in this track).
- Bibliography/biblatex integration in slides.
- Beamer transitions and animations.
- Custom itemize/enumerate bullet styles beyond Beamer defaults.
- A `nocoverpage` equivalent option (all presentations start with the title
  frame using `portada.png`).
