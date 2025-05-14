---
title: Démo et tests
tx_slug: documentation_user-guide_tests
---

# Démo et tests
## Projet de démonstration
Une version préconfigurée du projet SIGNALO est mise à disposition pour toute personne souhaitant le découvrir. Pour obtenir un accès, merci de nous contacter à sales@opengis.ch.

## Tests des mises à jour
Les nouvelles versions du projet SIGNALO peuvent être testées avec des données d’exemple avant leur publication officielle.

Le projet à tester est accessible via la [pull request](https://github.com/opengisch/signalo/pull) contenant les modifications.

Les testeurs reçoivent un accès personnalisé à la base de données de test. Lors de l’ouverture du projet à tester, il suffit de mettre à jour le service `pg_signalo` avec ces informations d’accès. Cette opération peut être réalisée facilement grâce à l’extension [pgservice parser](https://plugins.qgis.org/plugins/pg_service_parser/).

À la fin du test, le service `pg_signalo` peut être rétabli à sa configuration d’origine.

Une fois le projet testé et validé, une version officielle sera publiée. Les instructions sur les [Mises à jour](https://www.signalo.ch/user-guide/updates)pourront alors être suivies.

