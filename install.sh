#!/bin/bash
set -e

SKILLS_DIR="$HOME/.claude/skills"
SKILL_NAME="rgaa-dev"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Installation de la skill $SKILL_NAME..."
echo ""
echo "ℹ️  Installation recommandée via plugin Claude Code :"
echo "   claude plugin install accessibility@https://github.com/Isalafont/claude-skill-rgaa-dev"
echo "   → Invocable via : /accessibility:rgaa-dev"
echo ""
echo "Installation manuelle (legacy) dans ~/.claude/skills/..."

mkdir -p "$SKILLS_DIR"

if [ -d "$SKILLS_DIR/$SKILL_NAME" ]; then
  echo "⚠️  La skill $SKILL_NAME existe déjà. Mise à jour..."
  rm -rf "$SKILLS_DIR/$SKILL_NAME"
fi

cp -r "$SCRIPT_DIR/skills/$SKILL_NAME" "$SKILLS_DIR/$SKILL_NAME"

echo "✅ Skill $SKILL_NAME installée dans $SKILLS_DIR/$SKILL_NAME"
echo "   Invocable via : /rgaa-dev"
echo "   Active automatiquement sur : app/views/**/*.erb, app/components/**, app/javascript/**/*.js"