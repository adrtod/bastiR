# Variables du projet ==========================================================

name = "BEUBOIS_CR" # nom du projet
num = 24 # num�ro de r�union
date = as.Date("2015-07-15") # date de r�union
date_next = date+7 # date prochaine r�union
num_next = num + 1 # num�ro prochaine r�union
heure_next = "9H00" # heure prochaine r�union

# Excel ------------------------------------------------------------------------
xl_file = paste0(name, ".xlsx") # fichier excel d'entr�e (r�union en cours)
xl_file_out = paste0(name, "_", num_next, ".xlsx") # fichier excel de sortie (prochaine r�union)
col_dates = c("REUNION", "ECHEANCE", "REALISATION", "DATE")
origin = "1899-12-30" # Depend du systeme de date Excel. Par d�faut "1899-12-30" pour Excel Windows et "1904-01-01" pour Excel Macintosh. Voir l'aide de as.Date et https://support.microsoft.com/en-us/kb/214330
open_files = TRUE # ouvrir les fichiers apr�s cr�ation

# Pdf --------------------------------------------------------------------------
rnw_file = system.file("template/chantier_cr.rnw", package = "bastiR") # fichier Sweave pour le compte rendu
out_name = paste0(name, "_", num) # nom du fichier pdf de sortie (sans extension)

# Photos -----------------------------------------------------------------------
photo_files = list.files(".", pattern = ".*\\.(jpg|jpeg|JPG|JPEG|png|PNG)") # liste des fichiers photos � traiter
photo_dir = file.path("../PHOTOS", format(date, "%Y-%m-%d")) # dossier de sauvegarde des photos
xl_file_photos = file.path(photo_dir, paste0(name, "_", num, ".xlsx")) # fichier excel pour les photos
max_width = 340 # largeur max
max_height = 340 # hauteur max
quality = 95 # qualit� de compression jpeg en pourcents

# Pr�ambule latex --------------------------------------------------------------
fontsize = "11pt" # taille de police par d�faut
geometry = "top=2.5cm, bottom=3.5cm, left=1.5cm, right=1.5cm" # marges
documentclass = "article" # classe du document
classoption = "a4paper" # options du document
parindent = "0em" # indentation de paragraphe
letterspace = 200 # espacement de lettres pour email
familydefault = "sfdefault" # police sans empattement

# Couleurs ---------------------------------------------------------------------
RGBcolors = list()
RGBcolors$DformVert = c(131,182,27)

# Page de garde ----------------------------------------------------------------
garde = list()
garde$titre = "CONSTRUCTION D'UN FAS ET FATH PASSIF AU BEUBOIS A ORBEY"
garde$soustitre = paste("Compte rendu \\no", num, "de la r�union du", format(date, "%d %B %Y"))
garde$img = "img/TAVAILLON_3D_600"
garde$img_width = "0.8\\textwidth"
garde$reu_next = paste0("R�union de chantier \\no ", num_next, " � {\\bf ", heure_next, "} le ", format(date_next, "%A %d %B %Y"))
garde$email = "t.weulersse@atelier-d-form.com"

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
format_fun$"reunion" <- function(x) {
  format(x, "\\vspace*{.5em}\\hspace*{1.4em}\n\\underline{R�union du %d %B %Y}\n\n")
}
format_fun$"section plans" <- function(x) {
  paste0("{\\bf ", x$NOM, "}\n\n")
}
format_fun$"soussection plans" <- function(x) {
  paste0("{\\bf \\small \\qquad", x$NOM, "}\n\n")
}