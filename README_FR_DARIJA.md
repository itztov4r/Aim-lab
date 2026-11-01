# AIMLAB — projet GitHub Pages + Supabase

Projet statique prêt à publier : jeu Aim Trainer, profil joueur, photo, coins, shop, rangs et classement partagé en ligne.

## Contenu du dossier

- `index.html` : le site complet.
- `supabase_setup.sql` : création de la table et des règles d'accès Supabase.
- `assets/favicon.svg` : icône de l'onglet.
- `assets/aimlab-mark.svg` : logo AIMLAB.
- `assets/arena-pattern.svg` : motif graphique fourni pour personnalisation.
- `assets/aimlab-preview.png` : aperçu visuel du concept.

## 1. Créer la base de données

1. Crée un compte/projet sur https://supabase.com/dashboard.
2. Ouvre **SQL Editor** puis **New query**.
3. Copie tout le contenu de `supabase_setup.sql`, colle-le et clique sur **Run**.
4. Dans **Project Settings → API** (ou **Connect** selon l'interface), copie le **Project URL** et la clé publique **anon / publishable**.

## 2. Connecter le site

Ouvre `index.html` avec un éditeur de texte (VS Code ou Notepad) et cherche :

```js
const SUPABASE_URL = "YOUR_SUPABASE_PROJECT_URL";
const SUPABASE_ANON_KEY = "YOUR_SUPABASE_ANON_KEY";
```

Remplace les deux valeurs par celles de TON projet Supabase, puis enregistre le fichier.

**Sécurité :** n'insère jamais la clé `service_role` ou une clé `secret` dans le HTML. Seule la clé publique anon/publishable est destinée au navigateur.

## 3. Publier sur GitHub Pages

1. Crée un dépôt GitHub, par exemple `aimlab`.
2. Envoie tous les fichiers et dossiers de ce projet dans le dépôt. `index.html` doit être à la racine, pas dans un sous-dossier.
3. Ouvre **Settings → Pages**.
4. Dans **Build and deployment**, choisis **Deploy from a branch**.
5. Choisis la branche `main` et le dossier `/ (root)`, puis **Save**.
6. Attends le déploiement et ouvre l'adresse GitHub Pages affichée.

## 4. Tester le classement partagé

- Ouvre le site publié dans une fenêtre normale, choisis un pseudo et une photo, puis joue une partie.
- Ouvre ensuite le même site dans un autre navigateur ou sur un autre appareil : le classement doit afficher le même joueur et son meilleur score.
- Le classement se rafraîchit automatiquement toutes les 10 secondes.

## Notes importantes

- Les pseudos sont publics et uniques sans distinction majuscule/minuscule.
- Cette version ne demande pas de compte : le pseudo sert d'identifiant. Un autre visiteur peut essayer d'utiliser le pseudo de quelqu'un. Pour une vraie identité protégée, il faudra ajouter Supabase Auth.
- Comme le jeu et le calcul du score tournent dans le navigateur, un classement public sans serveur de validation n'est pas anti-triche. Ne considère pas les scores comme une compétition officielle sécurisée.
- Les photos sont redimensionnées dans le navigateur et stockées dans la colonne `pic` de la base. Pour un grand nombre de joueurs, il sera préférable de migrer les images vers Supabase Storage.
- La clé publique Supabase peut être visible dans le code du site : c'est normal. La sécurité repose sur les règles RLS de la base, jamais sur le fait de cacher cette clé.

## En Darija

1. Sayiib projet f Supabase.
2. Sir l SQL Editor, 7ell `supabase_setup.sql`, copier kolchi w dir Run.
3. Jib Project URL w anon/publishable key, 7ethom f `index.html` f blasst `YOUR_...`.
4. Uploadi ga3 dossier l GitHub, khlli `index.html` f root.
5. F GitHub: Settings → Pages → Deploy from a branch → `main` → `/ (root)` → Save.
6. Jarrab b navigateur akhor: ila kolchi mzyan, ghadi tchouf nafs Leaderboard.

**Mat7ettch `service_role` key f HTML.**
