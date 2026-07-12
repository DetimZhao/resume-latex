# Resume Repository

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Detim Zhao's resume — LaTeX source compiled to PDF via GitHub Actions.

## Latest Resume
**Download**: **[Detim_Zhao_Resume.pdf](https://github.com/DetimZhao/resume-latex/releases/latest/download/Detim_Zhao_Resume.pdf)**

---

## Using This Template

If you're forking this repo to build your own resume:

### Repo Setup

1. In `.github/workflows/build.yml`, change `BASE_NAME: Detim_Zhao_Resume` to your name
2. In this README:
   - replace `DetimZhao/resume-latex` in the badge and download link with your own repo
   - update the title ("Detim Zhao's resume") and tailorable contact links

### Resume Content

3. Edit `src/heading.tex` — your name, email, LinkedIn, GitHub URLs
4. Edit `src/education.tex` — your school, degree, GPA
5. Edit `src/experience.tex` — your work history. Use `src-master/experience.tex` as full inventory for tailoring
6. Edit `src/projects.tex` — your projects. Use `src-master/projects.tex` as full inventory
7. Edit `src/skills.tex` — your languages, libraries, tools, domains
8. (Optional) Clear `archive/` and update `VERSIONS.md`

## Quick Start

### Prerequisites
- [Docker](https://www.docker.com/products/docker-desktop/)
- [VSCode](https://code.visualstudio.com/) with [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

### Open in Dev Container
1. Open this folder in VSCode
2. Open the Command Palette (`Cmd+Shift+P` on Mac / `Ctrl+Shift+P` on Windows/Linux / `F1`) and run "Dev Containers: Rebuild and Reopen in Container"
3. Wait for container to build (first time only, ~2 min)

### Local Development
```bash
# Canonical build
latexmk -pdf -jobname=Detim_Zhao_Resume -outdir=build resume.tex

# Or use VSCode: Ctrl+Alt+B (LaTeX Workshop build)
```

### Live Preview
- PDF opens in a tab next to your `.tex` file
- Updates automatically on save (Ctrl+S)
- Ctrl+Click in PDF → jumps to source

## Tailoring for a Job

Use an AI coding agent (e.g. Claude Code, opencode, Codex CLI) to tailor the resume for a specific job description. See [AGENTS.md](AGENTS.md) for the full workflow — it handles content selection, compilation, and 1-page enforcement without touching `src/` or git.

## CI/CD

### On Push to `main`
- Compiles → creates Release with `Detim_Zhao_Resume.pdf` + `Detim_Zhao_Resume-YYYYMMDD-HHMM.pdf`
- Latest release always at `github.com/DetimZhao/resume-latex/releases/latest`

### On Pull Request
- Compiles → uploads artifact `resume-preview`
- Download from Actions → Artifacts

### Manual Dispatch
- Actions → "Build Resume PDF" → "Run workflow"
- Enter `company` and `role` → tagged PDF uploaded as artifact
- `main` untouched

## Project Structure

```txt
.
├── resume.tex              # Main document → \input{src/...}
├── custom-commands.tex     # \newcommand macros
├── LICENSE                 # MIT
├── src/                    # Canonical (1-page), curated for general use
│   ├── heading.tex
│   ├── education.tex
│   ├── skills.tex
│   ├── experience.tex
│   └── projects.tex
├── src-master/             # Full inventory — agent selects from here
│   ├── experience.tex      # ALL real roles and bullets
│   └── projects.tex        # ALL real projects, unfiltered
├── build/                  # Canonical build artifacts (gitignored)
├── tailored/               # Tailored build artifacts (gitignored)
├── archive/                # Historical PDFs
├── VERSIONS.md             # Version log
├── AGENTS.md               # Instructions for AI coding agents
├── .devcontainer/          # VS Code Dev Container
└── .github/workflows/      # CI: push → compile → Release
```

## Archive

Old resume PDFs live in `archive/`. See [VERSIONS.md](VERSIONS.md) for the full changelog.

## Useful Commands

```bash
# Clean aux files (keeps PDF)
latexmk -c -outdir=build

# Full clean (removes PDF too)
latexmk -C -outdir=build

# Check page count
pdfinfo build/Detim_Zhao_Resume.pdf | grep Pages

# Clean up all tailored builds
rm -rf tailored/

# Delete all tailoring branches
git branch | grep tailored | xargs git branch -D
```