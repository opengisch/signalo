---
title: Champs de symbology
tx_slug: documentation_user-guide_symbologyfields
---

# Champs avec influence sur la représentation cartographique

La représentation des signaux sur la carte du projet QGIS peut être influencé par plusieurs champs repartis dans les tables de base.

- l'attribut `sign.hanging_mode` ou *mode d'accrochage* permet de définir si un panneau porte le même signal des deux côtés, [vers la description](https://signalo.ch/user-guide/advanced/doublesided/)
- en cas de supports portant de nombreux signaux, la visibilité des signaux sur la carte peut être améliorée avec les attributs `offset_x` et `offset_y` ainsi que `offset_x_verso` et `offset_y_verso` de la table `azimut`, voir [ici](https://signalo.ch/user-guide/advanced/offset/)
- l'attribut `sign.natural_direction_or_left` permet de changer la direction naturelle du panneau par rapport à son point d'ancrage défini au niveau du cadre, voir [ici](https://signalo.ch/user-guide/directionalsigns/).
- si l'attribut `sign.complex` est `true`, aucun symbol pré-existant n'est utilisé sur la carte. Un rond rouge avec point d'interrogation y apparaît, indiquant que le signal est trop complex à être representé sur la carte. Il doit être visualisé dans le formulaire d'attribut via une photo. 
- l'attribut `support.group_by_anchor` est par défaut activé, ce qui affiche les signaux sur chaque azimut groupés par le point d'ancrage de leur cadre. Plus d'informations [ici](https://www.signalo.ch/advanced/group_by_anchor) 

Les variables de projet ayant une influence sur la symbologie sont
- `@signalo_img_size` pour la taille des panneaux, voir [ce chapitre](https://www.signalo.ch/advanced/size)
- `@signalo_inscr_length` fixe la longueur maximale de texte à afficher sur les panneaux dynamiques. Les textes plus longs seront coupés et remplacés par `...`
- `@signalo_validation` : détermine quand une validation des modifications est nécessaire, voir [ces instructions](https://signalo.ch/user-guide/validation/)

