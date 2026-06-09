# Références RGAA — Thèmes 8 à 10 : Éléments obligatoires, Structuration, Présentation

---

## Thème 8 — Éléments obligatoires (9 critères)

> Mode page uniquement. En mode composant, ces critères sont listés dans « Limites du mode composant ».

### 8.3 / 8.4 — Langue de la page 🟠 Majeur

**Détecter :** `<html>` sans attribut `lang` dans `application.html.erb` ; passages en langue étrangère sans `lang`

**Non-conformité type :**
```html
<html>  <!-- lang absent -->
```

**Correction :**
```erb
<%# application.html.erb %>
<html lang="fr">

<%# Passage en langue étrangère %>
<p>Ce service respecte le
  <span lang="en">General Data Protection Regulation</span> (RGPD).
</p>
```

Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-8-3

---

### 8.5 / 8.6 — Titre de page unique et descriptif 🔴 Bloquant

**Détecter :** `set_title!` absent en mode page (→ question runtime) ; `<title>` générique identique sur toutes les pages

**Correction :**
```erb
<%# application.html.erb %>
<title><%= page_title %></title>

<%# Dans chaque vue — utiliser set_title! %>
<% set_title! t('.title') %>
<%# → titre final : "Nom de la page - NomDuSite" %>
```

**Note :** Dans DataPass, le layout admin appelle automatiquement `set_title!` via `t("admin.#{controller_name}.#{action_name}.title")`. Vérifier que la clé de traduction existe.

Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-8-5

---

## Thème 9 — Structuration de l'information (5 critères)

### 9.1 — Hiérarchie des titres 🔴 Bloquant

**Détecter :** plusieurs `<h1>` sur la même page ; saut de niveau (h1→h3 sans h2) ; `<h2>` à `<h6>` utilisé pour le style sans signification de titre

**Non-conformité type :**
```erb
<h1>Page title</h1>
<h3>Section</h3>    <%# saut h1→h3 %>
```

**Correction :**
```erb
<%# Layout / page : un seul h1 %>
<h1><%= @page_title %></h1>

<h2>Informations générales</h2>
  <h3>Contacts</h3>

<%# ViewComponent : niveau paramétrable %>
<%= content_tag "h#{@heading_level}", @title %>
```

Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-9-1

---

### 9.2 — Landmarks et navigation 🟠 Majeur

**Détecter :** absence de `<main>` ; plusieurs `<nav>` sans `aria-label` distincts ; `<header>` / `<footer>` absents du layout

**Correction :**
```erb
<%# application.html.erb %>
<header>
  <nav aria-label="Navigation principale">...</nav>
</header>
<main id="main">
  <%= yield %>
</main>
<footer>...</footer>

<%# Fil d'ariane : nav distinct %>
<nav aria-label="Fil d'Ariane">
  <ol>
    <li><%= link_to 'Accueil', root_path %></li>
    <li aria-current="page"><%= @page_title %></li>
  </ol>
</nav>
```

Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-9-2

---

### 9.3 — Listes sémantiques 🟡 Mineur

**Détecter :** suite de `<div>` ou `<span>` répétés rendant une liste d'items (cartes, résultats, étapes) sans `<ul>`/`<ol>`

**Non-conformité type :**
```erb
<div class="cards">
  <% @requests.each do |r| %>
    <div class="card"><%= r.intitule %></div>
  <% end %>
</div>
```

**Correction :**
```erb
<ul class="fr-cards-group">
  <% @requests.each do |r| %>
    <li><%= render Cards::RequestComponent.new(request: r) %></li>
  <% end %>
</ul>
```

Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-9-3

---

## Thème 10 — Présentation de l'information (14 critères)

### 10.7 — Focus visible 🔴 Bloquant

**Détecter :** `outline: none`, `outline: 0` dans le CSS sans `:focus-visible` de remplacement

**Non-conformité type :**
```css
:focus { outline: none; }
button:focus { outline: 0; }
```

**Correction :**
```css
/* DSFR gère le focus nativement — ne pas l'écraser */
/* Si customisation nécessaire : */
:focus-visible {
  outline: 2px solid #0a76f6;
  outline-offset: 2px;
}
```

Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-10-7

---

### 10.4 / 10.11 — Zoom 200% et reflow 320px 🔴 Bloquant

**Détecter :** hauteur fixe en `px` avec `overflow: hidden` sur des conteneurs de texte ; unités `px` pour les tailles de police

**Non-conformité type :**
```css
.card { height: 80px; overflow: hidden; }
font-size: 16px;
```

**Correction :**
```css
.card { min-height: 80px; }         /* min-height au lieu de height fixe */
font-size: 1rem;                     /* rem respecte les préférences navigateur */
```

**À vérifier manuellement :**
- [ ] Cmd++ × 6 dans Chrome/Firefox : aucun texte coupé, pas de scroll horizontal
- [ ] Simuler 320px de large (DevTools) : contenu lisible sans scroll horizontal

Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-10-4

---

### 10.1 — Information portée par CSS seul 🟡 Mineur

**Détecter :** `content:` CSS portant une information (astérisque obligatoire, symbole de statut) sans équivalent HTML

**Non-conformité type :**
```css
.required::after { content: ' *'; color: red; }
```

**Correction :**
```erb
<label for="email">
  Adresse e-mail
  <span aria-hidden="true"> *</span>
  <span class="fr-sr-only">(obligatoire)</span>
</label>
```

Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-10-1
