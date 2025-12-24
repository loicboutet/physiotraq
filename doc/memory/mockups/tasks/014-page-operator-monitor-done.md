# Tâche: Operator Monitor (CORE FEATURE ⭐)

## Description
Vue de monitoring temps réel - page la plus importante de l'app.

## Éléments UI requis
- [ ] Header minimal
  - Device name
  - Session info (patient ou anonymous ID)
  - Timer (chronomètre)
- [ ] Zone principale: TEMPÉRATURE
  - Affichage GÉANT (style défibrillateur)
  - Couleur selon niveau (turquoise/orange/rouge)
  - Toggle °C / °F
  - Animation pulse si > 40°C
- [ ] Courbe d'évolution
  - Graphique temps réel
  - Dernières 15-30 minutes
  - Seuils visuels (lignes à 39° et 40°)
- [ ] Indicateurs secondaires
  - Fiabilité de la mesure
  - Batterie device
  - Force WiFi
  - Firmware version
- [ ] Toggle: Vue numérique / Vue graphique
- [ ] Bouton STOP (gros, rouge, visible)
- [ ] Alertes visuelles
  - Banner warning à 39°C
  - Banner danger + vibration/son à 40°C

## Notes UX
- LISIBILITÉ MAXIMALE
- Fonctionne sur tablette en plein soleil
- Inspiré des équipements médicaux (défibrillateur)
- Wake lock pour empêcher mise en veille écran
- Gros boutons, pas de petits liens
