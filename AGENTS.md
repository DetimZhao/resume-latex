# AGENTS.md

## Project Overview

This is **Detim Zhao's resume** — a LaTeX source repository that compiles to PDF via GitHub Actions.
The canonical source lives here. The compiled PDF is published as a GitHub Release on push to `main`.

- **Repo**: public, `detimzhao/resume-latex`
- **Visibility**: public — the source, commit history, and compiled PDFs are all publicly accessible. No secrets are stored here.
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
  experience.tex        # Work history — curated subset for 1-page target
  projects.tex          # Personal/academic projects — curated subset
src-master/
  experience.tex        # ALL real roles and bullets — full inventory
  projects.tex          # ALL real projects — full inventory, unfiltered
archive/                # Historical PDFs (manual, not compiled)
build/                  # Build artifacts (gitignored)
.devcontainer/          # VS Code Dev Container (texlive + latexmk)
.github/workflows/      # CI: push → compile → Release
AGENTS.md               # This file
README.md               # Human-facing documentation
VERSIONS.md             # Version changelog
```

## Build Commands

### Local (Docker — recommended, same image as CI)
```bash
# Compile
docker run --rm -v "$PWD":/workspace -w /workspace texlive/texlive:latest \
  latexmk -pdf -jobname=Detim_Zhao_Resume -outdir=build resume.tex

# Clean aux files
docker run --rm -v "$PWD":/workspace -w /workspace texlive/texlive:latest \
  latexmk -c -outdir=build

# Full clean (removes PDF too)
docker run --rm -v "$PWD":/workspace -w /workspace texlive/texlive:latest \
  latexmk -C -outdir=build
```
Note: macOS MacTeX Basic lacks `latexmk` and some packages (e.g. `fontawesome5`). Use Docker above or the Dev Container.

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
- **Environment variable**: `BASE_NAME: Detim_Zhao_Resume` controls output filename

## Safe Editing for Agents

When editing `.tex` source files (experience, projects, skills, etc.), follow these rules to
avoid corrupting the document:

### Targeted Edits (Always Preferred)
- **Find-and-replace a unique, verbatim string** in the file
- The `search` string must match **exactly once** (whitespace, line endings, all characters)
- If 0 matches → the content may have changed; re-read the file and try again
- If >1 matches → include more surrounding context lines to disambiguate
- Prefer this for small changes: wording, a bullet point, a date, a number

### Full Rewrites (Use Sparingly)
- Replace the **entire file** only for the first draft or large reorganizations
- Always output a complete, valid, compilable `.tex` fragment (matching the surrounding
  file's command conventions — see [LaTeX Conventions](#latex-conventions))
- Only use `\resumeItem`, `\resumeSubheading`, etc. — do not invent new macros

### Post-Edit Validation
- After any edit, re-read the file to confirm the change was applied correctly
- Verify balanced braces, `\begin`/`\end` pairs, and correct macro usage

---

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
- **Can web-search the company** to learn about their tech stack, recent engineering
  blog posts, or product context — helps match keywords in bullets
- **Can surface commented-out content** (`% \resumeItem{...}`) if it fits the role
- **Can pull additional content from `src-master/`** — the full inventory of all real experience and projects

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
- Leave as-is

### Tailoring Workflow (Local, via AI agent)

Tailoring uses a `_build/` sandbox — `src/`, git, and `main` are never touched:

1. Agent sets up the sandbox:
   ```bash
   mkdir -p _build/src
   cp resume.tex custom-commands.tex _build/
   cp src/heading.tex src/education.tex src/skills.tex _build/src/
   ```

1b. Agent snapshots current source state for revision tracking:
    ```bash
    mkdir -p revisions
    TS=$(date +%Y%m%d-%H%M)
    cp -r src/ "revisions/$TS-before/"
    ```

2. Agent reads `src-master/` (full inventory) + JD, then writes tailored content into `_build/src/`:
   - `_build/src/experience.tex` — selects and rewrites experience from `src-master/experience.tex`
   - `_build/src/projects.tex` — selects and rewrites projects from `src-master/projects.tex`
   - `_build/src/skills.tex` — optionally reorders skills to match JD keywords

3. Agent compiles from inside `_build/` (so `\input{src/...}` resolves to sandboxed copies).
   **Important**: mount the repo root (not just `_build/`) so `../tailored/` is on the host filesystem:
   ```bash
   docker run --rm -v "$PWD":/workspace -w /workspace/_build texlive/texlive:latest \
     latexmk -pdf -jobname=Detim_Zhao_Resume-<Company>-<Role> -outdir=../tailored resume.tex
   ```

4. Agent checks page count:
   ```bash
   pdfinfo tailored/Detim_Zhao_Resume-*.pdf | grep Pages
   ```
   If >1 page: drop or condense content in `_build/src/`, recompile. Repeat until 1 page.

5. Agent cleans aux files (keeps PDF only):
   ```bash
   latexmk -c -outdir=tailored
   find tailored -type f ! -name '*.pdf' -delete
   ```

6. You review `tailored/Detim_Zhao_Resume-Google-PlatformEngineer.pdf`

6b. Agent snapshots tailored state and saves job description:
    ```bash
    cp -r _build/src/ "revisions/$TS-after/"
    cp job_description.txt tailored/ 2>/dev/null || true
    ```

7. If changes needed: agent edits `_build/src/*.tex`, recompiles, checks pages again

8. When done, agent cleans up:
   ```bash
   rm -rf _build
   ```
   No git operations needed. `src/` and `main` are untouched.

If you want to **keep** a tailored PDF permanently, trigger the CI dispatch (next section).

### Tailoring Workflow (CI, via workflow_dispatch)

Go to Actions → "Build Resume PDF" → "Run workflow":
- Fill in `company` and `role` (optional, sets PDF filename)
- Optionally paste `job_description` (for future agent-based editing)
- CI compiles → uploads artifact named `Detim_Zhao_Resume-<Company>-<Role>.pdf`
- `main` stays untouched, no release created

### Constraints
- **1-page target**: if additions push to 2 pages, drop or compress less relevant content
- **ATS-friendly**: keep plain text, avoid images/special characters
- **Truthful**: every skill and achievement must be real

## Owner Preferences

These are Detim Zhao's personal preferences for how the resume is managed. AI agents tailoring this resume should follow these:

- **No relevant coursework**: Detim is a recent graduate with internship experience — relevant coursework is unnecessary and should never be included in `src/education.tex`.

## CI/CD Behavior

- `.github/workflows/build.yml` controls everything
- `BASE_NAME: Detim_Zhao_Resume` env var sets the base output filename
- **On push to `main`**: compile, create Release with `Detim_Zhao_Resume.pdf` + dated copy, tag = `vYYYYMMDD-HHMM`
- **On pull_request**: compile, upload preview artifact (no release)
- **On workflow_dispatch**:
  - With `company`/`role`: compile to `Detim_Zhao_Resume-<Company>-<Role>.pdf`, upload as artifact
  - Without: same as canonical build, artifact only
- Releases use `softprops/action-gh-release@v2` with `make_latest: true`

## Commit Conventions

| Prefix | Purpose | Example |
|--------|---------|---------|
| `update:` | Manual content edits to resume source | `update: fix LANL internship end date` |
| `feat:` | New features or capabilities | `feat: add 1-page enforcement to CI` |
| `fix:` | Bug fixes | `fix: resume.tex not found in CI` |
| `docs:` | Documentation (README, AGENTS, VERSIONS) | `docs: add tailoring guide to AGENTS` |
| `chore:` | Config, CI, cleanup, tooling | `chore: switch to texlive/texlive image` |

The `_build/` sandbox never commits — agent changes are always ephemeral. No `tailor:` prefix needed.

## Do's and Don'ts

- **DO** reorder items within sections to match JD priority
- **DO** reword existing bullets with JD keywords
- **DO** uncomment archived content if it matches
- **DO** use targeted find-and-replace for small edits — not full file rewrites
- **DO** compile after every edit to verify
- **DO NOT** invent new experience, skills, or project details
- **DO NOT** change the section ordering in `resume.tex`
- **DO NOT** modify `custom-commands.tex` — macros are stable
- **DO NOT** commit build artifacts (they're gitignored)
- **DO NOT** create new `.tex` files in `src/` — use existing files only
- **DO NOT** rewrite entire files for minor changes — use find-and-replace