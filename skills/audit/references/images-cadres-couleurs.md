# Références RGAA — Thèmes 1 à 3 : Images, Cadres, Couleurs

---

## Thème 1 — Images (9 critères)

### 1.1 / 1.2 — Alternatives textuelles 🔴 Bloquant

**Détecter :** `image_tag` sans `alt:` ; `<img>` sans `alt` ; `alt=""` sur image informative ; `alt` absent (différent de `alt=""`)

**Non-conformité type Rails :**
```erb
<%= image_tag 'logo.png' %>                      <%# alt absent %>
<%= image_tag 'chart.png', alt: '' %>            <%# alt vide sur image informative %>
```

**Correction :**
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

---

### 1.1 — SVG et icônes DSFR 🔴 Bloquant

**Détecter :** `<svg>` sans `aria-hidden="true"` sur élément décoratif ; `fr-icon-*` dans un bouton ou lien sans texte ni `aria-label` ; `<svg>` informatif sans `role="img"` + alternative

**Non-conformité type :**
```html
<svg>...</svg>                                    <!-- décoratif, aria-hidden manquant -->
<button><span class="fr-icon-close-line"></span></button>  <!-- icône seule sans label -->
```

**Correction :**
```html
<%# Icône décorative DSFR %>
<span class="fr-icon-arrow-right-line" aria-hidden="true"></span>

<%# SVG décoratif %>
<svg aria-hidden="true" focusable="false">...</svg>

<%# SVG informatif %>
<svg role="img" aria-label="Répartition des habilitations par statut">
  <title>Répartition des habilitations par statut</title>
</svg>

<%# Bouton avec icône seule %>
<button type="button" aria-label="Fermer">
  <span class="fr-icon-close-line" aria-hidden="true"></span>
</button>
```

Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-1-1

---

### 1.6 / 1.7 — Images texte 🟠 Majeur

**Détecter :** `<img>` contenant du texte visible (capture d'écran, bouton en image, logo textuel) sans équivalent HTML

**Correction :**
Ne jamais créer d'image contenant du texte. Utiliser du texte HTML stylé. Si héritage impossible, fournir l'équivalent dans l'`alt`.

Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-1-6

---

## Thème 2 — Cadres (2 critères)

### 2.1 — Titre des iframes 🟠 Majeur

**Détecter :** `<iframe>` sans attribut `title` ou `title` vide

**Non-conformité type :**
```html
<iframe src="https://..."></iframe>
```

**Correction :**
```html
<iframe src="https://..." title="Carte de localisation des services"></iframe>
<iframe src="https://..." title="Vidéo de présentation du service"></iframe>
```

Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-2-1

---

## Thème 3 — Couleurs (3 critères)

### 3.1 — Information par la couleur seule 🔴 Bloquant

**Détecter :** badge sans texte de statut, lien sans soulignement dans du texte courant, champ obligatoire signalé uniquement par `color: red`

**Non-conformité type :**
```erb
<span class="badge-red"></span>       <%# statut uniquement par couleur %>
```

**Correction :**
```erb
<%# Badge statut : couleur + texte %>
<span class="fr-badge fr-badge--error">Refusée</span>

<%# Champ obligatoire : indiquer textuellement %>
<p>Les champs marqués d'un <span aria-hidden="true">*</span>
   <span class="fr-sr-only">astérisque</span> sont obligatoires.</p>
```

Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-3-1

---

### 3.2 / 3.3 — Contrastes des composants custom 🟠 Majeur

**Détecter :** classes CSS custom hors DSFR définissant des couleurs de texte ou de fond — les tokens DSFR sont validés, les dérives viennent des customisations.

**Règles :**
- Texte normal (< 24px) : ratio ≥ 4.5:1
- Grand texte (≥ 24px ou ≥ 18.5px gras) : ratio ≥ 3:1
- Composants UI (bordure input, outline focus, icônes informatives) : ratio ≥ 3:1

**Outil :** https://contrast-finder.tanaguru.com/ — voir aussi [colors.md](../../rgaa-dev/colors.md)

Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-3-2
