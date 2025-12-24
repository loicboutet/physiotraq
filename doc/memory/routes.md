# Routes - PhysioTraq

## Vue d'ensemble

Application web responsive (PWA) avec deux profils utilisateurs :
- **Admin** (License Owner) : Gestion des licences, devices, équipe, facturation
- **Operator** (Field User) : Monitoring temps réel, traitements, historique

**Note :** L'admin peut aussi agir comme opérateur terrain.

---

## Routes Publiques

### Landing & Auth

| Route | Méthode | Description |
|-------|---------|-------------|
| `/` | GET | Landing page (redirect vers dashboard si connecté) |
| `/sign_up` | GET/POST | Création de compte + achat licence (Stripe Checkout) |
| `/sign_in` | GET/POST | Connexion |
| `/sign_out` | DELETE | Déconnexion |
| `/password/forgot` | GET/POST | Mot de passe oublié |
| `/password/reset/:token` | GET/PATCH | Reset du mot de passe |

---

## Namespace: /admin (License Owner)

Accessible uniquement aux users avec `role: admin`.

### Dashboard (`/admin/dashboard`)
- **GET** `/admin` ou `/admin/dashboard`
- Vue d'ensemble :
  - Statut de la licence (active, expires dans X jours)
  - Nombre de devices et leur statut (online/offline)
  - Traitements en cours
  - Dernières alertes
- Actions rapides :
  - Voir tous les devices
  - Ajouter un device
  - Gérer l'équipe

### Devices (`/admin/devices`)

| Route | Méthode | Description |
|-------|---------|-------------|
| `/admin/devices` | GET | Liste des devices avec statuts |
| `/admin/devices/new` | GET | Formulaire ajout device (scan QR ou saisie serial) |
| `/admin/devices` | POST | Créer device |
| `/admin/devices/:id` | GET | Détails device (config, historique, stats) |
| `/admin/devices/:id/edit` | GET | Modifier device (nom, wifi credentials) |
| `/admin/devices/:id` | PATCH | Update device |
| `/admin/devices/:id/location` | GET | Localisation approximative (map via IP) |

### Team (`/admin/team`)

| Route | Méthode | Description |
|-------|---------|-------------|
| `/admin/team` | GET | Liste des membres de l'équipe |
| `/admin/team/new` | GET | Formulaire ajout membre |
| `/admin/team` | POST | Créer membre (envoie invitation email) |
| `/admin/team/:id` | GET | Profil membre |
| `/admin/team/:id/edit` | GET | Modifier membre |
| `/admin/team/:id` | PATCH | Update membre |
| `/admin/team/:id` | DELETE | Supprimer membre |
| `/admin/team/:id/assignments` | GET/PATCH | Gérer les devices assignés |

### Billing (`/admin/billing`)

| Route | Méthode | Description |
|-------|---------|-------------|
| `/admin/billing` | GET | Vue facturation (statut licence, historique paiements) |
| `/admin/billing/portal` | GET | Redirect vers Stripe Customer Portal |
| `/admin/billing/renew` | POST | Forcer renouvellement manuel |
| `/admin/billing/invoices` | GET | Liste des factures |
| `/admin/billing/invoices/:id` | GET | Détail/download facture (PDF) |

### Treatments History (`/admin/treatments`)

| Route | Méthode | Description |
|-------|---------|-------------|
| `/admin/treatments` | GET | Historique tous les traitements |
| `/admin/treatments/:id` | GET | Détail d'un traitement |
| `/admin/treatments/export` | GET | Export CSV/XLS (avec filtres) |

### Firmware (`/admin/firmware`)

| Route | Méthode | Description |
|-------|---------|-------------|
| `/admin/firmware` | GET | Liste des versions firmware |
| `/admin/firmware/new` | GET | Upload nouvelle version |
| `/admin/firmware` | POST | Créer release |
| `/admin/firmware/:id` | GET | Détails version |
| `/admin/firmware/:id` | DELETE | Supprimer version (si non utilisée) |

**Note :** Cette section est pour l'upload des firmwares par l'admin système. À voir si c'est accessible aux license owners ou juste super-admin PhysioTraq.

### Settings (`/admin/settings`)

| Route | Méthode | Description |
|-------|---------|-------------|
| `/admin/settings` | GET | Paramètres du compte admin |
| `/admin/settings` | PATCH | Update paramètres |
| `/admin/settings/notifications` | GET/PATCH | Préférences notifications |

---

## Namespace: /app (Field User - Operator)

Accessible à tous les users authentifiés (admin inclus).

### Dashboard (`/app/dashboard`)
- **GET** `/app` ou `/app/dashboard`
- Vue d'ensemble opérateur :
  - Devices assignés et leurs statuts
  - Traitement en cours (si existant)
  - Derniers traitements
- Actions rapides :
  - Démarrer un traitement
  - Voir mes traitements

### Monitoring - Cœur de l'application (`/app/monitor`)

| Route | Méthode | Description |
|-------|---------|-------------|
| `/app/monitor` | GET | Sélection device pour monitoring |
| `/app/monitor/:device_id` | GET | Vue monitoring temps réel |
| `/app/monitor/:device_id/start` | POST | Démarrer un traitement |
| `/app/monitor/:device_id/stop` | POST | Arrêter le traitement en cours |

#### Vue Monitoring (`/app/monitor/:device_id`)
- Affichage température en **gros chiffres** (style défibrillateur)
- Toggle °C / °F
- Courbe d'évolution temps réel (Chart.js/ApexCharts)
- Chronomètre de traitement
- Alertes visuelles :
  - 🟠 à 39°C
  - 🔴 au-dessus de 40°C
- Statut device (batterie, WiFi, fiabilité)
- Toggle affichage : graphique / numérique
- Bouton **STOP** traitement

### Treatments (`/app/treatments`)

| Route | Méthode | Description |
|-------|---------|-------------|
| `/app/treatments` | GET | Mon historique de traitements |
| `/app/treatments/new` | GET | Formulaire nouveau traitement (infos patient) |
| `/app/treatments` | POST | Créer traitement |
| `/app/treatments/:id` | GET | Détail traitement (replay courbe) |
| `/app/treatments/:id/export` | GET | Export CSV/XLS |
| `/app/treatments/:id/anonymize` | POST | Générer nom session aléatoire |

#### Formulaire Patient (`/app/treatments/new`)
- Nom, Prénom (optionnel)
- Âge
- Sexe
- Poids
- **Checkbox** : Anonymiser (génère session_identifier)
- Sélection du device

### Profile (`/app/profile`)

| Route | Méthode | Description |
|-------|---------|-------------|
| `/app/profile` | GET | Mon profil |
| `/app/profile` | PATCH | Update profil |
| `/app/profile/password` | PATCH | Changer mot de passe |
| `/app/profile/preferences` | GET/PATCH | Préférences (unité température) |

---

## API Namespace: /api/v1

API pour les thermomètres connectés.

### Device API (authentification via MAC + token)

| Route | Méthode | Description |
|-------|---------|-------------|
| `/api/v1/devices/register` | POST | Première connexion device |
| `/api/v1/devices/heartbeat` | POST | Ping régulier (statut online) |
| `/api/v1/devices/wifi_credentials` | GET | Récupérer WiFi credentials à jour |

### Measurements API

| Route | Méthode | Description |
|-------|---------|-------------|
| `/api/v1/measurements` | POST | Envoyer une mesure |
| `/api/v1/measurements/batch` | POST | Envoyer plusieurs mesures |

### Firmware API

| Route | Méthode | Description |
|-------|---------|-------------|
| `/api/v1/firmware/check` | GET | Vérifier si update disponible |
| `/api/v1/firmware/download/:version` | GET | Télécharger le binaire |
| `/api/v1/firmware/confirm` | POST | Confirmer installation réussie |

### Webhook Stripe

| Route | Méthode | Description |
|-------|---------|-------------|
| `/api/v1/webhooks/stripe` | POST | Webhooks Stripe (paiements, subscriptions) |

---

## Turbo Streams (Temps réel)

Routes pour les mises à jour temps réel via Turbo Streams.

| Channel | Description |
|---------|-------------|
| `device_#{device.id}` | Mises à jour device (status, measurements) |
| `treatment_#{treatment.id}` | Mises à jour traitement en cours |
| `user_#{user.id}_notifications` | Notifications utilisateur |
| `license_#{license.id}_devices` | Statuts devices pour admin |

---

## PWA / Service Worker

| Route | Méthode | Description |
|-------|---------|-------------|
| `/manifest.json` | GET | PWA Manifest |
| `/service-worker.js` | GET | Service Worker |
| `/offline` | GET | Page offline fallback |

---

## Récapitulatif Structure

```
/                           # Landing
/sign_up                    # Inscription + achat licence
/sign_in                    # Connexion
/password/*                 # Reset password

/admin                      # Dashboard admin
/admin/devices/*            # Gestion devices
/admin/team/*               # Gestion équipe
/admin/billing/*            # Facturation & licences
/admin/treatments/*         # Historique global
/admin/firmware/*           # Gestion firmware
/admin/settings/*           # Paramètres

/app                        # Dashboard opérateur
/app/monitor/*              # Monitoring temps réel ⭐
/app/treatments/*           # Mes traitements
/app/profile/*              # Mon profil

/api/v1/devices/*           # API devices
/api/v1/measurements/*      # API mesures
/api/v1/firmware/*          # API firmware
/api/v1/webhooks/stripe     # Webhooks Stripe
```

---

## Historique des modifications

### Initial (Brick 1)
- Date: 2025-12-24
- Routes définies pour les deux namespaces principaux (/admin, /app)
- API v1 pour les thermomètres
- Sources:
  - Specs fournies dans le prompt (fonctionnalités utilisateur terrain + admin)
  - Conversations Leexi : architecture WiFi, pas de connexion directe app ↔ device
