# Cover page, pagination, and backgrounds

**Source of truth:** `ui1activity.cls`, lines 151–161 (geometry), 195–244 (cover),
258–267 (backgrounds).
**Tests:** `tests/shell/{page_numbering,test_pdf_metadata}.bats`,
`tests/shell/test_helvetica_cover.sh`.

Three mechanisms overlap on the first page: the cover table, the page counter, and the
choice of background art. They were built separately and they interact — changing one
naively breaks another.

## The cover table

`\makecustomcover` draws a single-column `tabularx` of width **144mm**, the exact 8154
twips of the original docx table. Its rows are:

1. A `uired` cell, 16mm tall, with the degree program and academic year in white bold
   Helvetica at 11pt/13pt.
2. Four `uigray` rows: subject, didactic unit, student, date.

Rules are `0.8pt` in `uitableborder`, and the block starts `29mm` down the page. The
metadata comes from `\grado`, `\cursoacademico`, `\asignatura`, `\unidaddidactica`,
`\alumno` and `\fecha`, each initialized empty so an unset field degrades to a blank cell
instead of an error.

The width is a hard constraint from
[`product-guidelines.md`](product-guidelines.md): it makes the table line up with the
printed frame in the background art.

## Why the page counter is reset

The cover page and the table of contents share physical page 1. Content therefore starts
on physical page 2 — and, before the fix, was numbered "2" in both the footer and the
TOC. The first page of actual work should be page 1.

The obvious fix — resetting the counter — collides with the background logic, which
originally selected the cover art with `\ifthenelse{\value{page}=1}`. Reset the counter
and a later page becomes "page 1" and gets the cover background.

So the two concerns were separated (`git show
1e5483a:conductor/archive/fix_page_numbering_20260508/spec.md` records the reasoning):

- **Background selection** moved from the page counter to a dedicated flag,
  `\ifui@coverpage`, true at the start of the document.
- **The counter reset** happens in a one-shot hook registered inside `\makecustomcover`:

  ```latex
  \AddToHook{shipout/after}[ui1activity/coverreset]{%
    \setcounter{page}{0}%
    \global\ui@coverpagefalse
    \RemoveFromHook{shipout/after}[ui1activity/coverreset]%
  }%
  ```

Three details carry weight:

- **`shipout/after`, not `shipout/before`.** The reset must land after the cover page has
  physically shipped, or the cover itself is renumbered.
- **`\setcounter{page}{0}`, not `1`.** LaTeX increments the counter as the next page
  begins, so zero yields 1 on the first content page.
- **It removes itself.** Without `\RemoveFromHook` the reset fires on every subsequent
  page and the whole document is numbered 1.

`tests/shell/page_numbering.bats` compiles a fixture and greps the `.toc` to assert the
first section records page 1 — that file is the regression guard for all of the above.

## Backgrounds

`\AddToShipoutPictureBG` places a full-page image on every shipped page
(`ui1activity.cls:258–267`), choosing by flag:

```latex
\ifui@coverpage  imgs/portada  \else  imgs/interior  \fi
```

Both are drawn at `width=\paperwidth,height=\paperheight`. That is safe only because the
assets are A4 portrait and the class is A4 portrait — the same assumption that does *not*
hold for slides, which is why [`beamer-theme.md`](beamer-theme.md) redraws its frame.

Because the underlay is unconditional, the images must resolve at compile time from any
working directory. `make install` handles this by symlinking `imgs/` into the texmf tree
next to the class, so a generated activity elsewhere on disk still finds them.

## PDF metadata and bookmarks

`hyperref` fills the PDF properties from the cover metadata through `\AtBeginDocument`
(`ui1activity.cls:187–193`): `pdftitle` from `\unidaddidactica`, `pdfauthor` from
`\alumno`, `pdfsubject` from `\asignatura`. The hook is required because the values are
set in the preamble, after the package is loaded.

Bookmarks come from the same package with `bookmarksdepth=3`; the bibliography sections
use `heading=bibintoc` so they appear in both the TOC and the outline.
