---
title: Balises
tx_slug: documentation_user-guide_advanced_marker
---

# Balises

Les balises sont gérées comme une catégorie de signaux à part. Tout comme les signaux officiels et les signaux définis par l'utilisateur, une liste de valeurs spécifique (`vl_marker_type`) existe pour les balises. L'accès aux valeurs dans cette liste se fait en choisissant *balises* dans la liste déroulante **type de signal** de la couche *Signal*.

<figure markdown>
  ![Choix type balise](../../assets/images/printscreen/sign_form_marker.png){width="200"; loading=lazy; style="max-width: 900px"}
  <figcaption>Choisir le type de signal "balise"</figcaption>
</figure>

Les images `.svg` des balises sont stockées dans `project/images/marker/editable` et `... original`.

Les types de balises suivants sont directionnels et traités dans le projet QGIS exactement comme les [panneaux directionnels](https://signalo.ch/user-guide/directionalsigns/):  

- Flèche de balisage simple
- Flèche de balisage multiple
- Balise de guidage (direction).
