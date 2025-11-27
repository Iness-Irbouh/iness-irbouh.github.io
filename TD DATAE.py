import csv
import statistics

# Ouverture du fichier avec le bon séparateur (;)
with open('/Users/inessirbouh/Desktop/Cours Python/dataE.csv', 'r', newline='', encoding='utf-8') as fic:
    lecteur = csv.DictReader(fic, delimiter=';')
    data = [ligne for ligne in lecteur]

print("✅ Colonnes détectées :", list(data[0].keys()))

# Conversion des valeurs d'heures totales
for ligne in data:
    try:
        ligne['Total_HETD'] = float(ligne['Total_HETD'])
    except:
        ligne['Total_HETD'] = 0.0

# Harmonisation des clés selon ton fichier
# → On utilisera 'Grade' pour le statut
# → Et 'LIB_DPT' pour le département
for ligne in data:
    ligne['STATUT'] = ligne.get('Grade', '').strip().upper()
    ligne['DEPARTEMENT'] = ligne.get('LIB_DPT', '').strip()

# Regrouper les agrégés et certifiés
for ligne in data:
    if ligne['STATUT'] in ['AGREGE', 'CERTIFIE']:
        ligne['STATUT'] = 'AGREGES/CERTIFIES'

# On travaille sur la variable Total_HETD (heures équivalentes TD)
def synthese_departement(departement):
    if not departement:
        lignes_dep = [l for l in data if not l['DEPARTEMENT']]
        nom_fichier = "synthese_00.csv"
    else:
        lignes_dep = [l for l in data if l['DEPARTEMENT'] == departement]
        nom_fichier = f"synthese_{departement.replace(' ', '_')}.csv"

    statuts = sorted(set(l['STATUT'] for l in lignes_dep))

    synthese = []
    for statut in statuts:
        heures = [l['Total_HETD'] for l in lignes_dep if l['STATUT'] == statut]
        if heures:
            synthese.append({
                'STATUT': statut,
                'min_HSUP': min(heures),
                'max_HSUP': max(heures),
                'moy_HSUP': round(statistics.mean(heures), 2)
            })

    # Ligne TOUS (moyenne du département)
    heures_dep = [l['Total_HETD'] for l in lignes_dep]
    if heures_dep:
        synthese.append({
            'STATUT': 'TOUS',
            'min_HSUP': min(heures_dep),
            'max_HSUP': max(heures_dep),
            'moy_HSUP': round(statistics.mean(heures_dep), 2)
        })

    # Écriture du fichier CSV
    with open(nom_fichier, 'w', newline='', encoding='utf-8') as f:
        champs = ['STATUT', 'min_HSUP', 'max_HSUP', 'moy_HSUP']
        writer = csv.DictWriter(f, fieldnames=champs)
        writer.writeheader()
        writer.writerows(synthese)

    print(f"✅ Fichier {nom_fichier} créé ({len(synthese)} lignes)")

# Liste des départements
departements = sorted(set(l['DEPARTEMENT'] for l in data if l['DEPARTEMENT']))
departements.append(None)

# Création des fichiers
for dep in departements:
    synthese_departement(dep)






    
    