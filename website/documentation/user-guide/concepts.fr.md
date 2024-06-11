---
title: Concepts
tx_slug: documentation_user-guide_concepts
---

# Concepts
## Structure

On distingue 4 classes principales dans le modèle de données:
<!--
https://www.plantuml.com/plantuml/duml/JSj12i8m48NX_PpYaQMGXJUe6o_G4uHsZ85CKYQJXOft5ws1hlw1RzxKBAXroPJvPh0AJV5kM9FoOgaMeYM7rZ3tRQjgU14GkGgRFkWzzF9CqdSCl_DBO-BE3jvxk9CRZ_JlaQuQX45xZZ2dM6ZYidR97m00
@startuml
left to right direction
class Support { geometry }
class Azimut { azimut }
Support "1" --- "*" Azimut
Azimut "1" --- "*" Frame
Frame "1" --- "*" Sign
@enduml
-->

![Classes](../assets/images/signalo_classes.png#only-light)
![Classes](../assets/images/signalo_classes_dark.png#only-dark)

Un support peut présenter des objets selon plusieurs azimuts, chacun pouvant présenter plusieurs cadres, chacun pouvant supporter plusieurs signaux.

Ces tables, ansi que les tables de listes de valeurs, sont regroupé dans un schéma `signalo_db`.

Il existe par ailleurs un second schéma, `signalo_app` offrant quant à lui la vue permettant l'affichage des signaux sur la carte. Celle-ci regroupe les données des quatres tables principales dans une hierarchie aplatie et est générée de manière à ce que l'ordre des panneaux, cadres et azimuts est respecté.


## Documentation

La description complète du modèle de données se trouve [ici](https://www.signalo.ch/model-documentation).
