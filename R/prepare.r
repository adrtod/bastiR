
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
#' @importFrom dplyr data_frame
prepare_cr <- function(cfg_file = "config.r", encoding = "ISO8859-1",
                       quiet = FALSE, recursive = TRUE) {
  if (!quiet)
    cat("Preparation du compte rendu :\n")
  
  # chargement des variables du projet -----------------------------------------
  if (!quiet)
    cat("* Chargement du fichier de configuration :", cfg_file, "\n")
  
  source(cfg_file, local = TRUE, encoding = encoding)
  
  # lecture fichier excel ------------------------------------------------------
  if (!quiet)
    cat("* Lecture du tableur :", xl_file, "\n")
  xl = read_xl(xl_file,
               col_dates = col_dates, 
               origin = origin)
  
  # legende --------------------------------------------------------------------
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
  
  # edit taches ----------------------------------------------------------------
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
  
  # plans ----------------------------------------------------------------------
    if (!quiet){
      cat("* Edition de la feuille PLANS :\n")
      cat("  Conversion de SECTION, SOUSSECTION, ETAT en minuscule\n")
    }
  plans = xl$PLANS %>% 
    mutate_each(funs(tolower), SECTION, SOUSSECTION, ETAT)
  
  # prepare cejour prochaine reunion -------------------------------------------
  if (!quiet)
    cat("* Preparation de la feuille CEJOUR pour le prochain compte rendu\n")
  nafun = function(x) { y = NA; class(y) = class(x); return(y) }
  cejour_next = xl$CEJOUR %>% 
    summarise_each(funs(nafun)) %>% # 1 ligne vide
    mutate(REUNION = date_next) %>% # date prochaine reu
    slice(rep(1, 10)) # dupliquer 10 lignes
  
  # exporte xlsx ---------------------------------------------------------------
  if (!quiet)
    cat("* Sauvegarde du tableur :", xl_file_out, "\n")
  
  xl$TACHES = taches
  xl$CEJOUR = cejour_next
  xl$PLANS = plans
  
  write_xl(xl, xl_file_out, open=FALSE)
  
  # deplacer les photos --------------------------------------------------------
  if (!dir.exists(photo_dir)) {
    if (!quiet)
      cat("* Creation du dossier :", photo_dir, "\n")
    dir.create(photo_dir, recursive = recursive)
  }
  
  if (length(photo_files)>0) {
    if (!quiet)
      cat("* Deplacement des photos vers :", photo_dir, "\n")
    
    ok = file.copy(photo_files, photo_dir)
    file.remove(photo_files[ok])
    
    if (any(!ok))
      warning("Les fichiers suivants n'ont pas pu etre deplaces : ", 
              paste(photo_files[!ok], collapse=" "), "\n")
  }
  
  photo_files = list.files(photo_dir, pattern = ".*\\.(jpg|jpeg|JPG|JPEG|png|PNG)")
  
  # prepare tableau photo ------------------------------------------------------
  if (!file.exists(xl_file_photos)) {
    if (!quiet)
      cat("* Creation du tableur pour commentaires photos :", xl_file_photos, "\n")
    
    # creer repertoire
    if (!dir.exists(dirname(xl_file_photos)))
      dir.create(dirname(xl_file_photos), recursive = recursive)
    
    # prepare tableau photo
    xl_photos = list()
    xl_photos$PHOTOS = data_frame(FICHIER = photo_files, 
                                  COMMENTAIRE = as.character(rep(NA, length(photo_files))))
    
    # export excel
    write_xl(xl_photos, xl_file_photos, open = openxl)
    
    if (openxl) {
      open_fileman(photo_dir)
    }
      
  }
  
  if (!quiet) {
    cat("\nEtapes suivantes :\n")
    cat("1. Remplir COMMENTAIRE dans :", xl_file_photos, "\n")
    cat("2. Compiler le fichier pdf avec :\n")
    cat('    compile_cr("', cfg_file, '")\n', sep="")
  }
  
  invisible(NULL)
}


#' Open file manager to specified location
#'
#' @param path string. path to the target location
#' @param fileman string. name of the file manager application
#' @export
open_fileman <- function(path, fileman = NULL) {
  
  # guess the filemanager application
  if (is.null(fileman) || is.na(fileman)) {
    # Windows
    if (tolower(.Platform$OS.type) == "windows")
      fileman = "explorer"
    else {
      # OSX
      if (tolower(Sys.info()["sysname"]) == "darwin")
        fileman = "open"
      else {
        # Linux: check if different commands exist
        for (fm in c("gnome-open", "dolphin", "nemo", "pacmanfm", "thunar", "caja")) {
          if (!system(paste("hash", fm), ignore.stderr = TRUE)) {
            fileman = fm
            break
          }
        }
      }
    }
  }
  
  if (is.null(fileman) || is.na(fileman)) {
    warning("could not find a file manager")
    return(NULL)
  }
  
  system(paste(fileman, normalizePath(path)), intern=TRUE)
}
