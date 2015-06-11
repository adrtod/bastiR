
#' Print table to latex
#' @param df data.frame
#'
#' @param col_format string. column format
#' @param rowcol string. row color
#' @param hline logical. activate horizontal lines
#' @param replace_na function or NULL
#' @param header character vector or NULL. header
#'
#' @export
#' @importFrom tidyr unite_
#' @importFrom dplyr mutate_each
#' @examples  
#' print_tab(mtcars)
print_tab <- function(df, col_format="", rowcol = NULL, hline=TRUE, 
                      replace_na = function(x) ifelse(is.na(x), "", x),
                      replace_nl = function(x) gsub("\n", " \\\\newline ", x),
                      header = NULL) {
  cat("\\begin{tabular}{", col_format, "}\n", sep="")
  
  if (hline)
    cat(" \\hline\n")
  
  if (!is.null(rowcol))
    cat("\\rowcolor{", rowcol, "} ", sep="")
  
  collapse = " \\tabularnewline\n"
  if (hline)
    collapse = paste(collapse, "\\hline\n")
  
  if (!is.null(header)) {
    df_head = data.frame(as.list(header), stringsAsFactors = FALSE)
    df_head = mutate_each(df_head, funs(replace_na))
    cat(unlist(tidyr::unite_(df_head, "x", colnames(df_head), sep = " & ")))
    cat(" \\tabularnewline\n")
    if (hline)
      cat(" \\hline\n")
  }
  
  if (!is.null(replace_na)) {
    df = mutate_each(df, funs(replace_na))
  }
  if (!is.null(replace_nl)) {
    df = mutate_each(df, funs(replace_nl))
  }
  
  cat(paste(unlist(tidyr::unite_(df, "x", colnames(df), sep = " & ")), collapse = collapse))
  
  if (hline)
    cat(" \\tabularnewline\n \\hline\n")
  
  cat("\\end{tabular}\n\\vspace*{.5em}\n\n")
}

#' Print tasks to latex
#'
#' @param taches data.frame
#' @param legende data.frame
#' @param section string. section
#' @param col_type character vector. column types
#' @param col_sep string. column separator
#' @param col_form character vector. column format
#' @param col_form_head character vector. header column format
#' @param rowcol_head row color of the header
#' @param header character vector. header
#' @param cle_var string. key column name
#' @param classe_var string. class column name
#' @param format_fun list. formatting functions
#'
#' @export
#' @importFrom dplyr %>%
#' @importFrom dplyr filter
#' @importFrom dplyr select
#' @importFrom dplyr mutate
#' @importFrom dplyr mutate_each
#' @importFrom dplyr funs
print_taches <- function(taches, legende, section = "orga", 
                         col_type = c("p{11cm}", "p{2cm}", "p{2cm}"),
                         col_sep = "|",
                         col_form = c("", ">{\\centering}", ">{\\centering}"),
                         col_form_head = c(">{\\centering\\bf}", ">{\\centering\\bf}", ">{\\centering\\bf}"),
                         rowcol_head = "lightgray",
                         header,
                         cle_var = "CLE", classe_var = "CLASSE",
                         format_fun) {
  ind = match(section, legende[[cle_var]])
  cat("\\section*{", toupper(legende$Nom[ind]), "}\n\n", sep="")  
  
  taches = taches %>% 
    filter(SECTION == section)
  
  col_format_head = paste0(col_sep, paste0(col_form_head, col_type, collapse=col_sep), col_sep)
  col_format = paste0(col_sep, paste0(col_form, col_type, collapse=col_sep), col_sep)
  
  cat("\\parindent=0em\n")
  print_tab(data.frame(as.list(header), stringsAsFactors = FALSE), 
            col_format = col_format_head, 
            rowcol = rowcol_head)
  
  # acteurs dans l'ordre de la legende
  acteurs = unique(taches$ACTEUR)
  ind = match(legende[[cle_var]], acteurs)
  ind = ind[!is.na(ind)]
  acteurs = acteurs[ind]  
  
  for (a in seq_along(acteurs)) {
    taches_a = taches %>% 
      filter(ACTEUR == acteurs[a])
    
    ind = match(acteurs[a], legende[[cle_var]])
    
    fmtfun = do.call(switch, c(list(legende[[classe_var]][ind]), format_fun))
    libelle = fmtfun(legende[ind,])
    cat(libelle)
    
    dates = unique(taches_a$DATE)
    for (d in seq_along(dates)) {
      cat(format_fun$date_reu(dates[d]))
      
      taches_d = taches_a %>% 
        filter(DATE == dates[d])
      
      ind = match(taches_d$ETAT, legende[[cle_var]])
      ind_a = match("a", legende[[cle_var]])
      taches_d = taches_d %>% 
        mutate(ETAT = ifelse(ETAT == "a", 
                             ifelse(is.na(PRIORITE),
                                    legende$Nom[ind_a],
                                    PRIORITE),
                             legende$Nom[ind])) %>%  # libelle etat
        mutate(ECHEANCE = ifelse(is.na(ECHEANCE), "", format(ECHEANCE, "%d/%m/%Y"))) %>% # formatage date echeance
        select(TACHE, ECHEANCE, ETAT) %>% # ordonne colonnes
        mutate(TACHE = paste("$\\bullet$", TACHE)) # ajoute puce devant tache
      
      # formatage ligne fait, urgent, rappel
      rowformat = switch(tolower(taches_d$ETAT),
                         fait = "\\sout{",
                         rappel = "\\textcolor{red}{",
                         urgent = "\\textcolor{red}{",
                         "{")
      
      rowfun = function(x) paste0(rowformat, x, "}")
      
      taches_d = taches_d %>% 
        mutate_each(funs(rowfun))
      
      print_tab(taches_d, col_format=col_format)
    }
  }
}

#' print photos to latex
#'
#' @param photos data.frame
#' @param col_format string. column format
#' @param width string. photo max width
#' @param height string. photo max height
#'
#' @export
#' @importFrom dplyr mutate
#' @importFrom dplyr %>%
print_photos = function(photos, col_format="|>{\\centering}m{10cm}|m{7cm}|", 
                       width = "10cm",
                       height="5cm") {
  photos = photos %>% 
    mutate(FICHIER = paste0("\\includegraphics[height=", height, ", width=", width, 
                            ", keepaspectratio]{", tools::file_path_sans_ext(FICHIER), "}"))
  
  print_tab(photos, col_format=col_format)
}
