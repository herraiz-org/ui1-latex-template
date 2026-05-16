# Spec: Jurisprudencia Bibliography Support

## Overview

Extend `ui1activity.cls` to support a dedicated bibliography section for
Spanish court rulings (jurisprudencia), rendered with a custom `biblatex`
driver. The section appears before the legislation list and main bibliography,
and only when at least one `@jurisprudencia` entry is cited. This feature is
Spanish-only; no English localization is required.

## Functional Requirements

### FR-1: Custom `jurisprudencia` Biblatex Driver

A custom bibliography driver named `jurisprudencia` must be declared in
`ui1activity.cls` using `\DeclareBibliographyDriver`. The driver must render
entries in the following format:

```
<kind> <court> <number> (<chamber>), de <date>. ECLI:<ecli> <url>
```

Example:
```
Sentencia del Tribunal Supremo 751/1984 (Sala de lo Civil, Sección 1),
de 19 de diciembre. ECLI:ES:TS:1984:1744 https://www.poderjudicial.es/...
```

Required `.bib` fields: `kind`, `court`, `shortcourt`, `number`, `chamber`,
`date`, `ecli`, `url`.

**Field definitions:**
- `kind`: ruling type, e.g., `Sentencia`, `Auto`, `Providencia`
- `court`: court name **including the Spanish preposition**, e.g.,
  `del Tribunal Supremo`, `de la Audiencia Nacional` — handles grammatical
  gender without a separate preposition field
- `shortcourt`: abbreviation for inline citations, e.g., `STS`, `ATS`
- `number`: case number, e.g., `751/1984`
- `chamber`: sala and section, e.g., `Sala de lo Civil, Sección 1`
- `date`: full date string, e.g., `19 de diciembre de 1984`
- `ecli`: ECLI identifier **without** the `ECLI:` prefix, e.g.,
  `ES:TS:1984:1744` (driver prepends `ECLI:`)
- `url`: link to the ruling on poderjudicial.es

### FR-2: Custom Inline Citation Format

Inline citations must render as `({shortcourt} {number})`,
e.g., `(STS 751/1984)`. This is implemented via a `biblatex` cite command
or `\DeclareCiteCommand` extension that checks `\ifentrytype{jurisprudencia}`
and formats using only `shortcourt` and `number`.

### FR-3: Dedicated Jurisprudencia Bibliography Section

A separate bibliography section must be printed containing **only**
`@jurisprudencia` entries, implemented via `\printbibliography[type=jurisprudencia, ...]`.

### FR-4: Section Ordering

When bibliography printing commands are called, sections must appear in
this order:
1. Jurisprudencia (if any `@jurisprudencia` entries are cited)
2. Legislación (if any `@legislation` entries are cited)
3. Main bibliography (all other entry types)

### FR-5: Conditional Section Display

The Jurisprudencia heading and list must only appear when at least one
`@jurisprudencia` entry is cited. An empty section must never be printed.

### FR-6: Fixed Spanish-Only Heading

The section heading is always **"Jurisprudencia"** with no English
localization. This feature is intentionally Spanish-only.

### FR-7: Sample Entry in Scaffolded `referencias.bib`

`bin/new-activity` must add a commented-out `@jurisprudencia` example to
the generated `referencias.bib`:

```bibtex
% @jurisprudencia{sts751_1984,
%   kind       = {Sentencia},
%   court      = {del Tribunal Supremo},
%   shortcourt = {STS},
%   number     = {751/1984},
%   chamber    = {Sala de lo Civil, Sección 1},
%   date       = {19 de diciembre de 1984},
%   ecli       = {ES:TS:1984:1744},
%   url        = {https://www.poderjudicial.es/search/AN/openDocument/e82a9e13052f4162/19960113},
% }
```

## Non-Functional Requirements

- **NFR-1:** No changes to the public API for documents that do not use
  `@jurisprudencia` entries — existing `.tex` files compile unchanged.
- **NFR-2:** Compatible with `biblatex` + `biber` as specified in
  `tech-stack.md`.
- **NFR-3:** Works with the existing `pdflatex` + `biber` multi-pass
  `Makefile` compilation flow.
- **NFR-4:** The existing `@legislation` section functionality must not be
  broken.

## Acceptance Criteria

1. A `.bib` file with one or more `@jurisprudencia` entries compiles without
   errors or warnings under `pdflatex` + `biber`.
2. The rendered PDF shows a "Jurisprudencia" heading followed by entries in
   the format:
   `Sentencia del Tribunal Supremo 751/1984 (Sala de lo Civil, Sección 1),
   de 19 de diciembre. ECLI:ES:TS:1984:1744 https://...`
3. Inline citations render as `(STS 751/1984)`.
4. When both entry types are present, sections appear in order:
   Jurisprudencia → Legislación → main bibliography.
5. A document with no `@jurisprudencia` entries compiles without errors and
   shows no empty section.
6. `bin/new-activity` produces a `referencias.bib` with a commented-out
   `@jurisprudencia` example.
7. All existing BATS tests continue to pass.

## Out of Scope

- English localization of the "Jurisprudencia" heading.
- Jurisprudencia from non-Spanish jurisdictions.
- Sorting customization for the jurisprudencia list.
- GUI or interactive tooling for building entries.
