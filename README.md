# Skill rgaa-dev

Skill Claude Code pour l'implémentation accessibilité selon RGAA 4.1, WCAG 2.2 AA et patterns ARIA.
Conçue pour les projets BetaGouv/data.gouv.fr utilisant Rails + ERB + ViewComponent + Stimulus + Turbo,
**avec ou sans DSFR**. Détection automatique du contexte projet.

## Installation

### Via plugin (recommandé)

```bash
claude plugin install accessibility@https://github.com/Isalafont/claude-skill-rgaa-dev
```

Le plugin est alors disponible dans tous tes projets Claude Code via `/accessibility:rgaa-dev`.

### Via script (installation manuelle)

```bash
git clone https://github.com/Isalafont/claude-skill-rgaa-dev.git
cd claude-skill-rgaa-dev
bash install.sh
```

La skill sera copiée dans `~/.claude/skills/rgaa-dev/` et invocable via `/rgaa-dev`.

## Comment l'utiliser

### Mode automatique

La skill se charge **automatiquement** quand tu demandes à Claude de :
- Créer ou modifier un composant HTML, un formulaire, un lien, une navigation
- Implémenter un composant dynamique (modale, onglets, accordéon, upload)
- Corriger un problème d'accessibilité
- Parler d'accessibilité, RGAA, WCAG, ARIA ou handicap

Elle se charge aussi automatiquement quand tu travailles sur des fichiers ERB, ViewComponent ou JavaScript (via le champ `paths` du frontmatter).

Dans ce mode, Claude applique les règles sans que tu aies à le mentionner.

### Mode explicite `/accessibility:rgaa-dev`

Pour demander un audit ou poser une question ciblée :

```
/accessibility:rgaa-dev Audite ce composant avant merge
/accessibility:rgaa-dev Quelles règles ARIA pour une liste avec filtre dynamique ?
/accessibility:rgaa-dev Implémente un champ upload accessible RGAA
/accessibility:rgaa-dev Ce formulaire est-il conforme RGAA 11 ?
```

### Cas d'usage typiques

| Situation | Ce que tu demandes |
|-----------|-------------------|
| Code review | `/accessibility:rgaa-dev Vérifie ce composant` |
| Nouveau composant | Demander l'implémentation normalement — Claude suit les règles |
| Audit d'une page | `/accessibility:rgaa-dev Audite la page [X]` |
| Question ponctuelle | `/accessibility:rgaa-dev Comment gérer le focus dans une modale Turbo ?` |
| Correction d'erreur axe | `/accessibility:rgaa-dev axe remonte "aria-required-children" sur ce code` |

## Ce que la skill couvre

### Standards
- **RGAA 4.1** — standard légal français (obligatoire pour les services publics)
- **WCAG 2.2 AA** — niveaux A et AA (baseline légale EAA depuis juin 2025)
- **WAI-ARIA 1.2** — patterns d'interaction (combobox, dialog, tabs, accordion…)
- **DSFR** — Système de Design de l'État (composants, classes, helpers)
- **HTML ARIA conformance** — W3C

### Thèmes RGAA couverts
Thèmes 1 à 13 : images, cadres, couleurs, multimédia, tableaux, liens, scripts,
éléments obligatoires, structuration, présentation, formulaires, navigation, consultation.

### Stack technique
- Rails ERB + helpers ARIA
- DSFRFormBuilder
- ViewComponents (Atomic Design)
- Stimulus controllers (toggle, modal, live region, listbox)
- Turbo Drive / Frames / Streams
- Tests axe-core (Cucumber + RSpec)

## Fichiers de référence

| Fichier | Contenu |
|---------|---------|
| `SKILL.md` | Point d'entrée — règles d'or, arbre de décision, anti-patterns |
| `examples-dsfr.md` | Exemples HTML avec classes DSFR (DataPass) |
| `examples-html.md` | Référence universelle HTML/WCAG/ARIA (sans framework) |
| `checklist.md` | Checklists par type de page (formulaire, liste, composants dynamiques, zoom 200%) |
| `rails-patterns.md` | Patterns Rails / ERB / ViewComponent / Stimulus / Turbo |
| `colors.md` | Contrastes, tokens DSFR, outils de test |
| `fallbacks.md` | Alternatives quand l'idéal est impossible — charge disproportionnée, PDF, vidéo, composants tiers |
| `html-structure.md` | Validation HTML, titres, landmarks, snippets DevTools |
| `resources.md` | Liens RGAA par critère, outils, déclaration d'accessibilité |
| `impacts.md` | Impact des défauts par type de handicap + priorités |

## Points clés à retenir

**Anti-patterns fréquents que la skill corrige :**
- `role="alert"` + `aria-live="assertive"` → redondant, `role="alert"` suffit
- `<div onclick>` → utiliser `<button>` ou `<a>`
- `tabindex="2"` → ne jamais utiliser tabindex > 0
- `alt=""` + `role="presentation"` → `alt=""` suffit pour une image décorative
- placeholder comme seul label → toujours un `<label>` visible

**Règle des 5 ARIA (W3C) :**
1. Utiliser le HTML natif en premier (pas d'ARIA si un élément sémantique existe)
2. Ne pas modifier la sémantique native inutilement
3. Tous les contrôles ARIA doivent être utilisables au clavier
4. Les éléments focusables avec rôle/état/propriété visibles
5. Les éléments interactifs ont un nom accessible

## Obligation légale

Tout service numérique public → la conformité RGAA est **obligatoire** (loi 2005-102, décret 2019-768).
L'**European Accessibility Act** rend WCAG 2.2 AA obligatoire dans l'UE depuis le 28 juin 2025.

Cela implique :
- Publier une **déclaration d'accessibilité** accessible depuis le footer (`/accessibilite`)
- Maintenir un **schéma pluriannuel** mis à jour annuellement
- Viser **50 % minimum** des critères RGAA applicables (niveau « partiellement conforme »)

Générateur officiel de déclaration : https://betagouv.github.io/a11y-generateur-declaration/