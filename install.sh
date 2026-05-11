#!/usr/bin/env bash
set -e
HERMES_DIR="${HERMES_HOME:-$HOME/.hermes}"
mkdir -p "$HERMES_DIR/skills" "$HERMES_DIR/tools"

cp -r skills/superpowers "$HERMES_DIR/skills/"
echo "✓ Installed skills → $HERMES_DIR/skills/superpowers/"

cp tools/superpowers.py "$HERMES_DIR/tools/"
echo "✓ Installed toolset → $HERMES_DIR/tools/superpowers.py"

echo ""
echo "Run: hermes tools --enable superpowers"
