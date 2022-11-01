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

Il existe par ailleurs un second schéma, `signalo_app` offrant quant à lui la vue permettant l'affichage des signaux sur la carte.

## Documentation

La description complète du modèle de données se trouve [ici](https://www.signalo.ch/model-documentation).

<div class="doc">
  <iframe src="[map.html](https://www.signalo.ch/model-documentation)"></iframe>
</div>
