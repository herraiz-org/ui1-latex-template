# Technology Stack

## Core
- **Language:** LaTeX
- **Compiler:** `pdflatex` (Version 3.141592653 or newer)
- **Encoding:** UTF-8

## Formatting & Layout
- `geometry`: Used for strict margin control (Top: 7mm, Left: 27.5mm, Right: 25mm, Bottom: 20mm).
- `eso-pic`: Handles the full-page background underlays (`portada.png` and `interior.png`).
- `fancyhdr`: Manages custom headers and footers (page numbering).
- `ifthen`: Provides conditional logic for page-specific backgrounds.

## Branding & Aesthetics
- `raleway`: The official typeface substitute (Raleway Bold/Regular).
- `xcolor`: Defines university colors (`uired`: #E4004F, `uigray`: #BFBFBF).
- `graphicx`: Essential for including the PNG background assets.

## Tables
- `tabularx`: Provides fixed-width tables with auto-scaling columns.
- `colortbl`: Used for branded table headers and row backgrounds.

## Build Tools
- `Makefile`: Automates the dual-pass compilation required for table alignment and references.
