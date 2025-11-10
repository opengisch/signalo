---
title: Ajout de valeurs dans les listes de valeurs
tx_slug: documentation_user-guide_advanced_add_values
---

# Ajouter une entrée dans une liste de valeurs
## Approche souhaitée

Comme décrit dans le [modèle des données](https://www.signalo.ch/model-documentation), SIGNALO repose sur un certain nombre de listes de valeurs, intégrées comme listes déroulantes dans les formulaires des différents couches de données.

Le contenu et la structure de ces listes de valeurs sont relativement fixes. Elles ne peuvent être modifiées que lors d'une mise à jour du modèle de données qui sera publiée avec une [release officielle](https://github.com/opengisch/signalo/releases).

Si une utilisatrice ou un utilisateur souhaite ajouter une valeur dans une liste de valeurs, une demande peut être fait au groupe de pilotage SIGNALO via une issue sur [Github](https://github.com/opengisch/signalo/issues).  
En cas d'une nouvelle valeur qui aurait une influence sur l'affichage des signaux sur la carte, p.ex. un nouveau type de support, une image `.svg` correspondant devrait être fourni avec.  
Dans ce cas-là, le projet QGIS doit également être mis à jour.

Nous encourageons vivement cette approche à l'ajout d'entrées dans les listes de valeurs. Si toutefois, vous veniez à compléter ces listes, il est possible que cela entraîne des complications lors des mises à jour du modèle de données.

## Personnalisation avancée

Si l'option décrite ci-dessus n'est pas suffisante pour répondre aux cas d'usage, les points suivants peuvent être considérés.

### Listes de valeurs
Les listes de valeurs (tables ```vl_...```) de l'installation SIGNALO ont pour but de fournir un plus grand dénominateur commun pour les différents utilisateurs. Il est cependant probable que les besoins diffèrent légèrement entre l'un et l'autre.

Les valeurs à disposition dans le projet QGIS peuvent être adaptées par chaque utilisateur. En désactivant l'attribut ```active``` les valeurs respectifs ne seront plus à disposition dans les listes déroulantes sur QGIS.

De même, il est possible d'ajouter des valeurs supplémentaires dans ces listes. Pour bonne pratique, l'identifiant des nouvelles valeurs devrait être bien distinguable des valeurs standards, p.ex. en commençant par un identifiant 1000+.

> Attention : Il est recommandé de décrire tout changement personnalisé dans la **base de données** dans un fichier de migration ```.sql``` qui permet de retracer les changements effectués et de les réappliquer en cas de nécessité.

### Symbologie
S'il est désiré d'avoir un style personnalisé pour la symbologie des supports (couche *Support*, géométrie de points), il est possible d'utiliser une catégorisation, p.ex. par type de support.

La symbologie de la vue *Vue signal (symbologie)* qui est fourni avec le projet est très complexe et ne doit pas être modifiée afin d'éviter des problèmes d'affichage.

> Attention : Toute personnalisation du **projet QGIS** doit potentiellement être refaite à chaque release d'une nouvelle version SIGNALO. Il est donc avisé de bien noter les changements faits afin de pouvoir les reproduire.
> Depuis 2025, l'extension *Trackable QGIS Project* est utilisé, permettant de garder la même structure dans le xml du fichier ```.qgs``` et ainsi de faciliter la mise en avant des changements effectués dans le fichier du projet.
