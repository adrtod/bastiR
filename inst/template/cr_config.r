# Variables du projet ==========================================================

# Document ---------------------------------------------------------------------
fontsize = "11pt" # taille de police par d�faut
geometry = "top=2.5cm, bottom=3.5cm, left=1.5cm, right=1.5cm" # marges
documentclass = "article" # classe du document
classoption = "a4paper" # options du document
inputenc = ifelse(.Platform$OS.type == "windows", "latin1", "utf8")
parindent = "0em" # indentation de paragraphe
letterspace = 200 # espacement de lettres pour email
familydefault = "sfdefault" # police sans empattement

# Page de garde ----------------------------------------------------------------
num_reu = 24 # num�ro de r�union
date_reu = as.Date("2015-07-15") # date de r�union
date_reu_next = date_reu+7 # date prochaine r�union
num_reu_next = num_reu + 1 # num�ro prochaine r�union
heure_reu_next = "9H00" # heure prochaine r�union

garde = list()
garde$titre = "CONSTRUCTION D'UN FAS ET FATH PASSIF AU BEUBOIS A ORBEY"
garde$soustitre = paste("Compte rendu \\no", num_reu, "de la r�union du", format(date_reu, "%d %B %Y"))
garde$img = "img/TAVAILLON_3D_600"
garde$img_width = "0.8\\textwidth"
garde$reu_next = paste0("R�union de chantier \\no ", num_reu_next, " � {\\bf ", heure_reu_next, "} le ", format(date_reu_next, "%A %d %B %Y"))
garde$email = "t.weulersse@atelier-d-form.com"

# Couleurs perso ---------------------------------------------------------------
RGBcolors = list()
RGBcolors$DformVert = c(131,182,27)

# Entete -----------------------------------------------------------------------
entete = list()
entete$C = "\\large FAS et FATH au Beubois\\\\
Compte rendu de chantier\\\\
{\\bf \\Large \\leftmark}"
entete$L = "\\leavevmode\\smash{\\raisebox{6mm}{\\parbox[c]{\\linewidth}{\\includegraphics[width=\\linewidth]{img/Dform_logo}}}}"
entete$R = "\\thepage"

# Pied de page -----------------------------------------------------------------
pied = list()
pied$C = "{\\color{DformVert} \\raggedleft www.ateliers-d-form.com\\\\
\\vspace*{-2mm}\\rule{\\linewidth}{.5mm}\\vspace*{-.5mm}}
{\\color{gray} \\footnotesize Ateliers d-Form S�rl d'architecture au capital de 20000\\euro{} - si�ge social : 20 rue de Munster 68230 Soultzbach-les-bains\\\\ \\vspace*{-1mm}
T�l : 03.89.80.94.84 - Fax : 03.89.80.95.79 - mail : contact@atelier-d-form.com - APE : 7111 Z / SIRET : 49 945 834 00030}"

# Fichier excel ----------------------------------------------------------------
xlfile = "BEUBOIS_CR.xlsx"
xlfile_out = paste0(tools::file_path_sans_ext(xlfile), "_", num_reu, ".xlsx")
xlfile_next = paste0(tools::file_path_sans_ext(xlfile), "_", num_reu_next, ".xlsx")
col_dates = c("DATE", "ECHEANCE", "DATEREALISATION")
origin = "1899-12-30" # Depend du systeme de date Excel. Par d�faut "1899-12-30" pour Excel Windows et "1904-01-01" pour Excel Macintosh. Voir l'aide de as.Date et https://support.microsoft.com/en-us/kb/214330
openxl = TRUE

# Photos -----------------------------------------------------------------------
photo_files = list.files(".", pattern = ".*\\.(jpg|jpeg|JPG|JPEG|png|PNG)")
max_width = 350
max_height = 350
quality = 95
backup = format(date_reu, "%Y-%m-%d")
temp = "tmp/" # doit terminer par /

# Formatage --------------------------------------------------------------------
header = list()
header$orga = c("D�signation", "Nom", "Repr�sentants", "T�l�phones", "Mobiles", "Fax", "Courriels", "P", "Dif", "Inv", "")
header$exe = c("Lot", "Corps d'�tat", "Entreprise", "Repr�sentants", "T�l�phones", "Mobiles", "", "Courriels", "P", "Dif", "Conv", "Pen Abs.")
header$taches = c("T�che", "Pour le", "Etat")
header$plans = c("Plan", "N�", "Indice", "Date")
col_format = list()
col_format$orga = "|p{3.88cm}|p{2.4cm}|p{1.7cm}|p{1.5cm}|p{1.5cm}|p{1.5cm}|p{3.5cm}|>{\\centering}p{.3cm}|>{\\centering}p{.4cm}|>{\\color{red}\\centering}p{.5cm}|>{\\centering}p{.9cm}|"
col_format$exe = "|p{.7cm}|p{3.1cm}|p{2.4cm}|p{1.7cm}|p{1.5cm}|p{1.5cm}|p{1.5cm}|p{3.5cm}|>{\\centering}p{.3cm}|>{\\centering}p{.4cm}|>{\\color{red}\\centering}p{.5cm}|>{\\centering}p{.9cm}|"
col_format$taches = "|p{.75\\textwidth}|>{\\centering}p{.1\\textwidth}|>{\\centering}p{.1\\textwidth}|"
col_format$plans = "|p{.6\\textwidth}|>{\\centering}p{.1\\textwidth}|>{\\centering}p{.1\\textwidth}|>{\\centering}p{.1\\textwidth}|"
grid_col = "lightgray"
rowcol_head = "lightgray"
hline = TRUE

format_fun = list()
format_fun$"section taches" <- function(x) {
  paste0("\\clearpage\n\\section{", toupper(x$NOM), "}\n\n", sep="")
}
format_fun$"acteur orga" <- function(x) {
  lib = ifelse(is.na(x$NOM),
               toupper(x$DESIGNATION), # pour A TOUTES LES ENTREPRISES
               paste(x$NOM, x$DESIGNATION))
  paste0("\\vspace*{1em}\\textbf{", lib, "}\n\n")
}
format_fun$"acteur exe" <- function(x) {
  lib = paste(x$LOT, x$DESIGNATION, "-", x$NOM)
  paste0("\\vspace*{1em}\\textbf{", lib, "}\n\n")
}
format_fun$"date_reu" <- function(x) {
  format(x, "\\vspace*{.5em}\\hspace*{1.4em}\n\\underline{R�union du %d %B %Y}\n\n")
}
format_fun$"section plans" <- function(x) {
  paste0("{\\bf ", x$NOM, "}\n\n")
}
format_fun$"soussection plans" <- function(x) {
  paste0("{\\bf \\small \\qquad", x$NOM, "}\n\n")
}
