---
title: Installation
tx_slug: documentation_user-guide_installation
---


# Installation

## Prérequis

* QGIS version LTR ou plus récente
* Un serveur Postgresql version 14 ou plus récente

## Installation de l'application (modèle de données)

### Installation simple via interface graphique

1. Dans QGIS, installer le plugin [oQtopus](https://plugins.qgis.org/plugins/oqtopus/#plugin-about).

2. 

### Installation via PUM (utilisateur avancé)

Il est possible d'installer SIGNALO avec la librairie [pum](https://opengisch.github.io/pum/).

1. Télécharger la dernière release de SIGNALO https://github.com/opengisch/signalo/releases/latest
2. Définir un service Posrgresql avec les droits suffisants pour créer des schémas et des tables
3. Installer pum et ses dépendances via `pip install pum`
4. Lancer l'installation de l'application avec `pum install 

## Extensions

4. Dans QGIS, installez les plugins suivants:
    * [Ordered Relation Editor](https://plugins.qgis.org/plugins/ordered_relation_editor/)
    * [QFieldSync](https://plugins.qgis.org/plugins/qfieldsync/) (version min 4.0)
    * [Document Management System](https://plugins.qgis.org/plugins/document_management_system/)  

5. Ouvrez le projet QGIS du dossier extrait.
