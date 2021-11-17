

### Prérequis
* QGIS version 3.22 ou plus récente
* Un serveur Postgresql version 10 ou plus récente

### Procédure

Pour installer signalo, trouvez la [dernière version](https://github.com/opengisch/signalo/releases/latest) et téléchargez

* le fichier `project.zip` contenant le projet QGIS nécessaire à la visualisation des données.
* le dump du modèle de données (avec ou sans données démo)

Réstaurez ensuite le dump (avec pg_restore pour le fichier binaire ou avec psql pour le fichier SQL).

Créez un [service postgresl](https://www.postgresql.org/docs/current/libpq-pgservice.html) `pg_signalo` avec les informations de connexion.

Dans QGIS, installez le plugin [Ordered Relation Editor](https://plugins.qgis.org/plugins/ordered_relation_editor/).