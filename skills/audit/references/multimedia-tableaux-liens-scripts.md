# Références RGAA — Thèmes 4 à 7 : Multimédia, Tableaux, Liens, Scripts

---

## Thème 4 — Multimédia (13 critères)

> Si aucun `<video>` ni `<audio>` détecté → thème NA.

### 4.1 / 4.2 — Transcription et sous-titres 🔴 Bloquant

**Détecter :** `<video>` ou `<audio>` sans `<track kind="subtitles">` ni lien vers transcription

**À vérifier manuellement :**
- [ ] Transcription textuelle accessible sur la même page ou via lien adjacent
- [ ] Fichier de sous-titres `.vtt` ou `.srt` attaché à la `<video>`
- [ ] Sous-titres fidèles (pas de résumé), incluant les effets sonores importants

Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-4-1

---

### 4.11 — Contrôles accessibles + pas de lecture automatique 🔴 Bloquant

**Détecter :** `<video autoplay>` sans `muted` ni `controls` ; lecteur custom sans contrôles focusables

**Non-conformité type :**
```html
<video autoplay src="..."></video>
```

**Correction :**
```html
<video controls src="...">
  <track kind="subtitles" src="subtitles.vtt" srclang="fr" label="Français">
</video>
```

Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-4-11

---

## Thème 5 — Tableaux (7 critères)

### 5.4 — Caption et en-têtes 🟠 Majeur

**Détecter :** `<table>` sans `<caption>` ni `aria-label` ; `<th>` sans attribut `scope`

**Non-conformité type :**
```erb
<table>
  <tr><th>Nom</th><th>Statut</th></tr>    <%# th sans scope %>
</table>
```

**Correction :**
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

---

### 5.3 — Tableau de mise en page 🟡 Mineur

**Détecter :** `<table>` sans données structurées (utilisé pour la mise en page) sans `role="presentation"`

**Correction :**
Préférer CSS flexbox/grid. Si `<table>` de mise en page inévitable :
```html
<table role="presentation">...</table>
```

Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-5-3

---

## Thème 6 — Liens (2 critères)

### 6.1 — Intitulés explicites hors contexte 🔴 Bloquant

**Détecter :** `link_to 'Voir'`, `link_to 'Modifier'`, `link_to 'Supprimer'`, `link_to 'Consulter'` sans `aria-label` contextuel ; URL brute comme texte de lien ; `target: '_blank'` sans indication dans l'intitulé accessible

**Non-conformité type :**
```erb
<%= link_to 'Voir', authorization_path(r) %>                  <%# ambigu hors contexte %>
<%= link_to data_provider.link, data_provider.link %>          <%# URL brute comme texte %>
<%= link_to 'Doc', url, target: '_blank', title: 'Doc - nouvelle fenêtre' %>  <%# title seul insuffisant %>
```

**Correction :**
```erb
<%# Option 1 — fr-sr-only %>
<%= link_to authorization_path(r) do %>
  Voir
  <span class="fr-sr-only"> l'habilitation <%= r.intitule %></span>
<% end %>

<%# Option 2 — aria-label %>
<%= link_to 'Voir', authorization_path(r),
    aria: { label: "Voir l'habilitation #{r.intitule}" } %>

<%# Lien externe : nom + nouvelle fenêtre dans le contenu %>
<%= link_to data_provider.link, target: '_blank', rel: 'noopener external' do %>
  <%= data_provider.name %>
  <span class="fr-sr-only"> - <%= t('shared.new_window') %></span>
<% end %>
```

Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-6-1

---

### 6.2 — Lien sans intitulé 🔴 Bloquant

**Détecter :** `<a>` ou `link_to` sans texte visible, sans `aria-label`, sans `alt` sur image enfant

**Non-conformité type :**
```erb
<%= link_to authorization_path(r) do %>
  <span class="fr-icon-arrow-right-line"></span>    <%# icône seule sans label %>
<% end %>
```

**Correction :**
```erb
<%= link_to authorization_path(r),
    aria: { label: "Voir l'habilitation #{r.intitule}" } do %>
  <span class="fr-icon-arrow-right-line" aria-hidden="true"></span>
<% end %>
```

Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-6-2

---

### Nom accessible et nom visible — quand la règle NE s'applique PAS

**Règle (WCAG 2.5.3, pilotage vocal) :** quand un élément interactif a un **intitulé visible** (texte affiché), son **nom accessible** doit reprendre ce texte — sinon une personne qui pilote à la voix ne peut pas l'activer en prononçant ce qu'elle voit.

**Condition de non-applicabilité (NA) :** si l'élément n'a **pas d'intitulé visible** — par exemple un lien réseau social représenté par une **icône seule** — la règle ne s'applique pas. Il n'y a aucun texte visible à reprendre ; l'utilisateur active l'élément par d'autres commandes vocales. Exiger ici que le `aria-label` corresponde à un libellé visible inexistant est une **fausse NC**.

> Ne pas confondre avec 6.2 : une icône seule **sans** `aria-label` ni texte est bien une NC (l'élément n'a aucun nom accessible). La NA ci-dessus concerne uniquement la règle « nom visible repris dans le nom accessible ».

---

## Thème 7 — Scripts (5 critères)

### 7.1 — Éléments interactifs natifs 🔴 Bloquant

**Détecter :** `<div data-action="click->...">`, `<span data-action="click->...">` — éléments non-interactifs avec gestionnaire de clic

**Non-conformité type :**
```erb
<div data-action="click->modal#open" class="btn">Ouvrir</div>
```

**Correction :**
```erb
<button type="button" data-action="click->modal#open">Ouvrir</button>

<button type="button" data-action="click->nav#toggle"
        aria-expanded="false" aria-controls="main-nav">
  Menu
</button>
```

Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-7-1

---

### 7.1 — Attributs ARIA sur composants dynamiques 🔴 Bloquant

**Détecter :** composant Stimulus (toggle, accordéon, onglets, modale) sans `aria-expanded`, `aria-controls`, `aria-selected`, `role` appropriés

**Correction :**
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

---

### 7.3 — Focus et annonces après Turbo 🟠 Majeur

**Détecter :** `turbo_stream`, navigation Turbo Drive, action ajax sans gestion du focus ni live region

**Correction :**
```erb
<%# Live region pour les annonces Turbo %>
<div id="flash-region" role="status" aria-live="polite" aria-atomic="true">
  <%= turbo_stream.replace "flash-region" do %>
    <p>Habilitation mise à jour avec succès.</p>
  <% end %>
</div>
```
```javascript
// Repositionner le focus après navigation Turbo
afterNavigate() {
  document.querySelector('h1')?.focus()
}
```

Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-7-3
