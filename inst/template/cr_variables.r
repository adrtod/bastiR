# variables du projet
# ===================

# document
fontsize = "11pt"
geometry = "top=2.5cm, bottom=3cm, left=1.5cm, right=1.5cm"
documentclass = "article"
classoption = "a4paper"
parindent = "0em"
letterspace = 200
familydefault = "sfdefault" # police sans empattement

# page de garde
num_reu = 12
date_reu = as.Date("2015-04-29")
date_reu_next = date_reu+7
num_reu_next = num_reu + 1
heure_reu_next = "9H00"

garde = list()
garde$titre = "CONSTRUCTION D'UN FAS ET FATH PASSIF AU BEUBOIS A ORBEY"
garde$soustitre = paste("Compte rendu \\no", num_reu, "de la réunion du", format(date_reu, "%d %B %Y"))
garde$img = "images/TAVAILLON_3D"
garde$img_width = "0.8\\textwidth"
garde$reu_next = paste0("Réunion de chantier  \\no ", num_reu_next, " à {\\bf", heure_reu_next, "} le", format(date_reu_next, "%A %d %B %Y"))
garde$email = "t.weulersse@atelier-d-form.com"

# couleurs perso
RGBcolors = list()
RGBcolors$DformVert = c(131,182,27)

# entete
entete = list()
entete$C = "\\large FAS et FATH au Beubois\\\\
Compte-Rendu de chantier"
entete$L = "\\leavevmode\\smash{\\raisebox{6mm}{\\parbox[c]{\\linewidth}{\\includegraphics[width=\\linewidth]{images/Dform_logo}}}}"
entete$R = "\\thepage"

# pied de page
pied = list()
pied$C = "{\\color{DformVert} \\raggedleft www.ateliers-d-form.com\\\\
\\vspace*{-2mm}\\rule{\\linewidth}{.5mm}\\vspace*{-.5mm}}
{\\color{gray} \\footnotesize Ateliers d-Form Sàrl d'architecture au capital de 20000€ - siège social : 20 rue de Munster 68230 Soultzbach-les-bains\\\\ \\vspace*{-1mm}
Tél : 03.89.80.94.84 - Fax : 03.89.80.95.79 - mail : contact@atelier-d-form.com - APE : 7111 Z / SIRET : 49 945 834 00030}"

# fichier excel
xlfile = "BEUBOIS_CR_box_1.xlsx"
xlfile_out = paste0(tools::file_path_sans_ext(xlfile), "_export.xlsx")
xlfile_next = paste0(tools::file_path_sans_ext(xlfile), "_", num_reu_next, ".xlsx")
legende_sheet = "LEGENDE"
taches_sheet = "TACHES"
cejour_sheet = "CEJOUR"
photos_sheet = "PHOTOS"
plans_sheet = "PLANS"
plansnote_sheet = "PLANSNOTE"
col_dates = c("DATE", "ECHEANCE")
origin = "1899-12-30" # Depend du systeme de date Excel. Par défaut "1899-12-30" pour Excel Windows et "1904-01-01" pour Excel Macintosh. Voir l'aide de as.Date et https://support.microsoft.com/en-us/kb/214330
openxl = TRUE
cle_var = "CLE"
classe_var = "CLASSE"

# photos
photo_files = list.files(".", pattern = ".*\\.(jpg|jpeg|JPG|JPEG|png|PNG)")
max_width = 800
max_height = 600
quality = 95
backup = format(date_reu, "%Y-%m-%d")

# formatage
header_taches = c("Tâche", "Pour le", "Etat")
header_plans = c("Plan", "n°", "Indice", "Date")
grid_col = "lightgray"
rowcol_head = "lightgray"

format_fun = list(
  "section taches" = function(x) {
    paste0("\\clearpage\n\\section*{\\centering ", toupper(x$Nom), "}\n\n", sep="")
  },
  "acteur orga" = function(x) {
    lib = ifelse(is.na(x$Nom),
                 toupper(x$Désignation), # pour A TOUTES LES ENTREPRISES
                 paste(x$Nom, x$Désignation))
    paste0("\\textbf{", lib, "}\n\n")
  },
  "acteur exe" = function(x) {
    lib = paste(x$Lots, x$Désignation, "-", x$Nom)
    paste0("\\textbf{", lib, "}\n\n")
  },
  "date_reu" = function(x) {
    format(x, "\\hspace*{1.4em}\n\\underline{Réunion du %d %B %Y}\n\n")
  },
  "section plans" = function(x) {
    paste0("{\\bf ", x$Nom, "}\n\n")
  },
  "soussection plans" = function(x) {
    paste0("{\\bf \\small \\qquad", x$Nom, "}\n\n")
  }
)
