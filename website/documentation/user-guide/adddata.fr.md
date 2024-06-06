---
title: Edition
tx_slug: documentation_user-guide_adddata
hide:
  - navigation
  - toc
---

# Edition

## Ajout de signaux

* Mettre la couche "Support" en édition et digitaliser un point pour ouvrir le formulaire.

!!! info "Le formulaire est composé de quatre onglets:"

    === "Général"
        ![Onglet général](../assets/images/printscreen/support-form-general.png){loading=lazy}

    === "Azimut"
        ![Onglet azimut](../assets/images/printscreen/support-form-azimut.png){loading=lazy}

    === "Photo"
        ![Onglet azimut](../assets/images/printscreen/support-form-photo.png){loading=lazy}

    === "Documents"
        ![Onglet azimut](../assets/images/printscreen/support-form-documents.png){loading=lazy}

Dans l’onglet “Azimut”, les cadres et signaux peuvent y être saisis. L'attribut *Azimut* peut être rempli de manière graphique, grâce à la vue `vw_azimut_edit` (couche Outil Azimut) du schéma `signalo_app`.

<figure markdown>
  ![Exemple Azimut](../assets/images/printscreen/support-all.png)
  <figcaption>Exemple d'un azimut avec plusieurs cadres et signaux</figcaption>
</figure>

<figure markdown>
  ![Outil Azimut](../assets/images/printscreen/azimut-edit.png)
  <figcaption>Définition de l'azimut de manière graphique, grâce à l'outil</figcaption>
</figure>

Dans l'onglet “Documents“, des fichiers de tout format peuvent être liés à un support à travers leur chemin de stockage. L'extension [Document Management System](https://plugins.qgis.org/plugins/document_management_system/),fournit une interface pour gérer les relations du système de gestion des documents des deux côtés (côté document et côté objet). Elle prend en charge les relations 1-N et N-M. Les chemins vers les documents sont stockés dans la base de données dans la table `signalo_db.dms_document`.
