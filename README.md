# Resume Repository

Local LaTeX resume with VSCode Dev Container (Overleaf-like experience) and GitHub Actions CI.

## Quick Start

### Prerequisites
- [Docker](https://www.docker.com/products/docker-desktop/)
- [VSCode](https://code.visualstudio.com/) with [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

### Open in Dev Container
1. Open this folder in VSCode
2. Press `F1` → "Dev Containers: Reopen in Container"
3. Wait for container to build (first time only)

### Local Development
```bash
# Inside devcontainer terminal
latexmk -pdf -outdir=build resume.tex

# Or use VSCode: Ctrl+Alt+B (LaTeX Workshop build)
```

### Live Preview
- PDF opens in a tab next to your `.tex` file
- Updates automatically on save (Ctrl+S)
- Sync: Ctrl+Click in PDF → jumps to source

## CI/CD

### On Push to `main`
- GitHub Action compiles `resume.pdf`
- Creates Release with:
  - `resume.pdf` (always latest)
  - `resume-YYYYMMDD.pdf` (dated archive)

### On Pull Request
- Builds PDF as artifact (`resume-preview`)
- Download from Actions → Artifacts

### Manual Trigger (future: agent)
```bash
gh workflow run build.yml -f job_description="..." -f target_company="..."
```

## Project Structure

```
.
├── resume.tex              # Main file (inputs from src/)
├── custom-commands.tex     # Personal macros
├── src/
│   ├── heading.tex
│   ├── education.tex
│   ├── skills.tex
│   ├── experience.tex
│   └── projects.tex
├── archive/                # Your old PDFs (manual)
│   ├── resume-2024-01-15.pdf
│   └── resume-2024-06-20.pdf
├── VERSIONS.md             # Version log (manual)
├── .devcontainer/          # Dev Container config
└── .github/workflows/      # CI
```

## Archive Old Versions

1. Place PDFs in `archive/`
2. Update `VERSIONS.md` with date/tag/notes
3. Commit and push

## Useful Commands

```bash
# Clean build artifacts
latexmk -c -outdir=build

# Full clean
latexmk -C -outdir=build

# View PDF in browser (from devcontainer)
open build/resume.pdf  # macOS
xdg-open build/resume.pdf  # Linux
```