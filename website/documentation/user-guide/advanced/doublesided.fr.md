---
title: Panneaux recto-verso
tx_slug: documentation_user-guide_advanced_doublesided
---

# Panneaux recto-verso

Au niveau du signal, (table `sign`, couche *Signal* dans QGIS) l'attribut `hanging_mode` ou *mode d'accrochage* permet de définir si un panneau porte le même signal des deux côtés.

* *RECTO* -> le signal n'est affiché que d'un côté
* *RECTO-VERSO* -> le signal est affiché des deux côtés du panneau
* *VERSO* -> le signal n'est affiché que dans le dos du panneau. Cette valeur peut être choisi p.ex. quand le recto et le verso du panneau ne sont pas identiques.

* A noter: la couche **cadre** contient également un attribut lié au recto-verso (case à cocher **montage recto-verso**). La valeur de cet attribut n'est néanmoins qu'informative, elle n'aura aucune influence sur l'affichage du panneau sur la carte.*
