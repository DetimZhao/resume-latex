#!/usr/bin/env bash
# parse-latex-errors.sh — Extract structured, human-readable errors from LaTeX compiler output.
# Usage: bash scripts/parse-latex-errors.sh <logfile>

set -euo pipefail

LOG_FILE="${1:-}"

if [ -z "$LOG_FILE" ] || [ ! -f "$LOG_FILE" ]; then
  echo "Usage: parse-latex-errors.sh <logfile>"
  exit 1
fi

CONTENT=$(cat "$LOG_FILE")
FOUND=0

# Helper: look ahead from a line number for "l.<number>"
find_tex_line() {
  local start="$1"
  echo "$CONTENT" | tail -n +"$start" | head -5 | grep -oP 'l\.\K\d+' | head -1 || true
}

# ── Pattern 1: Traditional LaTeX errors ──────────────────────────
# Lines starting with "!" followed by context
echo "$CONTENT" | grep -n '^!' | head -20 | while IFS=: read -r lineNum errLine; do
  errMsg=$(echo "$errLine" | sed 's/^!\s*//' | sed 's/\s*\.\s*$//')
  texLineNum=$(find_tex_line "$lineNum")
  
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  if [ -n "$texLineNum" ]; then
    echo "ERROR line ${texLineNum}: ${errMsg}"
  else
    echo "ERROR: ${errMsg}"
  fi
  
  # Print next two context lines
  echo "$CONTENT" | tail -n +"$lineNum" | head -3 | tail -2 | sed 's/^/  /'
  echo ""
done

# ── Pattern 2: Undefined control sequence ────────────────────────
if echo "$CONTENT" | grep -q 'Undefined control sequence'; then
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "ERROR: Undefined control sequence"
  echo "$CONTENT" | grep -B 1 'Undefined control sequence' | head -3 | sed 's/^/  /'
  echo ""
  FOUND=1
fi

# ── Pattern 3: Emergency stop ────────────────────────────────────
if echo "$CONTENT" | grep -q 'Emergency stop'; then
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "ERROR: Emergency stop — compilation aborted"
  errSection=$(echo "$CONTENT" | grep -B 10 'Emergency stop' | grep '^!' | tail -1 || true)
  if [ -n "$errSection" ]; then
    echo "  Preceding error: $(echo "$errSection" | sed 's/^!\s*//')"
  fi
  echo ""
  FOUND=1
fi

# ── Pattern 4: Package errors ────────────────────────────────────
if echo "$CONTENT" | grep -qP 'Package \S+ Error:'; then
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Package Errors:"
  echo "$CONTENT" | grep -P 'Package \S+ Error:' | while read -r pkgLine; do
    echo "  ${pkgLine}"
  done
  echo ""
  FOUND=1
fi

# ── Fallback ─────────────────────────────────────────────────────
# Check if the grep in Pattern 1 found anything (subshell-safe)
HAS_BANG=$(echo "$CONTENT" | grep -c '^!' || echo 0)

if [ "$HAS_BANG" -eq 0 ] && [ "$FOUND" -eq 0 ]; then
  echo "No structured LaTeX errors detected. Last 60 non-blank lines of log:"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "$CONTENT" | grep -v '^$' | tail -60
fi

exit 1
