# ui1_template

A LaTeX document class and CLI tool for producing branded activity submissions
for the **Universidad Isabel I** — Grado en Administración y Dirección de
Empresas.

The class (`ui1activity.cls`) enforces the university's visual identity (cover
page, fonts, colors, backgrounds, and bibliography spacing) so every submission
looks correct without manual formatting.

---

## Prerequisites

- **TeX Live** (Linux) or **MacTeX** (macOS) with the following packages:
  - `geometry`, `eso-pic`, `graphicx`, `raleway`, `xcolor`, `colortbl`,
    `tabularx`
  - `fancyhdr`, `ifthen`, `amsmath`, `biblatex`, `listings`, `babel` (Spanish)
  - `hyperref` — PDF bookmarks and metadata
- **biber** — bibliography processor (included with TeX Live / MacTeX)
- **BATS** — only needed to run the test suite (included as a git submodule at
  `tests/bats/`)

---

## Installation

```bash
make install
```

This creates symlinks in your local texmf tree so `ui1activity.cls` is available
to any LaTeX document on the system, copies the `new-activity` script to
`~/bin/`, and installs the `new-activity` Agent Skill globally. The canonical
skill lives at `~/.agents/skills/new-activity`; compatibility links make it
available to Codex, Claude Code, Gemini CLI, and Antigravity CLI without
maintaining harness-specific copies.

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
├── .github/
│   └── workflows/
│       └── ci.yml            # GitHub Actions: shellcheck + BATS + LaTeX tests
├── bin/
│   └── new-activity          # CLI script — scaffolds a new activity directory
├── conductor/                # Spec-driven development workflow (Conductor)
│   ├── archive/              # Completed and archived tracks
│   ├── code_styleguides/     # Coding style guidelines
│   ├── tracks/               # Active track specs and plans
│   ├── index.md              # Conductor index / entry point
│   ├── product-guidelines.md # Design and quality guidelines
│   ├── product.md            # Product vision and goals
│   ├── tech-stack.md         # Technology stack reference
│   ├── tracks.md             # Track registry
│   └── workflow.md           # Development workflow reference
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
└── skills/
    └── new-activity/
        └── SKILL.md          # Portable Agent Skill for invoking the CLI
```

---

## Agent Skill Installation

The repository keeps one portable skill source at
`skills/new-activity/SKILL.md`. `make install` copies it to the open Agent
Skills user directory and creates compatibility links in the discovery paths
used by supported coding agents:

| Agent           | Discovery path                                  |
|-----------------|-------------------------------------------------|
| Codex           | `~/.agents/skills/new-activity`                 |
| Claude Code     | `~/.claude/skills/new-activity`                 |
| Gemini CLI      | `~/.gemini/skills/new-activity`                 |
| Antigravity     | `~/.gemini/config/skills/new-activity`          |
| Antigravity CLI | `~/.gemini/antigravity-cli/skills/new-activity` |

The canonical directory can be changed with `INSTALL_AGENT_SKILLS`, and the
complete space-separated compatibility destination list can be changed with
`SKILL_COMPAT_DIRS`. The older `INSTALL_SKILLS` and `INSTALL_GEMINI_SKILLS`
overrides remain supported.

---

## CLI Reference — `new-activity`

### Required flags

| Flag                   | Description                |
|------------------------|----------------------------|
| `--asignatura SUBJECT` | Subject name               |
| `--alumno NAME`        | Student name               |
| `<directory>`          | Target directory to create |

### Optional flags

| Flag              | Description                                  | Default                                             |
|-------------------|----------------------------------------------|-----------------------------------------------------|
| `--grado PROGRAM` | Degree program                               | `"Grado en Administración y Dirección de Empresas"` |
| `--curso YEAR`    | Academic year                                | *(empty)*                                           |
| `--unidad UNIT`   | Didactic unit                                | *(empty)*                                           |
| `--fecha DATE`    | Date in Spanish format                       | Today's date                                        |
| `--options OPTS`  | Document class options                       | `"palatino,nohangbib"`                              |
| `--dry-run`       | Print resolved values without creating files | —                                                   |
| `--help`          | Show usage and exit                          | —                                                   |

### Files created

Inside `<directory>/`:
- `<directory>.tex` — LaTeX source pre-filled with all metadata
- `referencias.bib` — empty bibliography stub
- `Makefile` — with `pdf`, `clean`, and `open` targets

---

## Running the Test Suite

**BATS tests** (argument parsing, file generation, install/uninstall, PDF
metadata, etc.):

```bash
bash tests/run_tests.sh tests/shell/*.bats
```

All 72 tests should pass.

**Shell tests** (Makefile install/uninstall targets and cover page formatting):

```bash
bash tests/shell/test_install.sh
bash tests/shell/test_helvetica_cover.sh
```

---

## Continuous Integration

A GitHub Actions workflow (`.github/workflows/ci.yml`) runs on every push and
pull request:

- **shellcheck** — lints all shell scripts in `bin/` (runs on `ubuntu-latest`)
- **BATS tests** — runs the full BATS suite inside the
  `ghcr.io/xu-cheng/texlive-full` container
- **LaTeX tests** — compiles all test documents via `make test`

---

## Bibliography

The class uses **biblatex + biber** with the APA style and adds two custom entry
types for Spanish legal writing.

### `\makebibliography`

Use this command instead of `\printbibliography` at the end of your document. It
automatically prints three sections in order — only the sections that have
entries are included:

1. **Jurisprudencia** — court rulings
2. **Legislación / Legislation** — statutes and regulations
3. **References** — everything else (books, articles, …)

### Entry type: `jurisprudencia`

| Field        | Description                                       |
|--------------|---------------------------------------------------|
| `kind`       | Type of ruling (e.g. `Sentencia`)                 |
| `court`      | Full court name                                   |
| `shortcourt` | Abbreviated court name — used in inline citations |
| `chamber`    | Chamber or section (e.g. `Sala de lo Civil`)      |
| `fdate`      | Date of the ruling (e.g. `12 de marzo de 2020`)   |
| `ecli`       | ECLI identifier                                   |
| `url`        | Optional URL to the official text                 |
| `year`       | Year — required by biblatex                       |

Inline citations (`\cite{key}`) render as `shortcourt number`.

Example:

```bibtex
@jurisprudencia{sts2020,
  kind       = {Sentencia},
  court      = {Tribunal Supremo},
  shortcourt = {STS},
  number     = {123/2020},
  chamber    = {Sala de lo Civil},
  fdate      = {12 de marzo de 2020},
  ecli       = {ECLI:ES:TS:2020:123},
  year       = {2020},
}
```

### Entry type: `legislation`

| Field    | Description                        |
|----------|------------------------------------|
| `title`  | Full official title of the statute |
| `number` | BOE issue number                   |
| `eid`    | Section identifier within the BOE  |
| `year`   | Year of publication                |

The class automatically derives `shorttitle` by stripping the law number and
date from `title`, so no manual `shorttitle` field is needed.

Example:

```bibtex
@legislation{lsc2010,
  title  = {Ley de Sociedades de Capital, Real Decreto Legislativo 1/2010,
            de 2 de julio, por el que se aprueba el texto refundido},
  number = {161},
  eid    = {A},
  year   = {2010},
}
```

---

## Contributing

- Keep all functional behavior in `ui1activity.cls` unchanged unless
  intentional.
- Run the full test suite before submitting changes.
- Use `git mv` for file moves to preserve history.
- Follow the [Conductor](conductor/) spec-driven workflow for non-trivial
  changes.

---

## License

Copyright 2026 Israel Herraiz \<isra@herraiz.org\>

Licensed under the Apache License, Version 2.0. See [LICENSE](LICENSE) for the
full text.

The Universidad Isabel I image assets in `imgs/` are excluded from that grant —
see [NOTICE](NOTICE).
