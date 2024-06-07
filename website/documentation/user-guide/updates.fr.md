---
title: Mises à jour
tx_slug: documentation_user-guide_updates
---


# Mise à jour du modèles de données

La structure des données peut évoluer d'une release à une autre. Si votre base de données est déjà en place, les mises à jour peuvent facilement être faites grâce à des fichiers de migration `sql`. Ainsi, la structure est actualisée sans modification des données existantes.

1. Avant de procéder à la mise à jour, faire un backup de la base de données
2. Télécharger les changelogs et le fichier application (`signalo-1.X.Y-db-app.sql`) sur la page de la [release](https://github.com/opengisch/signalo/releases/latest)
3. Supprimer l'application: `psql -c "DROP SCHEMA signalo_app CASCADE"`
4. Lancer les différents scripts SQL de migration: `psql -v ON_ERROR_STOP=1 -v SRID=2056 -f datamodel/changelogs/XXXX/XXXX_zzzzzz.sql` (pour chaque fichier)
5. Recréer l'application avec le ficher SQL de la release: `psql -v ON_ERROR_STOP=1 -f signalo-1.X.Y-db-app.sql`
