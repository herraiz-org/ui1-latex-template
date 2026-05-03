# LaTeX Template — ADE Plantilla Actividades

**Date:** 2026-05-03
**Source:** `ADE. Plantilla actividades 2026.docx`

## Goal

Produce a LaTeX template that visually matches the Universidad Isabel I branded activity template for the Grado en Administración y Dirección de Empresas, compiled with pdflatex.

## Files

| File | Role |
|---|---|
| `plantilla.tex` | Main template — users copy and fill in |
| `portada.png` | Cover page background, extracted from the docx |
| `interior.png` | Interior pages background, extracted from the docx |

Both PNGs are A4-sized (210mm × 297mm) and contain the full branded letterhead design (gray side borders, white content box, university logo, footer text).

## Page Setup

- **Paper:** A4 (210mm × 297mm)
- **Engine:** pdflatex
- **Margins** (converted from docx twips):
  - Top: 7mm
  - Left: 27.5mm
  - Right: 25mm
  - Bottom: 20mm
  - Header height: 0mm (background handled by eso-pic, not the header mechanism)
  - Footer skip: 7mm

## Font

Raleway via the `raleway` CTAN package (pdflatex-compatible substitute for Museo Sans). Applied as the default document font family.

## Colors

| Name | Hex | Usage |
|---|---|---|
| `uired` | #E4004F | Cover table header background |
| `uigray` | #BFBFBF | Cover table metadata rows background |
| `uitableborder` | #D9D9D9 | Table border color |

## Background Images

Placed as full-page underlays using the `eso-pic` package (`\AddToShipoutPictureBG`):

- **Page 1:** `portada.png` — positioned at `(0,0)` relative to the page, scaled to full page dimensions (210mm × 297mm)
- **Pages 2+:** `interior.png` — same positioning

Page switching uses `\ifthenelse{\value{page}=1}` inside a single `\AddToShipoutPictureBG` call, selecting `portada.png` on page 1 and `interior.png` on all subsequent pages.

## Cover Page (Page 1)

### Metadata Variables

Defined at the top of `plantilla.tex` for easy editing:

```latex
\newcommand{\grado}{Grado en Administración y Dirección de Empresas}
\newcommand{\cursoacademico}{2025-2026}
\newcommand{\asignatura}{}
\newcommand{\unidaddidactica}{}
\newcommand{\alumno}{}
\newcommand{\fecha}{}
```

### Cover Table

- Width: ~144mm (matching the docx's 8154 twips)
- Centered on the page
- Light gray outer border (#D9D9D9), `\arrayrulecolor` set accordingly
- Uses `tabularx` with a single `X` column (auto-fills remaining width)

**Row 1 — Header (red background):**
- Background: `uired` (#E4004F)
- Text: white, bold, centered, ~11pt (Raleway Bold)
- Line 1: `\grado`
- Line 2: "Curso académico \cursoacademico"

**Rows 2–5 — Metadata (gray background):**
- Background: `uigray` (#BFBFBF)
- Text: black bold label + regular value on the same line
- Row height: ~6mm
- Rows: Asignatura, Unidad didáctica, Alumno, Fecha

Table implemented with `colortbl` (`\rowcolor`, `\columncolor`) and `tabularx`.

## Interior Pages (Pages 2+)

- Background: `interior.png` via eso-pic
- Body: completely blank — users write their content after `\newpage`
- No pre-defined section structure

## Headers & Footers (`fancyhdr`)

| Page | Header | Footer |
|---|---|---|
| Page 1 (cover) | empty | empty |
| Pages 2+ | empty | page number, right-aligned |

Footer style: `\fancyfoot[R]{\thepage}`, plain style for cover page.

## Packages Required

| Package | Purpose |
|---|---|
| `geometry` | Page size and margins |
| `eso-pic` | Full-page background images |
| `graphicx` | `\includegraphics` for backgrounds |
| `raleway` | Raleway font (Museo Sans substitute) |
| `xcolor` | Custom colors |
| `colortbl` | Table row/cell colors |
| `tabularx` | Fixed-width table with auto column |
| `fancyhdr` | Header/footer control |
| `ifthen` | Page-conditional background switching |

## Out of Scope

- Mathematical content or special notation
- Multi-column layouts
- Custom section heading styles (interior pages are blank)
- xelatex/lualatex compatibility
