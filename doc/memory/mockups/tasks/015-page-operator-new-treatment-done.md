# Tâche: Operator New Treatment Form

## Description
Formulaire pour démarrer un nouveau traitement.

## Éléments UI requis
- [ ] Section: Select Device
  - Liste des devices assignés et online
  - Indication du status
- [ ] Section: Patient Information
  - First name (optional)
  - Last name (optional)
  - Age
  - Sex (select)
  - Weight (kg)
- [ ] Checkbox: "Anonymize this session"
  - Si coché, génère un session ID aléatoire
  - Cache les champs nom/prénom
- [ ] Bouton "Generate Random Name" (pour anonymisation)
- [ ] Préférences
  - Unit: °C / °F
- [ ] Bouton "Start Treatment" (gros, primary)

## Notes UX
- Formulaire rapide à remplir
- Support de l'anonymisation (RGPD friendly)
- Validation avant de démarrer
