# Projet 4 – Analyse des heures complémentaires des enseignants (Python)

Ce projet porte sur l’analyse des heures complémentaires (HETD) réalisées par les enseignants d’une UFR.  
À partir du fichier dataE.csv, j’ai développé deux versions du même travail : une version simple en Python pur et une version avancée utilisant pandas.

---

## 1. Version simple 

Dans cette première version, j’ai choisi de ne pas utiliser de librairies externes.  
J’ai traité directement le fichier CSV en utilisant uniquement les outils de base de Python.

Étapes réalisées :
- lecture manuelle du fichier CSV avec csv.DictReader ;  
- nettoyage et conversion des valeurs nécessaires ;  
- classement des enseignants par département et par statut ;  
- calcul du minimum, du maximum et de la moyenne des heures complémentaires ;  
- création d’un fichier CSV de synthèse pour chaque département ;  
- création d’un fichier séparé pour les enseignants sans département.

Cette version montre que je maîtrise la manipulation de fichiers, les structures de données (listes, dictionnaires), les boucles, les calculs simples et l’écriture de fichiers sans dépendre d’aucune librairie.

Lien vers le code :  
[Version simple en Python](code/TD_DATAE.py)

---

## 2. Version avec la librairie Pandas

Dans cette seconde version, j’ai repris le même objectif mais en utilisant la librairie pandas pour rendre l’analyse plus rapide et plus professionnelle.

Étapes réalisées :
- importation et nettoyage du fichier dataE.csv ;  
- harmonisation des colonnes (statut, département, heures) ;  
- regroupement des enseignants par département et par statut ;  
- calcul automatique des statistiques (minimum, maximum, moyenne) ;  
- création d’un fichier Excel complet regroupant tous les départements ;  
- génération automatique d’un graphique en barres pour visualiser la moyenne des heures complémentaires ;  
- création d’une feuille Excel par département, contenant à la fois les données et le graphique ;  
- ouverture automatique du fichier final.

Cette version permet de produire un document final clair, structuré et immédiatement exploitable, ce qui correspond davantage à une démarche professionnelle.

Lien vers le code :  
[Version avancée avec pandas](code/PandaVersion.py)

---
