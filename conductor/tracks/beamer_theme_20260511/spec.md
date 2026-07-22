# Spec: UI1 Beamer Theme

## Overview
Create a Beamer presentation theme (`ui1beamer.sty`) that mirrors the visual
identity of `ui1activity.cls` — same background images (`imgs/portada.png`,
`imgs/interior.png`), UI1 colors, and Helvetica typography — adapted for
landscape slide format (16:9). Accompany it with a `new-slides` CLI script
and AI skill for scaffolding new presentations, integrated into the existing
`Makefile` install workflow.

## Functional Requirements

### FR1: Theme File
- A Beamer outer/inner/color theme package (`ui1beamer.sty`) loaded via
  `\usetheme{ui1beamer}` in a standard `\documentclass{beamer}` document.
- Reuses `imgs/portada.png` and `imgs/interior.png` without duplicating assets.

### FR2: Title Slide
- Full-page `imgs/portada.png` background.
- Standard Beamer layout: presentation title (prominent, centered or upper
  area), subtitle below, then author + date in smaller text toward the bottom.
- All text in Helvetica; title colored uired (#E4004F), remaining text white
  or dark as needed for legibility against the background.
- Metadata commands: `\title`, `\subtitle`, `\author`, `\date`; optionally
  `\asignatura` for subject line.

### FR3: Content Slides
- Full-page `imgs/interior.png` background on all non-title frames.
- **Header band:** Solid uired (#E4004F) strip across the top.
  - Left: current section name (Helvetica, white, bold).
  - Right: UI1 branding (logo/wordmark if a standalone logo file is available,
    otherwise rely on the background image's built-in decoration).
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
- POSIX-compatible Bash script, following the same patterns as `bin/new-activity`.
- Required flags: `--titulo` (presentation title), `--autor` (author).
- Optional flags: `--asignatura`, `--subtitulo`, `--fecha` (with sensible
  defaults).
- Scaffolds a new directory containing:
  - A `.tex` file pre-filled with preamble, `\usetheme{ui1beamer}`, title
    frame, and one sample content frame.
  - A `Makefile` with `pdf`, `clean`, and `open` targets.
  - A symlink to `imgs/` (relative, pointing back to the repo root) so the
    background images resolve at compile time.

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
- `new-slides` script is idempotent: running it twice with the same arguments
  warns rather than overwrites.

## Acceptance Criteria

1. `\documentclass{beamer}` + `\usetheme{ui1beamer}` compiles without errors
   using `pdflatex`.
2. Title slide renders with `portada.png` background and correct UI1-styled
   title/author/date layout.
3. Content slides render with `interior.png` background, uired header band
   (section name left), uigray footer band (title left, slide number right).
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
