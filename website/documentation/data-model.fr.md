---
title: Data Model
tx_slug: documentation_data-model
hide:
  - navigation
  - toc
---

## Structure

On distingue 4 tables principales dans le modèle de données:

* support
* azimut
* cadre
* signal

Un support peut présenter des objets selon plusieurs azimuts, chacun pouvant présenter plusieurs cadres, chacun pouvant supporter plusieurs signaux.

Ces tables, ansi que les tables de listes de valeurs, sont regroupé dans un schéma `signalo_db`.

Il existe par ailleurs un second schéma, `signalo_app` offrant quant à lui la vue permettant l'affichage des signaux sur la carte. Celle-ci regroupe les données des quatres tables principales dans une hierarchie aplatie et est générée de manière à ce que l'ordre des panneaux, cadres et azimuts est respecté.

## Documentation

La description complète du modèle de données se trouve [ici](https://www.signalo.ch/model-documentation).

## Mise à jour des données

La structure des données peut évoluer d'une release à une autre. Si votre base de données est déjà en place, les mises à jour peuvent facilement être faites grâce à des fichiers de migration `sql`. Ainsi, la structure est actualisée sans modification des données existantes. 
