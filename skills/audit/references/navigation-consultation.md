# Références RGAA — Thèmes 12 à 13 : Navigation, Consultation

---

## Thème 12 — Navigation (11 critères)

> Mode page uniquement. En mode composant, ces critères sont listés dans « Limites du mode composant ».

### 12.6 — Zones de regroupement atteignables (landmarks) 🟠 Majeur

**Détecter :** zone de moteur de recherche sans `role="search"` (ou `<search>`) ; régions d'en-tête, navigation, contenu principal, pied de page non balisées par des landmarks (`<header>`, `<nav>`, `<main>`, `<footer>`).

**Placement correct de `role="search"` (piège fréquent) :** le rôle `search` se pose sur un **élément englobant sans rôle propre** (`<search>`, `<div>`, `<form>`) qui entoure le champ et le bouton — **jamais directement sur le `<button>`**. Sur le bouton, il écraserait la sémantique essentielle (`role="button"`), qui serait alors annoncé comme une zone de recherche au lieu d'un bouton.

**Non-conformité type :**
```erb
<%# role search sur le bouton : surcharge la sémantique du bouton %>
<button type="submit" role="search">Rechercher</button>
```

**Correction :**
```erb
<%# role search sur le conteneur ; le bouton garde sa sémantique %>
<search>                              <%# ou <div role="search"> %>
  <form action="/recherche">
    <label for="q">Rechercher</label>
    <input type="search" id="q" name="q">
    <button type="submit">Rechercher</button>
  </form>
</search>
```

Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-12-6

---

### 12.7 — Lien d'accès rapide / d'évitement vers le contenu principal 🔴 Bloquant

**Ce que le critère exige (et seulement ça) :** un lien permettant d'atteindre **la zone de contenu principal**, présent dans chaque page. Un **seul** lien vers le contenu principal suffit. Le critère **n'exige PAS** de lien « Aller à la navigation » ni « Aller au pied de page » — ce sont des bonus, leur absence n'est pas une NC 12.7.

**Vocabulaire (glossaire RGAA) — bien nommer dans le rapport :**
- **Lien d'accès rapide** : permet d'*accéder à* une zone → « Aller au contenu principal ». C'est ce qu'attend 12.7.
- **Lien d'évitement** : permet de *sauter/contourner* une zone → « Sauter la navigation ».
- La distinction est la **direction** (accéder à vs contourner), **pas** la visibilité : les deux peuvent être masqués et révélés au focus clavier.

**Détecter :** absence de tout lien vers `#main` (ou l'`id` du `<main>`) en tête de `<body>` ; lien présent mais pointant vers un `id` inexistant.

**Non-conformité type :**
```erb
<%# Aucun lien vers le contenu principal en tête de body %>
<body>
  <header>...</header>
```

**Correction :**
```erb
<%# application.html.erb — premier élément du body %>
<nav class="fr-skip-links" aria-label="Accès rapide">
  <ul class="fr-skip-links__list">
    <li>
      <a class="fr-skip-links__link" href="#main">
        Aller au contenu principal
      </a>
    </li>
    <%# Liens supplémentaires (navigation, recherche) = bonus, non exigés par 12.7 %>
  </ul>
</nav>
```

Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-12-7

---

### 12.2 — Page courante identifiée 🟠 Majeur

**Détecter :** menu de navigation sans `aria-current="page"` sur l'item actif

**Non-conformité type :**
```erb
<%= link_to 'Habilitations', authorizations_path %>  <%# actif mais sans aria-current %>
```

**Correction :**
```erb
<nav aria-label="Navigation principale">
  <ul>
    <% nav_links.each do |link| %>
      <li>
        <%= link_to link[:label], link[:path],
            aria: { current: current_page?(link[:path]) ? 'page' : nil } %>
      </li>
    <% end %>
  </ul>
</nav>
```

Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-12-2

---

### 12.1 — Plusieurs systèmes de navigation 🟡 Mineur

**À vérifier manuellement** (au niveau du site, pas d'un fichier isolé) :
- [ ] Menu principal présent
- [ ] Fil d'Ariane sur les pages intérieures
- [ ] Moteur de recherche ou lien vers plan du site (si applicable)

Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-12-1

---

## Thème 13 — Consultation (12 critères)

### 13.1 — Limite de temps et session 🔴 Bloquant

**Détecter :** formulaire long ou session authentifiée sans mécanisme de prolongation ; `setTimeout` déclenchant une déconnexion sans avertissement

**Correction :**
```erb
<%# Avertissement d'expiration de session %>
<div id="session-warning"
     role="alertdialog"
     aria-modal="true"
     aria-labelledby="session-warning-title"
     hidden>
  <h2 id="session-warning-title">Votre session va expirer</h2>
  <p>Votre session expire dans <span id="session-countdown">5</span> minutes.
     Vos données non sauvegardées seront perdues.</p>
  <button type="button" id="extend-session">Prolonger la session</button>
</div>
```

Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-13-1

---

### 13.2 — Ouverture de nouvelle fenêtre indiquée 🟡 Mineur

**Détecter :** `target: '_blank'` avec `title` seul comme indication — le `title` n'est pas l'intitulé accessible quand du texte est présent

**Non-conformité type :**
```erb
<%= link_to 'Documentation', url, target: '_blank',
    title: 'Documentation - nouvelle fenêtre' %>    <%# title ignoré par les AT %>
```

**Correction :**
```erb
<%= link_to url, target: '_blank', rel: 'noopener external' do %>
  Documentation
  <span class="fr-sr-only"> - <%= t('shared.new_window') %></span>
<% end %>

<%# Ou avec classe DSFR icon externe %>
<%= link_to 'Documentation', url,
    target: '_blank',
    rel: 'noopener external',
    class: 'fr-link fr-icon-external-link-line fr-link--icon-right' do %>
  Documentation
  <span class="fr-sr-only"> - <%= t('shared.new_window') %></span>
<% end %>
```

Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-13-2

---

### 13.3 / 13.4 — Documents en téléchargement 🟠 Majeur

**Détecter :** `<a href="*.pdf">`, `<a href="*.docx">` sans indication du format/poids ni alternative HTML

**À vérifier manuellement :**
- [ ] PDF accessible : ouvrir dans Acrobat Reader → Outils > Accessibilité > Vérification complète
- [ ] Alternative proposée : version HTML sur la même page, ou lien « Version accessible sur demande »

Voir [fallbacks.md](../../rgaa-dev/fallbacks.md) §PDF pour les alternatives acceptables.

Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-13-3

---

### 13.7 / 13.8 — Animations et contenus en mouvement 🟠 Majeur

**Détecter :** carrousel ou animation sans bouton pause/stop ; absence de `prefers-reduced-motion` dans le CSS

**Correction :**
```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
  }
}
```
```erb
<%# Carrousel : bouton pause obligatoire %>
<div class="carousel" data-controller="carousel">
  <button type="button"
          data-action="click->carousel#togglePause"
          aria-label="Mettre le carrousel en pause">
    <span class="fr-icon-pause-line" aria-hidden="true"></span>
  </button>
</div>
```

Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-13-7
