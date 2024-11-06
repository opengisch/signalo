---
title: Validation des changements
tx_slug: documentation_user-guide_validation
---

# Validation des changements

## Principe

Il est possible de mettre en place un système de validation pour les données saisies sur le terrain (QField) et/ou sur QGIS.
L'idée est que pour tout changement sur une des 4 tables principales (support, azimut, cadre, signal), le champ de validation sera défini comme vrai et signifie qu'un contrôle est nécessaire.
Une vue regroupe ensuite les informations par support et permet de passer en revue ceux à contrôler.

Attention, les suppressions d'éléments ne sont pas pris en compte dans ce système de validation.

## Configuration

Dans la configuration du projet, il faut définir la variable `signalo_validation` avec la valeur:

* `any`: la validation est requise pour toute modification
* `desktop`: la validation est requise pour les changements sur QGIS Desktop uniquement
* `mobile`: la validation est requise pour les changements sur QField uniquement

![Validation](../assets/images/printscreen/validation-config.png)

## Validation des données

La vue dénommée "Contrôles" dans le projet QGIS permet de passer en revue les supports nécessitant un contrôle, que ce soit au niveau du support, d'un azimut, d'un cadre ou d'un signal.

![Validation](../assets/images/printscreen/validation-layer.png)

Pour marquer un support comme contrôler, deux approches sont possibles:

* soit éditer directement le champ "à contrôler" dans la vue
* soit faire un clic droit sur le support avec l'outil d'identification et sélectionner "Marquer comme contrôlé".

![Validation](../assets/images/printscreen/validation-action.png)
