# ui1_template

A LaTeX document class and CLI tool for producing branded activity submissions for the **Universidad Isabel I** — Grado en Administración y Dirección de Empresas.

The class (`ui1activity.cls`) enforces the university's visual identity (cover page, fonts, colors, backgrounds) so every submission looks correct without manual formatting.

---

## Prerequisites

- **TeX Live** (Linux) or **MacTeX** (macOS) with the following packages:
  - `geometry`, `eso-pic`, `graphicx`, `raleway`, `xcolor`, `colortbl`, `tabularx`
  - `fancyhdr`, `ifthen`, `amsmath`, `biblatex`, `listings`, `babel` (Spanish)
- **biber** — bibliography processor (included with TeX Live / MacTeX)
- **BATS** — only needed to run the test suite (included as a git submodule at `tests/bats/`)

---

## Installation

```bash
make install
```

This creates symlinks in your local texmf tree so `ui1activity.cls` is available to any LaTeX document on the system, and copies the `new-activity` script to `~/bin/`.

To remove:

```bash
make uninstall
```

---

## Quick Start

Create a new activity directory with all required files pre-filled:

```bash
new-activity \
  --asignatura "Matemáticas Financieras" \
  --alumno "Israel Herraiz" \
  --grado "Grado en Administración y Dirección de Empresas" \
  --curso "2025-2026" \
  --unidad "Tema 3: Valoración de inversiones" \
  --fecha "8 de mayo de 2026" \
  --options "palatino,nohangbib" \
  actividad-tema-3
```

Then compile:

```bash
cd actividad-tema-3
make pdf
```

---

## Project Structure

```
ui1_template/
├── bin/
│   └── new-activity          # CLI script — scaffolds a new activity directory
├── examples/
│   ├── plantilla.tex         # Example LaTeX source using ui1activity
│   └── referencias.bib       # Example bibliography file
├── imgs/
│   ├── portada.png           # Cover page background (A4, branded)
│   └── interior.png          # Interior pages background (A4, branded)
├── tests/
│   ├── bats/                 # BATS test framework (git submodule)
│   ├── latex/                # LaTeX fixture files for make test
│   ├── shell/                # BATS and shell test files
│   └── run_tests.sh          # Test runner wrapper
├── ui1activity.cls           # LaTeX document class
├── Makefile                  # Build, install, and test targets
└── .claude/skills/
    └── new-activity.md       # Claude Code skill for invoking the CLI
```

---

## CLI Reference — `new-activity`

### Required flags

| Flag | Description |
|------|-------------|
| `--asignatura SUBJECT` | Subject name |
| `--alumno NAME` | Student name |
| `<directory>` | Target directory to create |

### Optional flags

| Flag | Description | Default |
|------|-------------|---------|
| `--grado PROGRAM` | Degree program | `"Grado en Administración y Dirección de Empresas"` |
| `--curso YEAR` | Academic year | *(empty)* |
| `--unidad UNIT` | Didactic unit | *(empty)* |
| `--fecha DATE` | Date in Spanish format | Today's date |
| `--options OPTS` | Document class options | `"palatino,nohangbib"` |
| `--dry-run` | Print resolved values without creating files | — |
| `--help` | Show usage and exit | — |

### Files created

Inside `<directory>/`:
- `<directory>.tex` — LaTeX source pre-filled with all metadata
- `referencias.bib` — empty bibliography stub
- `Makefile` — with `pdf`, `clean`, and `open` targets

---

## Running the Test Suite

```bash
bash tests/run_tests.sh tests/shell/*.bats
```

All 19 tests should pass. The suite covers argument parsing, file generation, install/uninstall behavior, and a smoke test for the BATS harness.

---

## Contributing

- Keep all functional behavior in `ui1activity.cls` unchanged unless intentional.
- Run the full test suite before submitting changes.
- Use `git mv` for file moves to preserve history.
- Follow the [Conductor](conductor/) spec-driven workflow for non-trivial changes.
