import xlsxwriter
import os

# === Création du fichier Excel ===
workbook = xlsxwriter.Workbook('res.xlsx')
worksheet_data = workbook.add_worksheet('Chiffres')

# === Données ===
Data = [
    {'DPT': 5, 'PR': 1500, 'MCF': 2500, 'ATER': 105},
    {'DPT': 26, 'PR': 1600, 'MCF': 2600, 'ATER': 126},
    {'DPT': 27, 'PR': 1700, 'MCF': 2700, 'ATER': 127}
]

# === Fonction pour écrire les données ===
def write_line(data, start_col, start_line, sheet, ecrit_entete=False):
    line = start_line
    col = start_col
    if ecrit_entete:
        for x in data[0].keys():
            sheet.write(line, col, x)
            col += 1
        line += 1
    for l in data:
        col = start_col
        for v in l.values():
            sheet.write(line, col, v)
            col += 1
        line += 1
    return line

# Écrire les données
write_line(Data, 0, 0, worksheet_data, ecrit_entete=True)

# === Feuille pour les graphiques ===
worksheet_chart = workbook.add_worksheet('Graphiques')

# === Graphique à barres (comparaison PR, MCF, ATER) ===
chart_bar = workbook.add_chart({'type': 'column'})
chart_bar.add_series({'values': '=Chiffres!$B$2:$B$4', 'name': 'PR'})
chart_bar.add_series({'values': '=Chiffres!$C$2:$C$4', 'name': 'MCF'})
chart_bar.add_series({'values': '=Chiffres!$D$2:$D$4', 'name': 'ATER'})
chart_bar.set_title({'name': 'Comparaison PR / MCF / ATER'})
chart_bar.set_x_axis({'name': 'DPT'})
chart_bar.set_y_axis({'name': 'Valeurs'})
worksheet_chart.insert_chart('A1', chart_bar)

# === "Histogramme" simulé (colonnes pour MCF uniquement) ===
chart_hist = workbook.add_chart({'type': 'column'})
chart_hist.add_series({
    'categories': '=Chiffres!$A$2:$A$4',  # DPT
    'values': '=Chiffres!$C$2:$C$4',      # MCF
    'name': 'MCF'
})
chart_hist.set_title({'name': 'Histogramme (MCF par DPT)'})
chart_hist.set_x_axis({'name': 'Départements'})
chart_hist.set_y_axis({'name': 'Valeurs MCF'})
worksheet_chart.insert_chart('A20', chart_hist)

# === Fermer et ouvrir ===
workbook.close()
os.system("open 'res.xlsx'")

print("✅ Fichier 'res.xlsx' créé avec graphiques (barres + histogramme simulé).")