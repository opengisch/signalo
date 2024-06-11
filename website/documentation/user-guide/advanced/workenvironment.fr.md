---
title: Environnements de travail
tx_slug: documentation_user-guide_advanced_workenvironment
---

# Environnements de travail

Vous avez la possibilité d'avoir plusieurs environnements de travail: test, production, …
Plusieurs fichiers projets sont disponibles avec chaque version:

| Fichier projet | nom du service PG     | exemple d'utilisation |
| ------------- | ---------------------- | --------------------- |
| `signalo.qgs` | `pg_signalo`           | demo                  |
| `signalo_prod.qgs` | `pg_signalo_prod` | production            |
| `signalo_dev.qgs` | `pg_signalo_dev`   | test et développement |

  
## PG Service Parser

L'extension [PG Service Parser](https://github.com/opengisch/qgis-pg-service-parser-plugin) permet de visualiser, d'éditer ou de copier les entrées du service PG (i.e., pg_service.conf) pour les connexions PostgreSQL. Cela permet de travailler avec un seul projet QGIS et de simplement adapter les informations du service pour pointer vers la base de données souhaitée.

Cette extension peut être utilisé en cas de bases de données clients différents ou pour gérer les différents environnements de travail avec un seul projet.
