# Références RGAA — Thème 11 : Formulaires (13 critères)

---

### 11.1 / 11.2 — Labels et groupes 🔴 Bloquant

**Détecter :** `<input>`, `<select>`, `<textarea>` sans `<label for>` visible ni `aria-label` ; placeholder seul sans label ; groupe radio/checkbox sans `<fieldset><legend>`

**Non-conformité type :**
```erb
<input type="email" placeholder="Votre email">    <%# placeholder seul, pas de label %>
<input type="radio" name="civility" value="m"> M. <%# radio sans fieldset/legend %>
```

**Correction :**
```erb
<%# DSFRFormBuilder — préférer %>
<%= f.input :email, label: 'Adresse e-mail', hint: 'Format : nom@domaine.fr' %>

<%# Sans DSFRFormBuilder %>
<label for="user_email">
  Adresse e-mail
  <span class="fr-hint-text">Format : nom@domaine.fr</span>
</label>
<input type="email" id="user_email" name="user[email]">

<%# Groupe radio — fieldset obligatoire %>
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

---

### 11.3 / 11.4 — Gestion des erreurs 🔴 Bloquant

**Détecter :** message d'erreur visible mais sans `aria-describedby` sur le champ ; champ en erreur sans `aria-invalid="true"` ; erreur sans suggestion de correction

**Non-conformité type :**
```erb
<input type="email" id="user_email">
<p class="error">Format invalide</p>    <%# non lié au champ %>
```

**Correction :**
```erb
<%# DSFRFormBuilder avec erreurs Rails %>
<%= f.input :email,
    label: 'Adresse e-mail',
    error: @user.errors[:email].first %>
<%# → génère automatiquement aria-invalid + aria-describedby %>

<%# Sans DSFRFormBuilder %>
<input type="email" id="user_email"
       aria-invalid="true"
       aria-describedby="user_email_error">
<p id="user_email_error" class="fr-error-text">
  <%= @user.errors[:email].first %>
</p>
```
```javascript
// Focus sur le premier champ en erreur après soumission
document.querySelector('[aria-invalid="true"]')?.focus()
```

Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-11-3

---

### 11.10 — Champs obligatoires 🔴 Bloquant

**Détecter :** champ obligatoire sans `required` (ou `aria-required="true"`) ; obligation signalée uniquement par la couleur ou un `*` sans explication

**Non-conformité type :**
```erb
<input type="email" id="email">    <%# requis visuellement mais sans required %>
```

**Correction :**
```erb
<label for="email">
  Adresse e-mail
  <span aria-hidden="true"> *</span>
</label>
<input type="email" id="email" required aria-required="true">
<p class="fr-hint-text">Les champs marqués d'un * sont obligatoires.</p>
```

Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-11-10

---

### 11.13 — Autocomplétion des données personnelles 🟡 Mineur

**Détecter :** `<input>` collectant des données personnelles (nom, prénom, email, tél, organisation) sans attribut `autocomplete`

**Correction :**
```erb
<input type="text"  autocomplete="given-name">     <%# Prénom %>
<input type="text"  autocomplete="family-name">    <%# Nom %>
<input type="email" autocomplete="email">
<input type="tel"   autocomplete="tel">
<input type="text"  autocomplete="organization">
<input type="text"  autocomplete="street-address">
```

Lien RGAA : https://accessibilite.numerique.gouv.fr/methode/criteres-et-tests/#critere-11-13