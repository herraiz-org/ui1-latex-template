---
name: new-activity
description: Scaffold a new LaTeX activity directory using the ui1activity document class. Use when the user asks to create a new activity, homework, or LaTeX exercise directory. Guides the user through supplying the required flags and runs the new-activity CLI.
---

# new-activity skill

Use the `new-activity` CLI to scaffold a new LaTeX activity directory pre-filled with the correct document class, metadata, bibliography stub, and Makefile.

## Trigger conditions

Invoke this skill when the user says something like:
- "Create a new activity"
- "New activity for [subject]"
- "Scaffold a LaTeX activity"
- "Start a new homework directory"

## Prerequisites

The `new-activity` script must be installed. If it is not on `$PATH`, run:

```bash
make install
```

from the project root (`ui1_template/`). This copies the script to `~/bin/` and updates `~/.zshrc`.

## Required information

Collect these from the user before running:

| Flag | Description | Example |
|------|-------------|---------|
| `--asignatura` | Subject name (required) | "Matemáticas Financieras" |
| `--alumno` | Student name (required) | "Israel Herraiz" |
| `<directory>` | Target directory name (required) | `actividad-tema-3` |

## Optional information

| Flag | Description | Default |
|------|-------------|---------|
| `--grado` | Degree program (see list below) | "Grado en Administración y Dirección de Empresas" |
| `--curso` | Academic year | *(empty)* |
| `--unidad` | Didactic unit | *(empty)* |
| `--fecha` | Date in Spanish format | Today's date |
| `--options` | Document class options | "palatino,nohangbib" |

## UI1 degree programs (`--grado`)

This template is for **Universidad Isabel I (UI1)**, an online university in Spain. Use the exact degree name below for `--grado`:

**Ciencias Jurídicas y Económicas**
- `Grado en Administración y Dirección de Empresas`
- `Grado en Derecho`
- `Grado en Filosofía, Política y Economía`

**Ciencias y Tecnología**
- `Grado en Ingeniería Informática`

**Ciencias de la Seguridad y Criminología**
- `Grado en Ciencias de la Seguridad`
- `Grado en Criminología`

**Humanidades y Ciencias Sociales**
- `Grado en Educación Infantil`
- `Grado en Educación Primaria`
- `Grado en Historia, Geografía e Historia del Arte`
- `Grado en Marketing, Publicidad y Relaciones Públicas`
- `Grado en Pedagogía`
- `Grado en Periodismo`

**Ciencias de la Salud**
- `Grado en Ciencias de la Actividad Física y del Deporte`
- `Grado en Logopedia`
- `Grado en Nutrición Humana y Dietética`
- `Grado en Psicología`

If the user doesn't specify a degree, ask or default to `Grado en Administración y Dirección de Empresas` (the most common one for this template).

## Example invocations

**Minimal (required flags only):**
```bash
new-activity --asignatura "Matemáticas Financieras" --alumno "Israel Herraiz" actividad-tema-3
```

**Full:**
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

**Preview without creating files (dry run):**
```bash
new-activity --asignatura "Matemáticas" --alumno "Israel" --dry-run actividad-tema-3
```

## Expected output

```
Activity created in 'actividad-tema-3'.

Next steps:
  cd actividad-tema-3
  make pdf     # compile
  make open    # open PDF
  make clean   # remove auxiliary files
```

## Files created

Inside `<directory>/`:
- `<directory>.tex` — LaTeX source pre-filled with all metadata
- `referencias.bib` — empty bibliography file
- `Makefile` — with `pdf`, `clean`, and `open` targets

## Workflow

1. Ask the user for `--asignatura`, `--alumno`, and the directory name if not provided.
2. Optionally ask for `--curso` and `--unidad` (common useful fields).
3. Run `new-activity` with the collected arguments.
4. Confirm the directory was created and show the next steps.

---

Copyright 2026 Israel Herraiz <isra@herraiz.org>
Licensed under the Apache License, Version 2.0.
