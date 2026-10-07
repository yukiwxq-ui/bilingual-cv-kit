---
name: bilingual-cv-kit
description: Build and maintain a bilingual (Chinese/English) LaTeX CV system — one master full-experience CV plus several job-tailored CVs (Chinese one page; English complete translation without a page cap) — from a shared template with a reusable content bank and tailoring workflow. Use when the user asks to build a CV/resume in this style, tailor a CV for a specific job direction, add a project/experience to a CV, adjust CV layout/font size/spacing, or generate a merged Chinese+English PDF, in any project that uses (or should use) this template.
---

# Bilingual CV Kit

## What this skill does

Maintains a bilingual (中/英) LaTeX CV system: one master CV with every experience (no page limit), plus job-direction-tailored versions capped at 1 page (Chinese) built by filtering a personal "content bank" of verified experiences through a repeatable tailoring workflow.

## Preserve the established CV system

- Read the existing project's personal `cv/template/CONTENT_NOTES.md` before editing; it overrides generic examples for that person's wording and preferences.
- Keep the established template, fonts, font sizes, spacing, section structure and colours. This kit's default is black text and black rules; a request to tailor or polish content is not permission to redesign it or add accent colours. Make only necessary portability fixes without changing the visual design.
- Finalise a substantive, information-rich one-page Chinese CV first. Translate its entire content into English, preserving every experience, qualification, tool, numerical result and caveat. English may span multiple pages. Never cut Chinese content, abbreviate English, or shrink English typography to force one page.
- For each new employer/position, create a folder within the user's existing `cv/`; for revisions, reuse that position's folder. Follow sibling naming conventions. Workspace/output copies are previews, not substitutes for saving to the requested CV project.
- Follow the user's requested deliverable set. When all three versions are requested as PDF and TeX, provide Chinese `.tex/.pdf`, English `.tex/.pdf`, and a merged bilingual `.tex/.pdf`. The merged TeX is a wrapper that includes the language PDFs in order, not duplicated resume content. Regenerate both language PDFs and the merged PDF after edits.

- Select internships and projects by direct relevance and verified evidence for the target role. Formal internship status alone never makes an entry mandatory. Omit weakly related entries and empty sections from tailored CVs; retain them in the master/content bank. Prioritise substantiated relevant project detail over generic transferable-skill claims; never recast teaching feedback as product user research or laboratory QC as LLM evaluation.

## First use in a new project

This skill ships a generic template with a **fictional example persona**, not the user's real CV. On first use in a project:

1. Ask the user where their CV project should live (or detect an existing one if the conversation references a path).
2. If it doesn't exist yet, copy `template/` (the `.cls`/`.sty`/`fonts/` files and `example_zh.tex`/`example_en.tex`) into that location as the starting point, then copy `CONTENT_NOTES.md` alongside it.
3. Work with the user to replace the example persona's placeholder content with their real name/contact info, and to build their real content bank in `CONTENT_NOTES.md`'s "Content bank" section — this must be **verified, real experience only** (see the anti-fabrication rule below), gathered from the user directly, not invented.
4. From then on, treat that project's copy of `CONTENT_NOTES.md` as the single source of truth for that user's content bank, writing rules, and file-naming conventions — it may diverge from this skill's shipped copy as the user's real content grows.

## Single source of truth

**`CONTENT_NOTES.md`** (shipped in this skill, then copied into the user's own CV project) is the authoritative document — command cheat-sheet for `my-resume.cls`, writing-style rules (STAR structure, bold lead-ins, anti-fabrication rule), the content-bank format, and the full tailoring workflow (steps 1-9).

**Read `CONTENT_NOTES.md` before making any content or formatting change.** This `SKILL.md` only adds the operational steps (compile/merge/verify commands) that aren't already in `CONTENT_NOTES.md` — don't duplicate content between the two, or they'll drift out of sync.

## File structure (once set up in a user's project)

```
cv/
├── template/                shared class/style files + fonts, copied from this skill
│   ├── my-resume.cls / my-resume-zh.sty / linespacing_fix.sty / fonts/
│   ├── CONTENT_NOTES.md     ← read this first, it's the user's real content bank
│   ├── <Name>_zh.tex / _en.tex   (+ compiled .pdf, + merged bilingual .pdf)
├── <job-direction-1>/        one folder per tailored direction
├── <job-direction-2>/
└── <new-direction>/           naming: <Name>_<Direction>_<Language>.tex, direction label has no "/"
```

## Compile

Chinese versions load `my-resume-zh.sty` (CJK), English versions don't. From inside a tailored-direction folder (sibling to `template/`):

```bash
TEXINPUTS=".:../template//:" xelatex -interaction=nonstopmode <Name>_<Direction>_zh.tex
TEXINPUTS=".:../template//:" xelatex -interaction=nonstopmode <Name>_<Direction>_en.tex
```

From inside `template/` itself, just `xelatex ...` (self-contained, no `TEXINPUTS` needed).

## Merge PDF (optional, per direction)

```bash
pdfunite <Name>_<Direction>_zh.pdf <Name>_<Direction>_en.pdf <Name>_<Direction>_merged.pdf
```

**Regenerate after every edit to either language version** — the merged PDF is plain page concatenation, not compiled from source, so it silently goes stale otherwise.

## Must-check after every change

1. The Chinese version must compile to exactly **1 page** for tailored (non-master) CVs; master is unconstrained.
2. No new `Overfull \hbox` warnings in the compile log beyond small pre-existing 1-5pt cosmetic ones (see the font-scope-leak pitfall below — a scope leak shows up first as a handful of small overfull warnings, easy to miss).
3. Open the rendered PDF and visually check:
   - Chinese: no lone single character stranded on its own line (单字不成行) — reword slightly if found.
   - Page fill: bottom whitespace ≥ roughly a quarter page → add a content-bank entry; smaller gap → expand existing bullets, don't pad with a whole new entry just to fill space; little/no gap → leave it.
   - No sign of an unexpectedly enlarged font size anywhere (e.g. a bullet's bold lead-in looking visibly bigger than the rest) — symptom of the scope-leak bug below.
4. Delete `.aux`/`.log`/`.out` build artifacts once you're done.

## Known pitfalls (don't relearn these)

- **A bare `\large` / `\fontsize{}{}\selectfont` leaks its scope.** If it's not wrapped in its own `{...}` brace group, the size setting silently continues into every paragraph that follows — `\ifthenelse{...}{...}` branches and plain macro bodies do **not** create a real TeX group. This bug quietly inflated font size across an entire document in this template's own development, showing up only as a handful of small "Overfull \hbox" warnings, not an obvious visual jump. Always write `{\large ...}`, never bare `\large ...`.
- **`\titlerule[Npt]` inside `\titleformat`'s bracketed argument needs an extra brace group**: `[{\titlerule[0.8pt]}]` — otherwise the inner `[0.8pt]` breaks the outer argument parsing, producing `! Argument of \ttl@rule@i has an extra }`.
- **Never fabricate an experience or a number.** Every line on the CV must trace back to something the user has confirmed is real. If it can't be verified, leave it out or ask — don't invent plausible-sounding detail to fill space.

## When asked to build a CV for a new job direction

Follow the "Tailoring workflow" section in `CONTENT_NOTES.md` end to end: parse the JD's keywords → filter the content bank by fit tags → skip the Personal Summary in tailored versions (master only) → write bullets per the STAR + quantification formula → filter the Skills section by whole category → compile and verify → check page fill → generate the requested bilingual PDF and, when requested, its TeX wrapper.

## Evidence-backed outcomes and JD alignment

Write concrete, evidence-backed outcomes, not vague benefit claims. Prefer verified numbers for scope, adoption, quality and measured impact, with the sample/evaluation setting and a baseline when claiming improvement. Distinguish activity counts and team usage from personal impact; never invent percentages, savings, users or causal gains. Where no impact metric exists, state the delivered capability and observed use explicitly, preserving limitations. Map each selected bullet to an actual JD requirement; record unsupported requirements instead of keyword-stuffing.
