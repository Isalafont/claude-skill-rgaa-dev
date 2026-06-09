---
name: audit
description: |
  Audit RGAA 4.1.2 — analyse statique du code puis 3 questions runtime.
  Produit un rapport de conformité structuré (tableau C/NC/NA par thème,
  NC détaillées avec Élément/Problème/Correction/Priorité, correction groupée).
  Invoquer avec le chemin du fichier : /accessibility:audit app/views/foo.html.erb
  Fonctionne en mode page (app/views/) ou composant (app/components/).
  Suit le RGAA 4.1.2 : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/
paths:
  - "app/views/**/*.erb"
  - "app/components/**/*.erb"
  - "app/components/**/*.rb"
---

# /accessibility:audit — Audit RGAA 4.1.2

## Comment utiliser cette skill

```
/accessibility:audit app/views/users/show.html.erb
/accessibility:audit app/components/ban_form_component.html.erb
```

---

## Phase 1 — Analyse statique silencieuse

Lire le code et **détecter directement les NC** sans poser de questions, en appliquant les critères RGAA pertinents.

### Détection du mode et du contexte

**Mode :**
- `app/views/` → **mode page** (thèmes 8 et 12 actifs)
- `app/components/` → **mode composant** (thèmes 8 et 12 désactivés)

**Contexte de la description (pour le rapport) :**
Inférer depuis le chemin du fichier :
- `admin/` → `(interface admin)`
- `instruction/` → `(interface instructeur)`
- `components/` → `(composant)`
- `users/` → `(espace utilisateur)`
- Sinon → laisser vide

### Critères à analyser par thème

Consulter les fichiers de référence pour les patterns de détection, non-conformités type et corrections ERB/DSFR :

| Thèmes | Fichier de référence | Ce qu'on cherche |
|--------|----------------------|-----------------|
| 1–3 Images, Cadres, Couleurs | [references/images-cadres-couleurs.md](references/images-cadres-couleurs.md) | `<img>` sans `alt` ; SVG sans `aria-hidden` ; `<iframe>` sans `title` ; info par couleur seule |
| 4–7 Multimédia, Tableaux, Liens, Scripts | [references/multimedia-tableaux-liens-scripts.md](references/multimedia-tableaux-liens-scripts.md) | `<video>` sans `<track>` ; `<th>` sans `scope` ; liens ambigus ou vides ; `target="_blank"` sans indication AT ; `<div onclick>` |
| 8–10 Éléments obligatoires, Structure, Présentation | [references/structure-presentation.md](references/structure-presentation.md) | `set_title!` absent ; hiérarchie titres ; landmarks ; `outline: none` ; zoom 200% |
| 11 Formulaires | [references/formulaires.md](references/formulaires.md) | `<input>` sans label ; erreurs sans `aria-invalid` + `aria-describedby` ; champs obligatoires |
| 12–13 Navigation, Consultation | [references/navigation-consultation.md](references/navigation-consultation.md) | Liens d'évitement ; `aria-current="page"` ; nouvelle fenêtre ; PDF sans alternative |

**Règle NC 6 / 13 — nouvelle fenêtre :**
`target: '_blank'` avec `title` seul → NC 13.2. L'indication doit être dans le contenu du lien (texte visible ou `fr-sr-only`).

**Règle NC 8.5 — titre de page :**
Si `set_title!` est présent dans le code → critère 8.5 C (ne pas poser la question).
Si absent en mode page → poser la question en Phase 2.

### Règle de tri par impact _(à appliquer avant tout verdict)_

Le RGAA vérifie un défaut **restitué à l'utilisateur**. Avant de conclure, raisonner par impact — pas par récitation de règle :

1. **Avant de conclure NC** — nommer l'impact concret : *quel handicap, quel blocage, avec quel outil ?* Si aucun impact réel n'existe (élément purement décoratif, règle non applicable au cas), ce **n'est pas une NC** — classer C ou NA selon le cas, pas NC.
2. **Avant de conclure C** — ne pas se contenter de l'absence de défaut visible. Avoir parcouru les tests du critère et vérifié qu'aucun pattern à risque n'est présent. Marquer C par défaut = faux négatif.
3. **Avant de conclure NA** — vérifier que le critère ne s'applique vraiment pas à ce contenu (conditions d'applicabilité), pas seulement qu'on n'a rien trouvé.

Table des impacts par type de handicap : [../rgaa-dev/impacts.md](../rgaa-dev/impacts.md).

---

## Phase 2 — Questions runtime (3 toujours + 1 conditionnelle)

Poser ces questions **en une seule fois**, après l'analyse :

```
Avant de finaliser le rapport, quelques vérifications que le code seul ne permet pas :

🔴 Test clavier effectué ? (Tab, Shift+Tab, Enter, Escape sur les éléments interactifs)
🔴 Zoom 200% testé ? (Cmd++ × 6 — aucun texte coupé, pas de scroll horizontal)
🟠 Focus visible sur tous les éléments interactifs ?
```

**Si `set_title!` absent en mode page**, ajouter :
```
🔴 Le titre de la page est-il pertinent et spécifique (pas juste le nom du site seul) ?
   → Si oui, indiquer le titre affiché.
   (Détecter le nom du site depuis `SITE_NAME` dans les helpers, ou `application.rb`, sinon utiliser « le nom du site »)
```

Intégrer les réponses dans le rapport (cocher les cases, noter le titre si pertinent).

---

## Phase 3 — Choix du format de sortie

```
Audit terminé. Comment veux-tu le résultat ?

1. Rapport Markdown complet sauvegardé dans audits/
2. Corrections directes maintenant (on corrige dans les fichiers)
3. Les deux — rapport sauvegardé + corrections immédiates
```

Si l'option 1 ou 3 est choisie :
- Créer le dossier `audits/` à la racine du projet s'il n'existe pas
- Écrire le rapport dans `audits/rgaa-YYYY-MM-DD.md`
- Si un fichier du même nom existe déjà, ajouter un suffixe incrémental : `rgaa-2026-04-22-2.md`
- Afficher le chemin et une synthèse en moins de 10 lignes dans la conversation

---

## Structure du rapport Markdown (option 1 ou 3)

```markdown
## Audit RGAA 4.1.2 — Rapport de conformité

**Date :** JJ/MM/AAAA
**Périmètre audité :** `chemin/du/fichier.html.erb` — description fonctionnelle (contexte) · Mode : page | composant
**Résultat global :** X% conforme sur les critères applicables
(N critères applicables — N conformes, N non conformes, N non applicables)

---

### Tableau de synthèse

| Thème | C | NC | NA |
|-------|---|----|----|
| 1. Images | | | |
| 2. Cadres | | | |
| 3. Couleurs | | | |
| 4. Multimédia | | | |
| 5. Tableaux | | | |
| 6. Liens | | | |
| 7. Scripts | | | |
| 8. Éléments obligatoires | | | |
| 9. Structuration | | | |
| 10. Présentation | | | |
| 11. Formulaires | | | |
| 12. Navigation | | | |
| 13. Consultation | | | |
| **Total** | | | |

---

### Non-conformités détectées

**[NC] X.Y — Intitulé du critère**
- **Élément concerné :** extrait de code ou `fichier:ligne` — ex : `link_to data_provider.link, data_provider.link, target: '_blank'` (ligne 26)
- **Problème :** explication du *pourquoi* c'est une violation — pas juste le *quoi*. Ex : « Le texte du lien EST l'URL brute. Une URL n'est pas un intitulé explicite : elle ne décrit pas la destination de façon compréhensible. L'attribut `title` ajoute le nom, mais le `title` n'est pas l'intitulé accessible quand du texte est présent. »
- **Impact utilisateur :** quel handicap est touché et quel blocage concret, avec quel outil — c'est ce qui justifie que ce soit bien une NC. Ex : « Cécité (lecteur d'écran) — le lien est restitué "h-t-t-p-s deux-points slash slash…" caractère par caractère, la destination est inintelligible. » Voir [../rgaa-dev/impacts.md](../rgaa-dev/impacts.md).
- **Correction :**
  ```erb
  exemple de correction ERB/DSFR immédiatement applicable
  ```
- **Priorité :** 🔴 Bloquant / 🟠 Majeur / 🟡 Mineur

---

### Correction groupée recommandée _(si plusieurs NC partagent le même élément source)_

Quand plusieurs NC portent sur le même bout de code, proposer une correction unique qui les résout toutes :

**NC X.Y + X.Z — résolution en une modification**

```erb
<%# Avant %>
<ancien code>

<%# Après %>
<nouveau code corrigeant les deux NC>
```

---

### Critères conformes

**X.Y** — justification courte
**X.Z** — justification courte

### Critères non applicables

- **X.Y–X.Z** — justification courte (ex : aucune image, pas de formulaire…)
- **X.Y** — critère de layout géré globalement

### À vérifier manuellement

- [x/☐] Test clavier (Tab / Shift+Tab / Enter / Escape / flèches) — résultat
- [x/☐] Zoom 200% (Cmd++ × 6 — aucun texte coupé, pas de scroll horizontal) — résultat
- [x/☐] Focus visible sur tous les éléments interactifs — résultat

### Limites du mode composant _(si applicable)_

Ces critères nécessitent la page complète pour être évalués :
- [8.5] `<title>` unique par page
- [8.3] `<html lang="fr">`
- [9.1] Hiérarchie h1 globale
- [12.1] Lien d'évitement présent
- [12.2] `aria-current="page"` dans le menu
```
