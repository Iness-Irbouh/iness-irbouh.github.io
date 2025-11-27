# 🧹 Projet 3 – Analyse AFC sur la répartition des tâches ménagères

## 🎯 Objectif du projet
Ce projet consiste à analyser comment plusieurs tâches ménagères sont réparties entre les membres d’un foyer (femme, mari, alternance, ou réalisé ensemble).  
Pour cela, j’ai utilisé une **Analyse des Correspondances (AFC)** afin d’identifier les associations entre types de tâches et personnes les réalisant.

Ce projet met en avant mes compétences en :
- statistiques descriptives,
- tableau de contingence,
- test du Chi²,
- Analyse Factorielle des Correspondances (AFC),
- interprétation visuelle des résultats,
- rédaction d’une analyse claire et structurée.

Il est basé sur le jeu de données **housetasks**.

---

## 📁 1. Données utilisées
Le tableau comporte :
- **13 tâches ménagères**,  
- **4 catégories de personnes** (Wife, Husband, Alternating, Jointly).

Ces données permettent d’étudier comment les rôles sont répartis au sein du foyer.

---

## 🧪 2. Test du Chi²
Le test d’indépendance montre clairement que les tâches ménagères **ne sont pas réparties au hasard**.

📌 Résultats clés (page 3 du PDF)  [oai_citation:1‡Exercice 2 data(housetasks) Un exo sexiste! (1) (1).pdf](sediment://file_00000000b6bc71f49cd1dd498a14a91b) :
- X² ≈ **1944.5**  
- p-value ≈ **0**, donc très significative  
➡️ On rejette l’hypothèse d’indépendance : **le lien entre tâche et personne est très fort**.

Exemples :
- La lessive, les repas → surtout réalisés par la femme  
- Les réparations, la conduite → plutôt réalisées par l’homme

---

## 📊 3. Tableau de contingence
Comme montré dans le document (page 4)  [oai_citation:2‡Exercice 2 data(housetasks) Un exo sexiste! (1) (1).pdf](sediment://file_00000000b6bc71f49cd1dd498a14a91b) :
- Wife réalise environ **34 %** des tâches,
- Husband environ **22 %**,
- Les tâches faites ensemble représentent près de **29 %**.

Cela montre déjà des différences importantes dans la répartition.

---

## 🧭 4. AFC : Analyse des axes
L’AFC permet de visualiser les associations principales.

✔ D’après les valeurs propres (page 6)  [oai_citation:3‡Exercice 2 data(housetasks) Un exo sexiste! (1) (1).pdf](sediment://file_00000000b6bc71f49cd1dd498a14a91b) :  
- Axe 1 explique **48,7 %**  
- Axe 2 explique **39,9 %**  
→ Les deux premiers axes expliquent **89 %** de l’information.

### 🔹 Axe 1 : Opposition “tâches féminines” / “tâches masculines”
- Laundry, Main_meal → très associés à **Wife**  
- Repairs, Driving → associés au **Husband**

### 🔹 Axe 2 : Les tâches partagées
- Jointly structure fortement l’axe 2 (page 9)  [oai_citation:4‡Exercice 2 data(housetasks) Un exo sexiste! (1) (1).pdf](sediment://file_00000000b6bc71f49cd1dd498a14a91b)  
- Holidays, Shopping, Dishes → tâches souvent faites ensemble

---

## 🎨 5. Visualisations clés
Plusieurs graphiques issus du PDF illustrent l’analyse (pages 12 à 15)  [oai_citation:5‡Exercice 2 data(housetasks) Un exo sexiste! (1) (1).pdf](sediment://file_00000000b6bc71f49cd1dd498a14a91b) :

- **Profils lignes** : regroupement des tâches proches  
- **Profils colonnes** : positions des rôles (Wife, Husband, Jointly…)  
- **Graphique superposé** : correspondance entre tâches et personnes  
- **Biplot asymétrique** : visualisation des relations avec flèches

Ces graphiques montrent clairement :
- un bloc de tâches domestiques souvent réalisées par la femme,
- un bloc de tâches techniques plutôt masculines,
- un ensemble de tâches partagées dans le couple.

---

## 🧩 6. Code R du projet
Le code complet utilisé pour l’AFC est disponible ici :

👉 **[Voir le code R du projet (Rmd)](Exercice2AFC.Rmd)**

---

## 📄 7. Rapport PDF détaillé
J’ai également produit un document visuel très complet :

👉 **[Voir le rapport PDF](Exercice%202%20data(housetasks)%20Un%20exo%20sexiste!%20(1)%20(1).pdf)**

---

## ✅ Résumé
Ce projet montre ma capacité à :
- analyser un tableau de contingence,
- mener une AFC complète,
- interpréter les axes et contributions,
- produire un rapport visuel clair et pédagogique,
- combiner statistiques + visualisation + rédaction.
