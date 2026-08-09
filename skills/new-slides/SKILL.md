---
name: new-slides
description: Scaffold a new Beamer presentation directory using the ui1beamer theme. Use when the user asks to create slides, a presentation, a deck, or a LaTeX Beamer directory. Guides the user through supplying the required flags and runs the new-slides CLI.
---

# new-slides skill

Use the `new-slides` CLI to scaffold a new Beamer presentation directory pre-filled with the UI1 theme, metadata, a title frame, a sample content frame, and a Makefile.

## Trigger conditions

Invoke this skill when the user says something like:
- "Create a new presentation"
- "New slides for [subject]"
- "Scaffold a Beamer deck"
- "Start a presentation for the next class"

## Prerequisites

The `new-slides` script and the `ui1beamer` theme must be installed. If the script is not on `$PATH`, run:

```bash
make install
```

from the project root (`ui1_template/`). This copies the script to `~/bin/`, updates `~/.zshrc`, and links the theme and the background images into the local texmf tree so the slides compile from any directory.

## Required information

Collect these from the user before running:

| Flag | Description | Example |
|------|-------------|---------|
| `--titulo` | Presentation title (required) | "Valoración de inversiones" |
| `--autor` | Author name (required) | "Israel Herraiz" |
| `<directory>` | Target directory name (required) | `clase-tema-3` |

## Optional information

| Flag | Description | Default |
|------|-------------|---------|
| `--subtitulo` | Presentation subtitle | *(empty)* |
| `--asignatura` | Subject name, shown on the title slide | *(empty)* |
| `--fecha` | Date in Spanish format | Today's date |

## Example invocations

**Minimal (required flags only):**
```bash
new-slides --titulo "Valoración de inversiones" --autor "Israel Herraiz" clase-tema-3
```

**Full:**
```bash
new-slides \
  --titulo "Valoración de inversiones" \
  --subtitulo "Métodos VAN y TIR" \
  --asignatura "Matemáticas Financieras" \
  --autor "Israel Herraiz" \
  --fecha "9 de agosto de 2026" \
  clase-tema-3
```

**Preview without creating files (dry run):**
```bash
new-slides --titulo "Valoración de inversiones" --autor "Israel" --dry-run clase-tema-3
```

## Expected output

```
Presentation created in 'clase-tema-3'.

Next steps:
  cd clase-tema-3
  make pdf     # compile
  make open    # open PDF
  make clean   # remove auxiliary files
```

## Files created

Inside `<directory>/`:
- `<directory>.tex` — Beamer source pre-filled with all metadata
- `Makefile` — with `pdf`, `clean`, and `open` targets

No `imgs/` symlink is needed: `make install` links the images into the texmf tree alongside the theme.

## Notes on the theme

- The slides are 16:9. `aspectratio=169` is a Beamer **class** option, so it stays on `\documentclass[aspectratio=169]{beamer}` in the generated file — the theme cannot set it and will warn if it is removed.
- `\asignatura{...}` is an addition of this theme; it prints a subject line on the title slide and may be left empty.
- Content frames get a red header band with the current `\section` name on the left and the UI1 logo in white on the right, and a gray footer band with the presentation title and slide number. Use `\section{...}` between frames so the header band is meaningful.
- `[plain]` frames (like the title frame) drop the bands.

## Workflow

1. Ask the user for `--titulo`, `--autor`, and the directory name if not provided.
2. Optionally ask for `--asignatura` and `--subtitulo`.
3. Run `new-slides` with the collected arguments.
4. Confirm the directory was created and show the next steps.

---

Copyright 2026 Israel Herraiz <isra@herraiz.org>
Licensed under the Apache License, Version 2.0.
