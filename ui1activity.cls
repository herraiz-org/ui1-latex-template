\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ui1activity}[2026/05/03 UI1 Activity Class]

\newif\ifui@palatino
\newif\ifui@times
\newif\ifui@nohangbib
\newif\ifui@coverpage
\ui@coverpagetrue

\DeclareOption{palatino}{\ui@palatinotrue\ui@timesfalse}
\DeclareOption{times}{\ui@palatinofalse\ui@timestrue}
\DeclareOption{nohangbib}{\ui@nohangbibtrue}

\ExecuteOptions{palatino}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass{article}

% Encoding and language
\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}

% Fonts
\ifui@palatino
	\RequirePackage{newpxtext}
	\RequirePackage{newpxmath}
	\newcommand{\ui@helvetscale}{0.95}
\fi
\ifui@times
	\RequirePackage{newtxtext}
	\RequirePackage{newtxmath}
	\newcommand{\ui@helvetscale}{0.92}
\fi
\RequirePackage[scaled=\ui@helvetscale]{helvet}

\RequirePackage{titlesec}
\titleformat{\section}{\sffamily\bfseries\large\color{black}}{\thesection}{1em}{}
\titleformat{\subsection}{\sffamily\bfseries\color{black}}{\thesubsection}{1em}{}
\titleformat{\subsubsection}{\sffamily\bfseries\color{black}}{\thesubsubsection}{1em}{}

\titlespacing*{\section}{0pt}{3.5ex plus 1ex minus .2ex}{1.5ex plus .2ex}

\RequirePackage[english,spanish,es-tabla]{babel}
\RequirePackage{icomma}

\RequirePackage{amsmath}
\RequirePackage{parskip}

\RequirePackage[autostyle=true]{csquotes}
\RequirePackage{caption}
\captionsetup{font={small,it},labelfont=bf,margin=1cm}
\RequirePackage[backend=biber,style=apa]{biblatex}
\setlength{\bibitemsep}{\parskip}
\ifui@nohangbib
	\setlength{\bibhang}{0pt}
\fi
\let\cite\parencite

\DeclareFieldFormat[legislation]{number}{#1}
\DeclareFieldFormat[legislation]{eid}{#1}

\DeclareBibliographyDriver{legislation}{%
  \usebibmacro{bibindex}%
  \usebibmacro{begentry}%
  \printfield{title}\addperiod\addspace
  BOE n\'{u}mero \printfield{number}\addspace
  \S\addnbspace\printfield{eid}\addspace
  (\printfield{year})%
  \usebibmacro{finentry}}

\defbibfilter{notlegislation}{not type=legislation}

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

% PDF bookmarks and metadata — must be loaded last
\RequirePackage[hidelinks,bookmarksdepth=3]{hyperref}
\AtBeginDocument{%
	\hypersetup{%
		pdftitle={\@unidaddidactica},%
		pdfauthor={\@alumno},%
		pdfsubject={\@asignatura}%
	}%
}

% Cover page data variables
\newcommand{\grado}[1]{\def\@grado{#1}}
\newcommand{\cursoacademico}[1]{\def\@cursoacademico{#1}}
\newcommand{\asignatura}[1]{\def\@asignatura{#1}}
\newcommand{\unidaddidactica}[1]{\def\@unidaddidactica{#1}}
\newcommand{\alumno}[1]{\def\@alumno{#1}}
\newcommand{\fecha}[1]{\def\@fecha{#1}}

% Initialize variables with empty values
\grado{}
\cursoacademico{}
\asignatura{}
\unidaddidactica{}
\alumno{}
\fecha{}

% Encapsulate the custom cover page
\newcommand{\makecustomcover}{%
	\thispagestyle{empty}
	\vspace*{29mm}
	{\centering
		\setlength{\tabcolsep}{4pt}%
		\setlength{\arrayrulewidth}{0.8pt}%
		\arrayrulecolor{uitableborder}%
		\begin{tabularx}{144mm}{|X|}
			\hline
			\cellcolor{uired}%
			\parbox[c][16mm][c]{\dimexpr\linewidth-2\tabcolsep\relax}{%
				\centering
				\color{white}\sffamily\bfseries\fontsize{11}{13}\selectfont
				\@grado\par\smallskip
				Curso académico \@cursoacademico\par
			}                                                                             \\
			\hline
			\cellcolor{uigray}\rule{0pt}{5mm}\textsf{\textbf{Asignatura:}} \@asignatura            \\
			\hline
			\cellcolor{uigray}\rule{0pt}{5mm}\textsf{\textbf{Unidad didáctica:}} \@unidaddidactica \\
			\hline
			\cellcolor{uigray}\rule{0pt}{5mm}\textsf{\textbf{Alumno:}} \@alumno                    \\
			\hline
			\cellcolor{uigray}\rule{0pt}{5mm}\textsf{\textbf{Fecha:}} \@fecha                      \\
			\hline
		\end{tabularx}
		\par}
	\AddToHook{shipout/after}[ui1activity/coverreset]{%
		\setcounter{page}{0}%
		\global\ui@coverpagefalse
		\RemoveFromHook{shipout/after}[ui1activity/coverreset]%
	}%
}

% Encapsulate bibliography — legislation first, then main references
\newcommand{\ui@legistitle}{\iflanguage{spanish}{Legislaci\'on}{Legislation}}
\newcommand{\makebibliography}{%
	\printbibliography[type=legislation, heading=bibintoc, title={\ui@legistitle}]%
	\printbibliography[filter=notlegislation, heading=bibintoc]%
}

% Full-page background: portada on page 1, interior on pages 2+
\AddToShipoutPictureBG{%
	\AtPageLowerLeft{%
		\ifui@coverpage
			\includegraphics[width=\paperwidth,height=\paperheight]{imgs/portada}%
		\else
			\includegraphics[width=\paperwidth,height=\paperheight]{imgs/interior}%
		\fi
	}%
}
