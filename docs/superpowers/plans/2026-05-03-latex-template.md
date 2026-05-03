# LaTeX Activity Template Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create `plantilla.tex` — a pdflatex template that visually matches the Universidad Isabel I branded activity document, with full-page background images, a colored cover table, and a right-aligned page number on interior pages.

**Architecture:** Background images are extracted from the docx and included as full-page underlays on every page via `eso-pic`, switching between `portada.png` (page 1) and `interior.png` (pages 2+) using `ifthen`. The cover page uses a `tabularx` table styled with `colortbl`. `fancyhdr` controls the footer with an empty cover page style and a right-aligned page number on interior pages.

**Tech Stack:** pdflatex, geometry, eso-pic, graphicx, raleway, xcolor (with `table` option), colortbl, tabularx, fancyhdr, ifthen, babel (spanish), inputenc, fontenc

---

## File Map

| File | Action | Purpose |
|---|---|---|
| `portada.png` | Create (extracted from docx) | Cover page full-page background |
| `interior.png` | Create (extracted from docx) | Interior pages full-page background |
| `plantilla.tex` | Create | The user-facing LaTeX template |

---

### Task 0: Initialize git repository

**Files:** none

- [ ] **Step 1: Initialize git and make an initial commit**

```bash
git init
git add "ADE. Plantilla actividades 2026.docx" docs/
git commit -m "chore: initial project state"
```

Expected: `[master (root-commit) ...] chore: initial project state`

---

### Task 1: Extract background images from the docx

**Files:**
- Create: `portada.png`
- Create: `interior.png`

The docx embeds two PNG images:
- `word/media/image2.png` → `portada.png` (cover page: red accent bars, large logo)
- `word/media/image1.png` → `interior.png` (interior: small logo top-left, footer text bottom)

- [ ] **Step 1: Extract both images**

```bash
python3 - <<'EOF'
import zipfile, shutil
with zipfile.ZipFile("ADE. Plantilla actividades 2026.docx", "r") as z:
    with z.open("word/media/image2.png") as src, open("portada.png", "wb") as dst:
        shutil.copyfileobj(src, dst)
    with z.open("word/media/image1.png") as src, open("interior.png", "wb") as dst:
        shutil.copyfileobj(src, dst)
print("Done")
EOF
```

Expected output: `Done`

- [ ] **Step 2: Verify both files exist**

```bash
ls -lh portada.png interior.png
```

Expected: both files listed with size > 10K, e.g.:
```
-rw-r--r-- 1 user user  19K May  3 12:00 portada.png
-rw-r--r-- 1 user user  27K May  3 12:00 interior.png
```

- [ ] **Step 3: Commit**

```bash
git add portada.png interior.png
git commit -m "feat: add background images extracted from docx"
```

---

### Task 2: Create the base LaTeX document with all packages and page setup

**Files:**
- Create: `plantilla.tex`

- [ ] **Step 1: Verify the raleway TeX package is installed**

```bash
kpsewhich raleway.sty
```

If the command returns nothing (package not found), install it:

```bash
# Debian/Ubuntu
sudo apt-get install texlive-fonts-extra

# Arch Linux
sudo pacman -S texlive-fontsextra
```

- [ ] **Step 2: Create `plantilla.tex` with the full preamble and a minimal body**

```latex
\documentclass[a4paper,11pt]{article}

% Encoding and language
\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
\usepackage[spanish]{babel}

% Font: Raleway (pdflatex-compatible Museo Sans substitute)
\usepackage[sfdefault]{raleway}
\renewcommand{\familydefault}{\sfdefault}

% Page layout — margins converted from docx twips (1 twip = 1/1440 inch)
\usepackage[
  a4paper,
  top=7mm,
  left=27.5mm,
  right=25mm,
  bottom=20mm,
  headheight=8pt,
  headsep=0pt,
  footskip=7mm
]{geometry}

% Colors
\usepackage[table]{xcolor}
\definecolor{uired}{HTML}{E4004F}
\definecolor{uigray}{HTML}{BFBFBF}
\definecolor{uitableborder}{HTML}{D9D9D9}

% Tables
\usepackage{tabularx}
\usepackage{colortbl}

% Headers and footers
\usepackage{fancyhdr}
\pagestyle{fancy}
\fancyhf{}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}
\fancyfoot[R]{\small\thepage}

% Background images
\usepackage{eso-pic}
\usepackage{graphicx}
\usepackage{ifthen}

% ==============================================================
% FILL IN YOUR DETAILS BELOW
% ==============================================================
\newcommand{\grado}{Grado en Administración y Dirección de Empresas}
\newcommand{\cursoacademico}{2025-2026}
\newcommand{\asignatura}{}
\newcommand{\unidaddidactica}{}
\newcommand{\alumno}{}
\newcommand{\fecha}{}
% ==============================================================

\begin{document}
Hello world.
\end{document}
```

- [ ] **Step 3: Compile and verify**

```bash
pdflatex -interaction=nonstopmode plantilla.tex
```

Expected: the last lines contain:
```
Output written on plantilla.pdf (1 page, ...
Transcript written on plantilla.log.
```

Warnings about font size substitution are acceptable. Any `! LaTeX Error` line means the file failed — check `plantilla.log` for details.

- [ ] **Step 4: Commit**

```bash
git add plantilla.tex
git commit -m "feat: add LaTeX template skeleton with packages and page layout"
```

---

### Task 3: Add full-page background images via eso-pic

**Files:**
- Modify: `plantilla.tex`

- [ ] **Step 1: Insert the background block into the preamble**

In `plantilla.tex`, add the following block immediately after the `\usepackage{ifthen}` line (before `% ===...=== FILL IN`):

```latex
% Full-page background: portada on page 1, interior on pages 2+
\AddToShipoutPictureBG{%
  \AtPageLowerLeft{%
    \ifthenelse{\value{page}=1}{%
      \includegraphics[width=\paperwidth,height=\paperheight]{portada}%
    }{%
      \includegraphics[width=\paperwidth,height=\paperheight]{interior}%
    }%
  }%
}
```

- [ ] **Step 2: Update the document body to produce two pages for visual verification**

Replace `Hello world.` with:

```latex
\thispagestyle{empty}
Page 1 test.

\newpage

Page 2 test.
```

- [ ] **Step 3: Compile**

```bash
pdflatex -interaction=nonstopmode plantilla.tex
```

Expected: `Output written on plantilla.pdf (2 pages,`

- [ ] **Step 4: Open PDF and verify visually**

```bash
xdg-open plantilla.pdf
```

Check:
- Page 1: portada background (red accent bar top-left, large University Isabel I logo, red bar bottom-left)
- Page 2: interior background (small logo top-right of white box, institutional footer text at page bottom)

- [ ] **Step 5: Commit**

```bash
git add plantilla.tex
git commit -m "feat: add conditional full-page backgrounds via eso-pic"
```

---

### Task 4: Build the cover page table

**Files:**
- Modify: `plantilla.tex`

The cover table is 144mm wide (matching 8154 docx twips), centered, with:
- Row 1: red background (#E4004F), white bold text, two lines — degree name and academic year
- Rows 2–5: gray background (#BFBFBF), bold label + value on one line

- [ ] **Step 1: Replace the document body with the cover table**

Replace everything between `\begin{document}` and `\end{document}` with:

```latex
% ---- Cover page ----
\thispagestyle{empty}

\vspace*{15mm}

{\centering
\setlength{\tabcolsep}{4pt}%
\setlength{\arrayrulewidth}{0.4pt}%
\arrayrulecolor{uitableborder}%
\begin{tabularx}{144mm}{|X|}
\hline
\cellcolor{uired}%
\parbox[c][16mm][c]{\dimexpr\linewidth-2\tabcolsep\relax}{%
  \centering
  \color{white}\bfseries\fontsize{11}{13}\selectfont
  \grado\par\smallskip
  Curso académico \cursoacademico\par
}\\
\hline
\cellcolor{uigray}\rule{0pt}{8mm}\textbf{Asignatura:} \asignatura \\
\hline
\cellcolor{uigray}\rule{0pt}{8mm}\textbf{Unidad didáctica:} \unidaddidactica \\
\hline
\cellcolor{uigray}\rule{0pt}{8mm}\textbf{Alumno:} \alumno \\
\hline
\cellcolor{uigray}\rule{0pt}{8mm}\textbf{Fecha:} \fecha \\
\hline
\end{tabularx}
\par}

\newpage

Page 2 test.
```

- [ ] **Step 2: Compile**

```bash
pdflatex -interaction=nonstopmode plantilla.tex
```

Expected: `Output written on plantilla.pdf (2 pages,`

- [ ] **Step 3: Open PDF and verify visually**

```bash
xdg-open plantilla.pdf
```

Check on page 1:
- The portada background is visible
- The table is centered on the page
- Row 1: solid red background, white bold "Grado en Administración y Dirección de Empresas" on one line, "Curso académico 2025-2026" below it
- Rows 2–5: gray background, bold labels "Asignatura:", "Unidad didáctica:", "Alumno:", "Fecha:" with empty space after each (labels only, values are empty)
- Table bordered in light gray (#D9D9D9)

Check on page 2:
- Interior background visible
- "Page 2 test." text appears in the content area
- Page number "2" appears bottom-right

- [ ] **Step 4: Commit**

```bash
git add plantilla.tex
git commit -m "feat: add cover page table with red header and gray metadata rows"
```

---

### Task 5: Verify footer positioning on interior pages

**Files:**
- Modify: `plantilla.tex` (only if adjustment needed)

The `fancyhdr` setup from Task 2 already places the page number at `\fancyfoot[R]{\small\thepage}`. This task confirms the number appears within the white content box and not overlapping the background image's institutional footer text.

- [ ] **Step 1: Inspect page 2 of the current PDF**

```bash
xdg-open plantilla.pdf
```

On page 2, verify:
- "2" appears bottom-right, inside the white content box
- It does NOT overlap the light-gray "UNIVERSIDAD INTERNACIONAL ISABEL I DE CASTILLA..." line baked into the interior background image

The background's footer text is at roughly the bottom 8mm of the page. The page number baseline with `footskip=7mm` sits at approximately 13mm from the bottom — it should clear the background text.

- [ ] **Step 2: If overlap occurs, adjust footskip**

If the page number overlaps the background's footer text, change `footskip=7mm` to `footskip=13mm` in the `geometry` block and recompile:

```bash
pdflatex -interaction=nonstopmode plantilla.tex
```

Verify again in the PDF.

- [ ] **Step 3: Commit only if a change was made**

```bash
git add plantilla.tex
git commit -m "fix: adjust footskip so page number clears background footer text"
```

---

### Task 6: Finalize the template

**Files:**
- Modify: `plantilla.tex`

- [ ] **Step 1: Do a full integration test with sample metadata and content**

Update the metadata variables to real values:

```latex
\newcommand{\asignatura}{Contabilidad Financiera}
\newcommand{\unidaddidactica}{Unidad 3: El ciclo contable}
\newcommand{\alumno}{María García López}
\newcommand{\fecha}{3 de mayo de 2026}
```

And replace `Page 2 test.` with:

```latex
\section*{Actividad 1}

Lorem ipsum dolor sit amet, consectetur adipiscing elit.
Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.

\section*{Desarrollo}

Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.
```

Compile:

```bash
pdflatex -interaction=nonstopmode plantilla.tex
```

Open and verify:

```bash
xdg-open plantilla.pdf
```

Expected:
- Page 1: cover table shows "Contabilidad Financiera", "Unidad 3: El ciclo contable", "María García López", "3 de mayo de 2026" in the gray rows
- Page 2: interior background, section headings and text in Raleway, page number "2" bottom-right

- [ ] **Step 2: Revert metadata to empty and replace interior content with a usage comment**

Restore the metadata `\newcommand`s to empty values:

```latex
\newcommand{\asignatura}{}
\newcommand{\unidaddidactica}{}
\newcommand{\alumno}{}
\newcommand{\fecha}{}
```

Replace the interior content block with a usage comment:

```latex
\newpage

% ---- Write your content here ----
% Use \newpage to add more pages. All pages after the first
% automatically use the interior background with the page number
% in the bottom-right corner.
```

- [ ] **Step 3: Final compile**

```bash
pdflatex -interaction=nonstopmode plantilla.tex
```

Expected: `Output written on plantilla.pdf (1 page,` — only the cover page, since interior content is commented out.

- [ ] **Step 4: Final commit**

```bash
git add plantilla.tex
git commit -m "feat: finalize LaTeX activity template for UI1 ADE 2025-2026"
```
