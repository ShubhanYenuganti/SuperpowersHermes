#!/usr/bin/env bash
set -e
HERMES_DIR="${HERMES_HOME:-$HOME/.hermes}"
mkdir -p "$HERMES_DIR/skills"

cp -r skills/superpowers "$HERMES_DIR/skills/"
echo "✓ Installed skills → $HERMES_DIR/skills/superpowers/"

mkdir -p "$HERMES_DIR/plugins"
cp -r plugin "$HERMES_DIR/plugins/superpowers"
echo "✓ Installed plugin → $HERMES_DIR/plugins/superpowers/"

echo ""
echo "Run: hermes plugins enable superpowers"
