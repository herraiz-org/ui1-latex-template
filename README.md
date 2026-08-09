# ui1_template

A LaTeX document class, a Beamer theme, and CLI tools for producing branded
activity submissions and presentations for the **Universidad Isabel I** — Grado
en Administración y Dirección de Empresas.

The class (`ui1activity.cls`) enforces the university's visual identity (cover
page, fonts, colors, backgrounds, and bibliography spacing) so every submission
looks correct without manual formatting. The Beamer theme
(`beamerthemeui1beamer.sty`, loaded with `\usetheme{ui1beamer}`) carries the
same identity onto 16:9 slides.

---

## Prerequisites

- **TeX Live** (Linux) or **MacTeX** (macOS). Loaded by the class and the theme:
  - `geometry`, `eso-pic`, `graphicx`, `xcolor`, `colortbl`, `tabularx`
  - `fancyhdr`, `ifthen`, `amsmath`, `icomma`, `parskip`, `titlesec`, `caption`
  - `biblatex`, `csquotes`, `babel` (Spanish)
  - `beamer`, `tikz` — presentation theme
  - `hyperref` — PDF bookmarks and metadata
- Loaded by *your* document when you need it, not by the class:
  - `listings` — source code. `examples/plantilla.tex` sets up a branded style
    for it, and `new-activity` writes the same block commented out in the
    generated `.tex`.
- **biber** — bibliography processor (included with TeX Live / MacTeX)
- **BATS** — only needed to run the test suite (included as a git submodule at
  `tests/bats/`)

---

## Installation

```bash
make install
```

This creates symlinks in your local texmf tree so `ui1activity.cls` and
`beamerthemeui1beamer.sty` are available to any LaTeX document on the system,
copies the `new-activity` and `new-slides` scripts to `~/bin/`, and installs
both Agent Skills globally. The canonical skills live under
`~/.agents/skills/`; compatibility links make them available to Codex, Claude
Code, Gemini CLI, and Antigravity CLI without maintaining harness-specific
copies.

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

Or create a presentation:

```bash
new-slides \
  --titulo "Valoración de inversiones" \
  --subtitulo "Métodos VAN y TIR" \
  --asignatura "Matemáticas Financieras" \
  --autor "Israel Herraiz" \
  clase-tema-3

cd clase-tema-3
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
│   ├── new-activity          # CLI script — scaffolds a new activity directory
│   └── new-slides            # CLI script — scaffolds a new presentation
├── examples/
│   ├── plantilla.tex         # Worked example: figures, tables, math, code, citations
│   ├── presentacion.tex      # Example presentation using ui1beamer
│   └── referencias.bib       # Example bibliography file
├── imgs/
│   ├── portada.png           # Cover page background (A4, branded)
│   └── interior.png          # Interior pages background (A4, branded)
├── tests/
│   ├── bats/                 # BATS test framework (git submodule)
│   ├── latex/                # LaTeX fixture files for make test
│   ├── shell/                # BATS and shell test files
│   ├── pixel_probe.py        # Reads rendered slide colors for the theme tests
│   └── run_tests.sh          # Test runner wrapper
├── ui1activity.cls           # LaTeX document class
├── beamerthemeui1beamer.sty  # Beamer theme (\usetheme{ui1beamer})
├── CLAUDE.md                 # Design constraints and conventions for contributors
├── Makefile                  # Build, install, and test targets
└── skills/
    ├── new-activity/
    │   └── SKILL.md          # Portable Agent Skill for invoking the CLI
    └── new-slides/
        └── SKILL.md          # Portable Agent Skill for the presentation CLI
```

---

## Agent Skill Installation

The repository keeps one portable skill source per CLI, at
`skills/new-activity/SKILL.md` and `skills/new-slides/SKILL.md`. `make install`
copies each to the open Agent Skills user directory and creates compatibility
links in the discovery paths used by supported coding agents (`<skill>` is
`new-activity` or `new-slides`):

| Agent           | Discovery path                            |
|-----------------|-------------------------------------------|
| Codex           | `~/.agents/skills/<skill>`                |
| Claude Code     | `~/.claude/skills/<skill>`                |
| Gemini CLI      | `~/.gemini/skills/<skill>`                |
| Antigravity     | `~/.gemini/config/skills/<skill>`         |
| Antigravity CLI | `~/.gemini/antigravity-cli/skills/<skill>`|

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
- `<directory>.tex` — LaTeX source pre-filled with all metadata, plus
  commented-out examples (see below)
- `referencias.bib` — commented-out `@legislation` and `@jurisprudencia`
  entries showing every field each type needs
- `Makefile` — with `pdf`, `clean`, and `open` targets

### Commented-out examples

The generated `.tex` carries two blocks delimited by
`% --- BEGIN/END EJEMPLOS / EXAMPLES ---`: a `listings` setup for the preamble,
and ready-made snippets for figures, branded tables, equations, code listings,
and citations of the two legal entry types. They are inert, so the activity
compiles as generated — uncomment what you need and delete the rest. Lines
starting with `%%` are explanatory prose and stay comments either way.

`examples/plantilla.tex` is the same material, live and compiled, if you would
rather copy from a working document:

```bash
make            # compiles examples/plantilla.pdf
make open       # compiles and opens it
```

---

## CLI Reference — `new-slides`

### Required flags

| Flag              | Description                |
|-------------------|----------------------------|
| `--titulo TITLE`  | Presentation title         |
| `--autor NAME`    | Author name                |
| `<directory>`     | Target directory to create |

### Optional flags

| Flag                   | Description                                  | Default      |
|------------------------|----------------------------------------------|--------------|
| `--subtitulo SUBTITLE` | Presentation subtitle                        | *(empty)*    |
| `--asignatura SUBJECT` | Subject name, shown on the title slide       | *(empty)*    |
| `--fecha DATE`         | Date in Spanish format                       | Today's date |
| `--dry-run`            | Print resolved values without creating files | —            |
| `--help`               | Show usage and exit                          | —            |

### Files created

Inside `<directory>/`:
- `<directory>.tex` — Beamer source pre-filled with all metadata, a title
  frame, and a sample content frame
- `Makefile` — with `pdf`, `clean`, and `open` targets

No `imgs/` symlink is created: `make install` links the images into the texmf
tree next to the theme.

---

## Presentation Theme — `ui1beamer`

```latex
\documentclass[aspectratio=169]{beamer}
\usetheme{ui1beamer}
```

- **16:9 only.** `aspectratio` is a Beamer *class* option, so it must stay on
  `\documentclass`; the theme warns if the slides are a different shape.
- **Title slide** — the UI1 decorative frame with the logo, the title in UI1
  red, and optional `\subtitle`, `\asignatura`, `\author` and `\date`. Use a
  `[plain]` frame for it.
- **Content slides** — a red header band with the current `\section` name, a
  gray footer band with the presentation title and slide number, red bold frame
  titles, and blocks in the UI1 palette.
- The logo is cropped out of `imgs/portada.png` rather than stretched: those
  assets are A4 portrait, and scaling them to 16:9 would deform the logo and
  the interior footer text.

`examples/presentacion.tex` is a seven-slide example covering the title slide,
sections, lists, math, two-column layouts, all three block types and a table.
Build it with:

```bash
make slides        # compiles examples/presentacion.pdf
make open-slides   # compiles and opens it
```

---

## Running the Test Suite

**BATS tests** (argument parsing, file generation, install/uninstall, PDF
metadata, etc.):

```bash
bash tests/run_tests.sh tests/shell/*.bats
```

All 121 tests should pass.

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
- Read [CLAUDE.md](CLAUDE.md) before changing the class or the theme — it
  records the design constraints inherited from the original template and the
  reasoning behind the package choices.

---

## License

Copyright 2026 Israel Herraiz \<isra@herraiz.org\>

Licensed under the Apache License, Version 2.0. See [LICENSE](LICENSE) for the
full text.

The Universidad Isabel I image assets in `imgs/` are excluded from that grant —
see [NOTICE](NOTICE).
