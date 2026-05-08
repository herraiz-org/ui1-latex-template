# Technology Stack

## Core
- **Language:** LaTeX
- **Document Class:** `ui1activity.cls` (Custom class inheriting from `article`)
- **Compilers:** `pdflatex` (Version 3.141592653 or newer), `biber`
- **Encoding:** UTF-8

## Formatting & Layout
- `geometry`: Used for strict margin control (Top: 7mm, Left: 27.5mm, Right: 25mm, Bottom: 20mm).
- `babel`: Configured for Spanish localization (`es-tabla`) to ensure correct hyphenation and labels.
- `icomma`: Intelligently handles decimal commas in math mode.
- `eso-pic`: Handles the full-page background underlays (`imgs/portada.png` and `imgs/interior.png`).
- `fancyhdr`: Manages custom headers and footers (page numbering).
- `ifthen`: Provides conditional logic for page-specific backgrounds.
- `caption`: Standardizes caption handling and resolves conflicts with advanced bibliography styles.
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

## Academic Features
- `amsmath`: Robust support for mathematical notation.
- `biblatex`, `csquotes`: Advanced bibliography management (APA style) with support for disabling hanging indents.
- `listings`: High-quality source code rendering with branded styles.

## Build Tools
- `Makefile`: Automates multi-pass compilation for table alignment and bibliographic references; provides `install`/`uninstall` targets to manage symlinks in the user's local texmf tree, and `install`/`uninstall` targets to copy the `new-activity` CLI to `~/bin/` with idempotent `~/.zshrc` PATH setup.
- `new-activity`: A POSIX-compatible Bash CLI script that scaffolds new activity directories. Flags: `--asignatura`, `--alumno` (required); `--grado`, `--curso`, `--unidad`, `--fecha`, `--options` (optional with defaults).

## Testing
- **BATS (bats-core):** Bash Automated Testing System, added as a git submodule under `tests/bats`. Test files live in `tests/*.bats`; run via `bash tests/run_tests.sh <file.bats>`.
