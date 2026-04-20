#!/bin/bash
set -e

SKILLS_DIR="$HOME/.claude/skills"
SKILL_NAME="rgaa-dev"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Installation de la skill $SKILL_NAME..."

mkdir -p "$SKILLS_DIR"

if [ -d "$SKILLS_DIR/$SKILL_NAME" ]; then
  echo "⚠️  La skill $SKILL_NAME existe déjà. Mise à jour..."
  rm -rf "$SKILLS_DIR/$SKILL_NAME"
fi

cp -r "$SCRIPT_DIR" "$SKILLS_DIR/$SKILL_NAME"
rm -f "$SKILLS_DIR/$SKILL_NAME/install.sh"

echo "✅ Skill $SKILL_NAME installée dans $SKILLS_DIR/$SKILL_NAME"
echo "   Invocable via : /rgaa-dev"
echo "   Active automatiquement sur : app/views/**/*.erb, app/components/**, app/javascript/**/*.js"