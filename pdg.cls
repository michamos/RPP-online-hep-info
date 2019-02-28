% pdg.cls
% Format reviews for PDG
% 2018-Mar-08  Jeffrey Anderson JDAnderson (at) lbl.gov

\ProvidesClass{pdg}[2019/01/18 version 1.10 PDG review format]
\NeedsTeXFormat{LaTeX2e}
\RequirePackage{xifthen} % for conditional statements


% This class extends the extbook class

% Some internal booleans to control flow
\newif\ifrppbook
\newif\ifrppweb
\newif\ifrppbooklet

\newif\ifischapter
\newif\ifismergedreview

\newcommand{\baseclass}{extbook}

% Allow booleans to be set as options passed to the pdg class
\@ifclasswith{pdg}{rppbook}{\rppbooktrue}{\rppbookfalse}
\@ifclasswith{pdg}{rppweb}{\rppwebtrue}{\rppwebfalse}
\@ifclasswith{pdg}{rppbooklet}{\rppbooklettrue}{\rppbookletfalse}
\@ifclasswith{pdg}{toplevel}{\ismergedreviewtrue}{}

% \isbook \isbooklet and \isweb are booleans that can be passed on the command line to set or override class options given in the review source files.
\ifdefined\isbook
\rppbooktrue
\rppwebfalse
\rppbookletfalse
\fi

\ifdefined\isweb
\rppwebtrue
\rppbookfalse
\rppbookletfalse
\fi

\ifdefined\isbooklet
\rppbooklettrue
\rppwebfalse
\rppbookfalse
\fi

% If neither book nor web is specified, assume draft
\ifthenelse{\isundefined\isbook \AND \isundefined\isweb \AND \isundefined\isbooklet}{\def\isdraft{1}}{}

\ifdefined\isdraft
\rppwebtrue
\rppbookfalse
\rppbookletfalse
\fi


% Set default options to pass to base class
\DeclareOption{rppbook} {%
  \PassOptionsToClass{8pt,twoside,twocolumn}{\baseclass}

}

\DeclareOption{rppweb} {%
  \PassOptionsToClass{11pt,onecolumn}{\baseclass}
}

% We actually set the booklet font in the tex files.  
% 8pt is the smallest we can pass to book as an option
\DeclareOption{rppbooklet} {%
  \PassOptionsToClass{8pt,onecolumn}{\baseclass}
}

%\DeclareOption{draft} {}

% Pass through any other options
\DeclareOption*{%
  \PassOptionsToClass{\CurrentOption}{\baseclass}}


\ifrppbook
\ExecuteOptions{rppbook} % rppbook is default
\fi

\ifrppweb
\ExecuteOptions{rppweb} 
\fi

\ifrppbooklet
\ExecuteOptions{rppbooklet}
\fi

\ProcessOptions\relax

% Load base class
\LoadClass{\baseclass}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Many external packages and definitions.  These will be replaced with canonical definitions in the final version.


% This allows us to test whether a counter has been set
\newcommand*\ifcounter[1]{%
  \ifcsname c@#1\endcsname
    \ifnum\value{#1}=0
    \expandafter\@secondoftwo
    \else
    \expandafter\@firstoftwo
    \fi
  \else
    \expandafter\@secondoftwo
  \fi
}

\RequirePackage[T1]{fontenc}
\RequirePackage{lmodern}
\RequirePackage[nodayofweek,level,12hr]{datetime}
\RequirePackage{color}
\RequirePackage{float} % to control figure placement
\RequirePackage[utf8]{inputenc} 
\RequirePackage{xspace} 

% Use hyperref, but hide the ugly green boxes.  Also try to suppress warnings
% related to math symbols in PDF bookmarks
\RequirePackage{hyperref}
\hypersetup{
    colorlinks=false,
    pdfborder={0 0 0},
}
\PassOptionsToPackage{pdfencoding=auto,psdextra, unicode, naturalnames}{hyperref}
\pdfstringdefDisableCommands{%
  \def\pi{pi}%
  \def\eta{eta}%
}

\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{hhline}


\RequirePackage{graphicx}  % to include figures (can also use other packages)
% Set default graphics width to be one column of a two-column page.
\setkeys{Gin}{width=0.49\textwidth}
%\RequirePackage{tabularx}

% Greater control over table caption formatting
\RequirePackage{caption}


%%%%%   Define a number of custom commands and environments %%%%%
\newcommand{\pdgfigure}[5]{
\ifthenelse{\isempty{#4}}{%
  \begin{figure}[!ht]}{%
  \begin{figure}[#4]}
    \centering
%% Still experimenting with figure scaling
    \includegraphics[width=.85\linewidth,#5]{figures/#1}
%    \includegraphics[#5]{figures/#1}
    \caption{#2}\label{#3}
  \end{figure}
}

\newcommand{\pdgwidefigure}[5]{
\ifthenelse{\isempty{#4}}{%
  \begin{figure*}[!ht]}{%
  \begin{figure*}[#4]}
    \centering
    \includegraphics[width=\textwidth,#5]{figures/#1}
    \caption{#2}\label{#3}
  \end{figure*}
}

\newcommand{\pdgdoublefigure}[6]{
\ifthenelse{\isempty{#5}}{%
  \begin{figure}[!ht]}{%
  \begin{figure}[#5]}
    \centering
    \includegraphics[#6]{figures/#1}
    \includegraphics[#6]{figures/#2}
    \caption{#3}\label{#4}
  \end{figure}
}


\RequirePackage{bigstrut}
    \setlength\bigstrutjot{1pt}
\newlength\mylena
\newlength\mylenb
\newcommand\mystrut[1][2]{%
    \setlength\mylena{#1\ht\@arstrutbox}%
    \setlength\mylenb{#1\dp\@arstrutbox}%
    \rule[\mylenb]{0pt}{\mylena}}

\newcommand{\pdgtableheader}[1]{%
#1\\
\hline
%\noalign{\smallskip}
%\mystrut[.5]
%\noalign{\smallskip}#1\\
%\noalign{\smallskip}\hline\noalign{\smallskip}
}

\RequirePackage{footmisc}

\newenvironment{pdgtable}[4]{% #1
\captionsetup{width=.75\linewidth,labelfont=bf}
\ifthenelse{\isempty{#4}}{%
  \begin{table}[!ht]}{%
  \begin{table}[#4]}
\centering
\begin{minipage}{\linewidth}% so footnote will appear
\renewcommand*{\thempfootnote}{\fnsymbol{mpfootnote}}
\renewcommand*\footnoterule{}
    \caption{#2}
    \label{#3}
    \centering
    \begin{tabular}{#1}
        \hline\hline
}{%
  \hline\hline
    \end{tabular}
    \end{minipage}
    \end{table}
}



\newenvironment{pdgwidetable}[4]{%
\captionsetup{width=.75\textwidth,labelfont=bf}
\ifthenelse{\isempty{#4}}{%
  \begin{table*}[!ht]}{%
  \begin{table*}[#4]}
\begin{minipage}{\textwidth} % so footnote will appear
\renewcommand*{\thempfootnote}{\fnsymbol{mpfootnote}}
\renewcommand*\footnoterule{}
    \caption{#2}
    \label{#3}
    \centering
    \begin{tabular}{#1}
        \hline\hline
}{%
  \hline\hline
    \end{tabular}
    \end{minipage}
    \end{table*}
}

%
\RequirePackage{import}

%%% Bibliography
%\RequirePackage{setspace}
\RequirePackage[globalcitecopy,labelstoglobalaux]{bibunits}
\RequirePackage{cite,mciteplus}
\defaultbibliographystyle{pdg}

% Print ``References'' instead of ``Bibliography
% Make review bibliographies start immediately after text, 
% not on a new page


\newlength{\bibitemsep}\setlength{\bibitemsep}{0pt plus 0.3ex}
\newlength{\bibparskip}\setlength{\bibparskip}{0pt}
\let\stdthebibliography\thebibliography
\renewcommand{\thebibliography}{%
  \renewcommand{\bibname}{References}
  \setlength{\parskip}{\bibparskip}%
  \setlength{\itemsep}{-.3ex}%
  \let\chapter\subsection
  \stdthebibliography%
}

\let\oldthebibliography=\thebibliography
\let\endoldthebibliography=\endthebibliography
\renewenvironment{thebibliography}[1]{%
   \begin{oldthebibliography}{#1}%
     \setlength{\itemsep}{-.3ex}%
}%
{%
   \end{oldthebibliography}%
}

\renewcommand{\@bibunitname}{\jobname.\the\@bibunitauxcnt}

%%% Configure line numbers and margin tags for draft mode
\RequirePackage[left]{lineno}
\ifdefined\isdraft
\linenumbers
\RequirePackage[inline]{showlabels}
% The following should cause labels to be rendered in red.
% Unfortunately, when the labels are inline, this causes all 
% text to be red.
\renewcommand{\showlabelfont}{\tiny}
\showlabels{cite}
\showlabels{bibitem}
\fi

\let\oldputbib\putbib
\renewcommand{\putbib}[1][]{
\renewcommand{\markboth}[2]{}
\oldputbib[#1]
}

%%% Don't change the running header inside the bibliography
\newcommand\inputbib[1]{
\renewcommand{\markboth}[2]{}
\input{#1}
}

%%% Special bibliography handling for toplevel reviews
\def\putmergedbib{\@ifnextchar[{\@putmergedbib}{\@putmergedbib[\bu@bibdata]}}
\def\@putmergedbib[#1]{%
  \@startbibunitorrelax
  \if@filesw
    \immediate\write\@bibunitaux{\string\bibdata{#1}}%
  \fi
  \@input@{\@bibunitname.bbl}%
}
\ifismergedreview \def\@putbib[#1]{\relax} \fi


% Packages to control style of titles and page headers
\RequirePackage{titling}
\RequirePackage{fancyhdr}

% Prevent clearpage before TOC.  Insert blank line after TOC
\renewcommand\tableofcontents{%
  \@starttoc{toc}
  \hfill\par
}

%%% Customize title formats
\RequirePackage{titlesec}
\titlespacing*{\chapter}{0pt}{-15pt}{5pt}
\titleformat{\chapter}[block]
{\centering\bfseries\Large}
{\thechapter.}
  {1ex}
%  {\vspace{1ex}\filcenter}
  {\vspace{1ex}}
  [\vspace{1ex}]

\titleformat*{\section}{\large\bfseries}
\titleformat*{\subsection}{\normalsize\bfseries}

%%% New macros for setting titles and authors
\newcommand{\chapterauthor}[1]{%
  {\parindent0pt\vspace*{-25pt}%
  \linespread{1.1}\scshape#1%
  \par\nobreak\vspace*{35pt}}
  \@afterheading%
}

%%% Don't label sections and subsections as chapter 0 if using \chapter*
\let\stdthesubsection\thesubsection
\renewcommand{\thesubsection}{
  \ifischapter \stdthesubsection \else \arabic{subsection} \fi
}
\let\stdthesection\thesection
\renewcommand{\thesection}{
  \ifischapter \stdthesection \else \arabic{section} \fi
}

\newcommand\reviewtitle[1]{\renewcommand\@reviewtitle{#1}}
\newcommand\@reviewtitle{}

\newcommand\sectiontitle[1]{\renewcommand\@sectiontitle{#1}}
\newcommand\@sectiontitle{}

\newcommand\subsectiontitle[1]{
  \setcounter{secnumdepth}{5}
  \renewcommand\@subsectiontitle{#1}}
\newcommand\@subsectiontitle{}

\newcommand\reviewlabel[1]{\renewcommand\@reviewlabel{#1}}
\newcommand\@reviewlabel{}

\newcommand\sectionlabel[1]{\renewcommand\@sectionlabel{#1}}
\newcommand\@sectionlabel{}


\newcommand\pdgtitle[1][]{%
\ifthenelse{\equal{\@subsectiontitle}{}}
{
  \ifthenelse{\equal{\@sectiontitle}{}}
      {
	\ifthenelse{\equal{#1}{}}
	{ %\bibliographyunit[\chapter]
%	  \ifcounter{chapter}{\chapter{\@reviewtitle}}{\chapter*{\@reviewtitle}}
	  \ifischapter \chapter{\@reviewtitle} 
	  \else {\chapter*{\@reviewtitle} \markboth{\@reviewtitle}{\@reviewtitle}}
	  \fi
%	  \chapter{\@reviewtitle}
	}
	{ %\bibliographyunit[\chapter]
	  \ifischapter \chapter{#1} 
	  \else {\chapter*{#1} \markboth{#1}{#1}}
	  \fi
%	  \ifcounter{chapter}{\chapter{#1}}{\chapter*{#1}}
	}
      }
      {
	\ifthenelse{\equal{#1}{}}
		   { %\bibliographyunit[\section]
		     \section{\@sectiontitle}}
		   { %\bibliographyunit[\section]
		     \section{#1}}
      }
}
{
  \ifthenelse{\equal{#1}{}}
  { %\bibliographyunit[\subsection]

    \subsection{\@subsectiontitle}}
  { %\bibliographyunit[\subsection]
    \subsection{#1}}
}
\ifthenelse{\equal{\@reviewlabel}{}}
{}{\label{\@reviewlabel}}
\ifthenelse{\equal{\@sectionlabel}{}}
{}{\label{\@sectionlabel}}
}

\newcommand\reviewauthor[1]{\renewcommand\@reviewauthor{#1}}
\newcommand\@reviewauthor{}

\newcommand{\showreviewtitle}{%
    {\@reviewtitle}
    \@afterheading%
}

\newcommand{\written}[1]{%
  {\parindent0pt%\vspace*{-25pt}%
  \linespread{1.1}{Written #1 by \@reviewauthor.}%
  \par\nobreak\vspace*{10pt}}
  \@afterheading%
}

\newcommand{\revised}[1]{%
  {\parindent0pt%\vspace*{-25pt}%
  \linespread{1.1}{Revised #1 by \@reviewauthor.}%
  \par\nobreak\vspace*{10pt}}
  \@afterheading%
}

\newcommand{\customauthor}[1]{%
  {\parindent0pt%\vspace*{-25pt}%
  \linespread{1.1}#1%
  \par\nobreak\vspace*{10pt}}
  \@afterheading%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Custom pagestyles


\newcommand\rppfooter[1]{%
  \ifthenelse{\isempty{#1} \OR \equal{#1}{none}}{%
    \fancyfoot{}
    \fancypagestyle{plain}{\fancyfoot{}}
}{
    \ifrppbook \geometry{includefoot} \fi
    \fancyfoot{}
    \fancyfoot[C]{\scriptsize #1}
    \fancypagestyle{plain}{\fancyfoot[C]{\scriptsize #1}}
}}


\fancypagestyle{rppbook}{%
\fancyhf{} % clear the fields
\renewcommand{\@chapapp}{}
\fancyhead[LE]{\thepage\xspace\xspace\xspace\bf\itshape\nouppercase{\leftmark}}
\fancyhead[RO]{{\bf\itshape\nouppercase{\leftmark}}\xspace\xspace\xspace\thepage}
\fancyhead[RE,LO]{}
}

\fancypagestyle{rppweb}{%
\fancyhf{}
\renewcommand{\@chapapp}{}
\setlength{\headheight}{14pt}
\renewcommand{\headrulewidth}{0pt}
\fancyhead[L]{\thepage}
\fancyhead[C]{\bf\itshape\nouppercase{\leftmark}}
\fancyfoot[C]{\scriptsize\today\hspace{5mm}\currenttime}
}

\fancypagestyle{rppdraft}{%
\fancyhf{}
\renewcommand{\@chapapp}{}
\setlength{\headheight}{14pt}
\renewcommand{\headrulewidth}{0pt}
\fancyhead[L]{\thepage}
\fancyhead[C]{\bf\itshape\nouppercase{\leftmark}}
\fancyfoot[C]{\scriptsize DRAFT \scriptsize\today\hspace{2mm}\currenttime - Not for public distribution}
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Book specific formatting
\ifrppbook
\setlength{\columnsep}{5 mm}
\RequirePackage[outer=.625in,inner=1in,top=1.125in,bottom=1.0cm]{geometry}
%%% Make first page footers/headers the same as others
\fancypagestyle{plain}{}
\pagestyle{rppbook}
\fi

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Web specific formatting
\ifrppweb
\RequirePackage[left=1in,right=1in,top=1in,bottom=1in]{geometry}
\ifdefined\isdraft
\fancypagestyle{plain}{}
\pagestyle{rppdraft}
\else
\fancypagestyle{plain}{%
\fancyfoot[C]{\scriptsize \rppCitation \\ \scriptsize\today\hspace{2mm}\currenttime}
}
\pagestyle{rppweb}
\fi
\fi

\ifrppbooklet
%\RequirePackage[total={76mm,147mm}]{geometry}
\RequirePackage[paperwidth=76mm,paperheight=147mm,top=5mm,right=5mm,left=5mm,bottom=5mm]{geometry}
\fi

%\RequirePackage[]{thumbs}

% Fix problem with "LaTeX Error: Too many unprocessed floats." on older LaTeX installations
% See https://tex.stackexchange.com/questions/46512/too-many-unprocessed-floats
\RequirePackage{morefloats}
\RequirePackage[section]{placeins}

%%% Define some useful macros for authors to use

\input{pdgdefs}
\endinput
