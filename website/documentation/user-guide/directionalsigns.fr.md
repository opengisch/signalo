---
title: Panneaux directionnels
tx_slug: documentation_user-guide_directionalsigns
---

# Panneaux directionnels

Le modèle des données permet une gestion fine des panneaux directionnels. Trois attributs définissent l'affichage de ces panneaux:

* Dans la table `vl_official_sign` (couche *Signal officiel* dans le projet QGIS), l'attribut boolean `directional_sign` définit si un signal est un signal directionnel ou non.
* Dans la table `frame`, l'attribut `anchor` permet de définir le point d'ancrage du cadre: *Gauche*, *Centré* ou *Droite* (couche *Cadre* avec l'attribut *point d'ancrage* dans le projet QGIS).
* Dans la table `sign`, l'attribut boolean `natural_direction_or_left` permet de changer la direction naturelle du panneau par rapport à son point d'ancrage défini au niveau du cadre. Par défaut (la case est cochée), la direction du panneau sera à l'opposé de son point d'ancrage. C'est-à-dire, si le point d'ancrage est à droite, le panneau pointera à gauche et vice-versa. Cet automatisme peut être contourné en décochant la case *direction naturel ou gauche*.
