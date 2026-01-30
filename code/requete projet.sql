-- Requête 1.1 : Liste des lycées parisiens (UAI + nom)
-- Objectif : définir le périmètre des établissements étudiés en sélectionnant uniquement les lycées situés à Paris.
-- Résultat attendu : obtenir la liste des UAI et des noms des lycées dont le code commune commence par 75.



SELECT UAI, Nom_etablissement
FROM Etablissement
WHERE Code_commune LIKE '75%';

-- Requête 1.2 : Liste des lycées parisiens privés puis publics
-- Objectif : distinguer clairement les lycées privés des lycées publics afin d’observer si le secteur peut influencer l’IPS ou les performances.
-- Résultat attendu : une liste des lycées parisiens triés d’abord par secteur (privé en premier), puis affichant leur UAI et leur nom.

SELECT UAI, Nom_etablissement, Secteur
FROM Etablissement
WHERE Code_commune LIKE '75%'
ORDER BY Secteur = 'public', Secteur = 'prive';

-- Requête 1.3 : Arrondissements parisiens ayant au moins un lycée
-- Objectif : contrôler que tousles arrondissements de Paris détiennent des lycées, afin de comprendre la répartition territoriale des établissements analysés.
-- Résultat attendu : la liste distincte des codes communes (arrondissements) contenant au moins un lycée parisien.


SELECT DISTINCT 
    C.Code_commune,
    C.Nom_commune
FROM Etablissement E
JOIN Commune C ON E.Code_commune = C.Code_commune
WHERE E.Code_commune LIKE '75%'
ORDER BY C.Code_commune;

-- Requête 1.4 : Détection des années de surperformance relative à l’IPS moyen
-- Objectif : identifier les années où les lycées parisiens affichent un taux de réussite supérieur à ce que leur IPS moyen laisserait attendre.
-- Résultat attendu : pour chaque année entre 2016 et 2019, afficher l’IPS moyen, la réussite moyenne et l’écart, afin de repérer les années de surperformance.

SELECT 
    R.Annee,
    AVG(I.IPS_GT_PRO_Ensemble) AS IPS_moyen_paris,
    AVG(R.Taux_reussite_Toutes_Series) AS Reussite_moyenne_paris,
    AVG(R.Taux_reussite_Toutes_Series) - AVG(I.IPS_GT_PRO_Ensemble) AS Ecart_reussite_IPS
FROM Resultat_Bac R
JOIN Etablissement E ON R.UAI = E.UAI
LEFT JOIN IPS I 
       ON I.UAI = E.UAI
      AND LEFT(I.Annee_scolaire, 4) = R.Annee
WHERE E.Code_commune LIKE '75%'
  AND R.Annee BETWEEN 2016 AND 2019
GROUP BY R.Annee
ORDER BY R.Annee;

-- Requête 1.5A : Résultats du meilleur lycée parisien
-- Objectif : identifier le lycée ayant obtenu le taux de réussite le plus élevé afin d’observer un cas de performance maximale.
-- Résultat attendu : le nom du lycée, son arrondissement et ses indicateurs de résultats pour l’année la plus performante.

SELECT 
    R.UAI,
    E.Nom_etablissement,
    C.Nom_commune AS Arrondissement,
    R.Annee,
    R.Taux_reussite_Toutes_Series,
    R.Taux_mentions_Toutes_Series,
    R.Valeur_Ajoutee_Taux_Reussite,
    R.Valeur_Ajoutee_Taux_Mentions
FROM Resultat_Bac R
JOIN Etablissement E ON R.UAI = E.UAI
JOIN Commune C ON E.Code_commune = C.Code_commune
WHERE E.Code_commune LIKE '75%'
ORDER BY R.Taux_reussite_Toutes_Series DESC
LIMIT 1;


-- Requête 1.5B : Résultats du pire lycée parisien
-- Objectif : identifier le lycée affichant le taux de réussite le plus faible afin d’analyser un cas de forte difficulté scolaire.
-- Résultat attendu : le nom du lycée, son arrondissement et ses indicateurs de résultats pour l’année la moins performante.

SELECT 
    R.UAI,
    E.Nom_etablissement,
    C.Nom_commune AS Arrondissement,
    R.Annee,
    R.Taux_reussite_Toutes_Series,
    R.Taux_mentions_Toutes_Series,
    R.Valeur_Ajoutee_Taux_Reussite,
    R.Valeur_Ajoutee_Taux_Mentions
FROM Resultat_Bac R
JOIN Etablissement E ON R.UAI = E.UAI
JOIN Commune C ON E.Code_commune = C.Code_commune
WHERE E.Code_commune LIKE '75%'
ORDER BY R.Taux_reussite_Toutes_Series ASC
LIMIT 1;


-- Requête 1.6 : IPS d’un lycée parisien sur une année donnée
-- Objectif : consulter le niveau socio-économique d’un lycée spécifique pour analyser son lien avec les performances.
-- Résultat attendu : afficher l’IPS du lycée d'Alembert pour l’année 2016-2017.

SELECT 
    I.UAI,
    E.Nom_etablissement,
    I.Annee_scolaire,
    I.IPS_GT_PRO_Ensemble
FROM IPS I
JOIN Etablissement E ON I.UAI = E.UAI
WHERE I.UAI = '0750650Z'
  AND I.Annee_scolaire = '2016-2017';
  
  
-- Requête 2.1 : Lycées parisiens avec leur arrondissement
-- Objectif : associer chaque lycée parisien à son arrondissement pour analyser la répartition territoriale des IPS et des performances scolaires.
-- Résultat attendu : la liste des lycées situés à Paris accompagnés du nom de leur arrondissement (commune).

SELECT 
    E.UAI,
    E.Nom_etablissement,
    C.Nom_commune AS Arrondissement
FROM Etablissement E
JOIN Commune C ON E.Code_commune = C.Code_commune
WHERE E.Code_commune LIKE '75%';

-- Requête 2.2 : Lycées parisiens avec leur IPS et leurs résultats au bac
-- Objectif : relier les indicateurs socio-économiques (IPS) aux performances scolaires en réunissant, pour chaque lycée parisien, son IPS et ses résultats au baccalauréat.
-- Résultat attendu : pour chaque lycée de Paris, afficher l’UAI, le nom, l’année, l’IPS et les taux de réussite pour permettre une première lecture de la relation IPS ↔ performance.

SELECT 
    E.UAI,
    E.Nom_etablissement,
    R.Annee,
    I.Annee_scolaire,
    I.IPS_GT_PRO_Ensemble AS IPS,
    R.Taux_reussite_Toutes_Series,
    R.Taux_mentions_Toutes_Series
FROM Etablissement E
JOIN Resultat_Bac R ON E.UAI = R.UAI
LEFT JOIN IPS I 
       ON E.UAI = I.UAI
      AND LEFT(I.Annee_scolaire, 4) = R.Annee  
WHERE E.Code_commune LIKE '75%';


-- Requête 2.3 : Nombre de lycées, IPS moyen et taux de réussite moyen par arrondissement
-- Objectif : analyser les disparités territoriales à Paris en comparant le nombre de lycées, 
-- le niveau socio-économique (IPS) et les performances scolaires par arrondissement.
-- Résultat attendu : un tableau trié par arrondissement (ordre croissant) présentant :
-- nombre de lycées, IPS moyen et taux de réussite moyen.

SELECT 
    C.Nom_commune AS Arrondissement,
    COUNT(DISTINCT E.UAI) AS Nb_lycees,
    AVG(I.IPS_GT_PRO_Ensemble) AS IPS_moyen,
    AVG(R.Taux_reussite_Toutes_Series) AS Reussite_moyenne
FROM Etablissement E
JOIN Commune C ON E.Code_commune = C.Code_commune
LEFT JOIN IPS I ON I.UAI = E.UAI
LEFT JOIN Resultat_Bac R ON R.UAI = E.UAI
WHERE E.Code_commune LIKE '75%'
GROUP BY C.Nom_commune, C.Code_commune
ORDER BY C.Code_commune ASC;



-- Requête 2.4 : Taux de réussite moyen par arrondissement (tous les arrondissements affichés)
-- Objectif : obtenir pour chaque arrondissement de Paris le taux de réussite moyen au bac,
-- même lorsque aucun lycée n’est présent dans l'arrondissement.
-- Résultat attendu : 20 lignes (Paris 1 à Paris 20), avec le taux de réussite lorsque disponible,
-- On obtient NULL pour le 1er et 2ème arrondissement 

SELECT 
    C.Code_commune,
    C.Nom_commune AS Arrondissement,
    AVG(R.Taux_reussite_Toutes_Series) AS Taux_reussite_moyen
FROM Commune C
LEFT JOIN Etablissement E 
       ON C.Code_commune = E.Code_commune
LEFT JOIN Resultat_Bac R 
       ON R.UAI = E.UAI
WHERE C.Code_commune LIKE '75%'
GROUP BY C.Code_commune, C.Nom_commune
ORDER BY C.Code_commune ASC;


-- Requête 2.5 : Lycées parisiens sans données IPS
-- Objectif : identifier les lycées situés à Paris pour lesquels aucune donnée IPS n'est disponible,
-- afin de repérer les établissements dont le niveau socio-économique n’a pas été mesuré dans la base.
-- Résultat attendu : la liste des lycées (UAI + nom + arrondissement) dont l’IPS est NULL.

SELECT
    E.UAI,
    E.Nom_etablissement,
    C.Nom_commune AS Arrondissement
FROM Etablissement E
JOIN Commune C ON C.Code_commune = E.Code_commune
LEFT JOIN IPS I ON I.UAI = E.UAI
WHERE E.Code_commune LIKE '75%'
  AND I.UAI IS NULL
ORDER BY C.Code_commune, E.Nom_etablissement;

-- Requête 3.1 : Lycées parisiens ayant un IPS inférieur à l’IPS moyen parisien
-- Objectif : identifier les établissements socio-économiquement défavorisés relativement à la moyenne de Paris,
-- afin d'analyser ensuite s'ils réussissent mieux ou moins bien que prévu.
-- Résultat attendu : la liste des lycées dont l’IPS est strictement inférieur à l’IPS moyen de tous les lycées parisiens qui est de 117.81.

SELECT 
    E.UAI,
    E.Nom_etablissement,
    C.Nom_commune AS Arrondissement,
    I.Annee_scolaire,
    I.IPS_GT_PRO_Ensemble AS IPS
FROM IPS I
JOIN Etablissement E ON E.UAI = I.UAI
JOIN Commune C ON C.Code_commune = E.Code_commune
WHERE E.Code_commune LIKE '75%'
  AND I.IPS_GT_PRO_Ensemble <
      (
         SELECT AVG(I2.IPS_GT_PRO_Ensemble)
         FROM IPS I2
         JOIN Etablissement E2 ON E2.UAI = I2.UAI
         WHERE E2.Code_commune LIKE '75%'
      )
ORDER BY I.IPS_GT_PRO_Ensemble ASC;

-- Requête 3.2 : Lycées parisiens dont le taux de réussite dépasse la moyenne parisienne
-- Objectif : identifier les lycées qui performent mieux que la moyenne académique de Paris,
-- afin d’analyser les écarts de performance indépendamment du niveau socio-économique.
-- Résultat attendu : la liste des lycées dont le taux de réussite est strictement supérieur
-- au taux de réussite moyen des lycées parisiens.

SELECT 
    E.UAI,
    E.Nom_etablissement,
    C.Nom_commune AS Arrondissement,
    R.Annee,
    R.Taux_reussite_Toutes_Series AS Taux_reussite
FROM Resultat_Bac R
JOIN Etablissement E ON E.UAI = R.UAI
JOIN Commune C ON C.Code_commune = E.Code_commune
WHERE E.Code_commune LIKE '75%'
  AND R.Taux_reussite_Toutes_Series >
      (
         SELECT AVG(R2.Taux_reussite_Toutes_Series)
         FROM Resultat_Bac R2
         JOIN Etablissement E2 ON E2.UAI = R2.UAI
         WHERE E2.Code_commune LIKE '75%'
      )
ORDER BY R.Taux_reussite_Toutes_Series DESC;

-- Requête 3.3 : Lycées meilleurs que TOUS les lycées à IPS similaire
-- Objectif : identifier les lycées dont les performances dépassent TOUTES celles des établissements
-- ayant un niveau socio-économique comparable (IPS proche).
-- Résultat attendu : la liste des lycées parisiens dont le taux de réussite est strictement supérieur
-- à celui de tous les lycées ayant un IPS dans un intervalle similaire (± 2 points).

SELECT 
    E.UAI,
    E.Nom_etablissement,
    C.Nom_commune AS Arrondissement,
    I.IPS_GT_PRO_Ensemble AS IPS,
    R.Taux_reussite_Toutes_Series AS Taux_reussite
FROM IPS I
JOIN Etablissement E ON E.UAI = I.UAI
JOIN Commune C ON C.Code_commune = E.Code_commune
JOIN Resultat_Bac R ON R.UAI = E.UAI
WHERE E.Code_commune LIKE '75%'
  AND R.Taux_reussite_Toutes_Series >
        ALL (
              SELECT R2.Taux_reussite_Toutes_Series
              FROM IPS I2
              JOIN Resultat_Bac R2 ON R2.UAI = I2.UAI
              WHERE ABS(I2.IPS_GT_PRO_Ensemble - I.IPS_GT_PRO_Ensemble) <= 2
                AND I2.UAI <> I.UAI
            )
ORDER BY R.Taux_reussite_Toutes_Series DESC;

-- Requête 3.4 : Lycées meilleurs qu'au moins un lycée favorisé (ANY)
-- Objectif : identifier les lycées socialement défavorisés (IPS faible) dont le taux de réussite
-- dépasse celui d'au moins un lycée favorisé (IPS élevé).
-- Résultat attendu : la liste des lycées parisiens dont les performances sont supérieures
-- à AU MOINS un établissement socio-économiquement favorisé.

SELECT
    E.UAI,
    E.Nom_etablissement,
    C.Nom_commune AS Arrondissement,
    I.IPS_GT_PRO_Ensemble AS IPS,
    R.Taux_reussite_Toutes_Series AS Taux_reussite
FROM IPS I
JOIN Etablissement E ON E.UAI = I.UAI
JOIN Commune C ON C.Code_commune = E.Code_commune
JOIN Resultat_Bac R ON R.UAI = E.UAI
WHERE E.Code_commune LIKE '75%'
  -- Lycées défavorisés : IPS faible
  AND I.IPS_GT_PRO_Ensemble < 100
  -- Comparaison ANY : ils font mieux qu'au moins un lycée favorisé
  AND R.Taux_reussite_Toutes_Series >
        ANY (
              SELECT R2.Taux_reussite_Toutes_Series
              FROM IPS I2
              JOIN Resultat_Bac R2 ON R2.UAI = I2.UAI
              WHERE I2.IPS_GT_PRO_Ensemble > 120
            )
ORDER BY R.Taux_reussite_Toutes_Series DESC;

-- Requête 3.5 : Lycées parisiens dont la valeur ajoutée est supérieure à la moyenne
-- Objectif : identifier les lycées qui obtiennent des résultats meilleurs que prévu
-- compte tenu de leurs caractéristiques sociales et scolaires.
-- Résultat attendu : la liste des lycées parisiens ayant une valeur ajoutée
-- supérieure à la valeur ajoutée moyenne de tous les lycées parisiens.

SELECT 
    E.UAI,
    E.Nom_etablissement,
    C.Nom_commune AS Arrondissement,
    R.Annee,
    R.Valeur_Ajoutee_Taux_Reussite AS VA_reussite
FROM Resultat_Bac R
JOIN Etablissement E ON E.UAI = R.UAI
JOIN Commune C ON C.Code_commune = E.Code_commune
WHERE E.Code_commune LIKE '75%'
  AND R.Valeur_Ajoutee_Taux_Reussite >
      (
        SELECT AVG(R2.Valeur_Ajoutee_Taux_Reussite)
        FROM Resultat_Bac R2
        JOIN Etablissement E2 ON E2.UAI = R2.UAI
        WHERE E2.Code_commune LIKE '75%'
      )
ORDER BY R.Valeur_Ajoutee_Taux_Reussite DESC;

-- Requête 3.6 : Arrondissement parisien le plus favorisé (IPS moyen maximal)
-- Objectif : identifier l’arrondissement dont les lycées présentent en moyenne le niveau socio-économique (IPS) le plus élevé.
-- Résultat attendu : l’arrondissement de Paris avec l’IPS moyen le plus élevé, ainsi que la valeur de cet IPS moyen.

SELECT 
    C.Nom_commune AS Arrondissement,
    AVG(I.IPS_GT_PRO_Ensemble) AS IPS_moyen
FROM IPS I
JOIN Etablissement E ON E.UAI = I.UAI
JOIN Commune C ON C.Code_commune = E.Code_commune
WHERE E.Code_commune LIKE '75%'
GROUP BY C.Nom_commune, C.Code_commune
ORDER BY IPS_moyen DESC
LIMIT 1;

-- Requête 3.7 : Lycées parisiens dont le taux de mentions est supérieur à la moyenne parisienne
-- Objectif : repérer les lycées qui se situent dans la moitié supérieure en termes de réussite qualitative.
-- Résultat attendu : la liste des lycées dont le taux de mentions dépasse la moyenne parisienne.

SELECT 
    E.UAI,
    E.Nom_etablissement,
    C.Nom_commune AS Arrondissement,
    R.Annee,
    R.Taux_mentions_Toutes_Series
FROM Resultat_Bac R
JOIN Etablissement E ON E.UAI = R.UAI
JOIN Commune C ON C.Code_commune = E.Code_commune
WHERE E.Code_commune LIKE '75%'
  AND R.Taux_mentions_Toutes_Series >
      (
         SELECT AVG(R2.Taux_mentions_Toutes_Series)
         FROM Resultat_Bac R2
         JOIN Etablissement E2 ON E2.UAI = R2.UAI
         WHERE E2.Code_commune LIKE '75%'
      )
ORDER BY R.Taux_mentions_Toutes_Series DESC;

-- Requête 3.8 : Lycées dont le taux de réussite dépasse la moyenne de leur arrondissement
-- Objectif : repérer les lycées qui sur-performent localement en comparaison
-- avec la performance moyenne de leur arrondissement parisien.
-- Résultat attendu : classement des lycées dont le taux de réussite est
-- supérieur à la moyenne de leur arrondissement.

SELECT 
    E.UAI,
    E.Nom_etablissement,
    C.Nom_commune AS Arrondissement,
    R.Annee,
    R.Taux_reussite_Toutes_Series AS Taux_lycee
FROM Resultat_Bac R
JOIN Etablissement E ON E.UAI = R.UAI
JOIN Commune C ON C.Code_commune = E.Code_commune
WHERE E.Code_commune LIKE '75%'
  AND R.Taux_reussite_Toutes_Series >
      (
        SELECT AVG(R2.Taux_reussite_Toutes_Series)
        FROM Resultat_Bac R2
        JOIN Etablissement E2 ON E2.UAI = R2.UAI
        WHERE E2.Code_commune = C.Code_commune
      )
ORDER BY R.Taux_reussite_Toutes_Series DESC;

-- Requête 4.1 : Union des lycées favorisés et des lycées très performants
-- Objectif : obtenir la liste combinée des lycées socio-économiquement favorisés (IPS > 120)
-- et des lycées très performants (taux de réussite > 95%), sans doublons.
-- Résultat attendu : un ensemble d'établissements parisiens appartenant à l'une ou l'autre catégorie.

(SELECT 
        E.UAI,
        E.Nom_etablissement,
        C.Nom_commune AS Arrondissement,
        I.IPS_GT_PRO_Ensemble AS IPS,
        NULL AS Taux_reussite
    FROM IPS I
    JOIN Etablissement E ON E.UAI = I.UAI
    JOIN Commune C ON C.Code_commune = E.Code_commune
    WHERE E.Code_commune LIKE '75%'
      AND I.IPS_GT_PRO_Ensemble > 120)
UNION
(SELECT
        E.UAI,
        E.Nom_etablissement,
        C.Nom_commune AS Arrondissement,
        NULL AS IPS,
        R.Taux_reussite_Toutes_Series AS Taux_reussite
    FROM Resultat_Bac R
    JOIN Etablissement E ON E.UAI = R.UAI
    JOIN Commune C ON C.Code_commune = E.Code_commune
    WHERE E.Code_commune LIKE '75%'
      AND R.Taux_reussite_Toutes_Series > 95)
ORDER BY UAI;


-- Requête 4.2 : Intersection entre lycées favorisés (IPS > 120)
-- et lycées très performants (taux de réussite > 95%).
-- Objectif : identifier les lycées cumulant à la fois un niveau socio-économique élevé
-- et des performances exceptionnelles au bac.
-- Résultat attendu : la liste des lycées parisiens remplissant simultanément les deux critères.

SELECT
    E.UAI,
    E.Nom_etablissement,
    C.Nom_commune AS Arrondissement,
    I.IPS_GT_PRO_Ensemble AS IPS,
    R.Taux_reussite_Toutes_Series AS Taux_reussite
FROM IPS I
JOIN Resultat_Bac R ON R.UAI = I.UAI
JOIN Etablissement E ON E.UAI = I.UAI
JOIN Commune C ON C.Code_commune = E.Code_commune
WHERE E.Code_commune LIKE '75%'
  AND I.IPS_GT_PRO_Ensemble > 120
  AND R.Taux_reussite_Toutes_Series > 95
ORDER BY R.Taux_reussite_Toutes_Series DESC;


-- Requête 4.3 : Requête composée simulant EXCEPT en MySQL
-- Objectif : obtenir les lycées très performants (>95%) tout en excluant
-- ceux qui sont favorisés (IPS > 120), comme le ferait EXCEPT en SQL standard.
-- Résultat attendu : les lycées performants mais non favorisés.

-- Ensemble A : lycées très performants
SELECT 
    E.UAI,
    E.Nom_etablissement,
    C.Nom_commune AS Arrondissement,
    R.Taux_reussite_Toutes_Series AS Taux_reussite
FROM Resultat_Bac R
JOIN Etablissement E ON E.UAI = R.UAI
JOIN Commune C ON C.Code_commune = E.Code_commune
WHERE E.Code_commune LIKE '75%'
  AND R.Taux_reussite_Toutes_Series > 95
AND E.UAI NOT IN (
    SELECT I.UAI
    FROM IPS I
    JOIN Etablissement E2 ON E2.UAI = I.UAI
    WHERE E2.Code_commune LIKE '75%'
      AND I.IPS_GT_PRO_Ensemble > 120
)
ORDER BY Taux_reussite DESC;


-- Requête 5.1 : Ajout d'un lycée parisien fictif et crédible
-- Objectif : enrichir la base avec un établissement imaginé mais cohérent avec le paysage éducatif parisien.
-- Résultat attendu : insertion d'un lycée parisien aux caractéristiques réalistes.

INSERT INTO Etablissement (UAI, Nom_etablissement, Type_lycee, Secteur, Code_commune)
VALUES ('7500D3S','Lycée des Didier Saint Samuel Sébastien (D3S)','lycée général','prive', '75110');

-- Requête 5.2 : Ajouter une valeur d'IPS pour le lycée fictif
-- Objectif : compléter les données socio-économiques du lycée "Lycée des Arts & Sciences du Canal Saint-Martin"
-- afin de l'intégrer pleinement aux analyses portant sur l'IPS et les performances.
-- Résultat attendu : une nouvelle ligne insérée dans la table IPS pour l'année choisie.

INSERT INTO IPS (UAI, Annee_scolaire, IPS_GT_PRO_Ensemble)
VALUES ('7500D3S', '2018-2019', 93.95);

-- Requête 6.1 : Correction d'une valeur IPS erronée
-- Objectif : rectifier une erreur de saisie dans les données socio-économiques (IPS) 
-- d’un lycée parisien pour garantir la fiabilité des analyses.
-- Résultat attendu : l'IPS mis à jour correctement pour l'établissement concerné.

UPDATE IPS
SET IPS_GT_PRO_Ensemble = 118.00
WHERE UAI = '0931683S'
  AND Annee_scolaire = '2018-2019';
  
-- Requête 6.2 : Mise à jour d'une valeur ajoutée (VA) suite à réévaluation
-- Objectif : ajuster la valeur ajoutée d’un lycée parisien après correction des données
-- statistiques initiales du ministère.
-- Résultat attendu : une nouvelle valeur ajoutée mise à jour pour l’année ciblée.

UPDATE Resultat_Bac
SET Valeur_Ajoutee_Taux_Reussite = Valeur_Ajoutee_Taux_Reussite + 0.80
WHERE UAI = '0750650J'
  AND Annee = 2019;

-- Requête 7.1 : IPS moyen des lycées parisiens (toutes années 2016–2019)
-- Objectif : obtenir une mesure globale du niveau socio-économique des lycées parisiens
-- afin d’établir un point de comparaison pour les analyses de performance.
-- Résultat attendu : l'IPS moyen agrégé de tous les établissements parisiens en 2016–2019.

SELECT 
    AVG(I.IPS_GT_PRO_Ensemble) AS IPS_moyen_paris
FROM IPS I
JOIN Etablissement E ON E.UAI = I.UAI
WHERE E.Code_commune LIKE '75%';

-- Requête 7.2 : IPS moyen des lycées parisiens par année (2016–2019)
-- Objectif : analyser l’évolution du niveau socio-économique (IPS) des lycées parisiens
-- au fil du temps afin d’identifier une progression, stagnation ou dégradation du territoire.
-- Résultat attendu : un tableau indiquant, pour chaque année scolaire disponible,
-- l’IPS moyen des lycées parisiens.

SELECT 
    I.Annee_scolaire,
    AVG(I.IPS_GT_PRO_Ensemble) AS IPS_moyen_annuel
FROM IPS I
JOIN Etablissement E ON E.UAI = I.UAI
WHERE E.Code_commune LIKE '75%'
GROUP BY I.Annee_scolaire
ORDER BY I.Annee_scolaire;

-- Requête 7.3 : Taux de réussite moyen des lycées parisiens par année (2016–2019)
-- Objectif : analyser l’évolution des performances scolaires à Paris sur la période étudiée
-- afin de voir si le niveau de réussite progresse, régresse ou reste stable.
-- Résultat attendu : un tableau indiquant, pour chaque année, le taux de réussite moyen
-- des lycées parisiens toutes séries confondues.

SELECT 
    R.Annee,
    AVG(R.Taux_reussite_Toutes_Series) AS Taux_reussite_moyen
FROM Resultat_Bac R
JOIN Etablissement E ON E.UAI = R.UAI
WHERE E.Code_commune LIKE '75%'
GROUP BY R.Annee
ORDER BY R.Annee;

-- Requête 7.4 : Taux de réussite moyen des lycées par arrondissement
-- Objectif : comparer les performances scolaires des différents arrondissements parisiens
-- afin d'identifier les zones les plus performantes ou en difficulté.
-- Résultat attendu : un tableau indiquant, pour chaque arrondissement, 
-- le taux de réussite moyen des lycées situés sur son territoire.

SELECT 
    C.Nom_commune AS Arrondissement,
    AVG(R.Taux_reussite_Toutes_Series) AS Taux_reussite_moyen
FROM Resultat_Bac R
JOIN Etablissement E ON E.UAI = R.UAI
JOIN Commune C ON C.Code_commune = E.Code_commune
WHERE E.Code_commune LIKE '75%'
GROUP BY C.Nom_commune, C.Code_commune
ORDER BY C.Code_commune;

-- Requête 7.5 : Écart moyen entre l’IPS et le taux de réussite des lycées parisiens
-- Objectif : mesurer le décalage moyen entre le niveau socio-économique (IPS)
-- et la performance scolaire (taux de réussite) afin d'évaluer la cohérence
-- entre contexte social et résultats académiques.
-- Résultat attendu : une valeur moyenne représentant la différence IPS ↔ réussite
-- pour l’ensemble des lycées parisiens.

SELECT 
    AVG(ABS(I.IPS_GT_PRO_Ensemble - R.Taux_reussite_Toutes_Series)) 
        AS Ecart_moyen_IPS_Reussite
FROM IPS I
JOIN Resultat_Bac R ON R.UAI = I.UAI
JOIN Etablissement E ON E.UAI = I.UAI
WHERE E.Code_commune LIKE '75%';

-- Requête 7.6 : Top 10 des lycées parisiens selon leur meilleure valeur ajoutée (VA maximale)
-- Objectif : identifier les lycées ayant déjà atteint un niveau de sur-performance exceptionnel,
-- c'est-à-dire leur meilleure valeur ajoutée enregistrée entre 2016 et 2019.
-- Résultat attendu : les 10 lycées parisiens avec la VA maximale la plus élevée.

SELECT
    E.UAI,
    E.Nom_etablissement,
    C.Nom_commune AS Arrondissement,
    MAX(R.Valeur_Ajoutee_Taux_Reussite) AS VA_maximale
FROM Resultat_Bac R
JOIN Etablissement E ON E.UAI = R.UAI
JOIN Commune C ON C.Code_commune = E.Code_commune
WHERE E.Code_commune LIKE '75%'
GROUP BY E.UAI, E.Nom_etablissement, C.Nom_commune
ORDER BY VA_maximale DESC
LIMIT 10;

-- les requête 7.7 ne prennent pas en compte l'année ainsi un lycée peut être compter 3 fois dans un même IPS ou bien ëtre compter dans plusieurs IPS si la valeur d'une année à l'autre varie.

-- Requête 7.7.a : Nombre de lycées parisiens avec un IPS strictement inférieur à 80
-- Objectif : compter les lycées les plus défavorisés selon l’IPS.
-- Résultat attendu : un seul nombre indiquant combien de lycées ont un IPS < 80.

SELECT COUNT(*) AS Lycees_IPS_inf_80
FROM IPS I
JOIN Etablissement E ON E.UAI = I.UAI
WHERE E.Code_commune LIKE '75%'
  AND I.IPS_GT_PRO_Ensemble < 80;

-- Requête 7.7.b : Nombre de lycées parisiens avec un IPS compris entre 80 et 100
-- Objectif : compter les lycées ayant un environnement socio-économique “intermédiaire”.
-- Résultat attendu : un seul nombre indiquant combien de lycées ont 80 ≤ IPS < 100.

SELECT COUNT(*) AS Lycees_IPS_80_100
FROM IPS I
JOIN Etablissement E ON E.UAI = I.UAI
WHERE E.Code_commune LIKE '75%'
  AND I.IPS_GT_PRO_Ensemble >= 80
  AND I.IPS_GT_PRO_Ensemble < 100;
  
-- Requête 7.7.c : Nombre de lycées parisiens avec un IPS compris entre 100 et 120
-- Objectif : compter les lycées plutôt favorisés sur le plan socio-économique.
-- Résultat attendu : un seul nombre indiquant combien de lycées ont 100 ≤ IPS < 120.

SELECT COUNT(*) AS Lycees_IPS_100_120
FROM IPS I
JOIN Etablissement E ON E.UAI = I.UAI
WHERE E.Code_commune LIKE '75%'
  AND I.IPS_GT_PRO_Ensemble >= 100
  AND I.IPS_GT_PRO_Ensemble < 120;
  
-- Requête 7.7.d : Nombre de lycées parisiens avec un IPS supérieur ou égal à 120
-- Objectif : compter les lycées les plus favorisés socio-économiquement.
-- Résultat attendu : un seul nombre indiquant combien de lycées ont un IPS ≥ 120.

SELECT COUNT(*) AS Lycees_IPS_sup_120
FROM IPS I
JOIN Etablissement E ON E.UAI = I.UAI
WHERE E.Code_commune LIKE '75%'
  AND I.IPS_GT_PRO_Ensemble >= 120;

-- Requête 7.8 : Nombre de lycées publics et privés à Paris
-- Objectif : comparer la répartition des lycées parisiens selon le secteur (public / privé).
-- Résultat attendu : un tableau avec deux lignes indiquant, pour Paris, le nombre de lycées publics
-- et le nombre de lycées privés.

SELECT 
    Secteur,
    COUNT(*) AS Nombre_lycees
FROM Etablissement
WHERE Code_commune LIKE '75%'
GROUP BY Secteur;

-- Requête 7.9 : Nombre total d'élèves présents au bac à Paris et évolution annuelle
-- Objectif : analyser la dynamique du nombre d'élèves qui se présentent au bac
-- afin de comprendre l'évolution de la population scolarisée à Paris.
-- Résultat attendu : un tableau indiquant, pour chaque année (2016–2019),
-- le total des élèves présents au bac dans les lycées parisiens.

SELECT 
    R.Annee,
    SUM(R.Presents_Toutes_Series) AS Total_presents
FROM Resultat_Bac R
JOIN Etablissement E ON E.UAI = R.UAI
WHERE E.Code_commune LIKE '75%'
GROUP BY R.Annee
ORDER BY R.Annee;

-- Requête 7.10 : Classement des lycées par “score de performance”
-- Objectif : construire un indicateur synthétique combinant IPS, valeur ajoutée
-- et taux de réussite pour comparer les lycées de manière globale.
-- Résultat attendu : un classement des lycées parisiens selon un score calculé.

SELECT 
    E.UAI,
    E.Nom_etablissement,
    C.Nom_commune AS Arrondissement,
    MIN(I.IPS_GT_PRO_Ensemble) AS IPS_min,
    MAX(R.Valeur_Ajoutee_Taux_Reussite) AS VA_max,
    MAX(R.Taux_reussite_Toutes_Series) AS Reussite_max,
    (MAX(R.Valeur_Ajoutee_Taux_Reussite) + MAX(R.Taux_reussite_Toutes_Series))* MIN(I.IPS_GT_PRO_Ensemble) AS Score_performance
FROM Etablissement E
JOIN IPS I ON I.UAI = E.UAI
JOIN Resultat_Bac R ON R.UAI = E.UAI
JOIN Commune C ON C.Code_commune = E.Code_commune
WHERE E.Code_commune LIKE '75%'
GROUP BY E.UAI, E.Nom_etablissement, C.Nom_commune
ORDER BY Score_performance DESC;


-- Requête 8.1 : Création de la vue "Performance_globale_lycee_Paris"
-- Objectif : regrouper en une seule vue les informations essentielles pour analyser
-- la performance globale des lycées parisiens (IPS, valeur ajoutée et réussite).
-- Résultat attendu : une vue listant chaque lycée parisien avec :
-- - son nom
-- - son arrondissement
-- - son IPS minimal (meilleure année IPS)
-- - sa valeur ajoutée maximale
-- - son taux de réussite maximal

CREATE VIEW Performance_globale_lycee_Paris AS
SELECT 
    E.UAI,
    E.Nom_etablissement,
    C.Nom_commune AS Arrondissement,
    MIN(I.IPS_GT_PRO_Ensemble) AS IPS_min,
    MAX(R.Valeur_Ajoutee_Taux_Reussite) AS VA_max,
    MAX(R.Taux_reussite_Toutes_Series) AS Reussite_max
FROM Etablissement E
JOIN Commune C ON C.Code_commune = E.Code_commune
JOIN IPS I ON I.UAI = E.UAI
JOIN Resultat_Bac R ON R.UAI = E.UAI
WHERE E.Code_commune LIKE '75%'
GROUP BY 
    E.UAI, E.Nom_etablissement, C.Nom_commune;
    

-- Requête 8.2 : Création de la vue "Evolution_2016_2019_Paris"
-- Objectif : suivre l'évolution de l'IPS et du taux de réussite des lycées parisiens
-- entre 2016 et 2019, pour analyser les tendances sociales et scolaires.
-- Résultat attendu : une vue listant, pour chaque lycée et pour chaque année,
-- son IPS (année correspondante) et son taux de réussite.

CREATE VIEW Evolution_2016_2019_Paris AS
SELECT
    E.UAI,
    E.Nom_etablissement,
    C.Nom_commune AS Arrondissement,
    R.Annee,
    I.IPS_GT_PRO_Ensemble AS IPS_annee,
    R.Taux_reussite_Toutes_Series AS Taux_reussite_annee
FROM Etablissement E
JOIN Commune C ON C.Code_commune = E.Code_commune
JOIN IPS I ON I.UAI = E.UAI
JOIN Resultat_Bac R ON R.UAI = E.UAI
WHERE E.Code_commune LIKE '75%'
  AND R.Annee BETWEEN 2016 AND 2019
  AND I.Annee_scolaire LIKE '%201%';

-- Requête 9.1 : Classement des lycées parisiens selon l'écart entre IPS et taux de réussite
-- Objectif : calculer, pour chaque lycée, l'écart entre son IPS et son taux de réussite,
-- puis classer les lycées du plus "atypique" (écart fort) au plus "cohérent" (écart faible).
-- Résultat attendu : un tableau trié présentant les lycées et leur écart IPS <=> réussite.

WITH Ecart_IPS_Reussite AS (
    SELECT 
        E.UAI,
        E.Nom_etablissement,
        C.Nom_commune AS Arrondissement,
        MIN(I.IPS_GT_PRO_Ensemble) AS IPS_min,
        MAX(R.Taux_reussite_Toutes_Series) AS Reussite_max,
        ABS(MIN(I.IPS_GT_PRO_Ensemble) - MAX(R.Taux_reussite_Toutes_Series)) AS Ecart_IPS_Reussite
    FROM Etablissement E
    JOIN Commune C ON C.Code_commune = E.Code_commune
    JOIN IPS I ON I.UAI = E.UAI
    JOIN Resultat_Bac R ON R.UAI = E.UAI
    WHERE E.Code_commune LIKE '75%'
    GROUP BY E.UAI, E.Nom_etablissement, C.Nom_commune)
SELECT *
FROM Ecart_IPS_Reussite
ORDER BY Ecart_IPS_Reussite DESC;

-- Requête 9.2 : Lycées parisiens "meilleurs que prévu" selon la valeur ajoutée (VA > 0)
-- Objectif : identifier les lycées qui surperforment par rapport à ce qu'indique leur IPS,
-- c'est-à-dire ceux dont la valeur ajoutée est strictement positive.
-- Résultat attendu : la liste des lycées parisiens avec VA > 0, leur arrondissement et leur VA maximale.

WITH Lycees_Meilleurs_Que_Prevu AS (
    SELECT 
        E.UAI,
        E.Nom_etablissement,
        C.Nom_commune AS Arrondissement,
        MAX(R.Valeur_Ajoutee_Taux_Reussite) AS VA_max
    FROM Etablissement E
    JOIN Commune C ON C.Code_commune = E.Code_commune
    JOIN Resultat_Bac R ON R.UAI = E.UAI
    WHERE E.Code_commune LIKE '75%'
    GROUP BY E.UAI, E.Nom_etablissement, C.Nom_commune)
SELECT *
FROM Lycees_Meilleurs_Que_Prevu
WHERE VA_max > 0
ORDER BY VA_max DESC;

-- Requête 10.1 : Arrondissements où l'écart entre IPS et taux de réussite est le plus anormal
-- Objectif : mesurer, pour chaque arrondissement, l'écart moyen entre l'IPS et la réussite
-- afin d'identifier les zones où les performances scolaires sont les moins cohérentes
-- avec le niveau socio-économique.
-- Résultat attendu : un classement des arrondissements du plus anormal au plus cohérent.

WITH Ecart_Par_Lycee AS (
    SELECT 
        C.Nom_commune AS Arrondissement,
        MIN(I.IPS_GT_PRO_Ensemble) AS IPS_min,
        MAX(R.Taux_reussite_Toutes_Series) AS Reussite_max,
        ABS(MIN(I.IPS_GT_PRO_Ensemble) - MAX(R.Taux_reussite_Toutes_Series)) AS Ecart_Lycee
    FROM Etablissement E
    JOIN Commune C ON C.Code_commune = E.Code_commune
    LEFT JOIN IPS I ON I.UAI = E.UAI         -- jointure externe demandée
    LEFT JOIN Resultat_Bac R ON R.UAI = E.UAI
    WHERE E.Code_commune LIKE '75%'
    GROUP BY C.Nom_commune)
SELECT 
    Arrondissement,
    Ecart_Lycee AS Ecart_Anormal
FROM Ecart_Par_Lycee
ORDER BY Ecart_Anormal DESC;


-- Requête 10.2 : Lycées parisiens ayant des résultats au Bac mais aucune donnée IPS
-- Objectif : détecter les établissements pour lesquels l'État publie des résultats
-- mais ne fournit aucune information sur l'IPS.
-- Résultat attendu : liste des lycées parisiens avec données Bac mais IPS manquant.

SELECT 
    E.UAI,
    E.Nom_etablissement,
    C.Nom_commune AS Arrondissement
FROM Etablissement E
JOIN Commune C ON C.Code_commune = E.Code_commune
JOIN Resultat_Bac R ON R.UAI = E.UAI
LEFT JOIN IPS I ON I.UAI = E.UAI     
WHERE E.Code_commune LIKE '75%'
  AND I.UAI IS NULL;                 
  

-- Requête 11.1 : Analyse du plan d'exécution d'une requête lourde (multi-jointures)
-- Objectif : examiner, grâce à EXPLAIN, comment MySQL exécute une requête complexe
-- contenant plusieurs jointures et un GROUP BY. Cela permet d'identifier les points
-- coûteux et d'optimiser ensuite la requête (index, réécriture, etc.).
-- Résultat attendu : un tableau EXPLAIN montrant le type de jointure,
-- le nombre de lignes parcourues et les colonnes utilisées pour les recherches.

EXPLAIN
WITH Ecart_IPS_Reussite AS (
    SELECT 
        E.UAI,
        E.Nom_etablissement,
        C.Nom_commune AS Arrondissement,

        MIN(I.IPS_GT_PRO_Ensemble) AS IPS_min,
        MAX(R.Taux_reussite_Toutes_Series) AS Reussite_max,

        ABS(MIN(I.IPS_GT_PRO_Ensemble) - MAX(R.Taux_reussite_Toutes_Series)) AS Ecart_IPS_Reussite
    FROM Etablissement E
    JOIN Commune C ON C.Code_commune = E.Code_commune
    JOIN IPS I ON I.UAI = E.UAI
    JOIN Resultat_Bac R ON R.UAI = E.UAI
    WHERE E.Code_commune LIKE '75%'
    GROUP BY E.UAI, E.Nom_etablissement, C.Nom_commune)
SELECT *
FROM Ecart_IPS_Reussite
ORDER BY Ecart_IPS_Reussite DESC;

-- Requête 11.2 : Création d'index pour optimiser les requêtes lourdes
-- Objectif : accélérer les jointures et les filtrages utilisés dans les requêtes du projet.
-- Résultat attendu : réduction du coût des jointures sur UAI, des recherches sur Code_commune,
-- et des filtrages par année dans Resultat_Bac.

-- Index pour accélérer toutes les jointures utilisant la clé UAI
CREATE INDEX idx_etablissement_uai ON Etablissement(UAI);
CREATE INDEX idx_ips_uai ON IPS(UAI);
CREATE INDEX idx_resultat_uai ON Resultat_Bac(UAI);

-- Index pour optimiser les requêtes filtrant les lycées parisiens (Code_commune LIKE '75%')
CREATE INDEX idx_etablissement_commune ON Etablissement(Code_commune);

-- Index pour optimiser les analyses temporelles (filtre / groupement par année)
CREATE INDEX idx_resultat_annee ON Resultat_Bac(Annee);

-- Requête 11.3 : Réécriture d'une sous-requête corrélée en jointure plus efficace
-- Objectif : remplacer la sous-requête corrélée de la requête 3.8 par une jointure
-- avec une table dérivée qui contient, pour chaque arrondissement, le taux de réussite moyen.
-- Résultat attendu : même liste de lycées "meilleurs que la moyenne de leur arrondissement",
-- mais avec un plan d'exécution plus efficace (moins de recalculs répétés).

SELECT 
    E.UAI,
    E.Nom_etablissement,
    C.Nom_commune AS Arrondissement,
    R.Annee,
    R.Taux_reussite_Toutes_Series AS Taux_lycee,
    T.Taux_reussite_moyen_arrdt
FROM Resultat_Bac R
JOIN Etablissement E ON E.UAI = R.UAI
JOIN Commune C ON C.Code_commune = E.Code_commune
JOIN (SELECT 
            C2.Code_commune,
            AVG(R2.Taux_reussite_Toutes_Series) AS Taux_reussite_moyen_arrdt
        FROM Resultat_Bac R2
        JOIN Etablissement E2 ON E2.UAI = R2.UAI
        JOIN Commune C2 ON C2.Code_commune = E2.Code_commune
        WHERE E2.Code_commune LIKE '75%'
        GROUP BY C2.Code_commune) AS T
     ON T.Code_commune = C.Code_commune
WHERE E.Code_commune LIKE '75%'
  AND R.Taux_reussite_Toutes_Series > T.Taux_reussite_moyen_arrdt
ORDER BY R.Taux_reussite_Toutes_Series DESC;

