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

    Cette couche fait partie du projet de bureau : aucune préparation particulière n'est nécessaire, et l'empaquetage fonctionne aussi bien depuis la boîte de dialogue QFieldSync (câble ou QFieldCloud) qu'avec le script ci-dessous.

    Elle voisine dans le groupe **Symbologie** avec la couche PostgreSQL **Vue signal (symbologie)**, dont elle reproduit le rendu. Le groupe est à sélection exclusive : une seule des deux s'affiche à la fois. La couche hors ligne est celle qui est cochée, de sorte que le bureau montre ce que le terrain recevra ; cochez l'autre pour comparer les deux rendus. L'empaquetage retire la couche PostgreSQL.

    Tant que les deux couches coexistent, **une modification de symbologie doit être reportée sur les deux**, faute de quoi la comparaison ne veut plus rien dire.

!!! tip "Paquet de terrain automatisé"

    Le projet de terrain est également construit automatiquement à chaque publication : l'archive **`signalo-qfield-package.zip`** est jointe aux [releases](https://github.com/opengisch/signalo/releases) et peut être utilisée telle quelle.

    Elle est produite sans intervention manuelle, puis contrôlée : la couche de symbologie hors ligne est présente et valide, elle calcule bien sur les données emportées et non sur la base de données, la couche PostgreSQL a bien été retirée, aucune donnée n'a été perdue et l'ajout d'un signal repositionne effectivement les symboles.

    Pour la construire localement, ou pour vérifier un paquet créé à la main avec QFieldSync :

    ```sh
    docker compose --profile qgis run --rm -e QT_QPA_PLATFORM=offscreen qgis \
      /usr/src/project/scripts/package-qfield.py \
      /usr/src/project/signalo.qgs /usr/src/qfield-package

    docker compose --profile qgis run --rm -e QT_QPA_PLATFORM=offscreen qgis \
      /usr/src/project/scripts/check-qfield-package.py /usr/src/qfield-package/signalo.qgs
    ```
