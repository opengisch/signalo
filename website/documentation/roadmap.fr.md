---
title: Roadmap
tx_slug: documentation_roadmap
hide:
  - navigation
  - toc
---

SIGNALO est continuellement amélioré afin de répondre aux besoins des gestionnaires de la signalisation routière. SIGNALO se base sur la dernière LTR de QGIS. Celle-ci est généralement mise à jour en début d'année (voir aussi [Roadmap QGIS](https://qgis.org/fr/site/getinvolved/development/roadmap.html#location-of-prereleases-nightly-builds)). Une nouvelle version de SIGNALO est mise à disposition dans le mois qui suit la sortie de la LTR QGIS. Les releases suivants se basent sur la LTR en cours.

### Versioning

Les versions sont nommées major.minor.bugfix (par exemple 0.5.1). Tout changement dans le modèle de données (schéma signalo_db) se traduira par une augmentation de la version mineure et les changelogs correspondants sont nommés en conséquence. Tout changement dans l'application (schéma signalo_app) ou dans le projet de démonstration QGIS entraînera une augmentation de la correction de bugs.

### Roadmap
Voici une liste non-exhaustive des améliorations prévues pour SIGNALO

* Amélioration de l'interface du formulaire avec un regroupement des cadres et signaux:
    * une visualisation unique selon chaque azimut: tous les cadres et signaux sont affichés sur le même dessin
    * si possible une optimisation des requêtes (une seule requête pour tous les signaux par regroupement des cadres)

* Analyse et amélioration du contrôle de l'édition hors-ligne
    * remontée des infos d'ajout/suppression/modification jusqu'au support
    * investigation de l'utilisation d'un moteur de rendu développé spécifiquement (plugin QGIS + code spécifique pour QField)

* Inspection et validation des changements effectués sur le terrain

* Amélioration du contrôle des mises à jour du modèle de données, info de versionnement dans le modèle, contrôle dans la CI

* Outil avancé pour l'analyse de la cohérence globale via un plugin


### Derniers changements

Toutes les releases sont disponible sur [Github](https://github.com/opengisch/signalo/releases/)  - le changelog décrit les changements d'une version à une autre.
