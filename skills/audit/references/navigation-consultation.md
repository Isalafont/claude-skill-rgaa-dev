# Références RGAA — Thèmes 12 à 13 : Navigation, Consultation

---

## Thème 12 — Navigation (11 critères)

> Mode page uniquement. En mode composant, ces critères sont listés dans « Limites du mode composant ».

### 12.7 — Liens d'évitement 🔴 Bloquant

**Détecter :** absence de liens d'évitement dans `application.html.erb` ; lien d'évitement présent mais pointant vers un `id` inexistant

**Non-conformité type :**
```erb
<%# Aucun lien d'évitement en tête de body %>
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
    <li>
      <a class="fr-skip-links__link" href="#main-nav">
        Aller à la navigation
      </a>
    </li>
  </ul>
</nav>
```

Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-12-11

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
