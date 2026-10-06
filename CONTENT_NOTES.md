# CV template & content notes

Reference for building **job-tailored CVs** from this template — one master (full-experience) CV plus several 1-page versions tailored to specific job directions. Not part of any CV itself; read this before touching `template/`.

- `my-resume.cls` / `my-resume-zh.sty` — the shared LaTeX class + Chinese-font package. Fully self-contained: compiles standalone with plain `xelatex` run from the `template/` directory, no external dependencies (fonts are bundled).
- `example_zh.tex` / `example_en.tex` — worked examples using a fictional persona ("张三"/"Zhang San") that demonstrate every macro. **Copy one of these as the starting point for your own master CV**, then fill in real content and build tailored 1-page versions from there. `photo_placeholder.jpg` is a generic gray placeholder — swap it for your own photo (same 2.6cm-wide aspect works well) or drop `\photoheader` entirely in favor of `\headerNoPhoto`.
- **Fonts**:
  - **Latin**: `my-resume.cls` sets **Arimo** (a metric-compatible Arial clone) via `\setmainfont{Arimo}` — swap for `\setmainfont{Arial}` if you have real Arial installed.
  - **CJK**: `my-resume-zh.sty` uses **HarmonyOS Sans SC** (Huawei's free-for-commercial-use font, see `fonts/HARMONYOS_SANS_LICENSE.txt`) as a Microsoft-YaHei-style substitute — chosen because it's explicitly licensed for free embedding/redistribution, unlike YaHei itself. Font files (Regular + Bold only) are bundled in `fonts/` and loaded by relative path, so no system font installation is required to compile. If you have a legitimately licensed `msyh.ttc`, swap the family name in `my-resume-zh.sty` for `Microsoft YaHei` instead.

## Template usage

Start a new tailored CV as a new `.tex` file, copying the preamble from `example_en.tex`/`example_zh.tex`:

```latex
% English
\documentclass{my-resume}
\usepackage{linespacing_fix}
\usepackage{cite}
\begin{document}
...
```

```latex
% Chinese — add my-resume-zh after the class
\documentclass{my-resume}
\usepackage{my-resume-zh}
\usepackage{linespacing_fix}
\usepackage{cite}
\begin{document}
...
```

`my-resume.cls`/`my-resume-zh.sty` are self-contained; just run `xelatex <file>.tex` from the same directory as the class files (or copy the whole `template/` folder as the base for each new CV project and pass `TEXINPUTS=".:../template//:"` if you keep tailored versions in sibling folders instead).

### Command cheat-sheet (from `my-resume.cls`)

| Command | Args | Use |
|---|---|---|
| `\photoheader{content}{photofile}{width}` | 3 | Header block: `content` (typically `\name{}` + `\contactInfo{}`) on the left, ID photo on the right at `width` (e.g. `2.6cm`) — both blocks use `minipage[c]` so they're **vertically centered** relative to each other. **Chinese CVs only** — see `\headerNoPhoto` below for English |
| `\headerNoPhoto{content}` | 1 | Same header, no photo — `content` rendered full-width. **Use for every English CV** — a photo isn't customary on English-language/Western-market CVs, so English versions drop it while Chinese versions keep `\photoheader`. Same `content` argument as `\photoheader`'s first argument |
| `\name{name}` | 1 | Big bold name, left-aligned (used inside `\photoheader`/`\headerNoPhoto`) |
| `\contactInfo{phone}{email}{location}{tagline}` | 4 | Row 1: dot-free phone/email pair. Location (arg 3) and tagline (arg 4) each render on their own full-width line below — not side by side, that reads cramped once the tagline gets long. **Location convention**: prefix arg 3 with a label, e.g. `现居城市：上海` (ZH) / `Based in: Shanghai` (EN). Args 3–4 optional (blank line if empty) |
| `\section{title}` | 1 | Bold section heading + rule (e.g. "Education", "Research \& Project Experience") |
| `\entry{org/title}{date}{role/subtitle}{location}` | 4 | **The workhorse command for every entry.** **One line**: bold org/title + role/subtitle on the left, location + date on the right. Wrap-safe (`tabularx`): if the combined left-hand text is long, it wraps to a second line rather than jamming into the date. Any arg may be empty (e.g. `{}` for no location) — **in Education/Internship entries, put the degree/role+department in arg 3**; **in Research \& Project Experience entries, leave arg 3 empty and follow with `\role{tools}{}` on its own line instead** (see next row). Arg 3 (role/subtitle) renders at `\fontsize{11.5}{14}\selectfont` — a modest step above the 11pt body text |
| `\role{tools}{}` | 2 | Used **only in Research \& Project Experience**, directly below an `\entry` whose 3rd arg was left empty — puts the tools/methods list on its own italic line under the project title, rather than crammed onto the entry's single line |
| `itemize` (via `enumitem`) | — | 1–3 bullets per entry below `\entry`, each starting with `\textbf{Lead-in}: ...` (see Writing-style rule 4 below), `parsep=0.2ex` for tight spacing. Global `topsep=0pt`/`partopsep=0pt` keeps every list tight against its `\entry`/`\role` header — **except** the Skills section, which needs its own explicit `\entrySkillsSep` (see next row) since it has no `\entry` above it to naturally create breathing room |
| `\entrySkillsSep` | 0 | Place directly after `\section{Skills \& Other}` / `\section{技能/其他}`, before the `itemize` begins — adds back the gap the global tight `topsep` removes, since the Skills list sits right under a bare section heading rather than under an `\entry`/`\role` line. **Every Skills section in every CV must have this** or its first bullet will look jammed against the heading |
| `\datedsection{title}{date}` / `\datedsubsection{title}{date}` / `\datedline{text}{date}` | 2 each | Legacy plain `\hfill`-based commands, kept for backward compatibility only — **avoid for new content**, see the wrap bug below. Prefer `\entry`. |

**Known bug avoided by `\entry`**: `\datedsubsection`/`\datedline` use a plain `text \hfill date` pattern, which only right-aligns correctly if `text` fits on one line — if it wraps, the date gets jammed against the last word with no space (e.g. "SomeCity2025.03"). `\entry` fixes this with a `tabularx` layout (auto-wrapping left column + fixed right column), so long titles wrap safely with the date/location always cleanly separated and right-aligned.

**Hyphenation / overfull-hbox note**: `my-resume.cls` loads `babel[english]` for hyphenation, but slash-joined compound terms (e.g. `React/TypeScript`, `Python/FastAPI`) still don't get a break point at the `/` by default — English hyphenation only inserts breaks within letter sequences, not around punctuation. If a bullet containing a `/`-joined term causes a large overfull `\hbox` (check the compile log), replace `/` with `\slash` in that specific term (e.g. `Python\slash FastAPI`) rather than rewording the whole bullet.

## Writing-style rules

1. **STAR structure per bullet**: situation/task (what question or problem), action (method + named tools/software), result (quantified outcome or grade/distinction). Not every bullet needs all three, but the strongest lead bullet of an entry should.
2. **Reverse-chronological order** everywhere — most recent/relevant first. When tailoring, the JD's most relevant experience should also physically lead its section, even if not the most recent, but don't break date order within a section — instead choose *which* experiences to include, not reorder them out of sequence.
3. **Bold** org/institution names in `\entry`'s first argument, and standout numbers/superlatives (award tiers, top percentiles) inside bullets. Reserve bold for genuinely impressive, verifiable facts.
4. **Every bullet must start with a bold lead-in phrase + colon** summarizing that bullet's point, e.g. `\item \textbf{Pipeline Design}: Designed and built a reproducible...` — this gives each bullet an immediate "headline" instead of making the reader parse the whole sentence to find the point. Keep the lead-in to 1-3 words. Vary lead-ins across a single entry's bullets (don't repeat the same word).
5. **1–3 bullets per entry.** More bullets ⇒ trim to the most relevant + best quantified for the target job, don't just shorten each bullet.
6. Skills section: **group under bold category labels** (e.g. `\textbf{Category}: item, item, item`), don't list flat.
7. Lead the Summary paragraph with the single strongest, most job-relevant credential first — this is the one paragraph an employer skims for 5 seconds.
8. **Chinese line-wrap check**: after compiling a Chinese CV, visually check for a lone single character stranded alone on its own line (不要让一个字单独成一行) — CJK justification can produce this on long paragraphs. If spotted, reword slightly (add/remove a character) rather than leaving it, since a single trailing character reads as a typesetting mistake.
9. **Never fabricate an experience, number, or credential.** If something can't be verified against a real source the user has confirmed, either leave it out or ask the user directly — a gap in the CV is always safer than a made-up entry, and a fabricated line that later gets asked about in an interview is a much bigger problem than an under-filled page.

### Personal Summary formula (个人总结)

For every job-tailored CV, the Summary must be **freshly written for that JD** — never copy-pasted from the master CV or reused verbatim across applications. Formula: **identity/positioning + 2-3 core skills matched to the JD + one standout quantified achievement + motivation/fit for this specific role**.

- **Hard cap: 3-4 lines.** An HR reader spends ~30 seconds on this — it must be skimmable, not a full paragraph of every credential.
- **Data over adjectives.** Never write "认真负责/吃苦耐劳/性格开朗" (responsible/hardworking/outgoing) or their English equivalents ("hardworking," "team player," "detail-oriented") without a fact backing it up. Bad: "improved user engagement." Good: "grew followers 50% and article reads 80% in 3 months by planning online interactive campaigns."
- **Skills must match the JD's own keywords**, not a generic skills list.
- **Fresh-grad / limited-experience framing**: emphasize learning ability, potential, and transferable soft skills earned through coursework, club/society roles, or volunteering.
- **Experienced-candidate framing**: lead immediately with the strongest "ace card" — quantified experience + skills + results, tied directly to the target role.
- Never write one summary for every application — the whole point is precise JD matching.

### STAR + quantification bonus formula ("加分公式")

Applies to every bullet in every section, not just Projects:

- **STAR structure**: Situation/Task (the problem or context) → Action (method + named tools) → Result (quantified outcome).
- **Quantify the result, don't just state the task.** Don't write "负责什么" (was responsible for X) — write "做成了什么" (achieved X), with a number. Favor strong action verbs: 推动/优化/提升/缩短/对接 ("drove/optimized/improved/cut/coordinated with").
- **Mine campus/non-formal experience the same way** when a section is thin on real work experience — a vague task description earns nothing on a CV; a quantified scope does.

## Formatting rules baked into this template

- Preserve the existing template and its black text/rules; do not introduce new colours, typography, spacing or layout without a specific user request.
- Complete the fullest relevant one-page Chinese CV first, then translate it completely into English at the original template font sizes. English has no page limit; do not shorten either language for English pagination.

- **Vertical spacing is deliberately tight, between-block only** — line-wrap spacing within a single sentence/bullet (`\baselineskip`) is untouched at its normal value; what's compressed is the space *between* blocks: `\entry`'s leading gap (`0.6ex`), the gap from an `\entry`/`\role` line down to its own bullets (`0pt`, relies on the tight global itemize `topsep=0pt`/`partopsep=0pt`), and `\section` heading spacing (`\titlespacing*` at `*0.6`/`*0.4` of default). Don't loosen these back up without a specific reason — the tight spacing is what lets a 1-page CV hold this much real content.
- **Section rule thickness**: the horizontal rule under each section heading is `\titlerule[0.8pt]` (slightly thicker than titlesec's ~0.4pt default) — the `{\titlerule[0.8pt]}` must stay wrapped in its own braces inside `\titleformat`'s bracketed argument, or the inner `[0.8pt]` breaks the outer argument parsing (`! Argument of \ttl@rule@i has an extra }` if you get this wrong).
- **Always wrap a bare font-size command in its own `{...}` group** (e.g. `{\large #1}`, not `\large #1`) inside any macro that isn't itself already a self-contained group — `\large`/`\fontsize{}{}\selectfont`/etc. have no inherent scope and will silently leak into every paragraph that follows if the enclosing braces are only TeX argument-grabbing delimiters (as in `\ifthenelse{...}{...}` branches or plain macro bodies) rather than a real group. This bit twice during development of this template: `\contactInfo`'s `\large` fields leaked (12pt) into the *entire rest of the document* after the header, and `\entry`'s subtitle `\fontsize{11.5}{14}\selectfont` leaked into every following bullet — both showed up only as small "Overfull \hbox" warnings in the compile log (a few pt each), never as an obvious visual jump, so they're easy to miss without checking the log's reported font size (`.../12` instead of the expected `.../10.95`). If you add a new font-size tweak anywhere in `my-resume.cls`, brace it the same way.
- **Header**: name + contact block on the left, ID photo on the right at 2.6cm width, **vertically centered** relative to each other via `\photoheader` (both sides use `minipage[c]`) — **Chinese CVs only**. **English CVs use `\headerNoPhoto` instead — no photo, full-width name/contact block**. Contact info is a dot-free 2×2 grid (phone/email, location/tagline) — no separators between the four fields; if a separator is needed *within* a single field, use `\textbar` (|), not a dot.
- **Education/Internship entries are a single line** via `\entry{org/title}{date}{role/subtitle}{location}`. **Research \& Project Experience entries instead leave `\entry`'s 3rd arg empty and put the tools/methods list on its own line via `\role{tools}{}` right below** — project titles are usually already long, so cramming the tools list onto the same line gets visually cramped.
- **Every bullet opens with a bold lead-in + colon** (see Writing-style rule 4).
- **Skills section must be filtered by role relevance, not dumped in full**: a job-tailored CV should drop entire categories that don't serve the target role, not trim within them — keep only the categories the JD would actually care about, reordered so the most relevant leads.
- **Never add a skill to the CV without verified evidence.** The Skills section must reflect what's actually demonstrated in your real content bank / project code, not a generic "impressive skills" list.

## Content bank

Build your own content bank here — one entry per project/experience, in the same shape as the fictional examples below. `Fit tags` are for quick JD matching (pick your own vocabulary, e.g. quant/stats, wet-lab, bioinformatics, field-work, software, literature-review, modelling). `Private` lines are for triage only — e.g. grades or sensitive scores that should never be printed on the actual CV; translate strong ones into "distinction"/"high marks" language and omit mention of grade for average-scoring work.

**This section is deliberately just a format example, not real content.** Replace it with your own verified experiences before using this template for a real application.

---

### 0. [Project/role title] (start–end date, location)

**Fit tags**: e.g. software, quant/stats
- One bullet per key contribution, written in the STAR + bold-lead-in style above
- Include real, verifiable numbers where you have them
- **Private**: any triage notes for yourself (grade, confidentiality caveats, etc.) — never copied onto the CV itself

### 1. [Another project/role title] (start–end date, location)

**Fit tags**: ...
- ...
- **Private**: ...

---

## Tailoring workflow (for "make me a CV for job X" requests)

**The 1-page cap applies to the Chinese version only** (if you're building a bilingual set) — job-tailored English CVs are not forced to 1 page; if fuller bullets push it to 1.5–2 pages, leave it. The master CV is exempt from any page cap either way — it's the full content pool, not something to hand to an employer as-is.

**Job-tailored direction CVs omit the Personal Summary section entirely** (master CV keeps it). The space that would've gone to Summary goes into fuller, STAR-structured bullets instead.

1. Parse the JD for its explicit required/preferred skills and domain.
2. Filter your content bank by `Fit tags`. **Don't under-fill the page** — a 1-page CV with real content-bank depth to draw from should read as full, not sparse. Select internships and projects by direct relevance and verified evidence for the target role. Formal internship status alone never makes an entry mandatory. Omit weakly related entries and empty sections from tailored CVs; retain them in the master/content bank. Prioritise substantiated relevant project detail over generic transferable-skill claims; never recast teaching feedback as product user research or laboratory QC as LLM evaluation.
3. Write a fresh Summary using the **Personal Summary formula** above — but only for the **master CV**; skip this step for job-tailored direction CVs.
4. Write fresh bullets per the house style above (STAR, bold org/numbers, bold lead-in + colon on every bullet, 1–3 bullets) — use the master CV's bullet depth as the baseline, adjusting wording/emphasis toward the JD's skills rather than shrinking the content.
5. Filter and reorder the Skills section by role relevance — filter by whole category, not by trimming within one.
6. Compile with `xelatex`, confirm the Chinese version's page count is exactly **1 page** (English unconstrained), and visually inspect the rendered PDF for: overfull-hbox spillover (check for `/`-joined compound terms needing `\slash`), and (for Chinese) any single stranded character at a line end.
7. **Check the rendered page for leftover white space at the bottom — every time the CV is regenerated or edited, not just on first creation.** Estimate the gap as a fraction of the page:
   - **Large gap (roughly a quarter page or more)**: add another content-bank entry, picked by `Fit tags` overlap with the direction.
   - **Small gap**: don't add a whole new entry — expand existing bullets with more STAR detail, or restore a bullet that was trimmed down.
   - **No gap / page is tight**: leave it — don't force content in past the point where it reads padded.
8. **Save location**: create or reuse an employer/position folder inside the existing `cv/` root; match sibling folders. If PDF and TeX are requested for Chinese, English and the merged version, deliver all six files (the merged TeX includes the two language PDFs).

   **Filenames**: pick a convention and stay consistent, e.g. `<Name>_<Direction>_<Language>.tex/.pdf` for tailored versions (short, filesystem-safe direction label, no `/`), and plain `<Name>_<Language>.tex/.pdf` for the master CV (no direction label — it isn't tailored to one).
9. **If you want a merged bilingual PDF per direction**: concatenate with `pdfunite <name>_<direction>_zh.pdf <name>_<direction>_en.pdf <name>_<direction>_merged.pdf` (page concatenation; also create a TeX wrapper when requested). **Regenerate this after any edit to either language's `.tex`/`.pdf`** — it goes stale silently otherwise since it isn't compiled from source.
