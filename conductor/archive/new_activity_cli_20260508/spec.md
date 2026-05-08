# Spec: New Activity CLI + Claude Code Skill

## Overview
A Bash CLI script (`new-activity`) that scaffolds new LaTeX activity directories
using the `ui1activity` document class. All metadata is supplied via command-line
flags. The project's `Makefile` gains an `install` target that copies the script
to `~/bin/`. `~/bin` is added to `$PATH` in `~/.zshrc`. A companion Claude Code
skill enables easy invocation from within Claude Code sessions.

## Functional Requirements

### CLI Script (`new-activity`)
Flags:
- `--grado`      Degree program (default: "Grado en Administración y Dirección de Empresas")
- `--curso`      Academic year (e.g., "2025-2026")
- `--asignatura` Subject name (required)
- `--unidad`     Didactic unit
- `--alumno`     Student name (required)
- `--fecha`      Date in Spanish format (default: today's date)
- `--options`    Document class options (default: "palatino,nohangbib")
- Positional:    Target directory name (required)

Behaviour:
1. Validate required flags; print usage and exit 1 if missing.
2. Create the target directory (abort if it already exists).
3. Write a `.tex` file pre-filled with all metadata.
4. Write an empty `referencias.bib`.
5. Write a `Makefile` with `pdf`, `clean`, and `open` targets.
6. Print a success message with next steps.

### Generated Makefile (inside each new activity directory)
- `make` / `make pdf` — multi-pass compile: pdflatex → biber → pdflatex × 2
- `make clean`        — remove auxiliary files (`.aux`, `.log`, `.toc`, `.bbl`, etc.)
- `make open`         — open the compiled PDF via `xdg-open`

### Project Makefile (this repo)
- `make install`   — copies `new-activity` to `~/bin/` and makes it executable;
                     appends `export PATH="$HOME/bin:$PATH"` to `~/.zshrc` if not present
- `make uninstall` — removes `new-activity` from `~/bin/`

### Shell Configuration
- Append `export PATH="$HOME/bin:$PATH"` to `~/.zshrc` only if not already present.
  Done as part of `make install`.

### Claude Code Skill
- A skill file (`.claude/skills/new-activity.md`) that instructs Claude Code to
  use the `new-activity` CLI, documents all flags, and guides the user through
  creating a new activity directory from within a Claude Code session.

## Non-Functional Requirements
- POSIX-compatible Bash; no external dependencies beyond standard Unix tools + LaTeX.
- Script must be idempotent for `make install` (re-running is safe).

## Acceptance Criteria
- `new-activity --asignatura "Matemáticas" --alumno "Israel" my-dir` creates
  `my-dir/` with a compilable `.tex`, `referencias.bib`, and `Makefile`.
- `make pdf` inside the created directory produces a valid PDF.
- `make install` copies the script to `~/bin/` and updates `~/.zshrc`.
- The Claude Code skill is discoverable and usable.

## Out of Scope
- Interactive prompt mode
- Windows/macOS-specific support
- Multiple template styles
- GUI
