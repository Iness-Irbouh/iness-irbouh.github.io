# Projet 1: Analyse des Données sur les Coupes du Monde de football (1930–2014)

## Objectif du projet
Ce projet a pour but d’analyser l’évolution des Coupes du Monde et les performances des équipes depuis 1930.  
Il démontre mes compétences en :
- manipulation et nettoyage de données,
- analyses statistiques (uni/bivariées),
- visualisation,
- Machine Learning,
- méthodes multivariées (ACP et clustering).

---

#  1. Données utilisées
J’ai travaillé à partir de trois fichiers :
- **world_cups.csv** : informations par édition (année, pays hôte, vainqueur, affluence).  
- **world_cup_matches.csv** : détails des matchs (équipes, scores, stades).  
- **data_dictionary.csv** : dictionnaire des variables.

Ces bases couvrent plus de **800 matchs** de 1930 à 2014.

### Compétences démontrées
- Importation multi-fichiers  
- Nettoyage et préparation  
- Jointures et création de variables  
- Harmonisation des types et formats

---

# 2. Analyse univariée
Objectif : comprendre la structure générale des données.

### Résultats clés
- L’affluence des Coupes du Monde augmente fortement depuis 1970.  
- Le record est atteint en **1994 (USA)**, avec plus de 3,5M de spectateurs.  
- Le nombre d’équipes passe de 13 (1930) à 32 (depuis 1998).  
- Les nations les plus titrées : Brésil (5), Allemagne (4), Italie (4).

---

#  3. Analyse bivariée
Objectif : étudier les relations entre variables sportives.

### Relations étudiées
- **Année ⟶ affluence** : croissance nette à long terme.  
- **Continent ⟶ performance** : domination européenne, excellence sud-américaine en matchs à enjeu.  
- **Décennie ⟶ buts/match** : baisse progressive depuis les années 1930.

### Compétences démontrées
- Comparaison de groupes  
- Tableaux croisés  
- Visualisations comparatives (boxplots, barplots)

---

# 4. Visualisations (ggplot2)
Plusieurs graphiques avancés ont été produits :

- évolution de l’affluence par année ;  
- distribution des buts par match ;  
- comparaison des continents ;  
- carte des pays hôtes ;  
- scores moyens par phase du tournoi.

---

# 5. Machine Learning — Régression logistique
Objectif : prédire la probabilité qu’une équipe gagne un match en fonction de :
- buts marqués,
- buts encaissés,
- continent,
- année,
- stade (phase du tournoi).

### Résultat
Le modèle montre une bonne capacité de prédiction avec une interprétation claire des coefficients.

---

# 6. Analyse multivariée — ACP
Objectif : réduire la dimension et analyser les profils d’équipes.

### Résultats
- Les premiers axes opposent équipes offensives vs défensives.  
- L’ACP met en évidence des groupes de nations ayant des styles similaires.


---

# 7. Clustering (K-means)
Objectif : segmenter les équipes sur la base de leurs performances.

### Résultats
- Cluster 1 : nations très performantes (Brésil, Allemagne, Italie).  
- Cluster 2 : équipes intermédiaires (France, Argentine, Espagne).  
- Cluster 3 : équipes irrégulières ou émergentes.


---

# 8. Conclusion du projet
Ce projet illustre ma capacité à réaliser un **projet data complet**, incluant :
- collecte et préparation des données,  
- analyses uni/bivariées,  
- data visualisation avancée,  
- modélisation prédictive,  
- méthodes multivariées (ACP, clustering),  
- synthèse claire et opérationnelle.

Il met en avant des compétences essentielles pour un poste de **Data Analyst / Data Scientist**.

---
---

---

# Code 

Le code R complet utilisé pour l’analyse de la Coupe du Monde est disponible ici en version Rmd:
**[Voir le code R du projet Coupe du Monde (Rmd)](code/coupe%20du%20monde.Rmd)**

Ou ici en version html:
 **[Voir la version HTML du projet (visualisation directe)](coupe%20du%20monde.nb.html)**

Ce fichier contient :

- l’importation des trois bases (world_cups.csv, world_cup_matches.csv, data_dictionary.csv)  
- la préparation et le nettoyage des données  
- les analyses univariées et bivariées  
- la création de toutes les visualisations (ggplot2)  
- l’analyse statistique et les tableaux  
- l’interprétation des résultats  
- la structure complète du projet en R Markdown avec les commentaires intégrés

# Retour aux projets  
 [Revenir à la liste des projets](projects.md)
