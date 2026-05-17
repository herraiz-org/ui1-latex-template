# Bug Spec: Autor ausente en citas normales tras cambios de jurisprudencia/legislación

## Overview

After implementing the jurisprudencia and legislation bibliography support, standard
in-text citations (e.g., `@book` with `\autocite{}`) display incorrectly in APA format.
The author is omitted, producing output like `(2021, pp. 102-103)` instead of the
expected `(Apellido, 2021, pp. 102-103)`. Additionally, compilation produces warnings
about empty legislation and jurisprudencia bibliography sections.

## Observed Behavior

- In-text citation for a `@book` entry renders as `(año, pp. X-X)` — author is missing.
- PDF compiles without biblatex errors but shows warnings for empty `legislation`
  and `jurisprudencia` filtered bibliography sections.
- Problem began after the implementation of the jurisprudencia/legislation feature.

## Expected Behavior

- In-text citation for a `@book` entry renders as `(Apellido, año, pp. X-X)` in APA
  style, consistent with pre-feature behavior.
- No spurious warnings for empty bibliography sections when no jurisprudencia or
  legislation entries are cited.

## Reproduction Steps

1. Create a `.tex` file using `ui1activity.cls` (e.g., via `new-activity` CLI).
2. Add a standard `@book` entry to `referencias.bib`.
3. Cite it in the document with `\autocite[pp.~102-103]{key}`.
4. Compile with `pdflatex` + `biber` + `pdflatex`.
5. Observe: author is missing from the in-text citation; warnings appear in the log
   for empty legislation/jurisprudencia sections.

## Scope of Impact

- Confirmed: `@book` entries with `\autocite{}`.
- Unverified: other standard types (`@article`, `@misc`, etc.) — likely also affected.

## Acceptance Criteria

- [ ] `\autocite[pp.~102-103]{key}` for a `@book` entry renders as
      `(Apellido, año, pp. 102-103)` in the compiled PDF.
- [ ] All standard biblatex entry types (`@book`, `@article`, `@misc`) display
      author correctly in in-text citations.
- [ ] No warnings for empty legislation or jurisprudencia sections when no entries
      of those types are cited.
- [ ] Existing jurisprudencia and legislation bibliography functionality is unaffected.
- [ ] All existing BATS tests pass.

## Out of Scope

- Changes to the APA citation style itself.
- Adding new bibliography entry types.
- Visual/layout changes to the bibliography section.
