
#' Print table to latex
#' @param df data.frame
#'
#' @param envir string. table environment to be used in latex
#' @param col_format string. column format
#' @param rowcolors NULL or list with fields \code{begin} (integer. starting row including header)
#'   \code{even} (string. even rows color) and \code{odd} (string. odd rows color)
#' @param rowcol_head string. row color of the columns header
#' @param format_head string. header columns format
#' @param hline logical. activate horizontal lines
#' @param replace_na function or NULL. replace NA
#' @param header character vector or NULL. columns header text
#' @param replace_nl function or NULL. replace newlines
#' @param vspace_before string or NULL. height of vertical space before the table
#' @param vspace_after string or NULL. height of vertical space after the table
#'
#' @export
#' @importFrom tidyr unite_
#' @importFrom dplyr mutate_each
#' @examples  
#' print_tab(mtcars)
print_tab <- function(df = data.frame(), 
                      envir = c("longtable", "tabular", "tabularx"), 
                      col_format = "", 
                      rowcolors = NULL,
                      rowcol_head = "lightgray", hline=TRUE, 
                      format_head = "\\centering\\bf",
                      replace_na = function(x) ifelse(is.na(x), "", x),
                      replace_nl = function(x) gsub("\n", "\\\\newline ", x),
                      header = colnames(df),
                      vspace_before = "-.8em",
                      vspace_after = "-.8em") {
  envir = match.arg(envir, c("longtable", "tabular", "tabularx"))
  
  if (!is.null(vspace_before)) {
    cat("\\vspace*{", vspace_before, "}\n", sep="")
  }
    
  # begin table
  if (!is.null(rowcolors)) {
    cat("\\rowcolors{", rowcolors$begin, "}{", rowcolors$even, "}{", rowcolors$odd, "}\n", sep="")
  }
  
  cat("\\begin{", envir, "}{", col_format, "}\n", sep="")
  
  if (hline)
    cat(" \\hline\n")
  
  # header
  if (!is.null(header)) {
    df_head = data.frame(as.list(header), stringsAsFactors = FALSE)
    df_head = mutate_each(df_head, funs(replace_na))
    
    if (!is.null(rowcol_head))
      cat("\\rowcolor{", rowcol_head, "} ", sep="")
    
    cat(format_head,
        unlist(tidyr::unite_(df_head, "x", colnames(df_head), sep = paste0(" & ", format_head, " "))))
    
    cat(" \\tabularnewline\n")
    if (hline)
      cat(" \\hline\n")
  }
  
  # content of the table
  if (nrow(df)>0) {
    if (!is.null(replace_na)) {
      df = mutate_each(df, funs(replace_na))
    }
    if (!is.null(replace_nl)) {
      df = mutate_each(df, funs(replace_nl))
    }
    
    collapse = " \\tabularnewline\n"
    if (hline)
      collapse = paste(collapse, "\\hline\n")
    
    cat(paste(unlist(tidyr::unite_(df, "x", colnames(df), sep = " & ")), collapse = collapse), sep="")
    
    if (hline)
      cat(" \\tabularnewline\n \\hline\n")
  }
  
  # end table
  
  cat("\\end{", envir, "}\n", sep="")
  if (!is.null(vspace_after)) {
    cat("\\vspace*{", vspace_after, "}\n", sep="")
  }
  cat("\n")
}

#' Print tasks to latex
#'
#' @param taches data.frame
#' @param legende data.frame
#' @param section string. section
#' @param col_format string. column format
#' @param rowcol_head row color of the header
#' @param header character vector. header
#' @param cle_var string. key column name
#' @param classe_var string. class column name
#' @param format_fun list. formatting functions
#' @param ... further arguments to be passed to print_tab
#'
#' @export
#' @importFrom dplyr %>%
#' @importFrom dplyr filter
#' @importFrom dplyr select
#' @importFrom dplyr mutate
#' @importFrom dplyr mutate_each
#' @importFrom dplyr funs
print_taches <- function(taches,
                         legende, section = "orga", 
                         col_format = c("|p{11cm}|>{\\centering}p{2cm}|>{\\centering}p{2cm}|"),
                         rowcol_head = "lightgray",
                         header = c("TACHE", "ECHEANCE", "ETAT"),
                         cle_var = "CLE", classe_var = "CLASSE",
                         format_fun, ...) {
  ind = match(section, legende[[cle_var]])
  cat("\\section*{", toupper(legende$Nom[ind]), "}\n\n", sep="")  
  
  taches = taches %>% 
    filter(SECTION == section)
  
  print_tab(header = header,
            col_format = col_format, 
            rowcol_head = rowcol_head, ...)
  
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
      
      print_tab(taches_d, col_format=col_format, header=NULL, ...)
    }
  }
}

#' print photos to latex
#'
#' @param photos data.frame
#' @param col_format string. column format
#' @param width string. photo max width
#' @param height string. photo max height
#' @param ... further arguments to be passed to print_tab
#'
#' @export
#' @importFrom dplyr mutate
print_photos = function(photos, col_format="|>{\\centering}m{10cm}|m{7cm}|", 
                       width = "10cm",
                       height="5cm", ...) {
  photos = mutate(photos, FICHIER = paste0("\\includegraphics[height=", height, ", width=", width, 
                            ", keepaspectratio]{", tools::file_path_sans_ext(FICHIER), "}"))
  
  print_tab(photos, col_format=col_format, ...)
}
