# PhysioTraq

**Core Temperature Monitoring for Hyperthermia Treatment**

Application web PWA pour le monitoring en temps réel du traitement de l'hyperthermie via thermomètres connectés WiFi.

## État du projet

**État: MOCKUPS ✅ COMPLETE**

Phase précédente: ANALYSIS ✅

### Mockups créés (13 pages)

| Catégorie | Page | Status |
|-----------|------|--------|
| **Auth** | Login | ✅ Done |
| **Auth** | Sign Up | ✅ Done |
| **Admin** | Dashboard | ✅ Done |
| **Admin** | Devices | ✅ Done |
| **Admin** | Device Detail | ✅ Done |
| **Admin** | Team | ✅ Done |
| **Admin** | Billing | ✅ Done |
| **Admin** | Treatments | ✅ Done |
| **Operator** | Dashboard | ✅ Done |
| **Operator** | Live Monitor | ✅ Done |
| **Operator** | New Treatment | ✅ Done |
| **Operator** | Treatments | ✅ Done |
| **Operator** | Treatment Detail | ✅ Done |

**📍 Index des mockups:** `/mockups`

### Prochaine étape

⏳ **En attente de validation client** pour passer à la phase IMPLEMENTATION.

## Documentation

| Fichier | Status | Description |
|---------|--------|-------------|
| [data_models.md](doc/memory/data_models.md) | ✅ | Modèles de données (User, License, Device, Treatment, Measurement, etc.) |
| [routes.md](doc/memory/routes.md) | ✅ | Routes par namespace (/admin, /app, /api/v1) |
| [style_guide.html](doc/memory/style_guide.html) | ✅ | Guide de style visuel (couleurs, typo, composants) |

## Stack technique

- **Ruby on Rails 8** avec SQLite (Solid libraries)
- **Hotwire** (Turbo + Stimulus) pour le temps réel
- **Tailwind CSS** pour le styling
- **PWA** installable sur iOS/Android
- **Stripe** pour les paiements
- **OVH** pour l'hébergement (France)

## Architecture

```
┌─────────────┐     WiFi      ┌─────────────┐     API      ┌─────────────┐
│ Thermometer │ ────────────► │   Server    │ ◄──────────► │   Web App   │
│   (Device)  │               │  (Rails 8)  │              │    (PWA)    │
└─────────────┘               └─────────────┘              └─────────────┘
```

**Note:** Pas de connexion directe entre l'app et le thermomètre. Le thermomètre se connecte en WiFi et envoie les données au serveur via API.

## Fonctionnalités principales

### Utilisateur terrain (Opérateur)
- Monitoring temps réel avec affichage température en gros chiffres
- Courbe d'évolution en temps réel
- Alertes visuelles à 39°C et 40°C
- Historique des traitements
- Export CSV/XLS
- Anonymisation des sessions

### Propriétaire de licence (Admin)
- Achat de licences annuelles via Stripe
- Gestion des devices (enregistrement, assignation)
- Gestion de l'équipe
- Statistiques d'utilisation
- Géolocalisation approximative des devices (par IP)

### API Devices
- Enregistrement et heartbeat des thermomètres
- Envoi des mesures
- Mise à jour firmware OTA

## Charte graphique

- **Font:** DM Sans (Regular, Light, Medium, Bold)
- **Couleurs primaires:** Orange gradient (#D93611 → #F2811D)
- **Couleurs secondaires:** Turquoise (#32D9D9, #7EEAEA, #008B8B)
- **Alertes:** 
  - 39°C → Orange warning (#F59E0B)
  - 40°C+ → Rouge danger (#EF4444)

## Développement

```bash
# Démarrer le serveur (port 3001 pour éviter conflit)
bin/dev -p 3001

# Voir les mockups
open http://localhost:3001/mockups
```

---

*Projet démarré le 24/12/2025*
