# ======================================================
# PROJET BDA — Python + SQL
# Problématique :
# Comment le niveau socio-économique (IPS) influence-t-il
# les performances des lycées parisiens au bac (2016–2019) ?
# ======================================================

import mysql.connector
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import os
import platform
import subprocess
from matplotlib.backends.backend_pdf import PdfPages

# ------------------------------------------------------
# 1. Connexion MySQL
# ------------------------------------------------------
cnx = mysql.connector.connect(
    host="localhost",
    user="pythonuser",
    password="python123",
    database="projet_bd_resultats_bac"
)
print("Connexion MySQL réussie")

# ------------------------------------------------------
# 2. Dossier & PDF de sortie
# ------------------------------------------------------
folder = "Figures_BDA"
os.makedirs(folder, exist_ok=True)

pdf_path = os.path.join(folder, "Projet_BDA_Visualisations.pdf")

# ------------------------------------------------------
# 3. Style global
# ------------------------------------------------------
sns.set_theme(style="whitegrid", palette="Set2")

# ------------------------------------------------------
# 4. Création du PDF
# ------------------------------------------------------
with PdfPages(pdf_path) as pdf:

    # ==================================================
    # VISU 1 — DOT PLOT : IPS moyen par année
    # ==================================================
    df1 = pd.read_sql("""
    SELECT I.Annee_scolaire AS Annee,
           AVG(I.IPS_GT_PRO_Ensemble) AS IPS_moyen
    FROM IPS I
    JOIN Etablissement E ON E.UAI = I.UAI
    WHERE E.Code_commune LIKE '75%'
    GROUP BY I.Annee_scolaire
    ORDER BY I.Annee_scolaire;
    """, cnx)

    fig, ax = plt.subplots(figsize=(8,5))
    sns.pointplot(data=df1, x="Annee", y="IPS_moyen", join=False, ax=ax)

    for i, v in enumerate(df1["IPS_moyen"]):
        ax.text(
            i,
            v - 0.10,              # texte sous le point
            f"{v:.2f}",
            ha="center",
            va="top",
            fontsize=10)

    ax.set_title("Évolution de l’IPS moyen des lycées parisiens (2016–2019)")
    ax.set_ylabel("IPS moyen")
    pdf.savefig(fig)
    plt.close(fig)

    # ==================================================
    # VISU 2 — LINEPLOT : Taux de réussite par année
    # ==================================================
    df2 = pd.read_sql("""
    SELECT R.Annee,
           AVG(R.Taux_reussite_Toutes_Series) AS Reussite_moyenne
    FROM Resultat_Bac R
    JOIN Etablissement E ON E.UAI = R.UAI
    WHERE E.Code_commune LIKE '75%'
    GROUP BY R.Annee
    ORDER BY R.Annee;
    """, cnx)

    fig, ax = plt.subplots(figsize=(9,5))
    sns.lineplot(data=df2, x="Annee", y="Reussite_moyenne", marker="o", linewidth=3, ax=ax)

    ax.set_title("Évolution du taux de réussite moyen au bac (2016–2019)")
    ax.set_ylabel("Taux de réussite (%)")
    pdf.savefig(fig)
    plt.close(fig)

    # ==================================================
    # VISU 3 — BOXPLOT : Réussite selon IPS
    # ==================================================
    df3 = pd.read_sql("""
    SELECT
        CASE 
            WHEN I.IPS_GT_PRO_Ensemble < 80 THEN 'IPS < 80'
            WHEN I.IPS_GT_PRO_Ensemble < 100 THEN '80–100'
            WHEN I.IPS_GT_PRO_Ensemble < 120 THEN '100–120'
            ELSE 'IPS ≥ 120'
        END AS Tranche_IPS,
        R.Taux_reussite_Toutes_Series AS Reussite
    FROM IPS I
    JOIN Resultat_Bac R ON R.UAI = I.UAI
    JOIN Etablissement E ON E.UAI = I.UAI
    WHERE E.Code_commune LIKE '75%';
    """, cnx)

    fig, ax = plt.subplots(figsize=(10,6))
    sns.boxplot(data=df3, x="Tranche_IPS", y="Reussite", ax=ax)

    ax.set_title("Distribution du taux de réussite selon le niveau socio-économique")
    ax.set_ylabel("Taux de réussite (%)")
    pdf.savefig(fig)
    plt.close(fig)

    # ==================================================
    # VISU 4 — CAMEMBERT : Répartition IPS
    # ==================================================
    counts = df3["Tranche_IPS"].value_counts()

    fig, ax = plt.subplots(figsize=(7,7))
    ax.pie(counts, labels=counts.index, autopct="%1.1f%%", startangle=90)
    ax.set_title("Répartition des lycées par tranche d’IPS")
    ax.axis("equal")
    pdf.savefig(fig)
    plt.close(fig)

    # ==================================================
    # VISU 5 — BARPLOT : IPS moyen par arrondissement
    # ==================================================
    df5 = pd.read_sql("""
    SELECT 
        CAST(RIGHT(C.Code_commune, 2) AS UNSIGNED) AS Arrondissement,
        AVG(I.IPS_GT_PRO_Ensemble) AS IPS_moyen
    FROM IPS I
    JOIN Etablissement E ON E.UAI = I.UAI
    JOIN Commune C ON C.Code_commune = E.Code_commune
    WHERE E.Code_commune LIKE '75%'
    GROUP BY Arrondissement
    ORDER BY Arrondissement;
    """, cnx)

    fig, ax = plt.subplots(figsize=(11,6))
    sns.barplot(data=df5, x="Arrondissement", y="IPS_moyen", ax=ax)

    ax.set_title("IPS moyen par arrondissement parisien")
    ax.set_xlabel("Arrondissement")
    pdf.savefig(fig)
    plt.close(fig)

    # ==================================================
    # VISU 6 — LOLLIPOP : Top 10 VA
    # ==================================================
    df6 = pd.read_sql("""
    SELECT E.Nom_etablissement AS Lycee,
           MAX(R.Valeur_Ajoutee_Taux_Reussite) AS VA_max
    FROM Resultat_Bac R
    JOIN Etablissement E ON E.UAI = R.UAI
    WHERE E.Code_commune LIKE '75%'
    GROUP BY E.UAI, E.Nom_etablissement
    ORDER BY VA_max DESC
    LIMIT 10;
    """, cnx)

    fig, ax = plt.subplots(figsize=(10,6))
    ax.hlines(df6["Lycee"], 0, df6["VA_max"], alpha=0.7)
    ax.plot(df6["VA_max"], df6["Lycee"], "o")

    ax.set_title("Top 10 des lycées parisiens selon la valeur ajoutée")
    ax.set_xlabel("Valeur ajoutée maximale")
    pdf.savefig(fig)
    plt.close(fig)

    # ==================================================
    # VISU 7 — HEATMAP : IPS × Réussite
    # ==================================================
    df7 = pd.read_sql("""
    SELECT 
        CAST(RIGHT(C.Code_commune, 2) AS UNSIGNED) AS Arrondissement,
        AVG(I.IPS_GT_PRO_Ensemble) AS IPS_moyen,
        AVG(R.Taux_reussite_Toutes_Series) AS Reussite_moyenne
    FROM Etablissement E
    JOIN Commune C ON C.Code_commune = E.Code_commune
    LEFT JOIN IPS I ON I.UAI = E.UAI
    LEFT JOIN Resultat_Bac R ON R.UAI = E.UAI
    WHERE E.Code_commune LIKE '75%'
    GROUP BY Arrondissement
    ORDER BY Arrondissement;
    """, cnx)

    heat = df7.set_index("Arrondissement")[["IPS_moyen", "Reussite_moyenne"]]

    fig, ax = plt.subplots(figsize=(6,8))
    sns.heatmap(heat, annot=True, fmt=".1f", cmap="viridis", ax=ax)

    ax.set_title("IPS moyen et réussite moyenne par arrondissement")
    pdf.savefig(fig)
    plt.close(fig)

# ------------------------------------------------------
# 5. Fermeture connexion + ouverture PDF
# ------------------------------------------------------
cnx.close()

system = platform.system()
if system == "Darwin":
    subprocess.call(["open", pdf_path])
elif system == "Windows":
    os.startfile(pdf_path)
else:
    subprocess.call(["xdg-open", pdf_path])

print("\nPDF unique généré avec succès :", pdf_path)
