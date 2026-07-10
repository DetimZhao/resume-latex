# AGENTS.md

## Project Overview

This is **Detim Zhao's resume** — a LaTeX source repository that compiles to PDF via GitHub Actions.
The canonical source lives here. The compiled PDF is published as a GitHub Release on push to `main`.

- **Repo**: private, `detimzhao/resume-latex`
- **Template origin**: https://github.com/sb2nov/resume (`article` class, `\resumeItem`, `\resumeSubheading`, etc.)
- **Language**: LaTeX with custom macros in `custom-commands.tex`
- **Build**: `latexmk -pdf -jobname=Detim_Zhao_Resume -outdir=build resume.tex`

## Directory Structure

```
resume.tex              # Main document — preamble, \begin{document}, \input{src/...}
custom-commands.tex     # \newcommand macros (\resumeItem, \resumeSubheading, etc.)
src/
  heading.tex           # Name, email, LinkedIn, GitHub links
  education.tex         # University, degree, GPA, honors
  skills.tex            # Languages, libraries, tools, domains
  experience.tex        # Work history (reverse chronological, most recent first)
  projects.tex          # Personal/academic projects
archive/                # Historical PDFs (manual, not compiled)
build/                  # Build artifacts (gitignored)
.devcontainer/          # VS Code Dev Container (texlive + latexmk)
.github/workflows/      # CI: push → compile → Release
AGENTS.md               # This file
README.md               # Human-facing documentation
VERSIONS.md             # Version changelog
```

## Build Commands

### Local (Dev Container)
```bash
latexmk -pdf -jobname=Detim_Zhao_Resume -outdir=build resume.tex
latexmk -c -outdir=build          # Clean aux files
latexmk -C -outdir=build          # Full clean (removes PDF too)
```

### CI (GitHub Actions)
- **On push to `main`**: compiles → creates Release with `Detim_Zhao_Resume.pdf` + `Detim_Zhao_Resume-YYYYMMDD-HHMM.pdf`
- **On PR**: compiles → uploads artifact (preview only, no release)
- **`workflow_dispatch`**: manual trigger (for future agent-driven tailoring)
- **Environment variable**: `RESUME_NAME: Detim_Zhao_Resume` controls output filename

## LaTeX Conventions

### Custom Commands (defined in `custom-commands.tex`)

| Command | Purpose |
|---------|---------|
| `\resumeItem{text}` | Bullet point in any list |
| `\resumeSubItem{text}` | Sub-bullet (smaller indent) |
| `\resumeSubheading{title}{dates}{subtitle}{location}` | Section header (experience, education) — 4 args, tabular layout |
| `\resumeSubSubheading{left}{right}` | Sub-entry without bold title |
| `\resumeProjectHeading{title}{extra}` | Project header — 2 args |
| `\resumeSubHeadingListStart` / `\resumeSubHeadingListEnd` | Wrap experience/education entries |
| `\resumeItemListStart` / `\resumeItemListEnd` | Wrap bullet lists |
| `\resumeSubheading` format | `{**Role**}{Date}` then `{*Company/Context*}{*Location*}` |

### Section Order (in `resume.tex`)
1. Heading
2. Education
3. Skills
4. Experience
5. Projects

## Tailoring the Resume for a Role

When asked to tailor the resume for a specific job description (JD):

### Principles
- **Never fabricate experience, skills, or achievements**
- **Reorder, reword, emphasize, de-emphasize** — don't invent
- **Keep the same section order** unless instructed otherwise
- **Match keywords from the JD** using existing content
- **Can surface commented-out content** (`% \resumeItem{...}`) if it fits the role

### Per-Section Tailoring Guide

#### `src/heading.tex`
- Usually leave as-is (name, contact, links)
- Could add a title line or summary if JD demands it (e.g., "Software Engineer | HPC & Distributed Systems")

#### `src/skills.tex`
- **Reorder categories** so most relevant come first
- **Reorder items within categories** to highlight JD-matching skills
- **Add/remove items** only if you genuinely have the skill and it exists elsewhere in the resume
- Lines end with `\\` — keep them aligned

#### `src/experience.tex`
- **Reorder bullet points** within each role: most relevant to JD first
- **Reword bullets** to match JD keywords (e.g., "built pipeline" → "developed CI/CD pipeline" if JD uses that term)
- **Can adjust emphasis** — expand relevant bullets, compress or drop less relevant ones
- **Uncomment role stubs** if you have prior experience that matches (the file has commented-out `\resumeSubheading` blocks and `\resumeItem` bullets)
- Roles are reverse chronological. Do NOT reorder roles.

#### `src/projects.tex`
- **Reorder projects**: most JD-relevant first
- **Uncomment archived projects** (commented `\resumeProjectHeading` blocks exist) if they match the JD
- **Reword bullets** to match JD terminology
- **Can drop projects** that don't match by commenting them out

#### `src/education.tex`
- Usually leave as-is
- Can uncomment `\resumeItem{\textbf{Relevant Coursework:} ...}` line (currently commented out) and update courses to match JD

### Tailoring Workflow

1. Read the JD and extract key keywords, technologies, and domain requirements
2. Read `src/skills.tex` — match skills to JD, reorder/emphasize
3. Read `src/experience.tex` — reword bullets with JD keywords, reorder, consider uncommenting
4. Read `src/projects.tex` — reorder, reword, consider uncommenting
5. Read `src/education.tex` — optionally activate relevant coursework
6. Compile: `latexmk -pdf -jobname=Detim_Zhao_Resume -outdir=build resume.tex`
7. Verify: `ls build/Detim_Zhao_Resume.pdf` — check page count (target 1 page)

### Constraints
- **1-page target**: if additions push to 2 pages, drop or compress less relevant content
- **ATS-friendly**: keep plain text, avoid images/special characters
- **Truthful**: every skill and achievement must be real

## CI/CD Behavior

- `.github/workflows/build.yml` controls everything
- `RESUME_NAME` env var sets the output filename
- On push to `main`: release tag = `vYYYYMMDD-HHMM`, 2 assets uploaded
- PRs: artifact only, no release
- Releases use `softprops/action-gh-release@v2` with `make_latest: true`

## Do's and Don'ts

- **DO** reorder items within sections to match JD priority
- **DO** reword existing bullets with JD keywords
- **DO** uncomment archived content if it matches
- **DO** compile after every edit to verify
- **DO NOT** invent new experience, skills, or project details
- **DO NOT** change the section ordering in `resume.tex`
- **DO NOT** modify `custom-commands.tex` — macros are stable
- **DO NOT** commit build artifacts (they're gitignored)
- **DO NOT** create new `.tex` files in `src/` — use existing files only