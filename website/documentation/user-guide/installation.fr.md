---
title: Installation
tx_slug: documentation_user-guide_installation
---


# Installation

## Prérequis

* QGIS version LTR ou plus récente
* Un serveur Postgresql version 10 ou plus récente

## Installation simplifiée

1. Installer le plugin QGIS [oQtopus](https://plugins.qgis.org/plugins/oqtopus/)
2. Suivez le processus d'[installation](https://opengisch.github.io/oqtopus/usage/module/installation/) pour installer SIGNALO

## Installation manuelle

### Téléchargement

1. Pour installer signalo, trouvez la [dernière version](https://github.com/opengisch/signalo/releases/latest) et téléchargez

    * le fichier `project.zip` contenant le projet QGIS nécessaire à la visualisation des données.
    * le dump du modèle de données (avec ou sans données démo)

### Modèle de données

2. Créez un [service postgresl](https://www.postgresql.org/docs/current/libpq-pgservice.html) `pg_signalo` avec les informations de connexion.

3. Réstaurez ensuite le dump:
    * pour un dump binaire (fichier avec extension `.backup`), utiliser `pg_restore` facilement utilisable avec [pgAdmin](https://www.pgadmin.org/)
    * pour un dump SQL (fichier avec extension `.sql`), utiliser la ligne de commande:
    `PGSERVICE=pg_signalo psql -v ON_ERROR_STOP=1 -f _chemin_vers_le_fichier_sql`

## Extensions QGIS

4. Dans QGIS, installez les plugins suivants:
    * [Ordered Relation Editor](https://plugins.qgis.org/plugins/ordered_relation_editor/)
    * pour une utilisation mobile avec QField: [QFieldSync](https://plugins.qgis.org/plugins/qfieldsync/)
    * pour la gestion documentaire: [Document Management System](https://plugins.qgis.org/plugins/document_management_system/)  

5. Ouvrez le projet QGIS du dossier extrait.
