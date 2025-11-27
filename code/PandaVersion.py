import pandas as pd
import matplotlib.pyplot as plt
import os

# Charger le fichier CSV
df = pd.read_csv('/Users/inessirbouh/Desktop/Cours Python/dataE.csv', sep=';', encoding='utf-8')

# Nettoyage et préparation
df['Total_HETD'] = pd.to_numeric(df['Total_HETD'], errors='coerce').fillna(0)
df['STATUT'] = df['Grade'].str.upper().str.strip()
df['DEPARTEMENT'] = df['LIB_DPT'].str.strip()
df.loc[df['STATUT'].isin(['AGREGE', 'CERTIFIE']), 'STATUT'] = 'AGREGES/CERTIFIES'

# Liste des départements
departements = df['DEPARTEMENT'].dropna().unique().tolist()

# Création du fichier Excel
with pd.ExcelWriter("synthese_departements.xlsx", engine="xlsxwriter") as writer:
    for dep in departements:
        data_dep = df[df['DEPARTEMENT'] == dep]

        # Calcul des statistiques
        result = data_dep.groupby('STATUT')['Total_HETD'].agg(
            min_HSUP='min',
            max_HSUP='max',
            moy_HSUP=lambda x: round(x.mean(), 2)
        ).reset_index()

        # Ligne "TOUS"
        result.loc[len(result)] = [
            "TOUS",
            data_dep['Total_HETD'].min(),
            data_dep['Total_HETD'].max(),
            round(data_dep['Total_HETD'].mean(), 2)
        ]

        # Export du tableau dans l’onglet
        feuille = dep.replace(" ", "_")[:30]
        result.to_excel(writer, sheet_name=feuille, index=False, startrow=0)

        # Créer un graphique à barres des moyennes
        workbook  = writer.book
        worksheet = writer.sheets[feuille]
        chart = workbook.add_chart({'type': 'column'})

        # Plage de données pour le graphique
        n_rows = len(result)
        chart.add_series({
            'name': 'Moyenne HSUP',
            'categories': [feuille, 1, 0, n_rows, 0],  # STATUT
            'values': [feuille, 1, 3, n_rows, 3],      # moy_HSUP
            'fill': {'color': '#4472C4'}
        })

        # Ajouter un titre et axes
        chart.set_title({'name': f'Moyenne des HSUP - {dep}'})
        chart.set_x_axis({'name': 'Statut'})
        chart.set_y_axis({'name': 'Moyenne des heures'})

        # Insérer le graphique dans la feuille
        worksheet.insert_chart('F2', chart)

print("✅ Fichier Excel créé avec graphiques : synthese_departements.xlsx")

# Ouvrir automatiquement sur Mac
os.system("open 'synthese_departements.xlsx'")
