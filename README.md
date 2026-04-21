# RGAA Skill pour Claude Code

Plugin Claude Code fournissant deux skills d'accessibilité numérique pour les
projets publics français : un guide d'implémentation conforme RGAA 4.1 / WCAG 2.2
AA / WAI-ARIA 1.2, et un audit guidé critère par critère. Conçu pour la stack
Rails + ERB + ViewComponent + Stimulus + Turbo, **avec ou sans DSFR** (détection
automatique du contexte projet).

## Contexte

Skill développée par **Isabelle Lafont** dans le cadre de son travail sur
DataPass, au sein du **Pôle Data - Circulation de la Donnée de la DINUM**.
Elle a vocation à être adoptée par les autres équipes du pôle.

Publiée sous [Licence Ouverte 2.0](./LICENSE.md) (Etalab).

## Table des matières

- [Installation](#installation)
- [Utilisation avec Claude Code](#utilisation-avec-claude-code)
- [Skills disponibles](#skills-disponibles)
- [Structure du projet](#structure-du-projet)
- [Ce que la skill couvre](#ce-que-la-skill-couvre)
- [Fichiers de référence](#fichiers-de-référence)
- [Points clés à retenir](#points-clés-à-retenir)
- [Obligation légale](#obligation-légale)
- [Licence](#licence)
- [Références](#références)
- [Support](#support)

## Installation

### Option 1 : Via le système de plugins (recommandée)

Depuis Claude Code :

```
/plugin marketplace add https://github.com/Isalafont/claude-skill-rgaa-dev
/plugin install accessibility@rgaa-toolkit
```

Le plugin `accessibility` est alors disponible dans tous tes projets Claude Code
via les skills `/accessibility:rgaa-dev` et `/accessibility:audit`.

Pour vérifier l'installation : `/plugin` liste les plugins actifs.
Pour recharger après une mise à jour : `/reload-plugins`.

### Option 2 : Installation manuelle via Git

**Installation globale (disponible partout)** :

```bash
cd ~/.claude/skills
git clone https://github.com/Isalafont/claude-skill-rgaa-dev.git rgaa-dev
```

**Installation spécifique à un projet** :

```bash
cd /chemin/vers/votre/projet
mkdir -p .claude/skills
cd .claude/skills
git clone https://github.com/Isalafont/claude-skill-rgaa-dev.git rgaa-dev
```

**Via le script fourni** (équivalent installation globale) :

```bash
git clone https://github.com/Isalafont/claude-skill-rgaa-dev.git
cd claude-skill-rgaa-dev
bash install.sh
```

### Vérifier l'installation

Dans Claude Code, les skills sont actifs si tu peux poser ce genre de questions :

```
"Quelles règles ARIA pour une liste avec filtre dynamique ?"
"Implémente un champ upload accessible RGAA"
"Audite ce composant avant merge"
```

Si les skills sont chargés, Claude Code a accès au guide complet et à la
méthodologie d'audit pas-à-pas.

## Utilisation avec Claude Code

### Mode automatique

Les skills se chargent **automatiquement** quand tu demandes à Claude de :

- Créer ou modifier un composant HTML, un formulaire, un lien, une navigation
- Implémenter un composant dynamique (modale, onglets, accordéon, upload)
- Corriger un problème d'accessibilité
- Parler d'accessibilité, RGAA, WCAG, ARIA ou handicap

Elles se chargent aussi quand tu travailles sur des fichiers ERB, ViewComponent
ou JavaScript (via le champ `paths` du frontmatter). Dans ce mode, Claude
applique les règles sans que tu aies à les mentionner.

### Mode explicite

Pour demander un audit ou poser une question ciblée :

```
/accessibility:rgaa-dev Quelles règles ARIA pour une liste avec filtre dynamique ?
/accessibility:rgaa-dev Implémente un champ upload accessible RGAA
/accessibility:rgaa-dev Ce formulaire est-il conforme RGAA 11 ?

/accessibility:audit app/views/users/show.html.erb
/accessibility:audit app/components/admin/data_provider_selector_component.html.erb
```

### Cas d'usage typiques

| Situation | Ce que tu demandes |
|-----------|-------------------|
| Code review | `/accessibility:rgaa-dev Vérifie ce composant` |
| Nouveau composant | Demander l'implémentation normalement — Claude suit les règles |
| Audit d'une page | `/accessibility:audit app/views/foo.html.erb` |
| Question ponctuelle | `/accessibility:rgaa-dev Comment gérer le focus dans une modale Turbo ?` |
| Correction d'erreur axe | `/accessibility:rgaa-dev axe remonte "aria-required-children" sur ce code` |

## Skills disponibles

Ce plugin accueille plusieurs skills complémentaires :

| Skill | Invocation | Statut | Description |
|-------|------------|--------|-------------|
| Guide RGAA/WCAG | `/accessibility:rgaa-dev` | ✅ Disponible | Guide complet d'implémentation — HTML sémantique, ARIA, Rails, DSFR |
| Audit guidé | `/accessibility:audit` | ✅ Disponible | Audit critère par critère avec sévérité 🔴/🟠/🟡 et corrections ERB/DSFR |
| Checklist commit | `/accessibility:check` | 🚧 En conception | Checklist rapide avant commit/merge |

## Structure du projet

```
claude-skill-rgaa-dev/
│
├── README.md                       # Ce fichier
├── LICENSE.md                      # Licence Ouverte 2.0 (Etalab)
├── install.sh                      # Script d'installation manuelle
│
├── .claude-plugin/
│   ├── plugin.json                 # Métadonnées du plugin Claude Code
│   └── marketplace.json            # Configuration du marketplace rgaa-toolkit
│
├── templates/                      # Templates pour futurs skills
│
└── skills/                         # Skills disponibles
    ├── rgaa-dev/                   # Guide d'implémentation
    │   ├── SKILL.md                # Point d'entrée — règles d'or, anti-patterns
    │   ├── examples-dsfr.md        # Exemples HTML avec classes DSFR
    │   ├── examples-html.md        # Référence universelle HTML/WCAG/ARIA
    │   ├── checklist.md            # Checklists par type de page
    │   ├── rails-patterns.md       # Patterns Rails / ERB / ViewComponent / Stimulus / Turbo
    │   ├── colors.md               # Contrastes, tokens DSFR, outils
    │   ├── fallbacks.md            # Alternatives en cas de charge disproportionnée
    │   ├── html-structure.md       # Validation HTML, titres, landmarks
    │   ├── resources.md            # Liens RGAA par critère, outils, déclaration
    │   ├── impacts.md              # Impact par type de handicap + priorités
    │   └── rgaa-themes.md          # Les 13 thèmes RGAA détaillés
    │
    └── audit/                      # Méthodologie d'audit guidé
        ├── SKILL.md                # Point d'entrée — détection de thèmes, sévérités
        └── audit-flow.md           # Questions guidées thème par thème
```

## Ce que la skill couvre

### Standards

- **RGAA 4.1** — standard légal français (obligatoire pour les services publics)
- **WCAG 2.2 AA** — niveaux A et AA (baseline légale EAA depuis juin 2025)
- **WAI-ARIA 1.2** — patterns d'interaction (combobox, dialog, tabs, accordion…)
- **DSFR** — Système de Design de l'État (composants, classes, helpers)
- **HTML ARIA conformance** — W3C

### Thèmes RGAA couverts

Thèmes 1 à 13 : images, cadres, couleurs, multimédia, tableaux, liens, scripts,
éléments obligatoires, structuration, présentation, formulaires, navigation,
consultation.

### Stack technique

- Rails ERB + helpers ARIA
- DSFRFormBuilder
- ViewComponents (Atomic Design)
- Stimulus controllers (toggle, modal, live region, listbox)
- Turbo Drive / Frames / Streams
- Tests axe-core (Cucumber + RSpec)

## Fichiers de référence

### Skill `rgaa-dev` — guide d'implémentation

| Fichier | Contenu |
|---------|---------|
| `SKILL.md` | Point d'entrée — règles d'or, arbre de décision, anti-patterns |
| `examples-dsfr.md` | Exemples HTML avec classes DSFR (contexte DataPass) |
| `examples-html.md` | Référence universelle HTML/WCAG/ARIA (sans framework) |
| `checklist.md` | Checklists par type de page (formulaire, liste, composants dynamiques, zoom 200 %) |
| `rails-patterns.md` | Patterns Rails / ERB / ViewComponent / Stimulus / Turbo |
| `colors.md` | Contrastes, tokens DSFR, outils de test |
| `fallbacks.md` | Alternatives quand l'idéal est impossible — charge disproportionnée, PDF, vidéo, composants tiers |
| `html-structure.md` | Validation HTML, titres, landmarks, snippets DevTools |
| `resources.md` | Liens RGAA par critère, outils, déclaration d'accessibilité |
| `impacts.md` | Impact des défauts par type de handicap + priorités |
| `rgaa-themes.md` | Les 13 thèmes RGAA détaillés |

### Skill `audit` — méthodologie d'audit guidé

| Fichier | Contenu |
|---------|---------|
| `SKILL.md` | Point d'entrée — détection des thèmes pertinents, sévérités 🔴/🟠/🟡, structure de rapport |
| `audit-flow.md` | Questions guidées thème par thème, corrections ERB/DSFR prêtes à l'emploi |

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

Tout service numérique public → la conformité RGAA est **obligatoire**
(loi 2005-102, décret 2019-768).

L'**European Accessibility Act** rend WCAG 2.2 AA obligatoire dans l'UE
depuis le 28 juin 2025.

Cela implique :

- Publier une **déclaration d'accessibilité** accessible depuis le footer (`/accessibilite`)
- Maintenir un **schéma pluriannuel** mis à jour annuellement
- Viser **50 % minimum** des critères RGAA applicables (niveau « partiellement conforme »)

Générateur officiel de déclaration : https://betagouv.github.io/a11y-generateur-declaration/

## Licence

Ce projet est publié sous [Licence Ouverte 2.0 (Etalab-2.0)](./LICENSE.md).

**Droits** : réutilisation libre et gratuite, y compris à des fins commerciales.

**Obligation** : mentionner la paternité (source + date de mise à jour).

**Compatibilité** : CC-BY, OGL (UK), ODC-BY.

## Références

- [RGAA 4.1](https://accessibilite.numerique.gouv.fr/) — référentiel officiel
- [WCAG 2.2](https://www.w3.org/TR/WCAG22/) — standard international
- [WAI-ARIA 1.2](https://www.w3.org/TR/wai-aria-1.2/) — patterns ARIA
- [Design System Français (DSFR)](https://www.systeme-de-design.gouv.fr/)
- [dsfr-skill](https://github.com/numerique-gouv/dsfr-skill) — skill Claude Code pour les 23 composants DSFR
- [Générateur de déclaration d'accessibilité](https://betagouv.github.io/a11y-generateur-declaration/)
- [Licence Ouverte 2.0](https://github.com/etalab/licence-ouverte/)

## Support

**Questions ou bugs sur la skill** : ouvrir une issue sur
[ce dépôt](https://github.com/Isalafont/claude-skill-rgaa-dev/issues).

**Questions sur le RGAA** :

- [Forum RGAA](https://github.com/DISIC/accessibilite-numerique) (DISIC)
- [Documentation officielle](https://accessibilite.numerique.gouv.fr/)

---

**Version** : 1.1.0 | **Dernière mise à jour** : 2026-04-21