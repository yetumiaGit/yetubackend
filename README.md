# 🌍 Yetumia — African Language Intelligence Platform

**Yetumia** est un projet technologique et linguistique visant à créer un **dictionnaire intelligent multi-langues** et, à long terme, une **IA vocale** dédiée aux langues et dialectes africains sous-représentés dans les technologies actuelles.

L’objectif est de **réduire le fossé technologique** en donnant aux communautés locales un accès à des outils linguistiques modernes.

[![Website](https://img.shields.io/badge/Visiter_Yetumia-www.yetumia.com-4CAF50?style=for-the-badge&logo=world&logoColor=white)](http://www.yetumia.com)
[![GitHub](https://img.shields.io/badge/GitHub-Repository-181717?style=for-the-badge&logo=github)](https://github.com/your-username/yetumia)

---

## 🚀 État actuel du projet

✔ Frontend en ligne  
✔ Backend Node.js opérationnel  
✔ Base de données PostgreSQL  
✔ API REST pour gérer le lexique  
✔ Infrastructure déployée sur VPS  

---

## 🧠 Fonctionnalités actuelles

- 🔎 **Recherche de mots** (Swahili → Français)
- ➕ **Ajout de mots** dans le dictionnaire
- ✏ **Modification** de traductions
- ❌ **Suppression** de mots
- 📦 **Import massif** de lexique via fichiers SQL
- 🗃 **Structure prête** pour évolution IA

---

## 🏗 Stack technique

| Couche           | Technologie             |
| ---------------- | ----------------------- |
| Frontend         | HTML / CSS / JavaScript |
| Backend          | Node.js + Express       |
| Base de données  | PostgreSQL              |
| Déploiement      | VPS (Linux)             |
| Containerisation | Docker via Dokploy      |
| Reverse Proxy    | Traefik                 |
| Versioning       | GitHub                  |

---

## 🗂 Structure du backend

Routes principales :

| Méthode | Route                 | Description                          |
| ------- | --------------------- | ------------------------------------ |
| GET     | `/`                   | Test serveur                         |
| GET     | `/health`             | État API + connexion DB               |
| GET     | `/mot/:mot`           | Rechercher un mot (paramètre requis) |
| POST    | `/ajouter`            | Ajouter un mot (retourne `id` pour lier les autres lexiques) |
| PUT     | `/modifier/:mot`      | Modifier par mot (toutes les lignes) |
| PUT     | `/modifier/id/:id`    | Modifier par id (UUID valide)        |
| DELETE  | `/supprimer/:id`      | Supprimer par UUID (409 si d'autres lexiques référencent cet id) |

---

## 🗄 Base de données

- **Schéma complet** : **`yetumia_schema.sql`** — langues, lexique_swahili (pivot), lexique_bemba, lexique_hemba, lexique_luba, lexique_sanga, lexique_songye, lexique_tshiluba + clés étrangères + index sur `mot_swahili`.
- **Pivot seul** : **`schema.sql`** — uniquement `lexique_swahili` (pour environnement minimal ou test).

**Table pivot : `lexique_swahili`**
- C’est la table centrale : les **UUID sont générés automatiquement** (`id DEFAULT gen_random_uuid()`).
- Champs : `id`, `mot_swahili`, `argot`, `traduction_fr`, `categorie_grammaticale` (NOT NULL), exemples, synonymes, antonymes, étymologie, prononciation, notes, niveau_langue, date_ajout, historique_modifications, categorie_semantique, niveau_difficulte. Contrainte : **UNIQUE(mot_swahili, argot)**.

**Autres tables (bemba, hemba, luba, sanga, songye, tshiluba)**
- Les **UUID sont renseignés manuellement** : le même `id` que dans `lexique_swahili` pour lier le même sens d’un mot d’une langue à l’autre.
- **Clés étrangères** : `id` de chaque table référence `lexique_swahili(id)`. La suppression d’une entrée dans le pivot échoue (409) si un autre lexique référence cet `id`.

---

## 🔌 Connectivité (Backend ↔ Frontend ↔ Base de données)

Pour que les **3 communiquent** correctement (surtout sur VPS Hostinger) :

### 1. Base de données PostgreSQL

- Créez une base PostgreSQL nommée **`yetumiadb`** sur Hostinger (ou utilisez celle existante).
- Exécutez le schéma une fois :
  - **Complet** (tous les lexiques + FKs) : `psql -h VOTRE_HOST -U VOTRE_USER -d yetumiadb -f yetumia_schema.sql`
  - **Pivot seul** (Swahili uniquement) : `psql ... -d yetumiadb -f schema.sql`  
  Ou copiez-collez le contenu du fichier choisi dans l’outil SQL de Hostinger.

### 2. Variables d’environnement du backend

- Copiez `.env.example` en `.env` et renseignez les identifiants de votre base (Hostinger ou locale) :
  - `PGUSER`, `PGHOST`, `PGDATABASE`, `PGPASSWORD`, `PGPORT`
- En production (Dokploy / Docker), définissez ces variables dans la configuration du conteneur (pas de fichier `.env` commité).

### 3. Vérifier que tout est connecté

- **API** : `GET https://votre-domaine.com/api/` → doit retourner `{ "success": true, "message": "Yetumia Backend Running" }`.
- **API + Base** : `GET https://votre-domaine.com/api/health` → si la base est joignable : `{ "api": true, "database": true }`. Si la base est injoignable : `database: false` et un message d’erreur.

### 4. Frontend

- Le frontend appelle l’API à l’URL configurée (ex. `https://yetumia.com/api`). Assurez-vous que le backend est déployé sous ce préfixe (ex. Traefik avec `PathPrefix(/api)`).

---

## 🌐 Déploiement

Le projet est déployé sur un **VPS Linux** via **Dokploy (Docker)** :
- Conteneur backend Node.js
- Conteneur PostgreSQL
- Traefik pour HTTPS
- Domaine connecté au frontend

[![Live Demo](https://img.shields.io/badge/LIVE_DEMO-Accéder_au_site-009688?style=for-the-badge&logo=google-chrome&logoColor=white)](http://www.yetumia.com)

---

## 🔮 Vision future

- Intégration **IA linguistique**
- **Assistant vocal** pour dialectes africains
- **Apprentissage automatique** sur lexiques
- **Traduction intelligente** contextuelle
- **API publique** linguistique

---

## 🤝 Contribution

Les développeurs peuvent contribuer en :
1. Améliorant l'API
2. Ajoutant des langues
3. Optimisant la base de données
4. Développant les modules IA

**Processus :** Fork → Branch → Pull Request

[![Contribute](https://img.shields.io/badge/Contribuer-au_projet-FF6F61?style=for-the-badge&logo=github&logoColor=white)](https://github.com/your-username/yetumia/fork)

---

## 📜 Licence

Projet en développement — licence à définir.

---

## ✨ Auteur

Projet initié par **Meso**  
Vision : connecter les langues africaines au futur numérique.

---

**Yetumia = Technologie + Culture + Langues africaines**

---

<div align="center">

[![Visit Yetumia](https://img.shields.io/badge/🌍_Visiter_Yetumia-Click_ici-8A2BE2?style=for-the-badge)](http://www.yetumia.com)
[![Report Issue](https://img.shields.io/badge/🐛_Signaler_un_bug-DD0031?style=for-the-badge&logo=github)](https://github.com/your-username/yetumia/issues)
[![Feature Request](https://img.shields.io/badge/💡_Suggestion-F39C12?style=for-the-badge&logo=github)](https://github.com/your-username/yetumia/issues)

</div>

---

*Dernière mise à jour : Janvier 2025*
