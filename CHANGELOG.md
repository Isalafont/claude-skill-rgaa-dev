# Changelog

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