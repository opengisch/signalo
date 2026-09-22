---
title: Mobile
tx_slug: documentation_user-guide_mobile
---

Pour le travail de terrain, l'application mobile [**QField**](https://qfield.org/) et l'extension pour QGIS [**QFieldSync**](https://plugins.qgis.org/plugins/qfieldsync/) sont utilisées.

Nous renvoyons ici vers la [documentation de QField](https://docs.qfield.org/get-started/) pour les étapes de préparation du projet de terrain.

!!! info "Édition sous QField"

    === "Carte"
          ![visualisation sous QField](../assets/images/printscreen/qfield_signalo.jpg){ width="300" align="left"; loading=lazy }

    === "Légende"
          ![édition des supports](../assets/images/printscreen/qfield_edit.jpg){ width="300" align="left"; loading=lazy }

    === "Formulaire d'attribut"
          ![édition du signal](../assets/images/printscreen/qfield_form.jpg){ width="300" align="left"; loading=lazy }

!!! info "Symbologie hors ligne"

    Le positionnement des signaux sur la carte (empilement, recto/verso, décalages) est calculé par une vue de la base de données, qui n'est pas accessible sur le terrain.

    Le projet embarque donc une couche virtuelle **Vue signal (symbologie hors ligne)** qui rejoue ce calcul directement sur les couches emportées hors ligne. Les signaux ajoutés, supprimés ou réordonnés sur le terrain sont donc repositionnés immédiatement dans QField.

    Cette couche fait partie du projet de bureau : aucune préparation particulière n'est nécessaire, et l'empaquetage se fait normalement depuis la boîte de dialogue QFieldSync, aussi bien par câble que par QFieldCloud.

    Elle voisine dans le groupe **Symbologie** avec la couche PostgreSQL **Vue signal (symbologie)**, dont elle reproduit le rendu. Le groupe est à sélection exclusive : une seule des deux s'affiche à la fois. La couche hors ligne est celle qui est cochée, de sorte que le bureau montre ce que le terrain recevra ; cochez l'autre pour comparer les deux rendus. L'empaquetage retire la couche PostgreSQL.

    La symbologie ne se modifie toutefois qu'à un seul endroit : c'est celle de la couche PostgreSQL qui fait foi, la couche hors ligne en reçoit une copie lorsque le projet est régénéré.

!!! warning "Le dossier `images` doit accompagner le projet"

    La symbologie va chercher les SVG des signaux dans le dossier `images` situé à côté du
    projet. Un paquet qui ne le contient pas s'ouvre sans erreur, contient bien tous les
    signaux, et n'en dessine aucun.

    `images` est donc déclaré dans les **répertoires de pièces jointes** du projet
    (*Propriétés du projet > QFieldSync*), ce qui est la seule façon de le faire suivre :
    l'empaquetage ne copie que les répertoires déclarés là, et la conversion vers
    QFieldCloud ne lit que cette liste.
