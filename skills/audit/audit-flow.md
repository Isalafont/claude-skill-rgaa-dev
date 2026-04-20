# Audit Flow — Questions RGAA 4.1 par thème

Ce fichier est utilisé par la skill `/accessibility:audit`.
Pour chaque thème activé (détection automatique), poser les questions dans l'ordre.
Maximum 3 questions par thème. Indiquer le niveau de sévérité avant chaque question.

Référence officielle : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/

---

## Thème 1 — Images (9 critères)

### Question 1 — [1.1 / 1.2] Alternatives textuelles 🔴 Bloquant

**Vérifie :** Toute `<img>` / `image_tag` a-t-elle un attribut `alt` ? Les images décoratives ont-elles `alt=""` ?

**Si NON — Correction :**
```erb
<%# Image porteuse de sens %>
<%= image_tag 'logo.png', alt: 'DataPass — Gestion des habilitations' %>

<%# Image décorative : alt vide obligatoire (pas d'alt absent) %>
<%= image_tag 'decoration.png', alt: '' %>

<%# Image-lien %>
<%= link_to root_path do %>
  <%= image_tag 'logo.png', alt: 'DataPass — Retour à l\'accueil' %>
<% end %>
```
Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-1-1

### Question 2 — [1.1] SVG et icônes DSFR 🔴 Bloquant

**Vérifie :** Les SVG inline et icônes `fr-icon-*` décoratives ont-ils `aria-hidden="true"` ? Les SVG informatifs ont-ils `role="img"` + `aria-label` ou `<title>` ?

**Si NON — Correction :**
```html
<%# Icône décorative DSFR %>
<span class="fr-icon-arrow-right-line" aria-hidden="true"></span>

<%# SVG décoratif %>
<svg aria-hidden="true" focusable="false">...</svg>

<%# SVG informatif (graphique, illustration) %>
<svg role="img" aria-label="Répartition des habilitations par statut">
  <title>Répartition des habilitations par statut</title>
  ...
</svg>

<%# Bouton avec icône seule : label obligatoire %>
<button type="button" aria-label="Fermer">
  <span class="fr-icon-close-line" aria-hidden="true"></span>
</button>
```
Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-1-1

### Question 3 — [1.6 / 1.7] Images texte 🟠 Gênant

**Vérifie :** Y a-t-il des images contenant du texte (captures d'écran de texte, boutons en image, logos textuels) ? Si oui, une alternative textuelle équivalente est-elle fournie ?

**Si NON — Correction :**
Ne jamais créer d'image contenant du texte. Utiliser du texte HTML stylé à la place. Si héritage impossible, fournir l'équivalent textuel dans l'`alt`.

Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-1-6

---

## Thème 2 — Cadres (2 critères)

### Question 1 — [2.1] Titre des iframes 🟠 Gênant

**Vérifie :** Chaque `<iframe>` a-t-elle un attribut `title` décrivant son contenu de façon pertinente ?

**Si NON — Correction :**
```html
<%# Mauvais %>
<iframe src="https://..."></iframe>

<%# Correct %>
<iframe src="https://..." title="Carte de localisation des services"></iframe>
<iframe src="https://..." title="Vidéo de présentation du service"></iframe>

<%# Iframe décorative/cachée %>
<iframe src="..." title="Contenu sans titre" aria-hidden="true" tabindex="-1"></iframe>
```
Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-2-1

---

## Thème 3 — Couleurs (3 critères)

### Question 1 — [3.1] Information par la couleur seule 🔴 Bloquant

**Vérifie :** Y a-t-il une information transmise uniquement par la couleur ? (badge rouge sans mot « erreur », lien non souligné indiscernable du texte, champ obligatoire signalé seulement en rouge)

**Si NON — Correction :**
```erb
<%# Badge statut : couleur + texte %>
<span class="fr-badge fr-badge--error">Refusée</span>

<%# Champ obligatoire : toujours indiquer textuellement %>
<p>Les champs marqués d'un <span aria-hidden="true">*</span>
   <span class="fr-sr-only">astérisque</span> sont obligatoires.</p>

<%# Lien dans un texte : ne pas supprimer le soulignement %>
<%# → ne pas écrire text-decoration: none sur les <a> dans du texte courant %>
```
Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-3-1

### Question 2 — [3.2 / 3.3] Contrastes des composants custom 🟠 Gênant

**Vérifie :** Les composants **hors DSFR natif** (CSS custom, Tailwind, couleurs personnalisées) respectent-ils : texte ≥ 4.5:1, grand texte ≥ 3:1, composants UI (bordure input, outline focus, icônes informatives) ≥ 3:1 ?

**Si NON :**
Tester avec https://contrast-finder.tanaguru.com/ ou l'inspecteur DevTools (onglet Accessibilité).
Les tokens DSFR sont validés — les dérives viennent des customisations. Voir [colors.md](../rgaa-dev/colors.md).

Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-3-2

---

## Thème 4 — Multimédia (13 critères)

> Si aucun `<video>` ni `<audio>` détecté → thème non concerné, passer au suivant.

### Question 1 — [4.1 / 4.2] Transcription et sous-titres 🔴 Bloquant

**Vérifie :** Les contenus audio/vidéo ont-ils une transcription textuelle ? Les vidéos avec parole ont-elles des sous-titres synchronisés ?

**À vérifier manuellement** — pas de correction code automatique.
- [ ] Transcription textuelle accessible sur la même page ou via lien adjacent
- [ ] Fichier de sous-titres `.vtt` ou `.srt` attaché à la `<video>`
- [ ] Sous-titres fidèles (pas de résumé), incluant les effets sonores importants

Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-4-1

### Question 2 — [4.11] Contrôles accessibles + pas de lecture automatique 🔴 Bloquant

**Vérifie :** Les médias ne démarrent-ils pas automatiquement ? Les contrôles lecture/pause/volume sont-ils accessibles au clavier ?

**Si NON — Correction :**
```html
<%# Ne jamais utiliser autoplay sans mute + controls %>
<%# Mauvais %>
<video autoplay src="..."></video>

<%# Correct : contrôles natifs accessibles %>
<video controls src="...">
  <track kind="subtitles" src="subtitles.vtt" srclang="fr" label="Français">
</video>
```
Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-4-11

---

## Thème 5 — Tableaux (7 critères)

### Question 1 — [5.4] Caption et en-têtes 🟠 Gênant

**Vérifie :** Les tableaux de données ont-ils un `<caption>` descriptif ? Tous les `<th>` ont-ils `scope="col"` ou `scope="row"` ?

**Si NON — Correction :**
```erb
<table>
  <caption>Habilitations en cours par statut et par API</caption>
  <thead>
    <tr>
      <th scope="col">Nom</th>
      <th scope="col">API</th>
      <th scope="col">Statut</th>
    </tr>
  </thead>
  <tbody>
    <% @requests.each do |r| %>
      <tr>
        <th scope="row"><%= r.intitule %></th>
        <td><%= r.api_name %></td>
        <td><%= r.status %></td>
      </tr>
    <% end %>
  </tbody>
</table>
```
Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-5-4

### Question 2 — [5.1] Tableau de mise en page 🟡 Mineur

**Vérifie :** Y a-t-il des `<table>` utilisés pour la mise en page (pas pour des données) ? Si oui, ont-ils `role="presentation"` ?

**Si NON — Correction :**
Préférer CSS flexbox/grid. Si `<table>` de mise en page inévitable :
```html
<table role="presentation">...</table>
```
Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-5-3

---

## Thème 6 — Liens (2 critères)

### Question 1 — [6.1] Intitulés explicites hors contexte 🔴 Bloquant

**Vérifie :** Chaque `link_to` / `<a>` est-il compréhensible sorti de son contexte ? Les « Voir », « Modifier », « Consulter », « Télécharger » répétés sont-ils contextualisés ?

**Si NON — Correction :**
```erb
<%# Mauvais : ambigu hors contexte %>
<%= link_to 'Voir', authorization_path(r) %>

<%# Correct : option 1 — fr-sr-only %>
<%= link_to authorization_path(r) do %>
  Voir
  <span class="fr-sr-only"> l'habilitation <%= r.intitule %></span>
<% end %>

<%# Correct : option 2 — aria-label %>
<%= link_to 'Voir', authorization_path(r),
    aria: { label: "Voir l'habilitation #{r.intitule}" } %>
```
Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-6-1

### Question 2 — [6.1] Liens externes et téléchargements 🟠 Gênant

**Vérifie :** Les liens ouvrant une nouvelle fenêtre ont-ils `target="_blank"` + indication « nouvelle fenêtre » ? Les liens de téléchargement indiquent-ils le format et le poids ?

**Si NON — Correction :**
```erb
<%# Lien externe %>
<%= link_to 'Documentation API', 'https://...', target: '_blank',
    rel: 'noopener external',
    title: 'Documentation API - nouvelle fenêtre',
    class: 'fr-link fr-icon-external-link-line fr-link--icon-right' %>

<%# Lien téléchargement %>
<%= link_to 'Télécharger la convention', convention_path, class: 'fr-link fr-link--download' %>
<span class="fr-link__detail">PDF — 245 Ko</span>
```
Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-6-1

---

## Thème 7 — Scripts (5 critères)

### Question 1 — [7.1] Éléments interactifs natifs 🔴 Bloquant

**Vérifie :** Tous les éléments cliquables custom (Stimulus controllers) sont-ils sur des `<button>` ou `<a>` natifs ? Y a-t-il des `<div onclick>`, `<span onclick>` ou `data-action` sur des éléments non interactifs ?

**Si NON — Correction :**
```erb
<%# Mauvais %>
<div data-action="click->modal#open" class="btn">Ouvrir</div>

<%# Correct %>
<button type="button" data-action="click->modal#open">Ouvrir</button>

<%# Mauvais : lien sans href %>
<span data-action="click->nav#toggle">Menu</span>

<%# Correct %>
<button type="button" data-action="click->nav#toggle"
        aria-expanded="false" aria-controls="main-nav">
  Menu
</button>
```
Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-7-1

### Question 2 — [7.1] Attributs ARIA sur composants dynamiques 🔴 Bloquant

**Vérifie :** Les composants Stimulus (toggle, accordéon, onglets, modale) ont-ils les attributs ARIA requis (`aria-expanded`, `aria-controls`, `aria-selected`, `role`) ?

**Si NON — Correction :**
```erb
<%# Accordéon / toggle %>
<button type="button"
        aria-expanded="false"
        aria-controls="section-<%= id %>"
        data-action="click->accordion#toggle">
  <%= title %>
</button>
<div id="section-<%= id %>" hidden>
  <%= content %>
</div>

<%# Modale %>
<dialog aria-labelledby="dialog-title-<%= id %>"
        aria-modal="true"
        data-modal-target="dialog">
  <h2 id="dialog-title-<%= id %>"><%= title %></h2>
  <button type="button" aria-label="Fermer"
          data-action="click->modal#close">
    <span class="fr-icon-close-line" aria-hidden="true"></span>
  </button>
</dialog>
```
Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-7-1

### Question 3 — [7.3] Gestion du focus et annonces après Turbo 🟠 Gênant

**Vérifie :** Après un Turbo Stream, une navigation Turbo Drive ou une action ajax, le focus est-il repositionné et les changements sont-ils annoncés aux lecteurs d'écran ?

**Si NON — Correction :**
```erb
<%# Live region pour les annonces Turbo %>
<div id="flash-region" role="status" aria-live="polite" aria-atomic="true">
  <%= turbo_stream.replace "flash-region" do %>
    <p>Habilitation mise à jour avec succès.</p>
  <% end %>
</div>

<%# Repositionner le focus après Turbo navigation %>
```
```javascript
// stimulus controller
afterNavigate() {
  document.querySelector('h1')?.focus()
}
```
Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-7-3

---

## Thème 8 — Éléments obligatoires (9 critères)
> Mode page uniquement. En mode composant, ces critères sont listés dans « Limites du mode composant ».

### Question 1 — [8.3 / 8.4] Langue de la page 🟠 Gênant

**Vérifie :** `<html lang="fr">` est-il présent dans `application.html.erb` ? Les passages en langue étrangère sont-ils marqués `lang` ?

**Si NON — Correction :**
```erb
<%# application.html.erb %>
<html lang="fr">

<%# Passage en langue étrangère dans une vue %>
<p>Ce service respecte le
  <span lang="en">General Data Protection Regulation</span> (RGPD).
</p>
```
Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-8-3

### Question 2 — [8.5 / 8.6] Titre de page unique et descriptif 🟠 Gênant

**Vérifie :** Chaque page a-t-elle un `<title>` unique et descriptif (pas juste « DataPass ») via `content_for :title` ou `provide` ?

**Si NON — Correction :**
```erb
<%# application.html.erb %>
<title><%= content_for?(:title) ? "#{yield(:title)} — DataPass" : 'DataPass' %></title>

<%# Dans chaque vue %>
<% provide(:title, "Nouvelle habilitation API Particulier") %>
<%# → titre final : "Nouvelle habilitation API Particulier — DataPass" %>
```
Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-8-5

---

## Thème 9 — Structuration de l'information (5 critères)

### Question 1 — [9.1] Hiérarchie des titres 🔴 Bloquant

**Vérifie :** Y a-t-il un seul `<h1>` par page ? La hiérarchie est-elle sans saut (h1→h2→h3, jamais h1→h3) ? Les ViewComponents n'introduisent-ils pas de rupture ?

**Si NON — Correction :**
```erb
<%# Layout / page %>
<h1><%= @page_title %></h1>  <%# Un seul h1 par page %>

<%# Section principale %>
<h2>Informations générales</h2>
  <h3>Contacts</h3>   <%# Sous-section du h2, pas de saut %>

<%# ViewComponent : utiliser un niveau paramétrable %>
<%# app/components/section_component.rb %>
# def initialize(heading_level: 2)
#   @heading_level = heading_level
# end
<%= content_tag "h#{@heading_level}", @title %>
```
Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-9-1

### Question 2 — [9.2] Landmarks et navigation 🟠 Gênant

**Vérifie :** Les landmarks HTML5 sont-ils présents (`<header>`, `<nav>`, `<main>`, `<footer>`) ? Si plusieurs `<nav>`, chacun a-t-il un `aria-label` distinct ?

**Si NON — Correction :**
```erb
<%# application.html.erb %>
<header>
  <nav aria-label="Navigation principale">...</nav>
</header>
<main id="main">
  <%= yield %>
</main>
<footer>...</footer>

<%# Fil d'ariane : nav distinct avec aria-label %>
<nav aria-label="Fil d'Ariane">
  <ol>
    <li><%= link_to 'Accueil', root_path %></li>
    <li aria-current="page"><%= @page_title %></li>
  </ol>
</nav>
```
Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-9-2

### Question 3 — [9.3] Listes sémantiques 🟡 Mineur

**Vérifie :** Les listes d'items (cartes, résultats de recherche, étapes) sont-elles des `<ul>`/`<ol>` (pas une suite de `<div>`) ?

**Si NON — Correction :**
```erb
<%# Mauvais %>
<div class="cards">
  <% @requests.each do |r| %>
    <div class="card"><%= r.intitule %></div>
  <% end %>
</div>

<%# Correct %>
<ul class="fr-cards-group">
  <% @requests.each do |r| %>
    <li><%= render Cards::RequestComponent.new(request: r) %></li>
  <% end %>
</ul>
```
Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-9-3

---

## Thème 10 — Présentation de l'information (14 critères)

### Question 1 — [10.7] Focus visible 🔴 Bloquant

**Vérifie :** Le focus clavier est-il toujours visible ? Y a-t-il des `outline: none` ou `outline: 0` sans alternative `:focus-visible` ?

**Si NON — Correction :**
```css
/* Mauvais */
:focus { outline: none; }
button:focus { outline: 0; }

/* Correct : focus-visible personnalisé */
:focus-visible {
  outline: 2px solid #0a76f6;
  outline-offset: 2px;
}

/* DSFR gère le focus nativement — ne pas l'écraser */
```
Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-10-7

### Question 2 — [10.4 / 10.11] Zoom 200% et reflow 320px 🔴 Bloquant

**Vérifie :** À zoom 200% (Cmd++ × 6), le contenu est-il lisible sans scroll horizontal et sans texte tronqué ? Les hauteurs fixes avec `overflow: hidden` sont-elles évitées sur les textes ?

**Si NON :**
```css
/* Mauvais : hauteur fixe sur un texte %>
.card { height: 80px; overflow: hidden; }

/* Correct : min-height ou pas de contrainte hauteur %>
.card { min-height: 80px; }

/* Éviter les unités px pour les tailles de texte %>
/* Préférer rem (respecte les préférences navigateur) %>
font-size: 1rem; /* pas font-size: 16px */
```

**À vérifier manuellement :**
- [ ] Cmd++ × 6 dans Chrome/Firefox : aucun texte coupé, pas de scroll horizontal
- [ ] Simuler 320px de large (DevTools) : le contenu s'adapte sans scroll horizontal

Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-10-4

### Question 3 — [10.1] Information portée par CSS seul 🟡 Mineur

**Vérifie :** Y a-t-il des informations véhiculées uniquement via CSS `content:` (ex : champs obligatoires signalés par `::after { content: ' *' }`) ?

**Si NON — Correction :**
```erb
<%# Mauvais : info uniquement en CSS %>
<%# .required::after { content: ' *'; color: red; } %>

<%# Correct : info dans le HTML %>
<label for="email">
  Adresse e-mail
  <span aria-hidden="true"> *</span>
  <span class="fr-sr-only">(obligatoire)</span>
</label>
```
Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-10-1

---

## Thème 11 — Formulaires (13 critères)

### Question 1 — [11.1 / 11.2] Labels et groupes 🔴 Bloquant

**Vérifie :** Chaque champ (`<input>`, `<select>`, `<textarea>`) a-t-il un `<label for>` visible (pas juste un `placeholder`) ? Les groupes radio/checkbox sont-ils dans `<fieldset><legend>` ?

**Si NON — Correction :**
```erb
<%# DSFRFormBuilder gère les labels automatiquement — préférer %>
<%= f.input :email, label: 'Adresse e-mail', hint: 'Format : nom@domaine.fr' %>

<%# Sans DSFRFormBuilder %>
<label for="user_email">
  Adresse e-mail
  <span class="fr-hint-text">Format : nom@domaine.fr</span>
</label>
<input type="email" id="user_email" name="user[email]">

<%# Groupe radio %>
<fieldset class="fr-fieldset">
  <legend class="fr-fieldset__legend">Civilité</legend>
  <div class="fr-fieldset__element">
    <div class="fr-radio-group">
      <input type="radio" id="civility_m" name="civility" value="m">
      <label for="civility_m">M.</label>
    </div>
  </div>
</fieldset>
```
Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-11-1

### Question 2 — [11.3 / 11.4] Gestion des erreurs 🔴 Bloquant

**Vérifie :** Les erreurs de validation sont-elles liées au champ via `aria-describedby` + `aria-invalid="true"` ? Le message suggère-t-il une correction ? Le focus revient-il sur le premier champ en erreur après soumission ?

**Si NON — Correction :**
```erb
<%# DSFRFormBuilder avec erreurs Rails %>
<%= f.input :email,
    label: 'Adresse e-mail',
    error: @user.errors[:email].first %>
<%# → génère automatiquement aria-invalid + aria-describedby %>

<%# Sans DSFRFormBuilder %>
<% if @user.errors[:email].any? %>
  <label for="user_email" class="fr-label">Adresse e-mail</label>
  <input type="email" id="user_email"
         aria-invalid="true"
         aria-describedby="user_email_error">
  <p id="user_email_error" class="fr-error-text">
    <%= @user.errors[:email].first %>
  </p>
<% end %>

<%# Focus sur le premier champ en erreur après soumission %>
<%# Dans le controller ou via Turbo : %>
```
```javascript
// Après rendu de la page avec erreurs
document.querySelector('[aria-invalid="true"]')?.focus()
```
Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-11-3

### Question 3 — [11.13] Autocomplétion des données personnelles 🟡 Mineur

**Vérifie :** Les champs de données personnelles (nom, prénom, email, téléphone, organisation) ont-ils l'attribut `autocomplete` approprié ?

**Si NON — Correction :**
```erb
<input type="text"  autocomplete="given-name">    <%# Prénom %>
<input type="text"  autocomplete="family-name">   <%# Nom %>
<input type="email" autocomplete="email">
<input type="tel"   autocomplete="tel">
<input type="text"  autocomplete="organization">
<input type="text"  autocomplete="street-address">
```
Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-11-13

---

## Thème 12 — Navigation (11 critères)
> Mode page uniquement. En mode composant, ces critères sont listés dans « Limites du mode composant ».

### Question 1 — [12.11] Liens d'évitement 🔴 Bloquant

**Vérifie :** Les liens d'évitement (« Aller au contenu principal », « Aller à la navigation ») sont-ils le premier élément focusable du `<body>` dans `application.html.erb` ?

**Si NON — Correction :**
```erb
<%# application.html.erb — avant tout autre contenu %>
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

### Question 2 — [12.2] Page courante identifiée 🟠 Gênant

**Vérifie :** La page courante est-elle indiquée dans le menu principal avec `aria-current="page"` ?

**Si NON — Correction :**
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

### Question 3 — [12.1] Plusieurs systèmes de navigation 🟡 Mineur

**Vérifie :** Y a-t-il au moins deux moyens de navigation parmi : menu principal, moteur de recherche, fil d'Ariane, plan du site ?

**À vérifier manuellement :**
- [ ] Menu principal présent
- [ ] Fil d'Ariane sur les pages intérieures
- [ ] Moteur de recherche ou lien vers plan du site (si applicable)

Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-12-1

---

## Thème 13 — Consultation (12 critères)

### Question 1 — [13.1] Limite de temps et session 🔴 Bloquant

**Vérifie :** Si la session a une limite de temps (formulaire long, session authentifiée), l'utilisateur peut-il la prolonger avant expiration ? Un avertissement est-il affiché avant la déconnexion ?

**Si NON — Correction :**
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

### Question 2 — [13.3 / 13.4] Documents en téléchargement 🟠 Gênant

**Vérifie :** Les PDF et documents téléchargeables (CGU, attestations, conventions) sont-ils accessibles ? Ou une version HTML/texte est-elle proposée en alternative ?

**À vérifier manuellement :**
- [ ] Ouvrir le PDF dans Adobe Acrobat Reader → Affichage > Outils > Accessibilité > Vérification complète
- [ ] Ou proposer une alternative : version HTML sur la même page, ou lien « Version accessible sur demande » avec contact

Voir [fallbacks.md](../rgaa-dev/fallbacks.md) §PDF pour les alternatives acceptables.

Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-13-3

### Question 3 — [13.7 / 13.8] Animations et contenus en mouvement 🟠 Gênant

**Vérifie :** Les animations et carrousels qui démarrent automatiquement ont-ils un bouton pause/stop ? `prefers-reduced-motion` est-il respecté ?

**Si NON — Correction :**
```css
/* Respecter les préférences utilisateur */
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
          data-carousel-target="pauseBtn"
          aria-label="Mettre le carrousel en pause">
    <span class="fr-icon-pause-line" aria-hidden="true"></span>
  </button>
</div>
```
Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-13-7