# Tâche: Admin Billing

## Description
Gestion de la facturation et des licences.

## Éléments UI requis
- [ ] Card: Current Plan
  - Nom du plan
  - Prix
  - Status (Active/Past due)
  - Next billing date
  - Bouton "Manage in Stripe" (portal)
- [ ] Card: Payment Method
  - Carte actuelle (last 4 digits, expiry)
  - Bouton "Update"
- [ ] Section: Invoices
  - Table des factures
  - Date, Amount, Status, Download PDF
- [ ] Alert si paiement échoué

## Notes UX
- Transparence sur l'état de l'abonnement
- Accès facile au Stripe Customer Portal
- Téléchargement des factures
