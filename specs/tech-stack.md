# Technology stack

Every package loaded by `ui1activity.cls` and `beamerthemeui1beamer.sty`, and why it is
there. `tests/shell/docs_consistency.bats` asserts that each package the sources load is
named in this file, so adding one without a note here fails the suite.

## Core

- **Language:** LaTeX2e, UTF-8 (`inputenc`), T1 output encoding (`fontenc`)
- **Document class:** `ui1activity.cls`, inheriting from `article`
- **Presentation theme:** `beamerthemeui1beamer.sty`, loaded with `\usetheme{ui1beamer}`
- **Compilers:** `pdflatex` and `biber`

## Class options

| Option | Effect |
|---|---|
| `palatino` *(default)* | `newpxtext` + `newpxmath`, with `helvet` scaled to `0.95` |
| `times` | `newtxtext` + `newtxmath`, with `helvet` scaled to `0.92` |
| `nohangbib` | Sets `\bibhang` to `0pt`, removing the hanging indent in the bibliography |

Anything else is passed through to `article`.

## Fonts

- **`newpxtext` / `newpxmath`** — Palatino-compatible body and math, the default pairing.
- **`newtxtext` / `newtxmath`** — Times-compatible alternative.
- **`helvet`** — Helvetica for all headers. The `scaled` factor differs per body font
  (`0.95` for Palatino, `0.92` for Times) so the sans headers sit visually level with the
  body text rather than towering over it.
- **`titlesec`** — sections, subsections and subsubsections restyled as sans-serif bold.

## Language and math

- **`babel`** with `[english,spanish,es-tabla]` — Spanish is the document default
  (hyphenation, "Tabla" for table captions); English is loaded so documents can
  `\selectlanguage{english}`. The dual setup is what makes the `\iflanguage` heading in
  [`bibliography.md`](bibliography.md) possible.
- **`icomma`** — lets `3,5` be typed literally in math mode with correct spacing, instead
  of `3{,}5`.
- **`amsmath`** — mathematical notation.
- **`parskip`** — vertical paragraph separation instead of first-line indents. Its
  `\parskip` value is reused as `\bibitemsep`, so bibliography entries are spaced like
  paragraphs.

## Layout

- **`geometry`** — the strict margins recorded in
  [`product-guidelines.md`](product-guidelines.md).
- **`fancyhdr`** — empty header, page number bottom-right, no rules.
- **`eso-pic`** — full-page background underlay on every shipped page.
- **`graphicx`** — includes the PNG background art, and is available to documents for
  their own figures.
- **`ifthen`** — conditional logic around the page-specific backgrounds.
- **`caption`** — one global caption style (`font={small,it}`, `labelfont=bf`,
  `margin=1cm`) for figures, tables and listings alike. It is deliberately loaded
  *before* `biblatex`, which it is known to conflict with.

## Color and tables

- **`xcolor`** with the `[table]` option — do not also load `colortbl`; the option pulls
  it in. Palette:

  | Name | Hex | Used for |
  |---|---|---|
  | `uired` | `E4004F` | Cover header cell, table headers, accents |
  | `uigray` | `BFBFBF` | Cover metadata rows, slide footer band |
  | `uitableborder` | `D9D9D9` | Cover table rules |
  | `uiframegray` | `E3E7E9` | Slide decorative ring (theme only) |

- **`tabularx`** — fixed-width tables whose `X` columns absorb the leftover width. The
  144mm cover table depends on it.

## Bibliography

- **`biblatex`** with `backend=biber, style=apa`, plus **`csquotes`** with
  `autostyle=true` (required by `biblatex`, and it follows the active `babel` language).
  The customization on top is substantial — see [`bibliography.md`](bibliography.md).

## PDF output

- **`hyperref`** — PDF bookmarks (`bookmarksdepth=3`) with `hidelinks`, and document
  properties filled from `\unidaddidactica`, `\alumno` and `\asignatura` through an
  `\AtBeginDocument` hook.

  **It must remain the last `\RequirePackage` in the class.** `hyperref` patches
  internals of many other packages and has to see their final state. This is asserted by
  `tests/shell/docs_consistency.bats`, not merely documented.

## Presentation theme

`beamerthemeui1beamer.sty` reloads `inputenc`, `fontenc`, `babel`, `icomma`, `helvet`,
`amsmath` and `graphicx` on its own — it is used with the `beamer` class, not with
`ui1activity.cls`, so it cannot inherit them. On top of those:

- **`tikz`** — draws the decorative frame as a beamer `background` template. See
  [`beamer-theme.md`](beamer-theme.md).
- **`beamer`** itself is the document class, and the 16:9 aspect ratio is a *class*
  option the document sets.

## Not loaded, on purpose

- **`listings`** — only documents that typeset code need it. Loading it in the class
  would put the dependency in every activity for the benefit of a few. It belongs in the
  document preamble: `examples/plantilla.tex` sets up a branded `\lstset`, and
  `bin/new-activity` writes the same block commented out into the generated `.tex`. The
  class still styles listing captions through the global `\captionsetup`.

  If you change the `\lstset` in one place, change it in the other.

## Build and test tooling

- **`Makefile`** — multi-pass compilation (`pdflatex` → `biber` → `pdflatex` ×2 when the
  source has an `\addbibresource`; two passes for slides so the section band and frame
  count settle), plus the install targets described in
  [`install-and-skills.md`](install-and-skills.md).
- **`bin/new-activity`, `bin/new-slides`** — POSIX-compatible Bash scaffolding CLIs,
  linted with `shellcheck` in CI.
- **BATS (bats-core)** — the test suite, as a git submodule at `tests/bats`. Shell tests
  in `tests/shell/`, LaTeX fixtures in `tests/latex/`; run with
  `bash tests/run_tests.sh tests/shell/*.bats`.
- **`pypdf`, `pdftotext`, `pdfinfo`** — used by tests that inspect rendered PDFs
  (bookmarks, metadata, bibliography section headings).
- **`tests/pixel_probe.py`** — reads pixel colors out of rendered slides to verify the
  theme's bands really are `uired` and `uigray`.
