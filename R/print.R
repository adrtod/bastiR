#' @export
libelle.acteur_orga <- function(nom, des, lot) {
  if (is.na(nom))
    lib = toupper(des)
  else
    lib = paste(nom, des)
  return(lib)
}

#' @export
libelle.acteur_exe <- function(nom, des, lot) {
  paste(lot, des, "-", nom)
}

#' @export
print_tab <- function(..., col_format="", rowcol = NULL, hline=TRUE) {
  cat("\\begin{tabular}{", col_format, "}\n", sep="")
  
  if (hline)
    cat(" \\hline\n")
  
  if (!is.null(rowcol))
    cat("\\rowcolor{", rowcol, "} ", sep="")
  
  collapse = " \\tabularnewline\n"
  if (hline)
    collapse = paste(collapse, "\\hline\n")
  
  cat(paste(..., sep=" & ", collapse = collapse))
  
  if (hline)
    cat(" \\tabularnewline \n \\hline\n")
  
  cat("\\end{tabular}\n\\vspace*{.5em}\n\n")
}

#' @export
print_taches <- function(tache, legende, section = "orga", 
                         col_type = c("p{11cm}", "p{2cm}", "p{2cm}"),
                         col_sep = "|",
                         col_form = c("", ">{\\centering}", ">{\\centering}"),
                         col_form_head = c(">{\\centering\\bf}", ">{\\centering\\bf}", ">{\\centering\\bf}"),
                         rowcol_head = "lightgray") {
  ind = match(section, legende$Clé)
  cat("\\section*{", toupper(legende$Nom[ind]), "}\n\n", sep="")  
  
  tache = tache %>% filter(SECTION == section)
  
  col_format_head = paste0(col_sep, paste0(col_form_head, col_type, collapse=col_sep), col_sep)
  col_format = paste0(col_sep, paste0(col_form, col_type, collapse=col_sep), col_sep)
  
  cat("\\parindent=0em\n")
  print_tab("Tâche", "Pour le", "Etat", 
            col_format = col_format_head, 
            rowcol = rowcol_head)
  
  # acteurs dans l'ordre de la légende
  acteurs = unique(tache$ACTEUR)
  ind = match(legende$Clé, acteurs)
  ind = ind[!is.na(ind)]
  acteurs = acteurs[ind]  
  
  for (a in seq_along(acteurs)) {
    tache_a = tache %>% 
      filter(ACTEUR == acteurs[a])
    
    ind = match(acteurs[a], legende$Clé)
    nom = legende$Nom[ind]
    des = legende$Désignation[ind]
    lot = legende$Num[ind]
    libelle = switch(legende$Classe[ind],
                     "acteur orga" = libelle.acteur_orga(nom, des, lot),
                     "acteur exe" = libelle.acteur_exe(nom, des, lot))
    cat("\\textbf{", libelle, "}\n\n", sep="")
    
    dates = unique(tache_a$DATE)
    for (d in seq_along(dates)) {
      cat("\\hspace*{1.4em}\n\\underline{Réunion du", format(dates[d], "%d %B %Y"), "}\n\n")
      
      tache_d = tache_a %>% 
        filter(DATE == dates[d])
      
      ind = match(tache_d$ETAT, legende$Clé)
      ind_a = match("a", legende$Clé)
      tache_d = tache_d %>% 
        mutate(ETAT = ifelse(ETAT == "a", 
                             ifelse(is.na(PRIORITE),
                                    legende$Nom[ind_a],
                                    PRIORITE),
                             legende$Nom[ind])) %>%  # libelle etat
        mutate(ECHEANCE = ifelse(is.na(ECHEANCE), "", format(ECHEANCE, "%d/%m/%Y"))) %>% # formatage date echeance
        select(TACHE, ECHEANCE, ETAT) %>% # ordonne colonnes
        mutate(TACHE = paste("$\\bullet$", TACHE)) # ajoute puce devant tache
      
      # formatage ligne fait, urgent, rappel
      rowformat = switch(tolower(tache_d$ETAT),
                         fait = "\\sout{",
                         rappel = "\\textcolor{red}{",
                         urgent = "\\textcolor{red}{",
                         "{")
      
      rowfun = function(x) paste0(rowformat, x, "}")
      
      tache_d = tache_d %>% 
        mutate_each(funs(rowfun))
      
      print_tab(tache_d$TACHE, tache_d$ECHEANCE, tache_d$ETAT, col_format=col_format)
    }
  }
}

#' @export
print_photo = function(photo, col_format="|>{\\centering}m{10cm}|m{7cm}|", 
                       width = "10cm",
                       height="5cm") {
  photo = photo %>% 
    mutate(FICHIER = paste0("\\includegraphics[height=", height, ", width=", width, 
                            ", keepaspectratio]{", tools::file_path_sans_ext(FICHIER), "}"))
  
  print_tab(photo$FICHIER, photo$COMMENTAIRE, col_format=col_format)
}