# AIMLAB — projet GitHub Pages + Supabase

Projet statique prêt à publier : jeu Aim Trainer, profil joueur, photo, coins, shop, rangs et classement partagé en ligne. **Les scores en ligne nécessitent maintenant un compte Supabase Auth (email + mot de passe).**

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

- Les pseudos sont publics et uniques sans distinction majuscule/minuscule. Les anciens profils sans compte restent visibles mais sont verrouillés et ne sont pas attribués automatiquement à un nouvel utilisateur.
- Pour enregistrer de nouveaux scores en ligne, ouvre le profil puis choisis **Create account** ou **Sign in** (email + mot de passe). Selon la configuration Supabase Auth, il peut être nécessaire de confirmer ton email.
- Sans connexion, le jeu reste jouable et la progression reste locale à cet appareil.
- La base `public.players` associe les nouveaux profils à `auth.users.id` par `user_id` et RLS n'autorise que le propriétaire à modifier sa ligne.
- Les scores sont calculés dans le navigateur : cette version protège la propriété des profils mais **n'empêche pas la triche**. Une compétition sécurisée nécessite une validation côté serveur.
- Les photos sont redimensionnées dans le navigateur et stockées dans la colonne `pic` de la base. Pour un grand nombre de joueurs, il sera préférable de migrer les images vers Supabase Storage.
- La clé publique Supabase peut être visible dans le code du site : c'est normal. La sécurité repose sur les règles RLS de la base, jamais sur le fait de cacher cette clé.

## En Darija

1. Sayiib projet f Supabase.
2. Sir l SQL Editor, 7ell `supabase_setup.sql`, copier kolchi w dir Run.
3. Jib Project URL w anon/publishable key, 7ethom f `index.html` f blasst `YOUR_...`.
4. Uploadi ga3 dossier l GitHub, khlli `index.html` f root.
5. F GitHub: Settings → Pages → Deploy from a branch → `main` → `/ (root)` → Save.
6. L3ab o l Leaderboard yban l nass kamlin. Bach t7fed score online khass compte w tconfirmi email ila talab Supabase. L profiles l9dam kayb9aw f leaderboard mais m7myin men modification.

**Mat7ettch `service_role` key f HTML.**

## Migration existante (2026-11-04)

La migration de sécurité a été appliquée au projet AIMLAB : elle a conservé les cinq anciens profils, placé une sauvegarde dans le schéma privé `aimlab_private_backup` et fermé les policies anonymes INSERT/UPDATE. Ne pas retirer `user_id` ou réouvrir ces anciennes policies. La clé publique dans `index.html` n'est pas une clé secrète.
