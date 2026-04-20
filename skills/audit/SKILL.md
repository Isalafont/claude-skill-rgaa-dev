---
name: audit
description: |
  Audit RGAA 4.1 guidé — évalue la conformité accessibilité d'une page ou d'un
  composant Rails/DSFR avant merge. Pose des questions thème par thème (images,
  liens, formulaires, scripts, navigation, structuration…) avec niveau de sévérité
  🔴 Bloquant / 🟠 Gênant / 🟡 Mineur et exemple de correction ERB/DSFR immédiat.
  Produit un rapport de non-conformités priorisées. Invoquer avec le chemin du
  fichier : /accessibility:audit app/views/foo.html.erb
  Fonctionne en mode page (vue complète) ou mode composant (audit partiel).
  Suit le RGAA 4.1 : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/
paths:
  - "app/views/**/*.erb"
  - "app/components/**/*.erb"
  - "app/components/**/*.rb"
---

# /accessibility:audit — Audit RGAA 4.1 guidé

## Comment utiliser cette skill

```
/accessibility:audit app/views/users/show.html.erb        # mode page
/accessibility:audit app/components/ban_form_component.html.erb  # mode composant
```

Fournis le chemin du fichier à auditer. La skill lit le code, détecte les thèmes
concernés et pose des questions ciblées avec exemples de correction.

---

## Phase 1 — Détection automatique des thèmes

Analyser le code fourni et activer uniquement les thèmes pertinents :

| Détecteur dans le code | Thèmes activés |
|------------------------|----------------|
| `<img>`, `image_tag`, `<svg>`, `fr-icon-*` | Thème 1 — Images |
| `<iframe>` | Thème 2 — Cadres |
| CSS custom, classes couleur hors DSFR | Thème 3 — Couleurs |
| `<video>`, `<audio>` | Thème 4 — Multimédia |
| `<table>` | Thème 5 — Tableaux |
| `<a>`, `link_to`, `button_to` | Thème 6 — Liens |
| `data-controller`, `<dialog>`, `onclick`, `aria-expanded` | Thème 7 — Scripts |
| Fichier layout / mode page | Thème 8 — Éléments obligatoires |
| `<h1>`…`<h6>`, `<nav>`, `<main>`, `<header>` | Thème 9 — Structuration |
| Tout fichier avec CSS inline ou `class=` | Thème 10 — Présentation |
| `<form>`, `form_with`, `<input>`, `<select>`, `<textarea>` | Thème 11 — Formulaires |
| Fichier layout / mode page | Thème 12 — Navigation |
| Session, `<a href="*.pdf">`, animations, `setTimeout` | Thème 13 — Consultation |

Thèmes non détectés → marqués « non concerné » dans le rapport, sans questions.

**Détecter aussi le mode :**
- Fichier dans `app/views/` → **mode page** (thèmes 8 et 12 actifs)
- Fichier dans `app/components/` → **mode composant** (thèmes 8 et 12 désactivés, avertissement en fin de rapport)

---

## Phase 2 — Questions guidées par thème

Consulter [audit-flow.md](audit-flow.md) pour les questions détaillées de chaque thème.

**Règles de conduite :**
- Poser les questions **thème par thème**, pas toutes d'un coup
- Maximum 3 questions par thème
- Indiquer le niveau de sévérité avant chaque question : 🔴 Bloquant / 🟠 Gênant / 🟡 Mineur
- **Si NON** : afficher immédiatement l'exemple de correction ERB/DSFR
- **Si NON CONCERNÉ** : passer au thème suivant sans attendre
- Proposer « Veux-tu que je corrige ça maintenant ? » après chaque non-conformité bloquante

---

## Phase 3 — Vérifications transverses (toujours posées)

Après tous les thèmes, poser systématiquement :

```
Avant de finaliser le rapport :

🔴 [ ] Test clavier effectué ? (Tab, Shift+Tab, Enter, Escape, flèches dans les composants)
🔴 [ ] Zoom 200% testé ? (Cmd++ × 6 — aucun texte coupé, pas de scroll horizontal)
🟠 [ ] Focus visible sur tous les éléments interactifs ?
```

---

## Choix du format de sortie

En fin d'audit, demander :

```
Audit terminé. Comment veux-tu le résultat ?

1. Rapport Markdown complet (à sauvegarder ou coller dans la PR description)
2. Corrections directes maintenant (on corrige dans les fichiers)
3. Les deux — rapport + corrections immédiates
```

---

## Structure du rapport Markdown (option 1 ou 3)

```markdown
# Rapport d'audit RGAA — [Nom du fichier]
Date : YYYY-MM-DD · Mode : page | composant
Thèmes évalués : X/13 · Thèmes non concernés : Y/13

## Score de conformité estimé
- Critères évalués : N · Conformes : N (X%) · Non-conformes : N (X%)
> Score indicatif — ne remplace pas un audit officiel par un tiers qualifié.

## Non-conformités

### 🔴 Bloquant
- [11.1] Champ "Email" sans `<label for>` — `app/views/…:12`
  → `<label for="user_email">Adresse e-mail</label>`

### 🟠 Gênant
- [6.1] Lien "Voir" ambigu — `app/components/…:28`
  → Ajouter `<span class="fr-sr-only"> l'habilitation <%= r.intitule %></span>`

### 🟡 Mineur
- [10.7] `outline: none` sans alternative — `custom.css:42`

## À vérifier manuellement
- [ ] Test clavier (Tab / Enter / Escape)
- [ ] Zoom 200%
- [ ] Lecteur d'écran sur le parcours principal
- [Critère 4.1](https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-4-1) Sous-titres vidéo

## Thèmes non évalués (hors scope)
- Thème 4 — aucun `<video>`/`<audio>` détecté
- Thème 5 — aucun `<table>` détecté

## Limites du mode composant
Ces critères nécessitent la page complète pour être évalués :
- [8.5] `<title>` unique par page
- [8.3] `<html lang="fr">`
- [9.1] Hiérarchie h1 globale
- [12.1] Liens d'évitement présents
- [12.2] `aria-current="page"` dans le menu
```