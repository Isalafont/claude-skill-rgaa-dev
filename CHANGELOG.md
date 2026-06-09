# Changelog

## [1.2.1] — 2026-06-09

### Modifications
- `/accessibility:audit` : section « Critères conformes » du template de rapport passée en liste à puces (un critère par ligne), au lieu de paragraphes accolés — rapport plus lisible

## [1.2.0] — 2026-06-09

### Modifications
- `/accessibility:audit` : refonte en analyse statique silencieuse du code, au lieu d’un questionnaire thème par thème. Produit un rapport de conformité structuré (tableau C/NC/NA par thème, NC détaillées, correction groupée), plus fidèle à un audit RGAA réel
- `audit-flow.md` éclaté en `skills/audit/references/` (un fichier par groupe de thèmes)

### Ajouts
- Raisonnement par impact utilisateur : règle de tri en Phase 1 (pas d’impact réel → pas de NC, distinguer C et NA) et ligne « Impact utilisateur » obligatoire dans chaque NC, branchée sur `impacts.md`
- Critères affinés dans les références : états signalés par la couleur seule (3.1), exclusion du décoratif du contraste (3.3), non-applicabilité de la règle nom visible/nom accessible sans intitulé visible (6.1), absence de titres en NC (9.1), suites de liens en liste (9.3), menu au zoom 200 % (10.4), objectif du critère 10.9, placement de `role="search"` hors du bouton (12.6), distinction accès rapide / évitement (12.7)

## [1.1.1] — 2026-04-22

### Améliorations
- README : bloc disclaimer avec limites de l'IA et tableau de couverture par thème RGAA
- README : contexte handicap et lien vers accessibilite.numerique.gouv.fr
- README : suppression de la section Contexte (redondante avec §Licence)
- README : convention `plugin@marketplace` clarifiée pour `rgaa-toolkit`
- README : exemples d'invocation avec chemins génériques
- README : déclencheurs du mode automatique reformulés
- SKILL.md : règle de navigation globale (Read ciblé, pas de grep exploratoire)
- SKILL.md : entrée « Liste filtrée / recherche dynamique » ajoutée dans le tableau des tâches
- `/accessibility:audit` : sauvegarde automatique du rapport dans `.claude/audit/`
- RGAA 4.1 → RGAA 4.1.2 dans tous les fichiers

## [1.1.0] — 2026-04-21

### Ajouts
- Skill `/accessibility:audit` — audit guidé critère par critère, thème par thème
- Rapport structuré avec sévérités 🔴/🟠/🟡 et corrections ERB/DSFR
- Plugin publié sous Licence Ouverte 2.0 (Etalab)
- `marketplace.json` — installation via `/plugin install accessibility@rgaa-toolkit`

## [1.0.0] — 2026-04-01

### Ajouts
- Skill `/accessibility:rgaa-dev` — guide d'implémentation RGAA 4.1.2 / WCAG 2.2 AA / WAI-ARIA 1.2
- Exemples Rails + DSFR : formulaires, composants interactifs, navigation, upload
- Détection automatique du contexte projet (DSFR ou non)
- Compatible Rails + ERB + ViewComponent + Stimulus + Turbo