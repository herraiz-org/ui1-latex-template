\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ui1activity}[2026/05/03 UI1 Activity Class]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass{article}

% Encoding and language
\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}
\RequirePackage[spanish,es-tabla]{babel}
\RequirePackage{icomma}

\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{amsfonts}

\RequirePackage[autostyle=true]{csquotes}
\RequirePackage{caption}
\RequirePackage[backend=biber,style=apa]{biblatex}
\let\cite\parencite

% Font: Raleway (pdflatex-compatible Museo Sans substitute)
\RequirePackage[sfdefault]{raleway}
\renewcommand{\familydefault}{\sfdefault}

% Page layout -- margins converted from docx twips (1 twip = 1/1440 inch)
\RequirePackage[
  a4paper,
  top=18mm,
  left=27.5mm,
  right=25mm,
  bottom=22mm,
  headheight=8pt,
  headsep=0pt,
  footskip=5mm
]{geometry}

% Colors
\RequirePackage[table]{xcolor}   % [table] option loads colortbl automatically
\definecolor{uired}{HTML}{E4004F}
\definecolor{uigray}{HTML}{BFBFBF}
\definecolor{uitableborder}{HTML}{D9D9D9}

% Tables
\RequirePackage{tabularx}

% Headers and footers
\RequirePackage{fancyhdr}
\pagestyle{fancy}
\fancyhf{}
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}
\fancyfoot[R]{\small\thepage}

% Background images
\RequirePackage{eso-pic}
\RequirePackage{graphicx}
\RequirePackage{ifthen}

% Full-page background: portada on page 1, interior on pages 2+
\AddToShipoutPictureBG{%
  \AtPageLowerLeft{%
    \ifthenelse{\value{page}=1}{%
      \includegraphics[width=\paperwidth,height=\paperheight]{imgs/portada}%
    }{%
      \includegraphics[width=\paperwidth,height=\paperheight]{imgs/interior}%
    }%
  }%
}
