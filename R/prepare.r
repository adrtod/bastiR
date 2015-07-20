
#' Prepare photo sheet to be completed
#' 
#' @param photo_files character vector. paths of the photo files
#'
#' @importFrom dplyr data_frame
#' @keywords internal
prepare_photos <- function(photo_files = list.files(".", pattern = ".*\\.(jpg|jpeg|JPG|JPEG|png|PNG)")) {
  df = data_frame(FICHIER = photo_files, 
                  COMMENTAIRE = as.character(rep(NA, length(photo_files))))
  return(df)
}


#' Preparation du compte rendu
#'
#' @param cfg_file string. ficher R de configuration
#' @param encoding string. encodage du fichier cfg_file
#' @param quiet logical. desactive les sorties textuelles
#' @param recursive logical. voir \code{\link{dir.create}}
#'
#' @return \code{NULL}
#' @export
#' @importFrom dplyr %>%
#' @importFrom dplyr mutate_each
#' @importFrom dplyr filter
#' @importFrom dplyr mutate
#' @importFrom dplyr arrange
#' @importFrom dplyr bind_rows
#' @importFrom dplyr summarise_each
#' @importFrom dplyr slice
prepare_cr <- function(cfg_file = "config.r", encoding = "ISO8859-1",
                       quiet = FALSE, recursive = TRUE) {
  if (!quiet)
    cat("Preparation du compte rendu :\n")
  
  # chargement des variables du projet
  if (!quiet)
    cat("* Chargement du fichier de configuration :", cfg_file, "\n")
  
  source(cfg_file, local = TRUE, encoding = encoding)
  
  # lecture fichier
  if (!quiet)
    cat("* Lecture du tableur :", xl_file, "\n")
  xl = read_xl(xl_file,
               col_dates = col_dates, 
               origin = origin)
  
  # legende
  if (!quiet){
    cat("* Edition de la feuille LEGENDE :\n")
    cat("  Conversion de CLE, CLASSE en minuscule\n")
  }
  
  legende = xl$LEGENDE %>% 
    mutate_each(funs(tolower), CLE, CLASSE) %>% 
    filter(!is.na(CLE))
  
  cles = legende$CLE
  if (anyDuplicated(cles))
    stop("Cles dupliquees dans LEGENDE :", cles[duplicated(cles)], "\n")
  
  # edit taches
  if (!quiet)
    cat("* Edition de la feuille TACHES :\n")
  
  # Ajoute `CEJOUR` a TACHES
  if (!quiet)
    cat("  Ajout de CEJOUR\n")
  cejour = xl$CEJOUR %>% 
    filter(!is.na(SECTION))
  
  taches = xl$TACHES %>% 
    bind_rows(cejour)
  
  # Complete `ETAT` manquant par `A faire`
  if (!quiet)
    cat("  Remplissage d'ETAT manquant par 'A Faire'\n")
  
  taches = taches %>% 
    mutate(ETAT = ifelse(is.na(ETAT), "af", ETAT)) 
    
  # recodage et tri
  if (!quiet){
    cat("  Conversion de ETAT, SECTION, ACTEUR en minuscule\n")
    cat("  Tri des lignes par ETAT, SECTION, ECHEANCE, ACTEUR\n")
  }
  taches = taches %>% 
    mutate_each(funs(tolower), ETAT, SECTION, ACTEUR) %>% # Edite cles `ETAT`, `SECTION`, `ACTEUR` en minuscule
    arrange(ETAT, SECTION, ECHEANCE, ACTEUR) # Tri des lignes par `ETAT`, `SECTION`, `ECHEANCE` puis `ACTEUR`
  
  # Edite `PRIORITE` : `Rappel` (`ECHEANCE` passee) ou `Urgent` (`ECHEANCE` + 1 semaine)
  if (!quiet){
    cat("  Remplissage de PRIORITE\n")
  }
  row = (taches$ETAT %in% c("af", "av")) & (taches$ECHEANCE <= date)
  taches$PRIORITE[row] = "RAPPEL"
  
  row = (taches$ETAT %in% c("af", "av")) & (taches$ECHEANCE <= date-7)
  taches$PRIORITE[row] = "URGENT"
  
  # Complete `REALISATION` manquante par la date de la reunion
  if (!quiet){
    cat("  Remplissage de REALISATION manquante\n")
  }
  row = (taches$ETAT %in% c("f", "v", "an")) & is.na(taches$REALISATION)
  taches$REALISATION[row] = date
  
  # Supprime les lignes `Fait`/`Valide`/`Annule` avec `REALISATION` superieure a 3 semaines
  if (!quiet){
    cat("  Suppression des lignes REALISATION superieure a 3 semaines\n")
  }
  taches = taches %>% 
    filter( !( (ETAT %in% c("f", "v", "an")) & (REALISATION <= date-3*7) ) )
  
  # plans
    if (!quiet){
      cat("* Edition de la feuille PLANS :\n")
      cat("  Conversion de SECTION, SOUSSECTION, ETAT en minuscule\n")
    }
  plans = xl$PLANS %>% 
    mutate_each(funs(tolower), SECTION, SOUSSECTION, ETAT)
  
  # prepare cejour prochaine reunion
  if (!quiet)
    cat("* Preparation de la feuille CEJOUR pour le prochain compte rendu\n")
  nafun = function(x) { y = NA; class(y) = class(x); return(y) }
  cejour_next = xl$CEJOUR %>% 
    summarise_each(funs(nafun)) %>% # 1 ligne vide
    mutate(REUNION = date_next) %>% # date prochaine reu
    slice(rep(1, 10)) # dupliquer 10 lignes
  
  # exporte xlsx
  if (!quiet)
    cat("* Sauvegarde du tableur :", xl_file_next, "\n")
  
  xl$TACHES = taches
  xl$CEJOUR = cejour_next
  xl$PLANS = plans
  
  write_xl(xl, xl_file_next, open=FALSE)
  
  # deplacer les photos
  if (!dir.exists(backup)) {
    if (!quiet)
      cat("* Creation du dossier :", backup, "\n")
    dir.create(backup, recursive = recursive)
  }
  
  if (length(photo_files)>0) {
    if (!quiet)
      cat("* Deplacement des photos vers :", backup, "\n")
    
    ok = file.copy(photo_files, backup)
    file.remove(photo_files[ok])
    
    if (any(!ok))
      warning("Les fichiers suivants n'ont pas pu etre deplaces : ", 
              paste(photo_files[!ok], collapse=" "), "\n")
  }
  
  photo_files = list.files(backup, pattern = ".*\\.(jpg|jpeg|JPG|JPEG|png|PNG)",
                           full.names = TRUE)
  
  # prepare tableau photo
  if (!file.exists(xl_file_photos)) {
    if (!quiet)
      cat("* Creation du tableur pour commentaires photos :", xl_file_photos, "\n")
    
    xl_photos = list()
    # prepare tableau photo
    xl_photos$photos = prepare_photos(photo_files)
    write_xl(xl_photos, xl_file_photos, open = openxl)
    
  }
  
  if (!quiet) {
    cat("\nEtapes suivantes :\n")
    cat("1. Remplir COMMENTAIRE dans :", xl_file_photos, "\n")
    cat("2. Compiler le fichier pdf avec :\n")
    cat('    compile_cr("', cfg_file, '")\n', sep="")
  }
  
  invisible(NULL)
}
