# Beamer theme

**Source of truth:** `beamerthemeui1beamer.sty` (226 lines).
**Tests:** `tests/shell/beamer_theme.bats`, with `tests/pixel_probe.py` sampling rendered
slide colors.
**Example:** `examples/presentacion.tex`, seven slides covering every element.

Loaded as `\usetheme{ui1beamer}` — beamer maps that name to the
`beamerthemeui1beamer.sty` filename.

## 16:9 is the document's decision, not the theme's

`aspectratio` is a *class* option, so a theme file cannot set it. Documents must write:

```latex
\documentclass[aspectratio=169]{beamer}
\usetheme{ui1beamer}
```

The theme computes `\paperheight * 16/9` and compares it against `\paperwidth`, warning
in both directions when they differ by more than `1pt`. A warning is all it can do.

Everything else is expressed as a fraction of `\paperwidth` or `\paperheight`, so the
layout degrades gracefully rather than shattering at another aspect ratio.

## Why the frame is redrawn instead of reused

`ui1activity.cls` gets its identity by stretching `imgs/portada.png` and
`imgs/interior.png` across the page. The theme cannot: those assets are A4 portrait
(1240 × 1754 px at 150 dpi = 595.2 bp × 841.9 bp), and stretching them to 16:9 widens
their content by roughly 26%. The round UI1 logo becomes an ellipse and the address line
at the foot of `interior.png` visibly smears.

So the theme **redraws** the decorative frame with TikZ and reuses only the logo:

```latex
\includegraphics[trim=70.6bp 726.2bp 382.6bp 70.6bp,clip,width=#1]{imgs/portada}
```

Those trim values are the measured margins of the logo *inside the A4 artwork*, so the
crop preserves the logo's own aspect ratio. **They are tied to the exact pixel dimensions
of `imgs/portada.png`.** Replace or re-export that asset and the crop must be
re-measured; `tests/shell/docs_consistency.bats` asserts the values here match the source,
but nothing can detect that the asset itself moved underneath them.

No background asset is stretched, and none is distorted.

## The negative logo

The header band is `uired`, and the colour logo cannot be read on it: the rosette is
`#E5004C`, all but the band's own red, and the wordmark is `#4C565C`, dark on dark. The
header therefore uses a second asset, `imgs/logo-blanco.png` (296 × 94 px, RGBA), drawn by
`\ui@logoneg`. It is the *same* crop with its alpha channel preserved and every visible
pixel set to white, so anti-aliased edges still blend against the red:

```python
from PIL import Image
im = Image.open("imgs/portada.png").convert("RGBA")
s = 1240 / 595.2                                   # px per bp
crop = im.crop((round(70.6*s), round(70.6*s),
                round(1240 - 382.6*s), round(1754 - 726.2*s)))
white = Image.new("RGBA", crop.size, (255, 255, 255, 255))
white.putalpha(crop.getchannel("A"))
white.save("imgs/logo-blanco.png")
```

That box is the `trim` values above expressed in pixels, so **the asset shares their
dependency on `imgs/portada.png`**: re-export the cover artwork and this file has to be
regenerated along with the trim. Because it is pre-cropped, `\ui@logoneg` takes a height
and no `trim`.

`imgs/logo-blanco.png` is a derivative of the university's artwork and sits under the same
carve-out as the rest of `imgs/` — see [`NOTICE`](../NOTICE).

## Frame geometry

Dimensions are assigned in `\AtBeginDocument`, after the paper size is known:

| Register | Value | Meaning |
|---|---|---|
| `\ui@margin` | `0.018\paperwidth` | White margin, paper edge to gray ring |
| `\ui@band` | `0.018\paperwidth` | Thickness of the gray ring |
| `\ui@inset` | `margin + band` | Paper edge to content area |
| `\ui@barx` | `0.12\paperwidth` | Left edge of the red accent bar and the logo |
| `\ui@barw` | `0.24\paperwidth` | Width of the red accent bar |
| `\ui@logow` | `0.22\paperwidth` | Logo width on the title slide |
| `\ui@headerh` | `0.10\paperheight` | Header band height |
| `\ui@footerh` | `0.055\paperheight` | Footer band height |
| `\ui@pad` | `0.02\paperwidth` | Horizontal text padding inside the bands |
| `\ui@hlogoh` | `0.055\paperheight` | Negative logo height in the header band |

The same hook sets beamer's `text margin left`/`right` to `\ui@inset + \ui@pad`, keeping
body text clear of the ring. Proportions were taken from the printed template's border.

The `background` template paints, in order: a `uiframegray` rectangle inset by
`\ui@margin`, a white rectangle inset by `\ui@inset` punching out the content area, and
two `uired` accent bars on the top and bottom segments of the resulting ring, aligned
with the logo at `\ui@barx`.

`uiframegray` (`E3E7E9`) is a *third* gray, sampled from the printed border, and is
deliberately distinct from `uigray` (`BFBFBF`), which the footer band uses.

## Header and footer bands

Both are `beamercolorbox`es drawn by the `headline` and `footline` templates. That choice
is deliberate: templates make beamer reserve vertical space for the bands *and* omit them
on `[plain]` frames, which is how the title slide gets a clean canvas without a special
case.

- **Header** — `uired`, white bold text: the current `\insertsectionhead` on the left, the
  negative logo on the right. The logo is centred in the band by a `\raisebox` of
  `0.05\ui@headerh - 0.5\ui@hlogoh` — the colorbox's baseline sits `0.55\ui@headerh` below
  the band's top and its midpoint `0.50\ui@headerh` — and is given zero height and depth
  so the space beamer reserves for the band is unchanged. The university's name is
  consequently no longer extractable text on content slides.
- **Footer** — `uigray`, dark text: `\inserttitle` on the left, `\insertframenumber` on
  the right.

Section names in the header need two compilation passes to settle, which is why the
`slides` target in the `Makefile` runs `pdflatex` twice.

Beamer's navigation symbols are blanked — they do not belong on this layout.

## Title slide

A `[plain]` frame. The logo sits at `\ui@barx`, offset by `\beamer@leftmargin` so it
aligns with the accent bar above it. Then, centered and vertically distributed:
`\inserttitle` in `uired` bold `\LARGE`, an optional `\insertsubtitle`, an optional
`\asignatura` in small `uired`, `\insertauthor`, and `\insertdate` in gray.

`\asignatura` is theme-specific — beamer has no such command — and defaults to empty, as
do `\subtitle` and `\date`; each is suppressed when unset rather than leaving a gap.

## Body elements

Frame titles are `uired` bold `\large` with no background. `structure`, itemize and
enumerate markers are `uired`. Blocks are rounded, shadowless, and use the palette:
standard blocks have a `uired` title bar, example blocks a `uigray` one, alert blocks
`uired!65!black`; all three share a `uiframegray` body.
