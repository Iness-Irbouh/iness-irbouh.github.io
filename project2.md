# 🤖 Projet 2 – Prédiction du Churn Client (Machine Learning)

## 🎯 Objectif du projet
L’objectif de ce projet est de prédire si un client quitte la banque ou non.
Pour cela, j’ai appliqué plusieurs méthodes de Machine Learning et comparé leurs performances.

Ce projet m’a permis de mettre en pratique un processus complet :  
- préparation et nettoyage des données  
- exploration des variables  
- mise en place de plusieurs modèles  
- comparaison des résultats  
- création de graphiques explicatifs  

C’est un projet concret basé sur un vrai jeu de données utilisé dans l’analyse du churn bancaire.

---

## 📁 1. Description des données
J’ai utilisé le fichier **Churn_Modelling.csv**, qui contient des informations sur 10 000 clients.

Les données incluent notamment :  
- Âge  
- Genre  
- Pays  
- Solde bancaire  
- Score crédit  
- Ancienneté  
- Produits détenus  
- Statut actif  

La variable à prédire est :

**Exited** → 1 si le client quitte la banque, 0 sinon.

Avant de commencer, j’ai supprimé les colonnes inutiles :  
- RowNumber  
- CustomerId  
- Surname   

Elles n’apportent aucune information utile pour un modèle.

---

# 🧹 2. Préparation et exploration
J’ai ensuite préparé les données :

- transformation des variables en facteurs,  
- vérification des valeurs manquantes,  
- création de graphiques pour comprendre la répartition des clients,  
- séparation des données en deux parties : **75% pour l’entraînement**, **25% pour le test**.

J’ai également réalisé quelques visualisations simples comme :  
- Age vs Balance  
- distribution des âges selon la classe  
- distribution des soldes selon la classe

Cela permet de repérer les tendances avant d’entraîner les modèles.

---

# 🔧 3. Modèles testés

## ✔ kNN (k-Nearest Neighbors)
C’est le premier modèle que j’ai testé.  
J’ai commencé avec **k = 5**, puis j’ai cherché le meilleur “k” possible en testant plusieurs valeurs.

J’ai aussi affiché la **frontière de décision**, qui montre comment le modèle sépare les clients sortants des clients restants.

---

## ✔ Régression Logistique
Ensuite, j’ai testé un modèle plus classique mais très efficace : la régression logistique.

J’ai créé deux versions :
- une version simple,
- une version améliorée avec le critère AIC (qui sélectionne les meilleures variables).

J’ai ensuite analysé :
- les probabilités prédites,  
- la matrice de confusion,  
- l’accuracy,  
- la sensibilité et la spécificité,  
- la courbe ROC et l’AUC.

---

## ✔ Naïve Bayes
J’ai testé un modèle Naïve Bayes, qui est rapide et simple à entraîner.

Pour celui-ci, j’ai aussi affiché sa frontière de décision.

---

## ✔ LDA et QDA
Pour compléter l’analyse, j’ai testé deux méthodes de classification :

- LDA (Linear Discriminant Analysis)  
- QDA (Quadratic Discriminant Analysis)

Ces deux modèles permettent de visualiser comment les classes se séparent lorsque les relations entre les variables ne sont pas forcément les mêmes.

Je les ai comparés via :
- leur accuracy,  
- leur sensibilité,  
- leur spécificité,  
- et leur matrice de confusion.

---

# 📉 4. Comparaison finale
J’ai regroupé les résultats de tous les modèles pour les comparer :

- Régression Logistique  
- kNN  
- Naïve Bayes  
- LDA  
- QDA  

Pour chacun, j’ai analysé :
- l’accuracy,  
- la sensibilité,  
- la spécificité,  
- et la courbe ROC.

Cela permet de choisir le modèle le plus efficace pour prédire la sortie d’un client.

---

# 🔧 État actuel du projet
Toute la partie **code** du projet est réalisée.  
Les modèles sont testés, les graphiques sont faits, et les résultats sont comparés.

Il me reste maintenant à :
- **rédiger un mémoire** pour expliquer ce que j’ai fait,  
- créer une **présentation orale** pour présenter les résultats de manière simple et claire.

Je suis donc dans la partie “explication et présentation”, la partie technique étant terminée.

---

# 💻 Code source complet

👉 **[Voir le code complet en R (Rmd)](projet%202.Rmd)**

Ce fichier contient l’ensemble du code :
- préparation des données,  
- visualisations,  
- modèles (kNN, Logistique, Naïve Bayes, LDA, QDA),  
- frontières de décision,  
- courbes ROC,  
- tableaux comparatifs.

---

👉 [Retour aux projets](projects.md)
