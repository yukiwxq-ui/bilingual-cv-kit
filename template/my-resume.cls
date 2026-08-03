\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{my-resume}[2026/07/03 Personal fork of resume.cls with Arimo (Arial) as main font, bold headers, photo header, two-line entries]
\LoadClass[11pt]{article}

% disable indent globally
\setlength{\parindent}{0pt}
% English hyphenation patterns -- without this, long unhyphenatable
% tokens (e.g. "React/TypeScript", "geographic/taxonomic") can push a
% justified line into an overfull \hbox once bullet text starts with a
% bold lead-in phrase (the added bold width shifts where each line
% breaks). babel doesn't touch font selection, so it's safe to load even
% in the Chinese CV alongside xeCJK (loaded via my-resume-zh.sty).
\RequirePackage[english]{babel}
% some general improvements, defines the XeTeX logo
\RequirePackage{xltxtra}
% use xifthen
\RequirePackage{xifthen}
% use xcolor for customizing color
\RequirePackage[usenames,dvipsnames]{xcolor}
% for the headshot in \photoheader
\RequirePackage{graphicx}
% for \entry's wrap-safe two-column title/date layout, and for the
% dot-free 2x2 contact info grid in \contactInfo
\RequirePackage{tabularx}
% loading fonts
\RequirePackage{fontspec}
% Main document font: Arimo, a metric-compatible Arial substitute
% (real Arial is not installed on this machine; swap this line for
% \setmainfont{Arial} on a machine that has the real font installed)
\setmainfont{Arimo}

\RequirePackage[
	a4paper,
	left=0.7in,
	right=0.7in,
	top=0.50in,
	bottom=0.5in,
	nohead
]{geometry}

\RequirePackage{titlesec}
\RequirePackage{enumitem}
\setlist{noitemsep} % removes spacing from items but leaves space around the whole list
%\setlist{nosep} % removes all vertical spacing within and around the list
% topsep/partopsep both 0 -- a list right under an \entry/\role line should
% read as the next line, not a new paragraph with breathing room. Skills
% section adds its own space back explicitly via \entrySkillsSep instead.
\setlist[itemize]{topsep=0pt, partopsep=0pt, leftmargin=1.5pc}
\setlist[enumerate]{topsep=0pt, partopsep=0pt, leftmargin=1.5pc}
\RequirePackage[super]{nth}

\titleformat{\section}         % Customise the \section command
  {\Large\bfseries\raggedright} % Large, bold, left aligned section headers
  {}{0em}                      % Can be used to give a prefix to all sections, like 'Section ...'
  {}                           % Can be used to insert code before the heading
  [{\titlerule[0.8pt]}]        % Inserts a horizontal line after the heading (slightly thicker than titlesec's ~0.4pt default; braced so the inner [0.8pt] doesn't confuse titleformat's own bracketed argument)
\titlespacing*{\section}{0cm}{*0.6}{*0.4}

\titleformat{\subsection}
  {\large\raggedright}
  {}{0em}
  {}
\titlespacing*{\subsection}{0cm}{*1}{*0.5}

\newcommand{\datedsection}[2]{%
  \section[#1]{#1 \hfill #2}%
}
\newcommand{\datedsubsection}[2]{%
  \subsection[#1]{#1 \hfill #2}%
}
\newcommand{\datedline}[2]{%
  {\par #1 \hfill #2 \par}%
}

% Left-aligned name/contact block (used inside \photoheader)
\newcommand{\name}[1]{
  {\Huge\bfseries #1}\par
  \vspace{0.6ex}
}

% Contact info: row 1 is a dot-free phone/email grid, then location and
% tagline each get their own full-width line below (not side-by-side --
% a long tagline paired with a location name read cramped next to each
% other). Args 3/4 stay optional (blank line if empty). Second column of
% row 1 is a wrapping X column (not plain "l") so a long email wraps
% instead of overflowing the header's left block.
\newcommand{\contactInfo}[4]{
  \begin{tabularx}{\linewidth}{@{}l@{\hspace{1.5em}}X@{}}
    {\large #1} & {\large #2} \\
  \end{tabularx}\par
  \ifthenelse{\isempty{#3}}{}{{\large #3}\par}
  \ifthenelse{\isempty{#4}}{}{{\large #4}\par}
  \vspace{0.5ex}
}

% Name+contact block on the left, ID photo on the right, vertically
% centered relative to each other (both blocks use minipage[c]).
% #1 = name/contact content (typically \name{..}\contactInfo{..}{..}{..}{..})
% #2 = path to photo file
% #3 = photo width (e.g. 2.6cm)
\newcommand{\photoheader}[3]{%
  \noindent
  \begin{minipage}[c]{0.74\textwidth}
    #1
  \end{minipage}%
  \hfill
  \begin{minipage}[c]{0.20\textwidth}
    \raggedleft\includegraphics[width=#3]{#2}
  \end{minipage}
  \par\vspace{0.8ex}
}

% Same header, no photo -- full-width name/contact block. Used for English
% CVs where a photo isn't customary/wanted (Chinese versions keep \photoheader).
% #1 = name/contact content (typically \name{..}\contactInfo{..}{..}{..}{..})
\newcommand{\headerNoPhoto}[1]{%
  \noindent#1\par\vspace{0.8ex}
}

\newcommand{\role}[2]{
  {\par \textit{#1} ~ #2 \par}
  \vspace{0pt}% gap to the bullets below, matching \entry's trailing gap
}

% One-line entry: bold org/title + role/subtitle on the left, location +
% date on the right, e.g. "**Company Name** Role . Dept ... City Date".
% Any of #3/#4 may be empty. Uses tabularx (not a plain \hfill) so that a
% long title+subtitle that wraps to a second line doesn't run into the
% date/location with no separating space.
% #1 = org/title  #2 = date  #3 = role/subtitle/tools  #4 = location
% Leading \vspace is the gap BETWEEN separate entries (deliberately the
% larger gap); the trailing \vspace is the (tight) gap before this entry's
% own bullet list -- see \entrySkillsSep below for the one place a wider
% gap is wanted instead (right before the Skills section's first bullet).
\newcommand{\entry}[4]{%
  \par\vspace{0.6ex}%
  \begin{tabularx}{\linewidth}{@{}X r@{}}
    {\bfseries #1}\ifthenelse{\isempty{#3}}{}{\ {\fontsize{11.5}{14}\selectfont #3}} & \ifthenelse{\isempty{#4}}{}{#4\ }#2 \\
  \end{tabularx}%
  \par\vspace{0pt}%
}

% Extra breathing room before the Skills section's first bullet only --
% every other bullet list sits right under its \entry/\role with almost no
% gap (see above), but the Skills list follows directly after a bare
% \section{} heading with nothing in between, so it needs its own explicit
% space to avoid looking cramped against the section rule.
\newcommand{\entrySkillsSep}{\vspace{0.8ex}}
