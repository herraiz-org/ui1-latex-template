# Product

## Goal

A professional, modular LaTeX toolkit that reproduces the Universidad Isabel I branded
templates for the Grado en Administración y Dirección de Empresas: a document class for
written activities (`ui1activity.cls`) and a Beamer theme for presentations
(`beamerthemeui1beamer.sty`).

## Target users

**Students** submitting activities and assignments for their degree. They are expected
to know LaTeX — see the audience note in [`product-guidelines.md`](product-guidelines.md).

## Primary benefit

**Consistency.** Compared with the original Word template, the class enforces the
university's visual identity rather than asking the author to reproduce it. Margins,
cover table, fonts, colors, and background art cannot drift, so a submission cannot be
formatted wrongly by accident.

## Features

- **Branded document class.** Complex layout logic is encapsulated in
  `ui1activity.cls`, so an activity's `.tex` stays short and is mostly content. See
  [`cover-and-pagination.md`](cover-and-pagination.md).
- **Branded Beamer theme.** The same identity on 16:9 slides, loaded with
  `\usetheme{ui1beamer}`. See [`beamer-theme.md`](beamer-theme.md).
- **Scaffolding CLIs.** `bin/new-activity` and `bin/new-slides` generate a
  ready-to-compile directory — `.tex` pre-filled with metadata, a `Makefile` with
  `pdf`/`clean`/`open`, and for activities a `referencias.bib` seeded with commented
  examples. Both are also published as portable Agent Skills; see
  [`install-and-skills.md`](install-and-skills.md).
- **Worked examples.** The generated `.tex` carries commented-out, ready-to-uncomment
  snippets for figures, branded tables, math, code listings, and legal citations.
  `examples/plantilla.tex` is the same material live and compiled.
- **Configurable typography.** Palatino (default) or Times for body and math, paired
  with Helvetica headers.
- **Spanish legal bibliography.** Two custom `biblatex` entry types — `jurisprudencia`
  for court rulings and `legislation` for BOE-published statutes — printed in their own
  sections ahead of the general references, and only when cited. See
  [`bibliography.md`](bibliography.md).
- **Spanish localization.** Hyphenation, table labels ("Tabla"), and decimal commas in
  math mode, with English available via `\selectlanguage{english}`.
- **Global installation.** `make install` symlinks the class and theme into the user's
  local texmf tree, so any document on the system can use them.

## Non-goals

- **A structured interior.** Beyond the cover and the background art, the class imposes
  no document structure. Adding opinionated section scaffolding would fight the
  free-form principle in [`product-guidelines.md`](product-guidelines.md).
- **Loading every package a student might want.** The class loads what every activity
  needs. `listings` is the worked example of the alternative: the scaffold offers it,
  commented, in the document preamble. See [`tech-stack.md`](tech-stack.md).
- **Support for other degrees or universities.** The branding is deliberately hard-coded.
