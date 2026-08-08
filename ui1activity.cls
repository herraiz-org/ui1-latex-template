% Copyright 2026 Israel Herraiz <isra@herraiz.org>
%
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
%
%     http://www.apache.org/licenses/LICENSE-2.0
%
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
% implied. See the License for the specific language governing
% permissions and limitations under the License.

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

% Jurisprudencia: remap .bib field names to biblatex user fields via source map.
% Legislation: derive shorttitle by stripping law number and date from title.
% biber discards fields not in its data model; source maps run before that check.
\DeclareSourcemap{
  \maps[datatype=bibtex]{
    \map{
      \pertype{jurisprudencia}
      \step[fieldsource=kind,       fieldtarget=usera]
      \step[fieldsource=court,      fieldtarget=userb]
      \step[fieldsource=shortcourt, fieldtarget=userc]
      \step[fieldsource=chamber,    fieldtarget=userd]
      \step[fieldsource=fdate,      fieldtarget=usere]
      \step[fieldsource=ecli,       fieldtarget=userf]
    }
    \map{
      \pertype{legislation}
      \step[fieldsource=title]
      \step[fieldset=shorttitle, origfieldval]
      \step[fieldsource=shorttitle,
            match=\regexp{^(.*?)\s+\d+/\d\d\d\d,?\s*(?:de\s\d\d?\sde\s(?:enero|febrero|marzo|abril|mayo|junio|julio|agosto|septiembre|octubre|noviembre|diciembre)(?:,\s*de\s\d\d\d\d)?,?\s*)?((?:de\s|sobre\s|por\s|relativo\s|que\s|del\s|en\s|a\s).*)$},
            replace={$1 $2}]
    }
  }
}

\DeclareFieldFormat[jurisprudencia]{usera}{#1}
\DeclareFieldFormat[jurisprudencia]{userb}{#1}
\DeclareFieldFormat[jurisprudencia]{userc}{#1}
\DeclareFieldFormat[jurisprudencia]{number}{#1}
\DeclareFieldFormat[jurisprudencia]{userd}{#1}
\DeclareFieldFormat[jurisprudencia]{usere}{#1}
\DeclareFieldFormat[jurisprudencia]{userf}{#1}
\DeclareFieldFormat[jurisprudencia]{url}{\url{#1}}

\DeclareBibliographyDriver{jurisprudencia}{%
  \usebibmacro{bibindex}%
  \usebibmacro{begentry}%
  \printfield{usera}\addspace
  \printfield{userb}\addspace
  \printfield{number}\addspace
  (\printfield{userd}),\addspace
  de \printfield{usere}.\addspace
  ECLI:\printfield{userf}%
  \iffieldundef{url}{}{\addperiod\addspace\printfield{url}}%
  \usebibmacro{finentry}}

\DeclareCiteCommand{\parencite}[\mkbibparens]
  {\usebibmacro{cite:init}%
   \usebibmacro{prenote}%
   \toggletrue{apa:inpcite}}
  {\usebibmacro{citeindex}%
   \ifentrytype{jurisprudencia}
     {\printfield{userc}\addnbspace\printfield{number}}
     {\usebibmacro{cite}%
      \usebibmacro{cite:post}}}
  {}
  {\usebibmacro{postnote}%
   \togglefalse{apa:inpcite}}

\defbibfilter{notlegislationorjuris}{not type=legislation and not type=jurisprudencia}

\newbool{ui@hasjuris}
\newbool{ui@hasleg}
\AtDataInput[jurisprudencia]{\global\booltrue{ui@hasjuris}}
\AtDataInput[legislation]{\global\booltrue{ui@hasleg}}

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

% Encapsulate bibliography — jurisprudencia, then legislation, then main references
\newcommand{\ui@legistitle}{\iflanguage{spanish}{Legislaci\'on}{Legislation}}
\newcommand{\makebibliography}{%
	\ifbool{ui@hasjuris}{%
		\printbibliography[type=jurisprudencia, heading=bibintoc, title={Jurisprudencia}]%
	}{}%
	\ifbool{ui@hasleg}{%
		\printbibliography[type=legislation, heading=bibintoc, title={\ui@legistitle}]%
	}{}%
	\printbibliography[filter=notlegislationorjuris, heading=bibintoc]%
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
