# Product guidelines

## Language and documentation

**Bilingual (Spanish/English).** Comments, user-facing strings, and generated content
are written in both languages: Spanish for the students who submit the work, English so
the code stays accessible to international contributors. The commented examples in the
generated activity follow this rule line by line.

## Branding and visual identity

Adherence to the Universidad Isabel I identity is **strict**, and deliberately not
configurable:

- The background images `imgs/portada.png` (cover) and `imgs/interior.png` (interior
  pages) are mandatory. Do not add an option to disable them.
- The official colors are the only ones used for decorative elements — see the palette
  in [`tech-stack.md`](tech-stack.md).
- The body font is Palatino or Times, and headers are always Helvetica. Both body
  choices are sanctioned; nothing else is.

## Content and structure

**Free-form interior.** Apart from the cover page and the background underlays, the
document is a blank canvas. Power users organize their work with standard LaTeX
sectioning, and the class does not get in the way.

## Technical expertise

Written for **expert** users:

- Comments are minimal and explain *why*, not *what*.
- The code favors clean implementation and programmatic extension over hand-holding.
- Readers are assumed to understand LaTeX environments and the `pdflatex` + `biber`
  compilation workflow.

## Design constraints inherited from the original `.docx`

These come from `ADE. Plantilla actividades 2026.docx` and exist to keep pixel fidelity
with the university template. Do not change them without an explicit request.

### Page geometry

Set in `ui1activity.cls`, converted from the docx twip measurements
(1 twip = 1/1440 in):

```latex
a4paper, top=18mm, left=27.5mm, right=25mm, bottom=22mm,
headheight=8pt, headsep=0pt, footskip=5mm
```

The margins are tuned against the background artwork, not just against the docx: the
printed frame in `imgs/interior.png` sets where body text may start and stop. Changing
them moves text onto the decorative border.

> Earlier revisions of this document recorded `top=7mm`, `bottom=20mm` and a 7mm footer
> skip. Those values were never in the class. `tests/shell/docs_consistency.bats` now
> reads the real ones out of `ui1activity.cls` and fails if this section disagrees.

### Cover table

Width **144mm** — exactly the 8154 twips of the original docx cover table. See
[`cover-and-pagination.md`](cover-and-pagination.md).

### Background image provenance

| Repository asset | Source in the `.docx` | Used for |
|---|---|---|
| `imgs/portada.png` | `word/media/image2.png` | Cover page |
| `imgs/interior.png` | `word/media/image1.png` | Interior pages |

Both are A4 portrait: 1240 × 1754 px at 150 dpi, i.e. 595.2 bp × 841.9 bp. That aspect
ratio is why the Beamer theme redraws its frame instead of reusing them — see
[`beamer-theme.md`](beamer-theme.md).
