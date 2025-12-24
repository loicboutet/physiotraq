# Data Models - PhysioTraq

## Vision globale

Application web pour le monitoring en temps réel du traitement de l'hyperthermie via thermomètres connectés WiFi. Système de licences annuelles avec paiement Stripe.

**Architecture :** Le thermomètre se connecte en WiFi et envoie les données directement au serveur via API. Pas de connexion directe app ↔ thermomètre.

---

## User

### Responsabilités
- Authentification et autorisation des utilisateurs
- Gestion des profils (admin/terrain)
- Appartenance à une organisation (via license)

### Attributs
| Nom | Type | Description |
|-----|------|-------------|
| id | bigint | Clé primaire |
| email | string | Email unique, utilisé pour login |
| encrypted_password | string | Mot de passe hashé (Devise) |
| first_name | string | Prénom |
| last_name | string | Nom |
| role | integer | Enum: admin (propriétaire licence), operator (terrain) |
| temperature_unit | integer | Enum: celsius, fahrenheit (préférence utilisateur) |
| license_id | bigint | FK vers License (appartenance) |
| created_at | datetime | |
| updated_at | datetime | |

### Relations
- `belongs_to :license`
- `has_many :treatments` (pour opérateurs)
- `has_many :device_assignments`
- `has_many :devices, through: :device_assignments`

### Notes
- Le **propriétaire de licence** (role: admin) peut aussi être opérateur terrain
- Un seul admin par licence
- L'admin est créé automatiquement à l'achat de la licence

---

## License

### Responsabilités
- Représente un abonnement annuel Stripe
- Lie un propriétaire à un ensemble de devices et users
- Gestion des renouvellements et expirations

### Attributs
| Nom | Type | Description |
|-----|------|-------------|
| id | bigint | Clé primaire |
| stripe_subscription_id | string | ID abonnement Stripe |
| stripe_customer_id | string | ID client Stripe |
| status | integer | Enum: active, expired, cancelled, payment_failed |
| started_at | datetime | Date de début |
| expires_at | datetime | Date d'expiration |
| auto_renew | boolean | Renouvellement automatique activé |
| created_at | datetime | |
| updated_at | datetime | |

### Relations
- `has_many :users`
- `has_one :admin, -> { where(role: :admin) }, class_name: 'User'`
- `has_many :devices`

### Notes
- 1 licence = 1 device actif en fonctionnement
- Pour plusieurs devices, il faut plusieurs licences
- Gestion via Stripe Billing (subscription)

---

## Device

### Responsabilités
- Représente un thermomètre physique connecté
- Stocke les informations de calibration et configuration
- Envoie les mesures via API

### Attributs
| Nom | Type | Description |
|-----|------|-------------|
| id | bigint | Clé primaire |
| serial_number | string | Numéro de série unique (sur QR code) |
| mac_address | string | Adresse MAC unique |
| name | string | Nom personnalisé (ex: "CoreTraQer005") |
| license_id | bigint | FK vers License |
| status | integer | Enum: online, offline, unknown |
| last_seen_at | datetime | Dernière communication |
| firmware_version | string | Version actuelle du firmware |
| firmware_auto_update | boolean | Mise à jour auto activée |
| temp_slope | decimal | Pente de calibration température |
| temp_intercept | decimal | Intercept de calibration température |
| last_ip_address | string | Dernière IP (pour géoloc approx) |
| last_location | string | Localisation approximative via IP |
| created_at | datetime | |
| updated_at | datetime | |

### Relations
- `belongs_to :license`
- `has_many :device_assignments`
- `has_many :users, through: :device_assignments`
- `has_many :treatments`
- `has_many :measurements`
- `has_many :wifi_credentials`

### Méthodes principales
- `online?` : vérifie si last_seen_at < 2 minutes
- `needs_firmware_update?` : compare avec dernière version disponible

---

## DeviceAssignment

### Responsabilités
- Table de jointure User ↔ Device
- Permet d'assigner plusieurs users à un device (pas en même temps)

### Attributs
| Nom | Type | Description |
|-----|------|-------------|
| id | bigint | Clé primaire |
| user_id | bigint | FK vers User |
| device_id | bigint | FK vers Device |
| assigned_at | datetime | Date d'assignation |
| created_at | datetime | |
| updated_at | datetime | |

### Relations
- `belongs_to :user`
- `belongs_to :device`

---

## Treatment (Session de traitement)

### Responsabilités
- Représente une session de monitoring d'hyperthermie
- Contient les infos patient (anonymisées ou non)
- Agrège les mesures d'une session

### Attributs
| Nom | Type | Description |
|-----|------|-------------|
| id | bigint | Clé primaire |
| session_identifier | string | ID auto-généré (date+heure+numéro) pour anonymisation |
| device_id | bigint | FK vers Device |
| user_id | bigint | FK vers User (opérateur) |
| patient_first_name | string | Prénom patient (optionnel, anonymisable) |
| patient_last_name | string | Nom patient (optionnel, anonymisable) |
| patient_age | integer | Âge patient |
| patient_sex | integer | Enum: male, female, other |
| patient_weight | decimal | Poids en kg |
| anonymous | boolean | Session anonymisée |
| status | integer | Enum: in_progress, completed, aborted |
| started_at | datetime | Début du traitement |
| ended_at | datetime | Fin du traitement |
| duration_seconds | integer | Durée calculée |
| max_temperature | decimal | Température max atteinte |
| alert_39_triggered | boolean | Alerte 39°C déclenchée |
| alert_40_triggered | boolean | Alerte 40°C déclenchée |
| notes | text | Notes libres |
| created_at | datetime | |
| updated_at | datetime | |

### Relations
- `belongs_to :device`
- `belongs_to :user`
- `has_many :measurements`

### Notes
- `session_identifier` généré automatiquement si anonymous = true
- Format : `YYYYMMDD-HHMMSS-NNN` (date, heure, numéro session du jour)

---

## Measurement

### Responsabilités
- Stocke chaque mesure envoyée par le thermomètre
- Données temps réel pour courbes et alertes

### Attributs
| Nom | Type | Description |
|-----|------|-------------|
| id | bigint | Clé primaire |
| device_id | bigint | FK vers Device |
| treatment_id | bigint | FK vers Treatment (nullable si hors session) |
| temperature | decimal | Température mesurée (°C) |
| reliability | integer | Indice de fiabilité (0-100) |
| measured_at | datetime | Horodatage de la mesure (device) |
| received_at | datetime | Horodatage de réception (serveur) |
| battery_level | integer | Niveau batterie % |
| battery_voltage | decimal | Voltage batterie |
| wifi_ssid | string | Nom du réseau WiFi |
| wifi_strength | integer | Force du signal (dBm) |
| firmware_version | string | Version firmware au moment de la mesure |
| created_at | datetime | |

### Relations
- `belongs_to :device`
- `belongs_to :treatment, optional: true`

### Notes
- Index sur `device_id` + `measured_at` pour requêtes temps réel
- Partitionnement possible par date pour les gros volumes

---

## WifiCredential

### Responsabilités
- Stocke les credentials WiFi pour un device
- Synchronisés avec le device via API

### Attributs
| Nom | Type | Description |
|-----|------|-------------|
| id | bigint | Clé primaire |
| device_id | bigint | FK vers Device |
| ssid | string | Nom du réseau |
| password | string | Mot de passe (encrypted) |
| priority | integer | Ordre de priorité (1-4) |
| created_at | datetime | |
| updated_at | datetime | |

### Relations
- `belongs_to :device`

### Notes
- Maximum 4 credentials par device (limitation hardware)

---

## FirmwareRelease

### Responsabilités
- Gestion des versions de firmware
- Stockage des fichiers binaires pour OTA updates

### Attributs
| Nom | Type | Description |
|-----|------|-------------|
| id | bigint | Clé primaire |
| version | string | Numéro de version (ex: "03.1.0") |
| release_notes | text | Notes de version |
| binary_file | attachment | Fichier binaire (Active Storage) |
| checksum | string | Checksum pour validation |
| is_stable | boolean | Version stable (vs beta) |
| min_compatible_version | string | Version minimum pour upgrade |
| released_at | datetime | Date de publication |
| created_at | datetime | |
| updated_at | datetime | |

### Relations
- (aucune)

### Méthodes principales
- `self.latest_stable` : retourne la dernière version stable
- `download_url` : URL signée pour téléchargement

---

## Event (Audit Log)

### Responsabilités
- Log des événements système pour audit
- Traçabilité des accès et actions

### Attributs
| Nom | Type | Description |
|-----|------|-------------|
| id | bigint | Clé primaire |
| event_type | string | Type d'événement |
| eventable_type | string | Polymorphic type |
| eventable_id | bigint | Polymorphic id |
| user_id | bigint | FK vers User (nullable) |
| ip_address | string | IP de l'action |
| user_agent | string | User agent |
| metadata | jsonb | Données additionnelles |
| created_at | datetime | |

### Relations
- `belongs_to :eventable, polymorphic: true`
- `belongs_to :user, optional: true`

### Event Types
- `device.connected`
- `device.disconnected`
- `treatment.started`
- `treatment.completed`
- `alert.temperature_39`
- `alert.temperature_40`
- `license.renewed`
- `license.expired`

---

## Diagramme des relations

```
License
  │
  ├── has_many :users
  │     │
  │     └── has_many :treatments
  │     └── has_many :device_assignments
  │
  └── has_many :devices
        │
        ├── has_many :measurements
        ├── has_many :treatments
        ├── has_many :wifi_credentials
        └── has_many :device_assignments

Treatment
  │
  └── has_many :measurements

FirmwareRelease (standalone)
Event (polymorphic audit log)
```

---

## Historique des modifications

### Initial (Brick 1)
- Date: 2025-12-24
- Modèles définis: User, License, Device, DeviceAssignment, Treatment, Measurement, WifiCredential, FirmwareRelease, Event
- Sources: 
  - Specs fournies dans le prompt
  - Documentation technique Excel du client (database_e_struttura_del_software.xlsx)
  - Conversations Leexi avec Stephane Bermon (05/11/2025 et 10/12/2025)
