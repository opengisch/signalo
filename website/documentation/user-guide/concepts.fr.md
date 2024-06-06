---
title: Concepts
tx_slug: documentation_user-guide_concepts
---

# Structure

On distingue 4 classes principales dans le modèle de données:
<!--
https://www.plantuml.com/plantuml/duml/JSj12i8m48NX_PpYaQMGXJUe6o_G4uHsZ85CKYQJXOft5ws1hlw1RzxKBAXroPJvPh0AJV5kM9FoOgaMeYM7rZ3tRQjgU14GkGgRFkWzzF9CqdSCl_DBO-BE3jvxk9CRZ_JlaQuQX45xZZ2dM6ZYidR97m00
@startuml
left to right direction
class Support { geometry }
class Azimut { azimut }
Support "1" --- "*" Azimut
Azimut "1" --- "*" Frame
Frame "1" --- "*" Sign
@enduml
-->

![Classes](../assets/images/signalo_classes.png#only-light)
![Classes](../assets/images/signalo_classes_dark.png#only-dark)

Un support peut présenter des objets selon plusieurs azimuts, chacun pouvant présenter plusieurs cadres, chacun pouvant supporter plusieurs signaux.

Ces tables, ansi que les tables de listes de valeurs, sont regroupé dans un schéma `signalo_db`.

Il existe par ailleurs un second schéma, `signalo_app` offrant quant à lui la vue permettant l'affichage des signaux sur la carte. Celle-ci regroupe les données des quatres tables principales dans une hierarchie aplatie et est générée de manière à ce que l'ordre des panneaux, cadres et azimuts est respecté.

# Documentation

La description complète du modèle de données se trouve [ici](https://www.signalo.ch/model-documentation).

# Mise à jour du modèles de données

La structure des données peut évoluer d'une release à une autre. Si votre base de données est déjà en place, les mises à jour peuvent facilement être faites grâce à des fichiers de migration `sql`. Ainsi, la structure est actualisée sans modification des données existantes.

1. Avant de procéder à la mise à jour, faire un backup de la base de données
2. Télécharger les changelogs et le fichier application (`signalo-1.X.Y-db-app.sql`) sur la page de la [release](https://github.com/opengisch/signalo/releases/latest)
3. Supprimer l'application: `psql -c "DROP SCHEMA signalo_app CASCADE"`
4. Lancer les différents scripts SQL de migration: `psql -v ON_ERROR_STOP=1 -v SRID=2056 -f datamodel/changelogs/XXXX/XXXX_zzzzzz.sql` (pour chaque fichier)
5. Recréer l'application avec le ficher SQL de la release: `psql -v ON_ERROR_STOP=1 -f signalo-1.X.Y-db-app.sql`
