#  Projet D'Analyse de Données: Réaliser une AFC sur la répartition des tâches ménagères

## Objectif de l'analyse
L’objectif de ce projet est d’étudier comment différentes tâches ménagères sont réparties entre les membres d’un foyer (femme, mari, alternance, ou réalisé ensemble).  
Pour cela, j’ai réalisé une **Analyse des Correspondances (AFC)** afin d’identifier les liens entre les tâches et les personnes qui les accomplissent.

Ce projet permet d'effectuer:
- manipulation de tableaux de contingence,
- test du Chi²,
- analyses factorielles (AFC),
- visualisation et interprétation des résultats,
- synthèse et communication des analyses.

---

## 1. Données utilisées
Le jeu de données **housetasks** contient :  
- 13 tâches ménagères,
- 4 catégories de personnes : Wife, Husband, Alternating, Jointly.

Ce tableau permet d’étudier la répartition réelle des rôles au sein du foyer.

---

##  2. Test d’indépendance (Chi²)
Le test du Chi² montre que la répartition des tâches **n’est pas due au hasard**.  
Les différences entre tâches et personnes sont très significatives.

Exemples observés :
- Les tâches comme **la lessive, les repas, le repassage** → principalement réalisées par la femme.
- Les tâches comme **les réparations, la conduite** → plus souvent effectuées par l’homme.
- Certaines tâches (**vaisselle, courses, vacances**) sont souvent réalisées ensemble.

---

##  3. Résultats de l’AFC
L’AFC permet de visualiser les associations fortes entre tâches et personnes.

### Axe 1
Opposition entre :
- tâches majoritairement féminines,
- tâches majoritairement masculines.

### Axe 2
Opposition entre :
- tâches réalisées individuellement,
- tâches effectuées **en couple**.

Les deux premiers axes expliquent près de **90 % de l’inertie**, ce qui permet une excellente interprétation visuelle.

---

## 4. Visualisations produites
Le projet inclut plusieurs graphiques :
- profils lignes et colonnes,
- biplot de l’AFC,
- représentation des contributions,
- représentation jointe tâches/personnes.

Ces graphiques facilitent l’interprétation et donnent une vision claire des regroupements.

---

## 5. Code source du projet

**[Voir le code R du projet (Rmd)](code/code.housetasks.Rmd)**

Ce fichier contient :
- le tableau de contingence,
- le test du Chi²,
- l’AFC complète,
- les graphiques,
- les interprétations de base.

---

##  6. Rapport PDF

 **[Voir le rapport PDF](code/housetasks.pdf)**

Ce document regroupe :
- les résultats détaillés,
- les graphiques,
- les interprétations,
- la conclusion générale.

---

