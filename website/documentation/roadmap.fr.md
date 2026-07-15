---
title: Roadmap
tx_slug: documentation_roadmap
hide:
  - navigation
  - toc
---

SIGNALO est continuellement amélioré afin de répondre aux besoins des gestionnaires de la signalisation routière. SIGNALO se base sur la dernière LTR de QGIS. Celle-ci est généralement mise à jour en début d'année (voir aussi [Roadmap QGIS](https://qgis.org/fr/site/getinvolved/development/roadmap.html#location-of-prereleases-nightly-builds)). Une nouvelle version de SIGNALO est mise à disposition dans le mois qui suit la sortie de la LTR QGIS. Les releases suivants se basent sur la LTR en cours.

## Versioning

Les versions sont nommées major.minor.bugfix (par exemple 0.5.1). Tout changement dans le modèle de données (schéma signalo_db) se traduira par une augmentation de la version mineure et les changelogs correspondants sont nommés en conséquence. Tout changement dans l'application (schéma signalo_app) ou dans le projet de démonstration QGIS entraînera une augmentation de la correction de bugs.

## Roadmap
Voici une liste non-exhaustive des améliorations prévues pour SIGNALO.

**2026**
* Analyse et amélioration du contrôle de l'édition hors-ligne
    * investigation de l'utilisation d'un moteur de rendu développé spécifiquement (plugin QGIS + code spécifique pour QField)

**2027**
* Amélioration de l'interface du formulaire avec un regroupement des cadres et signaux:
    * une visualisation unique selon chaque azimut: tous les cadres et signaux sont affichés sur le même dessin
    * si possible une optimisation des requêtes (une seule requête pour tous les signaux par regroupement des cadres)
    * éventuellement une visualisation 3D


## Derniers changements

### Changements majeurs
**1.4 (pour septembre 2026)**  
* Amélioration du rendu cartographique sur mobile 

* Autoriser valeurs `null` ou non  
A travers la variable de projet `@signalo_null_autorised`, l'administrateur du projet peut décider si les champs avec listes déroulantes doivent être `not null` ou non.
* Amélioration de l'export DXF  
Ce développement a été directement fait dans QGIS core ([#66233](https://github.com/qgis/QGIS/pull/66233), 
[#66261](https://github.com/qgis/QGIS/pull/66261), 
[#66262](https://github.com/qgis/QGIS/pull/66262)).

**1.3**  
* Amélioration du contrôle des mises à jour du modèle de données, info de versionnement dans le modèle, contrôle dans la CI  
Avec l'intégration de PUM dans SIGNALO et la possibilité d'installer et de mettre à jour le module à travers l'extension QGIS oQtopus, ces étapes sont devenues beaucoup plus faciles. Le contrôle sur la version utilisée, la mise en place d'un environnement test et l'attribution de rôles et droits aux utilisateurs des données sont maintenant possibles avec quelques cliques. Voir [Installation](https://signalo.ch/user-guide/installation/) et [Tests](https://signalo.ch/user-guide/tests/).

**1.2**  
* Outil de validation des changements  
Chaque table de données contient une information sur la dernière modification (date, utilisateur, plateforme). L'administrateur du projet peut décider (à travers la variable de projet `@signalo_validation`) si et après quelles modifications, les changements doivent être validés. Voir [Validation](https://signalo.ch/user-guide/validation/).

**1.1**  
* Intégration des balises  
Les panneaux de balises principales sont intégrés dans SIGNALO. Voir [Balises](https://signalo.ch/user-guide/marker/).

**1.0**  
* Outil azimut  
Un outil graphique a été intégré pour créer un nouveau signal à partir d'un azimut ou pour changer un azimut existant. Voir [Ajout de signaux](https://signalo.ch/user-guide/adddata/#onglet-azimut).

### Changelogs détaillés
Toutes les releases sont disponible sur [Github](https://github.com/opengisch/signalo/releases/)  - le changelog décrit les changements d'une version à une autre.
