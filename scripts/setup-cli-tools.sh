#!/usr/bin/env bash
#
# Install the npm-based CLI tools used by the AI wiki.
# Run this AFTER creating and activating the conda env:
#
#   conda env create -f environment.yml
#   conda activate ai-wiki
#   bash scripts/setup-cli-tools.sh
#
set -euo pipefail

if [[ "${CONDA_DEFAULT_ENV:-}" != "ai-wiki" ]]; then
  echo "Error: the 'ai-wiki' conda env is not active." >&2
  echo "       Run: conda activate ai-wiki" >&2
  exit 1
fi

echo "==> Using node:  $(node --version)"
echo "==> Using npm:   $(npm --version)"
echo

echo "==> Installing @kepano/defuddle (web-page cleaner)..."
npm install -g @kepano/defuddle

echo
echo "==> Installing @tobilu/qmd (hybrid search)..."
npm install -g @tobilu/qmd

echo
echo "==> Done. Verify with:"
echo "    defuddle --help"
echo "    qmd --help"
echo
echo "Optional next step — register the wiki as a qmd collection:"
echo "    qmd collection add ./wiki --name ai-wiki"
echo "    qmd index rebuild ai-wiki"
