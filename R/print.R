
#' Print table to latex
#' @param df data.frame
#' @param col_format string. column format
#' @param rowcol string. row color
#' @param hline logical. activate horizontal lines
#'
#' @export
#' @importFrom tidyr unite_
#' @examples  
#' print_tab(mtcars)
print_tab <- function(df, col_format="", rowcol = NULL, hline=TRUE) {
  cat("\\begin{tabular}{", col_format, "}\n", sep="")
  
  if (hline)
    cat(" \\hline\n")
  
  if (!is.null(rowcol))
    cat("\\rowcolor{", rowcol, "} ", sep="")
  
  collapse = " \\tabularnewline\n"
  if (hline)
    collapse = paste(collapse, "\\hline\n")
  
  cat(paste(unlist(tidyr::unite_(df, "x", colnames(df), sep = " & ")), collapse = collapse))
  
  if (hline)
    cat(" \\tabularnewline\n \\hline\n")
  
  cat("\\end{tabular}\n\\vspace*{.5em}\n\n")
}

#' Print tasks to latex
#'
#' @param tache data.frame
#' @param legende data.frame
#' @param section string. section
#' @param col_type character vector. column types
#' @param col_sep string. column separator
#' @param col_form character vector. column format
#' @param col_form_head character vector. header column format
#' @param rowcol_head row color of the header
#' @param header character vector. header
#' @param cle_var string. key column name
#' @param format_fun list. formatting functions
#'
#' @export
#' @importFrom dplyr %>%
#' @importFrom dplyr filter
#' @importFrom dplyr select
#' @importFrom dplyr mutate
#' @importFrom dplyr mutate_each
#' @importFrom dplyr funs
print_taches <- function(tache, legende, section = "orga", 
                         col_type = c("p{11cm}", "p{2cm}", "p{2cm}"),
                         col_sep = "|",
                         col_form = c("", ">{\\centering}", ">{\\centering}"),
                         col_form_head = c(">{\\centering\\bf}", ">{\\centering\\bf}", ">{\\centering\\bf}"),
                         rowcol_head = "lightgray",
                         header,
                         cle_var,
                         format_fun) {
  ind = match(section, legende[[cle_var]])
  cat("\\section*{", toupper(legende$Nom[ind]), "}\n\n", sep="")  
  
  tache = tache %>% 
    filter(SECTION == section)
  
  col_format_head = paste0(col_sep, paste0(col_form_head, col_type, collapse=col_sep), col_sep)
  col_format = paste0(col_sep, paste0(col_form, col_type, collapse=col_sep), col_sep)
  
  cat("\\parindent=0em\n")
  print_tab(data.frame(as.list(header)), 
            col_format = col_format_head, 
            rowcol = rowcol_head)
  
  # acteurs dans l'ordre de la legende
  acteurs = unique(tache$ACTEUR)
  ind = match(legende[[cle_var]], acteurs)
  ind = ind[!is.na(ind)]
  acteurs = acteurs[ind]  
  
  for (a in seq_along(acteurs)) {
    tache_a = tache %>% 
      filter(ACTEUR == acteurs[a])
    
    ind = match(acteurs[a], legende[[cle_var]])
    
    fmtfun = do.call(switch, c(list(legende$Classe[ind]), format_fun))
    libelle = fmtfun(legende[ind,])
    cat(libelle)
    
    dates = unique(tache_a$DATE)
    for (d in seq_along(dates)) {
      cat(format_fun$date_reu(dates[d]))
      
      tache_d = tache_a %>% 
        filter(DATE == dates[d])
      
      ind = match(tache_d$ETAT, legende[[cle_var]])
      ind_a = match("a", legende[[cle_var]])
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
      
      print_tab(tache_d, col_format=col_format)
    }
  }
}

#' print photos to latex
#'
#' @param photo data.frame
#' @param col_format string. column format
#' @param width string. photo max width
#' @param height string. photo max height
#'
#' @export
#' @importFrom dplyr mutate
#' @importFrom dplyr %>%
print_photo = function(photo, col_format="|>{\\centering}m{10cm}|m{7cm}|", 
                       width = "10cm",
                       height="5cm") {
  photo = photo %>% 
    mutate(FICHIER = paste0("\\includegraphics[height=", height, ", width=", width, 
                            ", keepaspectratio]{", tools::file_path_sans_ext(FICHIER), "}"))
  
  print_tab(photo, col_format=col_format)
}