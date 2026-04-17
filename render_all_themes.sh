#!/bin/bash
# Render a map poster for every theme in the themes/ directory.
# Any arguments (positional or switch-style) are forwarded to create_map_poster.py.
# A trailing `-t <theme>` is appended per-iteration so the theme always wins over
# any --theme/-t the caller may have supplied.
#
# Usage:
#   ./render_all_themes.sh -c "Paris" -C "France"
#   ./render_all_themes.sh -c "Tokyo" -C "Japan" -d 15000 --no-attribution

set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

THEMES_DIR="themes"

if [ ! -d "$THEMES_DIR" ]; then
    echo "Error: themes directory '$THEMES_DIR' not found." >&2
    exit 1
fi

shopt -s nullglob
theme_files=("$THEMES_DIR"/*.json)
shopt -u nullglob

if [ ${#theme_files[@]} -eq 0 ]; then
    echo "Error: no theme files found in '$THEMES_DIR'." >&2
    exit 1
fi

for theme_file in "${theme_files[@]}"; do
    theme_name=$(basename "$theme_file" .json)
    echo "--- Rendering theme: $theme_name ---"
    uv run python3 create_map_poster.py "$@" -t "$theme_name"
done

echo "Done. Posters saved to posters/ directory."
