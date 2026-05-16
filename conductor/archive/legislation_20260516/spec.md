# Spec: Custom Legislation Bibliography Support

## Overview

Extend `ui1activity.cls` to support a dedicated bibliography section for
legislative references, rendered with a custom `biblatex` driver that formats
entries as Spanish BOE citations. The legislation list appears before the main
references list and its heading is automatically localized via `babel`.

## Functional Requirements

### FR-1: Custom `legislation` Biblatex Driver

A custom bibliography driver named `legislation` must be declared in
`ui1activity.cls` using `\DeclareBibliographyDriver`. The driver must render
entries in the following format:

```
<title>. BOE número <number> § <eid> (<year>)
```

Concretely, using the provided macros:

```latex
\DeclareBibliographyDriver{legislation}{%
  \usebibmacro{bibindex}%
  \usebibmacro{begentry}%
  \printfield{title}\addperiod\addspace
  BOE número \printfield{number}\addspace
  \S\addnbspace\printfield{eid}\addspace
  (\printfield{year})\finalpunct
  \usebibmacro{finentry}}
```

Required `.bib` fields: `title`, `number`, `eid`, `year`.

### FR-2: Dedicated Legislation Bibliography List

A separate bibliography section must be printed that includes **only**
`@legislation` entries. This is implemented using a `biblatex` bibliography
category or `\defbibfilter` to isolate entries of type `legislation`.

### FR-3: Legislation List Appears Before Main Bibliography

When the document author calls the bibliography printing commands, the
legislation list must be printed **before** the main references list.

The class must provide a single command (e.g., `\printbibliography` sequence
or a convenience macro `\printlegislation`) that prints:
1. The legislation section (if any `@legislation` entries exist)
2. The main bibliography section

### FR-4: Localized Section Heading

The legislation list heading must be automatically localized via `babel`:
- Spanish (`spanish` or `es-tabla`): **"Legislación"**
- English (`english`, `british`, `american`): **"Legislation"**

No additional class options or user commands are required.

### FR-5: Sample Entry in Scaffolded `referencias.bib`

The `bin/new-activity` CLI must add a commented-out example `@legislation`
entry to the generated `referencias.bib` file. Example:

```bibtex
% @legislation{lott1987,
%   title  = {Ley 16/1987, de 30 de julio, de Ordenación de los
%              Transportes Terrestres},
%   number = {182},
%   eid    = {23546},
%   year   = {1987},
% }
```

## Non-Functional Requirements

- **NFR-1:** No changes to the public API for documents that do not use
  `@legislation` entries — existing `.tex` files continue to compile unchanged.
- **NFR-2:** The implementation must be compatible with `biblatex` + `biber`
  as specified in `tech-stack.md`.
- **NFR-3:** The feature must work with the existing `pdflatex` + `biber`
  multi-pass `Makefile` compilation flow.

## Acceptance Criteria

1. A `.bib` file containing one or more `@legislation` entries compiles
   without errors or warnings under `pdflatex` + `biber`.
2. The rendered PDF shows a "Legislación" heading (in a Spanish-language
   document) followed by entries in the format:
   `Ley 16/1987, de 30 de julio, de Ordenación de los Transportes Terrestres.
    BOE número 182 § 23546 (1987)`
3. The legislation list appears before the main bibliography section.
4. An English-language document (`\usepackage[english]{babel}`) renders the
   heading as "Legislation".
5. A document with no `@legislation` entries compiles without errors and
   shows no empty legislation section.
6. `bin/new-activity` produces a `referencias.bib` containing a
   commented-out `@legislation` example.
7. All existing BATS tests continue to pass.

## Out of Scope

- Support for legislation from jurisdictions other than Spain (no EU Official
  Journal format, etc.).
- Additional `@legislation` fields beyond `title`, `number`, `eid`, `year`.
- GUI or interactive tooling for building legislation entries.
- Sorting customization for the legislation list (default `biblatex` order).
