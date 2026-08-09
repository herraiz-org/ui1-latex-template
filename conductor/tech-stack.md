# Technology Stack

## Core
- **Language:** LaTeX
- **Document Class:** `ui1activity.cls` (Custom class inheriting from `article`)
- **Presentation Theme:** `ui1beamer.sty` (Beamer theme for 16:9 slides)
- **Compilers:** `pdflatex` (Version 3.141592653 or newer), `biber`
- **Encoding:** UTF-8

## Presentations (added 2026-08-09, track `beamer_theme_20260511`)
- `beamer`: Presentation class. Documents select 16:9 themselves with
  `\documentclass[aspectratio=169]{beamer}` — `aspectratio` is a class option
  and cannot be set from a theme file, so `ui1beamer.sty` only warns when the
  paper is not 16:9.
- The theme reuses `uired`/`uigray` and Helvetica from `ui1activity.cls`, but
  **redraws** the decorative frame with `eso-pic` rectangles instead of using
  `imgs/portada.png` and `imgs/interior.png` full-bleed: those assets are A4
  portrait (595.2 bp × 841.9 bp) and stretching them to 16:9 deforms the logo
  and the interior footer text by ~26%. Only the logo is reused, cropped from
  `imgs/portada.png` with `\includegraphics[trim=…,clip]`.

## Formatting & Layout
- `geometry`: Used for strict margin control (Top: 7mm, Left: 27.5mm, Right: 25mm, Bottom: 20mm).
- `babel`: Configured for Spanish localization (`es-tabla`) with English also loaded; Spanish is the document default. The dual-language setup enables `\selectlanguage{english}` in documents and powers the automatic `iflanguage`-based heading for the legislation bibliography section.
- `icomma`: Intelligently handles decimal commas in math mode.
- `eso-pic`: Handles the full-page background underlays (`imgs/portada.png` and `imgs/interior.png`).
- `fancyhdr`: Manages custom headers and footers (page numbering).
- `ifthen`: Provides conditional logic for page-specific backgrounds.
- `caption`: Standardizes caption handling, enforces global caption style (bold-italic label, italic small-size text, 1 cm lateral margin via `\captionsetup`), and resolves conflicts with advanced bibliography styles.
- `titlesec`: Used for consistent formatting of section headers in sans-serif bold.

## Branding & Aesthetics
- `newpxtext`, `newpxmath`: Palatino-based fonts for body and math (default).
- `newtxtext`, `newtxmath`: Times-based fonts for body and math (optional).
- `helvet`: Helvetica font for headers, scaled for visual harmony.
- `xcolor`: Defines university colors (`uired`: #E4004F, `uigray`: #BFBFBF).
- `graphicx`: Essential for including the PNG background assets.

## Tables
- `tabularx`: Provides fixed-width tables with auto-scaling columns.
- `colortbl`: Used for branded table headers and row backgrounds.

## PDF Output
- `hyperref`: Embeds the table of contents as navigable PDF bookmarks (outline/sidebar) and auto-populates PDF document properties (Title from `\unidaddidactica`, Author from `\alumno`, Subject from `\asignatura`). Loaded last to avoid conflicts; configured with `hidelinks` and `bookmarksdepth=3`.

## Academic Features
- `amsmath`: Robust support for mathematical notation.
- `biblatex`, `csquotes`: Advanced bibliography management (APA style) with support for disabling hanging indents.
- `listings`: High-quality source code rendering with branded styles.

## Build Tools
- `Makefile`: Automates multi-pass compilation for table alignment and bibliographic references; provides `install`/`uninstall` targets to manage symlinks in the user's local texmf tree, copy the `new-activity` CLI to `~/bin/` with idempotent `~/.zshrc` PATH setup, and install one canonical Agent Skill under `~/.agents/skills/` with compatibility links for Codex, Claude Code, Gemini CLI, and Antigravity CLI. `INSTALL_AGENT_SKILLS` changes the canonical root, while `SKILL_COMPAT_DIRS` replaces the compatibility destination list.
- `bin/new-activity`: A POSIX-compatible Bash CLI script that scaffolds new activity directories. Flags: `--asignatura`, `--alumno` (required); `--grado`, `--curso`, `--unidad`, `--fecha`, `--options` (optional with defaults). The generated `referencias.bib` includes commented-out `@legislation` (`title`, `number`, `eid`, `year`) and `@jurisprudencia` (`kind`, `court`, `shortcourt`, `number`, `chamber`, `fdate`, `ecli`, `url`) entries showing all required fields for each type.
- `bin/new-slides`: A POSIX-compatible Bash CLI script that scaffolds new Beamer presentation directories using `ui1beamer.sty`. Flags: `--titulo`, `--autor` (required); `--asignatura`, `--subtitulo`, `--fecha` (optional with defaults); plus `--dry-run` and `--help`. Takes a positional target directory and aborts if it already exists, like `bin/new-activity`.
- `skills/new-activity/SKILL.md`, `skills/new-slides/SKILL.md`: Portable Agent Skill definitions for the CLIs and the single source of truth installed by `make install`.

## Testing
- **BATS (bats-core):** Bash Automated Testing System, added as a git submodule under `tests/bats`. Shell test files live in `tests/shell/`; LaTeX fixture files live in `tests/latex/`; run via `bash tests/run_tests.sh tests/shell/*.bats`.
