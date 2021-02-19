% pdg.cls
% Format reviews for PDG
% 2020-Feb-04  Jeffrey Anderson JDAnderson (at) lbl.gov
% 2020-Feb-04  Dean Robinson drobinson (at) lbl.gov
\ProvidesClass{pdg}[2020/02/07 version 1.30 PDG review format]
\NeedsTeXFormat{LaTeX2e}

% This PDG class extends the extbook class, for generation of the RPP
% Includes: a base set of common packages and 
% dedicated PDG environments for tables, figure and equations
\newcommand{\baseclass}{extbook}

%%%%%%%%%%%%%%%%
%%%     Version logic     %%%
%%%%%%%%%%%%%%%%

% Some internal booleans to control flow between different RPP versions
\RequirePackage{xifthen} % for conditional statements
\newif\ifrppbook
\newif\ifrppweb
\newif\ifrppbooklet
\newif\ifischapter
\newif\ifismergedreview

% Allow booleans to be set as options passed to the pdg class
\@ifclasswith{pdg}{rppbook}{\rppbooktrue}{\rppbookfalse}
\@ifclasswith{pdg}{rppweb}{\rppwebtrue}{\rppwebfalse}
\@ifclasswith{pdg}{rppbooklet}{\rppbooklettrue}{\rppbookletfalse}
\@ifclasswith{pdg}{toplevel}{\ismergedreviewtrue}{}

% \isbook \isbooklet and \isweb are booleans that can be passed on the command line to set or override class options given in the review source files.
\ifdefined\isweb
	\rppwebtrue
	\rppbookfalse
	\rppbookletfalse
\fi
\ifdefined\isbook
	\rppwebfalse
	\rppbooktrue
	\rppbookletfalse
\fi
\ifdefined\isbooklet
	\rppwebfalse
	\rppbookfalse
	\rppbooklettrue
%	\def\nohyperref{1}
\fi
% If neither book nor web is specified, assume draft
\ifthenelse{\isundefined\isbook \AND \isundefined\isweb \AND \isundefined\isbooklet}{\def\isdraft{1}}{}
\ifdefined\isdraft
	\rppwebtrue
	\rppbookfalse
	\rppbookletfalse
\fi

%%%%%%%%%%%%%%%
%%%     Base Class      %%%
%%%%%%%%%%%%%%%

%Squash moot warnings
%\RequirePackage{silence} 
%\WarningFilter{ltxutil}{Repair the float package} % Artifact of ltxgrid
%\WarningFilter{auxhook}{Cannot patch} % Cannot patch \document, using \AtBeginDocument instead.
%\WarningFilter{hyperref}{Token not allowed in a PDF string} % Fixable with \texorpdfstring


% Set default options to pass to base class
\DeclareOption{rppbook} {%
  \PassOptionsToClass{8pt,twoside,twocolumn,openany}{\baseclass}
  %Twocolumn option now enforced by ltxgrid
}
\DeclareOption{rppweb} {%
  \PassOptionsToClass{11pt,onecolumn}{\baseclass}
}
% We actually set the booklet font in the tex files.  
% 8pt is the smallest we can pass to book as an option
\DeclareOption{rppbooklet} {%
  \PassOptionsToClass{8pt,twoside,onecolumn,openany}{\baseclass}
}
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

%%%%%%%%%%%%%%%%%%%
%%%    Header/Footers/Titling   %%%
%%%%%%%%%%%%%%%%%%%

% Packages to control style of titles and page headers
\RequirePackage{titling}
\RequirePackage{fancyhdr, extramarks}
\RequirePackage[titles]{tocloft}
\RequirePackage[compact]{titlesec}
\RequirePackage[nodayofweek,level,12hr]{datetime}
\newcommand\booktitlestrut{\rule[-2ex]{0pt}{2ex}}

\newcommand\rppfooter[1]{%
  \ifthenelse{\isempty{#1}}{%
    \fancyfoot{}
    \fancypagestyle{plain}{\fancyfoot{}}
}{
    \ifrppbook \geometry{includefoot} \fi
    \fancyfoot{}
    \fancyfoot[C]{\scriptsize #1}
    \fancypagestyle{plain}{\fancyfoot[C]{\scriptsize #1}}
}}

\def\@runningreviewtitle{}
\newcommand\rpprunningheader[1]{%
  \ifthenelse{\isempty{#1}}{%
}{
   \def\@runningreviewtitle{#1}	
%    \ifrppweb
%   	 \fancyhead[C]{}
%    	\fancyhead[C]{\bf\itshape\nouppercase{\thechapter.  #1}}
%   	 \fancypagestyle{plain}{\fancyhead[C]{\bf\itshape\nouppercase{\thechapter.  #1}}}
%    \fi
%    \ifrppbook
%      \fancytabsTop{\numexpr\value{bleedersection}*73pt+4cm}
%    	\fancyhead[LE]{\booktitlestrut\bf\thepage\xspace\xspace\xspace\bf\itshape\nouppercase{\thechapter.  #1}\fancytab[LEFT]{}{}}
%   	 \fancyhead[RO]{{\booktitlestrut\bf\itshape\nouppercase{\thechapter.  #1}\xspace\xspace\xspace\fancytab[RIGHT]{}{}\bf\thepage}}
%   	 \fancypagestyle{plain}{%
%   	 \fancyhead[LE]{\booktitlestrut\bf\thepage\xspace\xspace\xspace\bf\itshape\nouppercase{\thechapter.  #1}\fancytab[LEFT]{}{}}
%   	 \fancyhead[RO]{{\booktitlestrut\bf\itshape\nouppercase{\thechapter.  #1}}\xspace\xspace\xspace\fancytab[RIGHT]{}{}\bf\thepage}}
%    \fi
}}

\fancypagestyle{rppbook}{%
	\fancyhf{} % clear the fields
	\renewcommand{\@chapapp}{}
	%Overridden by \rppthumb
	\fancyhead[LE]{\booktitlestrut\bf\thepage\xspace\xspace\xspace\bf\itshape\nouppercase{\firstleftmark}}
	\fancyhead[RO]{{\booktitlestrut\bf\itshape\nouppercase{\firstleftmark}}\xspace\xspace\xspace\bf\thepage}
	\fancyhead[RE,LO]{}
}

\fancypagestyle{rppweb}{%
	\fancyhf{} % clear the fields
	\renewcommand{\@chapapp}{}
	\setlength{\headheight}{14pt}
	\renewcommand{\headrulewidth}{0pt}
	\fancyhead[L]{\thepage}
	\fancyhead[C]{\bf\itshape\nouppercase{\firstleftmark}}
	\fancyfoot[C]{\scriptsize\today\hspace{5mm}\currenttime}
}

\fancypagestyle{rppdraft}{%
	\fancyhf{} % clear the fields
	\renewcommand{\@chapapp}{}
	\setlength{\headheight}{14pt}
	\renewcommand{\headrulewidth}{0pt}
	\fancyhead[L]{\thepage}
	\fancyhead[C]{\bf\itshape\nouppercase{\firstleftmark}}
	\fancyfoot[C]{\scriptsize DRAFT \scriptsize\today\hspace{2mm}\currenttime - Not for public distribution}
}

\fancypagestyle{rppbooklet}{%
	\fancyhf{} % clear the fields
	\renewcommand{\@chapapp}{}
	\renewcommand{\headrulewidth}{0pt}
	\setlength{\headheight}{14pt}
	\fancyhead[LE]{{\bf\thepage}\xspace\xspace\xspace\itshape\nouppercase{\firstleftmark}}
	\fancyhead[RO]{{\itshape\nouppercase{\firstleftmark}}\xspace\xspace\xspace\bf\thepage}
	\fancyhead[RE,LO]{}
}


%%%%%%%%%%%%%%%%%%%%%%
%%% Packages loaded before ltxgrid %%%
%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{amsmath} %AMS must be loaded before lineno for draft mode
\RequirePackage{longtable}
%%% Configure line numbers and margin tags for draft mode
\ifdefined\isdraft
	\RequirePackage[left]{lineno} 
	\linenumbers
\fi
%Attic for some commands deprecated by ltxgrid
	\let\stored@kludgeins\@kludgeins
	\let\stored@makecol\@makecol
	\let\stored@doclearpage\@doclearpage
	\let\stored@makefcolumn\@makefcolumn

%%%%%%%%%%%%%%%%%%%%%%%
%%% Ltxgrid and page geometry/format %%%
%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{ltxgrid} %The ReVTeX one/two column package

%Override ltxgrid defaults for footnotes
\def\@makefnmark{\hbox{\@textsuperscript{\normalfont\@thefnmark}}}			
%Provide overload one/two column commands compatible with extbook.
\let\onecolumn\onecolumngrid
\let\twocolumn\twocolumngrid	
	
\newif\ifbalancedlastpage
\newif\ifblankendpage	
\def\raggedlastpage{\gdef\ifbalancedlastpage{\iffalse}}
\def\addblankendpage{\gdef\ifblankendpage{\iftrue}}
\let\forceclearpage\clearpage
\ifrppbook
	%Take control of skips from extbook
	\renewcommand\normalsize{%
  	 	\@setfontsize\normalsize\@viiipt{9.5}%
		%   \abovedisplayskip 12\p@ \@plus4\p@ \@minus4\p@
   		\abovedisplayskip 8\p@ \@plus2\p@ \@minus2\p@
 		\abovedisplayshortskip \z@ \@plus3\p@
		\belowdisplayshortskip 5\p@ \@plus3\p@ \@minus3\p@
		\belowdisplayskip \abovedisplayskip
		\let\@listi\@listI}
	\normalsize
	\setlength{\skip\footins}{12\p@ \@plus 4\p@ \@minus 4\p@}
	%Set the two column mode
	\balancedlastpagetrue %default balancing
	\let\@document\document
	\let\@enddocument\enddocument
	\renewenvironment{document}{\@document \twocolumngrid}{
		\ifbalancedlastpage 
			\onecolumngrid 
		\fi
		\ifblankendpage
			\ifthenelse{\isodd{\thepage}}%
    			           {\fancyhead[LE]{\booktitlestrut\bf\thepage\fancytab[LEFT]{}{}}
                                     \clearpage\cleardoublepage}%
   			           {\fancyhead[RO]{\booktitlestrut\fancytab[RIGHT]{}{}\bf\thepage}
                                     \cleardoublepage}%
			%\pagestyle{empty}
		\fi		
		\@enddocument}
	%Override ltxgrid defaults for footnotes
	\renewcommand{\footnoterule}{%
		\kern -3\p@
		\hrule width 1.5in height 0.5\p@
		\kern 2.6\p@
	}
	%Page format
	\setlength{\columnsep}{5 mm}
	\RequirePackage[outer=.625in,inner=1in,top=2.35cm,bottom=1.0cm]{geometry}
	%%% Make first page footers/headers the same as others
	\fancypagestyle{plain}{}
	\pagestyle{rppbook}	
\fi

\ifrppbooklet
	\renewcommand\normalsize{%
   		\@setfontsize\normalsize\@viiipt{9.5}%
   		\abovedisplayskip 12\p@ \@plus4\p@ \@minus4\p@
  		 \abovedisplayshortskip \z@ \@plus3\p@
  		 \belowdisplayshortskip 5\p@ \@plus3\p@ \@minus3\p@
  		 \belowdisplayskip \abovedisplayskip
  		 \let\@listi\@listI}
	\normalsize
	\setlength{\skip\footins}{12\p@ \@plus 4\p@ \@minus 4\p@}
	\setlength\abovecaptionskip{0pt}
	%Set single column mode
	\balancedlastpagetrue %default balancing
	\let\@document\document
	\let\@enddocument\enddocument
	\renewenvironment{document}{\@document \onecolumngrid}{
		\ifbalancedlastpage
			\onecolumngrid 
		\fi		
		\@enddocument}
	%Override ltxgrid defaults for footnotes
	\renewcommand{\footnoterule}{%
		\kern-3\p@
  		\hrule\@width.4\columnwidth height 0.5\p@
  		\kern2.6\p@
	}
	\RequirePackage[paperwidth=115mm,paperheight=207mm,top=3mm,outer=3mm,inner=18mm,bottom=11mm,includehead,headsep=2mm]{geometry}
	\fancypagestyle{plain}{}
	\pagestyle{rppbooklet}
\fi

\ifrppweb
	%Set single column mode
	\balancedlastpagetrue %default balancing
	\let\@document\document
	\let\@enddocument\enddocument
	\renewenvironment{document}{\@document \onecolumngrid}{
		\ifbalancedlastpage 
			\onecolumngrid 
		\fi		 
		\@enddocument}
	%Override ltxgrid defaults for footnotes
	\renewcommand{\footnoterule}{%
		\kern-3\p@
  		\hrule\@width.4\columnwidth height 0.5\p@
  		\kern2.6\p@
	}
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

%%%%%%%%%%%%%
%%%    Thumbs    %%%
%%%%%%%%%%%%%
\RequirePackage{fancytabs}
\fancytabsLeftColor{black}
\fancytabsRightColor{black}
\fancytabsHeight{72pt}
\fancytabsWidth{1cm}

\newcounter{bleedersection}
\newcommand{\Repeat}[1]{%
    \expandafter\@Repeat\expandafter{\the\numexpr #1\relax}%
}

\def\@Repeat#1{%
    \ifnum#1>0
        \expandafter\@@Repeat\expandafter{\the\numexpr #1-1\expandafter\relax\expandafter}%
    \else
        \expandafter\@gobble
    \fi
}
\def\@@Repeat#1#2{%
    \@Repeat{#1}{#2}#2%
}
%\RequirePackage{thumbs}
%\pagenumbering{arabic}
%\newcommand\rppthumb{\Repeat{\numexpr\value{bleedersection}}{\addthumb{}{}{white}{white}}\addthumb{}{}{black}{black}}

\newcommand\rppthumb{%
   \ifrppbook
      \fancytabsTop{\numexpr\value{bleedersection}*73pt+4cm}
	\fancyhead[LE]{\booktitlestrut\bf\thepage\xspace\xspace\xspace\bf\itshape\nouppercase{\firstleftmark}\fancytab[LEFT]{}{}}
	\fancyhead[RO]{{\booktitlestrut\bf\itshape\nouppercase{\firstleftmark}}\xspace\xspace\xspace\fancytab[RIGHT]{}{}\bf\thepage}
	\fancyhead[RE,LO]{}
    \fi
}


%%%%%%%%%%%%%%%%%%%%%
%%%     Fundamental Packages      %%%
%%%%%%%%%%%%%%%%%%%%%

\RequirePackage[T1]{fontenc} % Allow hyphenated special symbols
\RequirePackage{lmodern} % Allow hyphenated special symbols

\RequirePackage{float} % to control figure placement
\RequirePackage[utf8]{inputenc} 
\RequirePackage{import}

\RequirePackage{xcolor}
%\PassOptionsToPackage{usenames,dvipsnames}{xcolor}
\RequirePackage{graphicx}  % to include figures (can also use other packages)
\setkeys{Gin}{width=0.49\textwidth} % Set default graphics width to be one column of a two-column page.
\RequirePackage{xspace} 
\RequirePackage{multirow}
\RequirePackage{rotating}
\RequirePackage{auxhook}
\RequirePackage{amsmath} %AMS
\RequirePackage{amssymb} %AMS
\RequirePackage{hhline}
\RequirePackage{isomath}
\RequirePackage{caption} % Greater control over table caption formatting
\RequirePackage{xstring} % String logic
\RequirePackage{array} %Must be after ltxgrid

\RequirePackage{varwidth}
\RequirePackage{footmisc}
\RequirePackage{adjustbox}
\RequirePackage{relsize}

%%% Decrease line spacing in itemize and enumerate lists
\RequirePackage{paralist}
  \let\itemize\compactitem
  \let\enditemize\endcompactitem
  \let\enumerate\compactenum
  \let\endenumerate\endcompactenum
  \let\description\compactdesc
  \let\enddescription\endcompactdesc
  \pltopsep=\medskipamount
  \plitemsep=1pt
  \plparsep=1pt

% Fix problem with "LaTeX Error: Too many unprocessed floats." on older LaTeX installations
% See https://tex.stackexchange.com/questions/46512/too-many-unprocessed-floats
\RequirePackage{morefloats}
\RequirePackage[section]{placeins}

%\RequirePackage{xcite}
\RequirePackage{pdg-xr-hyper}

%%%%%%%%%%%%%%%%
%%%   Footnote control   %%%
%%%%%%%%%%%%%%%%

\newcommand{\setfootnotestyle}[1]{
\renewcommand*{\thempfn}{#1{footnote}}
%	old version
%	\renewcommand*{\thefootnote}{#1{footnote}}
%	for minipage
%	\renewcommand*{\thempfootnote}{\fnsymbol{mpfootnote}}
}

%%%%%%%%%%%%%%%%%%%%%%%%
%%%  Counter manipulators (temporary)   %%%
%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand\bumpupfigurenumber{\stepcounter{figure}}
\newcommand\bumpuptablenumber{\stepcounter{table}}
\newcommand\bumpupsubsubsectionnumber{\stepcounter{subsubsection}}
\newcommand\bumpupsubsectionnumber{\stepcounter{subsection}}
\newcommand\bumpupsectionnumber{\stepcounter{section}}
\newcommand\bumpupequationnumber{\stepcounter{equation}}

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

%%%%%%%%%%%%%%%%%%%%%
%%%  Title and Header Formats   %%%%
%%%%%%%%%%%%%%%%%%%%%

%\RequirePackage{minitoc}
%\nomtcrule
%\renewcommand{\mtctitle}{}
\let\@@l@chapter\l@chapter
\def\l@chapter#1{\@@l@chapter{}}
\cftpagenumbersoff{chapter}

% Prevent clearpage before TOC.  Insert blank line after TOC
\renewcommand\tableofcontents{%
  \@starttoc{toc}
  \hfill\par
}
\addtolength{\cftsecnumwidth}{10pt}
\addtolength{\cftchapnumwidth}{10pt}
\renewcommand{\@cftmaketoctitle}{}

%%%% Define subsubsubsection between subsubsection and paragraph
\titleclass{\subsubsubsection}{straight}[\subsection]
\newcounter{subsubsubsection}[subsubsection]
%\renewcommand\thesubsubsubsection{\thesubsubsection.\roman{subsubsubsection}}
\renewcommand\thesubsubsubsection{\roman{subsubsubsection}.}
%\renewcommand\theparagraph{\thesubsubsubsection.\arabic{paragraph}} % optional; useful if paragraphs are to be numbered

\titleformat{\subsubsubsection}
  {\normalsize\mdseries}{\thesubsubsubsection}{.5em}{\itshape}
\titlespacing*{\subsubsubsection}
{0pt}{3.25ex plus 1ex minus .2ex}{1.5ex plus .2ex}

\renewcommand\paragraph{\@startsection{paragraph}{5}{\z@}%
  {3.25ex \@plus1ex \@minus.2ex}%
  {-1em}%
  {\normalfont\normalsize\bfseries}}
\renewcommand\subparagraph{\@startsection{subparagraph}{6}{\parindent}%
  {3.25ex \@plus1ex \@minus .2ex}%
  {-1em}%
  {\normalfont\normalsize\bfseries}}
\def\toclevel@subsubsubsection{4}
\def\toclevel@paragraph{5}
\def\toclevel@paragraph{6}
\def\l@subsubsubsection{\@dottedtocline{4}{7em}{4em}}
\def\l@paragraph{\@dottedtocline{5}{10em}{5em}}
\def\l@subparagraph{\@dottedtocline{6}{14em}{6em}}

\setcounter{secnumdepth}{4}
%%%%

%% Format Chapter titles
\ifrppbooklet
	\titlespacing{\chapter}{0pt}{-15pt}{5pt}
	\titleformat{\chapter}[block]
	{\centering\bfseries\Large}
	{\thechapter.}
 	 {1ex}
	%  {\vspace{1ex}\filcenter}
 	 {\vspace{0ex}}
 	 [\vspace{0ex}]
\fi
\ifrppbook
	\titlespacing{\chapter}{0pt}{-15pt}{5pt}
	\titleformat{\chapter}[block]
	{\onecolumn\vskip-24\p@\centering\bfseries\Large}
	{\thechapter.}
 	 {1ex}
	%  {\vspace{1ex}\filcenter}
 	 {\vspace{0ex}}
 	 [\vspace{1ex}\twocolumn]
\else
	\titlespacing{\chapter}{0pt}{-15pt}{5pt}
	\titleformat{\chapter}[block]
	{\centering\bfseries\Large}
	{\thechapter.}
 	 {1ex}
	%  {\vspace{1ex}\filcenter}
 	 {\vspace{1ex}}
 	 [\vspace{1ex}]
\fi
%%

\titleformat{\section}[block]{\large\bfseries}{\thesection}{.5em}{}
%\titleformat*{\subsection}{\normalsize\bfseries}
\titleformat{\subsection}[block]{\normalsize\bfseries}{\thesubsection}{.5em}{\itshape}
\titleformat{\subsubsection}[block]{\normalsize\mdseries}{\thesubsubsection}{.5em}{\itshape}
\titlespacing{\section}{0pt}{5pt}{0pt}
\titlespacing{\subsection}{0pt}{5pt}{0pt}
\titlespacing{\subsubsection}{0pt}{5pt}{0pt}


%%% New macros for setting titles and authors
\newcommand{\chapterauthor}[1]{%
  {\parindent0pt\vspace*{-25pt}%
  \linespread{1.1}\scshape#1%
  \par\nobreak\vspace*{35pt}}
  \@afterheading%
}

%%% Don't label sections and subsections as chapter 0 if using \chapter*
\let\stdthesubsubsubsection\thesubsubsubsection
\renewcommand{\thesubsubsubsection}{%
  \ifischapter%
  \stdthesubsubsubsection\else\arabic{section}.\arabic{subsection}.\arabic{subsubsection}.\arabic{subsubsubsection}\fi%
}

\let\stdthesubsubsection\thesubsubsection
\renewcommand{\thesubsubsection}{%
  \ifischapter%
  \stdthesubsubsection\else\arabic{section}.\arabic{subsection}.\arabic{subsubsection}\fi%
}
\let\stdthesubsection\thesubsection
\renewcommand{\thesubsection}{%
  \ifischapter%
  \stdthesubsection\else\arabic{section}.\arabic{subsection}\fi%
}
\let\stdthesection\thesection
\renewcommand{\thesection}{%
  \ifischapter%
  \stdthesection\else\arabic{section}\fi%
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
	  \ifischapter{
	  	\chapter{\@reviewtitle}}
	  \else{
	  \chapter*{\@reviewtitle}}
	  \fi%
	  \ifthenelse{\equal{\@runningreviewtitle}{}}{
	 	%\gdef\@internalmark{\thechapter.  \@reviewtitle}
	  	\markboth{\thechapter.  \@reviewtitle}{\thechapter.  \@reviewtitle}
		
	  	}{%
		%\gdef\@internalmark{\thechapter.  \@runningreviewtitle}
		\markboth{\thechapter.  \@runningreviewtitle}{\thechapter.  \@runningreviewtitle}
	}
	}
	{ %\bibliographyunit[\chapter]
	  \ifischapter \chapter{#1}%
	  \else{\chapter*{#1}\markboth{#1}{#1}}
	  \fi%
	}
      }
      {
	\ifthenelse{\equal{#1}{}}
		   {\section{\@sectiontitle}}
		   {\section{#1}}
      }
}
{
  \ifthenelse{\equal{#1}{}}
  {\subsection{\@subsectiontitle}}
  {\subsection{#1}}
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
  \par\nobreak\vspace*{5pt}}
  \@afterheading%
}

\newcommand{\revised}[1]{%
  {\parindent0pt%\vspace*{-25pt}%
  \linespread{1.1}{Revised #1 by \@reviewauthor.}%
  \par\nobreak\vspace*{5pt}}
  \@afterheading%
}

\newcommand{\customauthor}[1]{%
  {\parindent0pt%\vspace*{-25pt}%
  \linespread{1.1}#1%
  \par\nobreak\vspace*{5pt}}
  \@afterheading%
}


%%%%%%%%%%%%%%%%%%%
%%%  PDG Strip Environment   %%%
%%%%%%%%%%%%%%%%%%%

\newenvironment{pdgstrip}[1][\unskip]{
	}{%
	\ignorespacesafterend
	\noindent
}

\newif\ifplainbool
\ifrppbook
%
\let\pdg@caption\caption
\newcommand{\captionfigure}{\def\@captype{figure}\pdg@caption}
\newcommand{\captiontable}{\def\@captype{table}\pdg@caption}
\let\pdg@figure\figure
\let\pdg@endfigure\endfigure
\let\pdg@table\table
\let\pdg@endtable\endtable
%
\RequirePackage{listofitems}
\renewenvironment{pdgstrip}[1][\unskip]{
	\readlist*\optlist{#1,} %generalized list reader, allows multiple option list in future in any order [plain, tight etc]
		\plainboolfalse
		\foreachitem\x\in\optlist[]{\IfStrEq{\x}{plain}{\plainbooltrue}{}}
	\renewenvironment{figure}[1][\unskip]{\let\caption\captionfigure}{\let\caption\pdg@caption}
	\renewenvironment{table}[1][\unskip]{\let\caption\captiontable}{\let\caption\pdg@caption}
	\ifplainbool
		\onecolumngrid
		\vskip12\p@
	\else
		\onecolumngrid
		\vskip6\p@
		\noindent
		\rule{0.4\p@}{6\p@}\noindent
		\rule{\dimexpr(0.5\textwidth-0.5\columnsep-1.4\p@)}{0.4\p@}\hfill
	\fi	
	}{%
	\ifplainbool
		\vskip8\p@%
		\twocolumngrid
	\else	
		\hfill\rule{\dimexpr(0.5\textwidth-0.5\columnsep-1\p@)}{0.4\p@}\noindent
		\rule[-6\p@]{0.4\p@}{6.4\p@}
		\vskip2\p@%
		\twocolumngrid
	\fi
	\let\figure\pdg@figure
	\let\endfigure\pdg@endfigure
	\let\table\pdg@table
	\let\endtable\pdg@endtable
	\ignorespacesafterend
	\noindent
}
\fi

%%%%%%%%%%%%%
%%%   PDG Align   %%%
%%%%%%%%%%%%%

%Version dependent align/cr (previously an environment)
\let\webalign\relax
\newcommand{\webcr}[2]{}
\let\bookalign\relax
\newcommand{\bookcr}[2]{}	
\let\bookletalign\relax
\newcommand{\bookletcr}[2]{}
\ifrppbook
	\def\bookalign{&}
	\renewcommand{\bookcr}[2]{#1 \\#2}	
\fi	
\ifrppweb
	\def\webalign{&}
	\renewcommand{\webcr}[2]{#1 \\#2}	
\fi		
\ifrppbooklet
	\def\bookletalign{&}
	\renewcommand{\bookletcr}[2]{#1 \\#2}	
\fi

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  PDG Book/Web includegraphics `Gin' keys  %%%
%%%%%%%%%%%%%%%%% %%%%%%%%%%%

\def\pdgtab@scale{1}
\def\pdgtab@bbscale{1}
\def\pdgtab@widecapscale{0.75}
\define@key{Gin}{widecaptionscale}[0.75]{
        \def\pdgtab@widecapscale{#1}	
}
\def\pdgtab@narrowcapscale{0.45}
\define@key{Gin}{narrowcaptionscale}[0.9]{
	\pgfmathsetmacro{\pdgtab@narrowcapscale}{#1*0.5}
        %\def\pdgtab@narrowcapscale{#1}	
}
\def\pdgtab@tabularstretch{1}	
\define@key{Gin}{tabularstretch}[1]{
	\def\pdgtab@tabularstretch{#1}	
}
\ifrppbook
    %	
    \define@key{Gin}{bookwidth}{
        \setkeys{Gin}{width = #1}
    }
    \define@key{Gin}{bookscale}{
        \setkeys{Gin}{scale = #1}
        \def\pdgtab@scale{#1}
    }
    \define@key{Gin}{bookbbscale}{
        \def\pdgtab@bbscale{#1}
    }
    \define@key{Gin}{webwidth}{}
    \define@key{Gin}{webscale}{}
    \define@key{Gin}{webbbscale}{}
    \define@key{Gin}{bookletwidth}{}
    \define@key{Gin}{bookletscale}{}
    \define@key{Gin}{bookletbbscale}{}
    %
\else\ifrppweb
	%
        \define@key{Gin}{bookwidth}{}
        \define@key{Gin}{bookscale}{}
        \define@key{Gin}{bookbbscale}{}
        \define@key{Gin}{webwidth}{
            \setkeys{Gin}{width = #1}
        }
        \define@key{Gin}{webscale}{
            \setkeys{Gin}{scale = #1}
            \def\pdgtab@scale{#1}
        }
        \define@key{Gin}{webbbscale}{
        	    \def\pdgtab@bbscale{#1}
        }
        \define@key{Gin}{bookletwidth}{}
        \define@key{Gin}{bookletscale}{}
        \define@key{Gin}{bookletbbscale}{}
        %
    \else\ifrppbooklet
    		%
    		\define@key{Gin}{bookwidth}{}
       		\define@key{Gin}{bookscale}{}
		\define@key{Gin}{bookbbscale}{}
		\define@key{Gin}{webwidth}{}
  		\define@key{Gin}{webscale}{}
		\define@key{Gin}{webbbscale}{}
		\define@key{Gin}{bookletwidth}{
           		 \setkeys{Gin}{width = #1}
        		}
        		\define@key{Gin}{bookletscale}{
            		\setkeys{Gin}{scale = #1}
            		\def\pdgtab@scale{#1}
       		 }
		 \define@key{Gin}{bookletbbscale}{
        	   		 \def\pdgtab@bbscale{#1}
       		 }
		 %
    	\else
 		\define@key{Gin}{bookwidth}{}
        		\define@key{Gin}{bookscale}{}
		\define@key{Gin}{bookbbscale}{}
       		\define@key{Gin}{webwidth}{}
        		\define@key{Gin}{webscale}{}
		\define@key{Gin}{webbbscale}{}
		\define@key{Gin}{bookletwidth}{}
        		\define@key{Gin}{bookletscale}{}
		\define@key{Gin}{bookletbbscale}{}
	\fi
    \fi
\fi 

%%%%%%%%%%%%%%%%% 
%%%  PDG Figures/Tables  %%%
%%%%%%%%%%%%%%%%% 

\RequirePackage{bigstrut}
\setlength\bigstrutjot{1pt}
\newlength\mylena
\newlength\mylenb
\newcommand\mystrut[1][2]{%
\setlength\mylena{#1\ht\@arstrutbox}%
\setlength\mylenb{#1\dp\@arstrutbox}%
\rule[\mylenb]{0pt}{\mylena}}

\newcommand{\pdgfigure}[5]{
\ifthenelse{\isempty{#4}}{%
  \begin{figure}[!ht]}{%
  \begin{figure}[#4]}
    \centering
%% Still experimenting with figure scaling
\ifthenelse{\isempty{#5}}{%
    \includegraphics[width=.85\linewidth]{figures/#1}}{%
  \includegraphics[#5]{figures/#1}}
%    \includegraphics[#5]{figures/#1}
    \caption{#2}\label{#3}
  \end{figure}
}

\newcommand{\pdgwidefigure}[5]{
\ifthenelse{\isempty{#4}}{%
  \begin{figure*}[!ht]}{%
  \begin{figure*}[#4]}
    \centering
\ifthenelse{\isempty{#5}}{%
    \includegraphics[width=\textwidth]{figures/#1}}{%
  \includegraphics[#5]{figures/#1}}
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

\newcommand{\pdgwidedoublefigure}[6]{
\ifthenelse{\isempty{#5}}{%
  \begin{figure*}[!ht]}{%
  \begin{figure*}[#5]}
    \centering
\ifthenelse{\isempty{#6}}{%
    \includegraphics[width=.45\textwidth]{figures/#1}
    \includegraphics[width=.45\textwidth]{figures/#2}}{%
    \includegraphics[#6]{figures/#1}
    \includegraphics[#6]{figures/#2}}
    \caption{#3}\label{#4}
  \end{figure*}
}

\newcommand{\pdgdoublefigurex}[7]{
\ifthenelse{\isempty{#5}}{%
  \begin{figure}[!ht]}{%
  \begin{figure}[#5]}
    \centering
    \includegraphics[#6]{figures/#1}
    \includegraphics[#7]{figures/#2}
    \caption{#3}\label{#4}
  \end{figure}
}

\newcommand{\pdgwidedoublefigurex}[7]{
\ifthenelse{\isempty{#5}}{%
  \begin{figure*}[!ht]}{%
  \begin{figure*}[#5]}
    \centering
\ifthenelse{\isempty{#6}}{%
    \includegraphics[width=.45\textwidth]{figures/#1}
    \includegraphics[width=.45\textwidth]{figures/#2}}{%
    \includegraphics[width=.45\textwidth,#6]{figures/#1}
    \includegraphics[width=.45\textwidth,#7]{figures/#2}}
    \caption{#3}\label{#4}
  \end{figure*}
}

%\newcommand\tableline{\noalign{\smallskip}\hline\noalign{\smallskip}\bigstrut[t]\bigstrut[b]}
\newcommand\tableline{\noalign{\smallskip}\hline\noalign{\smallskip}}
\newcommand\Tablerule{\noalign{\smallskip}\hline\noalign{\smallskip}}
\newcommand\tabledoubleline{\noalign{\smallskip}\hline\hline\noalign{\smallskip}}

\newcommand{\pdgtableheader}[1]{%
#1\\
\hline
%\tableline
%\noalign{\smallskip}
%\mystrut[.5]
%\noalign{\smallskip}#1\\
%\noalign{\smallskip}\hline\noalign{\smallskip}
}

\newcolumntype{P}[1]{>{\raggedright\arraybackslash}p{#1}}

\newenvironment{pdgtable}[4]{% #1
\captionsetup{width=.75\linewidth,labelfont=bf}
\ifthenelse{\isempty{#4}}{%
  \begin{table}[!ht]}{%
  \begin{table}[#4]}
\centering
\setlength{\parindent}{0pt}
\begin{minipage}{\columnwidth}% so footnote will appear
\renewcommand*{\thempfn}{\fnsymbol{mpfootnote}}
\renewcommand*\footnoterule{}
    \caption{#2}
    \label{#3}
    \centering
    \begin{tabular}{@{}#1@{}}
        \hline\hline
}{%
  \hline\hline
    \end{tabular}
    \end{minipage}
    \end{table}
}

\newenvironment{pdgwidetable}[4]{%
\captionsetup{width=1\textwidth,labelfont=bf}
\ifthenelse{\isempty{#4}}{%
  \begin{table*}[!ht]}{%
  \begin{table*}[#4]}
\begin{minipage}{\textwidth} % so footnote will appear
\renewcommand*{\thempfn}{\fnsymbol{mpfootnote}}
\renewcommand*\footnoterule{}
    \caption{#2}
    \label{#3}
    \centering
    \begin{tabular}{@{}#1@{}}
        \hline\hline
}{%
  \hline\hline
    \end{tabular}
    \end{minipage}
    \end{table*}
}

\newenvironment{pdgverywidetable}[4]{% #1
\captionsetup{width=1\linewidth,labelfont=bf}
\ifthenelse{\isempty{#4}}{%
  \begin{table*}[!ht]}{%
  \begin{table*}[#4]}
\relscale{.95}
\centering
\setlength{\parindent}{0pt}
\begin{minipage}{\linewidth}% so footnote will appear
	\renewcommand*{\thempfn}{\fnsymbol{mpfootnote}}
\renewcommand*\footnoterule{}
    \caption{#2}
    \label{#3}
%    \begin{adjustbox}{width=\linewidth}
    \centering
    \begin{tabular}{@{}#1@{}}
        \hline\hline
}{%
  \hline\hline
    \end{tabular}
%    \end{adjustbox}
    \end{minipage}
    \end{table*}
}

\newenvironment{pdgscaletable}[5]{% #1
\captionsetup{width=.75\linewidth,labelfont=bf}
\ifthenelse{\isempty{#4}}{%
  \begin{table}[!ht]}{%
  \begin{table}[#4]}
\ifthenelse{\isempty{#5}}{\relscale{.95}}{\relscale{#5}}
\centering
\setlength{\parindent}{0pt}
\begin{minipage}{\linewidth}% so footnote will appear
\renewcommand*{\thempfn}{\fnsymbol{mpfootnote}}
\renewcommand*\footnoterule{}
    \caption{#2}
    \label{#3}
%    \begin{adjustbox}{width=\linewidth}
    \centering
    \begin{tabular}{@{}#1@{}}
        \hline\hline
}{%
  \hline\hline
    \end{tabular}
%    \end{adjustbox}
    \end{minipage}
    \end{table}
}

\newenvironment{pdgscaletable*}[5]{% #1
\captionsetup{width=.75\textwidth,labelfont=bf}
\ifthenelse{\isempty{#4}}{%
  \begin{table*}[!ht]}{%
  \begin{table*}[#4]}
\ifthenelse{\isempty{#5}}{\relscale{.95}}{\relscale{#5}}
\centering
\setlength{\parindent}{0pt}
\begin{minipage}{\linewidth}% so footnote will appear
\renewcommand*{\thempfn}{\fnsymbol{mpfootnote}}
\renewcommand*\footnoterule{}
    \caption{#2}
    \label{#3}
%    \begin{adjustbox}{width=\linewidth}
    \centering
    \begin{tabular}{@{}#1@{}}
        \hline\hline
}{%
  \hline\hline
    \end{tabular}
%    \end{adjustbox}
    \end{minipage}
    \end{table*}
}

\newenvironment{pdgscalewidetable}[5]{% #1
\ifrppbook
  \captionsetup{width=1\textwidth,labelfont=bf}
\else
  \captionsetup{width=.75\linewidth,labelfont=bf}
\fi
\ifthenelse{\isempty{#4}}{%
  \begin{table*}[!ht]}{%
  \begin{table*}[#4]}
\ifrppbook
  \begin{minipage}{\textwidth} % so footnote will appear
\else
  \ifthenelse{\isempty{#5}}{\relscale{.95}}{\relscale{#5}}
  \centering
  \setlength{\parindent}{0pt}
  \begin{minipage}{\linewidth}
\fi
\renewcommand*{\thempfn}{\fnsymbol{mpfootnote}}
\renewcommand*\footnoterule{}
  \caption{#2}
  \label{#3}
  \centering
  \begin{tabular}{@{}#1@{}}
  \hline\hline
}{%
  \hline\hline
  \end{tabular}
  \end{minipage}
  \end{table*}
}

\newenvironment{pdgsidewaystable}[4]{% #1
\captionsetup{width=.75\linewidth,labelfont=bf}
\ifthenelse{\isempty{#4}}{%
  \begin{sidewaystable*}[!ht]}{%
  \begin{sidewaystable*}[#4]}
\relscale{.95}
\centering
\setlength{\parindent}{0pt}
\begin{minipage}{\linewidth}% so footnote will appear
\renewcommand*{\thempfn}{\fnsymbol{mpfootnote}}
\renewcommand*\footnoterule{}
    \caption{#2}
    \label{#3}
%    \begin{adjustbox}{width=\linewidth}
    \centering
    \begin{tabular}{@{}#1@{}}
        \hline\hline
}{%
  \hline\hline
    \end{tabular}
%    \end{adjustbox}
    \end{minipage}
    \end{sidewaystable*}
}

%%%%%%%%%%%%%
%%%   pdgxtable  %%%
%%%%%%%%%%%%%

%Keys for placement, wide setting, orientation
\define@key{Gin}{place}[!ht]{
	\def\fps@table{#1}
}
\define@boolkey{Gin}{wide}[false]{}	
\define@boolkey{Gin}{sideways}[false]{}	
\def\pdgtab@rotate{0}
\define@choicekey{Gin}{rotated}[\val\nr]{left,right}{%,auto}{
	\ifcase\nr\relax
		\def\pdgtab@rotate{90}
	\or
		\def\pdgtab@rotate{-90}
%	\or
%		\ifnumodd{\value{page}}{\def\pdgtab@rotate{-90}}{\def\pdgtab@rotate{90}}
	\fi
}
\newlength{\@minipagewidth}
\newlength{\@capwidth}
	
\newenvironment{pdgxtabular}[1]{
	\begin{tabular}{@{} #1 @{}}
      		\hline\hline
		\centering
	}{
		\hline\hline
 	\end{tabular}	
}
		
\newenvironment{pdgxtable}[1][]{
	\setkeys{Gin}{#1}
	%(Minipage) width and caption logic
	\pgfmathsetmacro{\pdgtab@scale}{\pdgtab@bbscale*\pdgtab@scale} %bbscale adjusts size of total bounding box versus scale in adjustbox
	\pgfmathsetmacro{\inv@scaling}{1/\pdgtab@scale}
	\pgfmathsetmacro{\cap@scaling}{\pdgtab@widecapscale*\pdgtab@scale} %default 0.75\pdgtab@scale
	\ifKV@Gin@wide
		\ifKV@Gin@sideways
			\begin{sidewaystable*}
			\setlength{\@minipagewidth}{\inv@scaling\textheight}
		\else
			\begin{table*}	
			\setlength{\@minipagewidth}{\inv@scaling\textwidth}
		\fi
		\setlength{\@capwidth}{\cap@scaling\@minipagewidth}
	\else	
		\begin{table}
		\ifrppbook
			\setlength{\@minipagewidth}{\inv@scaling\textwidth - \inv@scaling\columnsep}
			\pgfmathsetmacro{\cap@scaling}{\pdgtab@narrowcapscale*\pdgtab@scale} 
			\setlength{\@capwidth}{\cap@scaling\@minipagewidth} %default 0.45\@minipagewidth
		\else
			\setlength{\@minipagewidth}{\inv@scaling\linewidth}
			\setlength{\@capwidth}{\cap@scaling\@minipagewidth}
		\fi	
	\fi
	%Adjust tabular scaling, stretching, orientation
	\renewcommand{\arraystretch}{\pdgtab@tabularstretch}
	\renewenvironment{pdgxtabular}[1]{
		\setkeys{Gin}{width = \@minipagewidth, #1}
		\begin{center}
		\begin{adjustbox}{max width = \@minipagewidth, scale = \pdgtab@scale, rotate = \pdgtab@rotate, minipage=\@minipagewidth}
			\def\KV@Gin@ewidth{\KV@Gin@width}
			\renewcommand*{\thempfn}{\fnsymbol{mpfootnote}}
    			\renewcommand*\footnoterule{}	
			\begin{center}
			\begin{tabular}{@{} ##1 @{}}
      				\hline\hline
	}{
				\hline\hline
 			\end{tabular}
			\end{center}	
		\end{adjustbox}	
		\end{center}
	}
	\captionsetup{width=\@capwidth,labelfont=bf}
	\begin{center}
}{  		
	\end{center}
	\ifKV@Gin@wide	
		\ifKV@Gin@sideways
			\end{sidewaystable*}
		\else
			\end{table*}
		\fi
	\else	
		\end{table}
	\fi
	%cleanup
	\def\pdgtab@rotate{0}
	\def\pdgtab@scale{1}
	\def\pdgtab@bbscale{1}
	\def\pdgtab@tabularstretch{1}
	\ignorespacesafterend
	\noindent
}

%%%%%%%%%%%%%%
%%%   Bibliography  %%%
%%%%%%%%%%%%%%

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

% Use hyperref, but hide the ugly green boxes.  Also try to suppress warnings
% related to math symbols in PDF bookmarks
% Disable hyperref in booklet mode due to conflicts with xcite
\definecolor{navyblue}{rgb}{0.0, 0.0, 0.5}
\ifdefined\nohyperref
	\RequirePackage{url}
%	\newcommand{\href[1]}{\tt{#1}}
	\newcommand{\texorpdfstring[1]}{#1}
%\relax
\else
 	\RequirePackage{hyperref}

\ifrppweb
 	\hypersetup{
     		colorlinks=true,
                linkcolor=black,
                citecolor=navyblue,
                filecolor=black,
                menucolor=black,
                runcolor=black,
                urlcolor=navyblue,
     		pdfborder={0 0 0},
	 }
\fi
\ifdefined\isdraft
\hypersetup{
  colorlinks=true,
                linkcolor=red,
                citecolor=blue,
                filecolor=blue,
                menucolor=run,
                runcolor=red,
                urlcolor=magenta,
  pdfborder={0 0 0},
  }
\fi

\ifrppbook
 	\hypersetup{
     		colorlinks=false,
     		pdfborder={0 0 0},
	 }
\fi
\ifrppbooklet
 	\hypersetup{
     		colorlinks=false,
     		pdfborder={0 0 0},
	 }
\fi

	 \PassOptionsToPackage{pdfencoding=auto,psdextra, unicode, naturalnames}{hyperref}
 		\pdfstringdefDisableCommands{%
  		 \def\pi{pi}%
 		 \def\eta{eta}%
	 }
\fi


%%%%%%%%%%
%%%   Tags  %%%
%%%%%%%%%%

\ifdefined\isdraft
	\newcommand\lbbox[1]{
		\vrule%
		\makebox[0pt][l]{\rule[-.25em]{\widthof{#1}+.2em}{.4pt}}%
		\makebox[\widthof{#1}+.2em][l]{#1}
	}
	%\RequirePackage[inline,nolabel]{showlabels}
	% The following should cause labels to be rendered in red.
	% Unfortunately, when the labels are inline, this causes all 
	% text to be red.
	%\renewcommand{\showlabelfont}{\tiny}
	%\showlabels{cite}
	%\showlabels{bibitem}
	\RequirePackage[color,notref,notcite]{showkeys}
	\def\SK@bib@relax{\global\let\SK@bib\relax}\SK@bib@relax
	\def\SK@@bib#1>#2\SK@{%
		\gdef\SK@bib{\smash{\SK@labelcolor\showkeysbibformat{#2}}}%
		\global\setbox\@labels\hbox{%
		\raisebox{-1.2ex}{\rlap{\SK@bib\SK@bib@relax}}
%		\llap{\SK@bib\SK@bib@relax
%		\kern\@totalleftmargin\kern\marginparsep}%
		\box\@labels}%
	}
	\def\@bibitem#1{%
		\SK@bibitem{#1} \SK@\SK@@bib{#1}\ignorespaces}
	\definecolor{refkey}{rgb}{1,0,0}
	\definecolor{labelkey}{rgb}{0,0,1}
	\providecommand\showkeysbibformat[1]{%
	\makebox[2cm][l]{\normalfont\scriptsize\ttfamily~#1}
	}
	\renewcommand\showkeyslabelformat[1]{%
	%\fbox{\normalfont\tiny\ttfamily#1}
	\makebox[2cm][l]{\lbbox{\normalfont\tiny\ttfamily~#1}}
	}
%\renewcommand*\showkeyslabelformat[1]{%
%  \fbox{\parbox[t]{\marginparwidth}{\raggedright\path{#1}}}}
\fi


%%% Adjust how missing bibrefs are displayed in cite.sty
\def\@make@cite@list{%
 \expandafter\ifx\csname b@\@citeb\@extra@b@citeb 
      \endcsname\relax % undefined: output ? and warning
    \@citea {\bfseries `\@citeb'~?}\let\@citea\citepunct \G@refundefinedtrue
    \@warning {Citation `\@citeb' on page \thepage\space undefined}%
 %% always verbose \oc@verbo \global\@namedef{b@\@citeb\@extra@b@citeb}{?}%
 \else %  defined        
    \@cite@nonhyper@sanitize
    \@addto@cite@list
 \fi}
 
%%% Adjust how missing refs are displayed 
\def\@setref#1#2#3{%
\ifx#1\relax
   \protect\G@refundefinedtrue
   \nfss@text{\reset@font\bfseries `#3'~??}%
   \@latex@warning{Reference `#3' on page \thepage \space
             undefined}%
  \else
   \expandafter#2#1\null
\fi}


%%% Define some useful macros for authors to use

\input{pdgdefs}
\endinput

