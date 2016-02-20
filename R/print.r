utils::globalVariables(c("FICHIER", "SECTION", "SOUSSECTION", "DATE", "PLAN", 
                         "NUM", "INDICE", "SECTION", "ACTEUR", "REUNION", "ETAT", 
                         "PRIORITE", "ECHEANCE", "TACHE", "COMMENTAIRE", "REALISATION",
                         "CLE", "CLASSE", "xl_file", "col_dates", "origin", "date", 
                         "date_next", "xl_file_out", "photo_dir", "xl_file_photos", 
                         "open_files", "max_width", "max_height", "quality", 
                         "out_name", "rnw_file"))


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
#' @param grid_col string. color of the grid
#'
#' @export
#' @importFrom tidyr unite_
#' @importFrom dplyr mutate_each
#' @examples  
#' print_table(mtcars)
print_table <- function(df = data.frame(), 
                        envir = c("longtable", "tabular", "tabularx"), 
                        col_format = "", 
                        rowcolors = NULL,
                        rowcol_head = "lightgray",
                        hline = TRUE, 
                        format_head = "\\centering\\bf",
                        replace_na = function(x) ifelse(is.na(x), "", x),
                        replace_nl = function(x) gsub("\n|&#10;", "\\\\newline ", x),
                        header = colnames(df),
                        grid_col = "lightgray",
                        vspace_before = "-.8em",
                        vspace_after = "-.8em") {
  envir = match.arg(envir, c("longtable", "tabular", "tabularx"))
  
  if (!is.null(vspace_before)) {
    cat("\\vspace*{", vspace_before, "}\n", sep="")
  }
  
  cat("\\arrayrulecolor{", grid_col,"}\n", sep="")
  
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

#' Print object depending on its class
#'
#' @param cle string. cle
#' @param legende data.frame
#' @param format_fun list. formatting functions
#' @export
print_classe <- function(cle, legende, 
                         format_fun) {
  ind = match(tolower(cle), tolower(legende$CLE))
  fmtfun = do.call(switch, c(tolower(list(legende$CLASSE[ind])), format_fun))
  cat(fmtfun(legende[ind,]))
}

#' Print tasks to latex
#'
#' @param taches data.frame
#' @param legende data.frame
#' @param col_format string. column format
#' @param rowcol_head row color of the header
#' @param header character vector. header
#' @param format_fun list. formatting functions
#' @param ... further arguments to be passed to print_table
#'
#' @export
#' @importFrom dplyr %>%
#' @importFrom dplyr filter
#' @importFrom dplyr select
#' @importFrom dplyr mutate
#' @importFrom dplyr mutate_each
#' @importFrom dplyr funs
print_taches <- function(taches,
                         legende,
                         col_format,
                         rowcol_head = "lightgray",
                         header = c("TACHE", "ECHEANCE", "ETAT"),
                         format_fun, ...) {
  
  # sections dans l'ordre de la legende
  sections = unique(tolower(taches$SECTION))
  ind = match(tolower(legende$CLE), sections)
  ind = ind[!is.na(ind)]
  sections = sections[ind]
  
  # boucle sur sections
  for (s in seq_along(sections)) {
    print_classe(sections[s], legende, 
                 format_fun = format_fun)
    
    taches_s = taches %>% 
      filter(tolower(SECTION) == sections[s])
    
    print_table(header = header,
                col_format = col_format, 
                rowcol_head = rowcol_head, ...)
    
    # acteurs dans l'ordre de la legende
    acteurs = unique(tolower(taches_s$ACTEUR))
    ind = match(tolower(legende$CLE), acteurs)
    ind = ind[!is.na(ind)]
    acteurs = acteurs[ind]  
    
    # boucle sur acteurs
    for (a in seq_along(acteurs)) {
      taches_a = taches_s %>% 
        filter(tolower(ACTEUR) == acteurs[a])
      
      print_classe(acteurs[a], legende, 
                   format_fun = format_fun)
      
      # par ordre chronologique
      reunions = sort(unique(taches_a$REUNION))
      
      # boucle sur reunions
      for (r in seq_along(reunions)) {
        #cat("\\begin{minipage}{\\textwidth}\n")
        
        cat(format_fun$reunion(reunions[r]))
        
        taches_r = taches_a %>% 
          filter(REUNION == reunions[r])
        
        cellformat = NULL
        for (j in 1:3)
          cellformat = cbind(cellformat, rep("{", nrow(taches_r)))
        
        # formatage ligne A faire, A valider, RAPPEL ou URGENT
        row = tolower(taches_r$ETAT) %in% c("af", "av")  & (!is.na(taches_r$PRIORITE))
        cellformat[row,] = "\\textcolor{red}{"
        
        # formatage ligne Fait, Annule
        row = (tolower(taches_r$ETAT) %in% c("f", "an"))
        cellformat[row,1:2] = "\\sout{" # sauf colonne ETAT
        
        ind = match(taches_r$ETAT, legende$CLE)
        taches_r = taches_r %>% 
          mutate(ETAT = ifelse(ETAT %in% c("f", "v", "an"), 
                               paste0(legende$NOM[ind], " le ", format(REALISATION, "%d/%m/%Y")),
                               ifelse(ETAT == "af" & !is.na(PRIORITE), 
                                      toupper(PRIORITE),
                                      legende$NOM[ind]))) %>%  # libelle etat
          mutate(ECHEANCE = ifelse(is.na(ECHEANCE), "", format(ECHEANCE, "%d/%m/%Y"))) %>% # formatage date echeance
          mutate(TACHE = paste("$\\bullet$", TACHE)) %>% # ajoute puce devant tache
          select(TACHE, ECHEANCE, ETAT) # ordonne colonnes
        
        # applique formatage
        for (j in 1:ncol(taches_r)) {
          taches_r[[j]] = ifelse(is.na(taches_r[[j]]), "", paste0(c(cellformat[,j]), taches_r[[j]], "}")) 
        }
        
        print_table(taches_r, col_format=col_format, header=NULL, ...)
        
        #cat("\\end{minipage}\n")
      }
    }
  }
}

#' Print plans to latex
#'
#' @param plans data.frame
#' @param legende data.frame
#' @param col_format string. column format
#' @param rowcol_head row color of the header
#' @param header character vector. header
#' @param format_fun list. formatting functions
#' @param ... further arguments to be passed to print_table
#'
#' @export
#' @importFrom dplyr %>%
#' @importFrom dplyr filter
#' @importFrom dplyr select
#' @importFrom dplyr mutate
#' @importFrom dplyr funs
print_plans <- function(plans,
                        legende, 
                        col_format,
                        rowcol_head = "lightgray",
                        header = c("PLAN", "NUM", "INDICE", "DATE"),
                        format_fun, ...) {
  
  print_table(header = header,
              col_format = col_format, 
              rowcol_head = rowcol_head, ...)
  
  # sections dans l'ordre de la legende
  sections = unique(tolower(plans$SECTION))
  ind = match(tolower(legende$CLE), sections)
  ind = ind[!is.na(ind)]
  sections = sections[ind]
  
  for (s in seq_along(sections)) {
    plans_s = plans %>% 
      filter(tolower(SECTION) == sections[s])
    
    print_classe(sections[s], legende, 
                 format_fun = format_fun)
    
    soussec = unique(tolower(plans_s$SOUSSECTION))
    for (ss in seq_along(soussec)) {
      print_classe(soussec[ss], legende, 
                   format_fun = format_fun)
      
      plans_ss = plans_s %>% 
        filter(tolower(SOUSSECTION) == soussec[ss])
      
      plans_ss = plans_ss %>% 
        mutate(DATE = ifelse(is.na(DATE), "", format(DATE, "%d/%m/%Y"))) # formatage date
      
      ok = ifelse(is.na(plans_ss$ETAT), FALSE, (tolower(plans_ss$ETAT) == "n"))
      
      plans_ss = plans_ss %>%
        select(PLAN, NUM, INDICE, DATE) # ordonne colonnes
      
      # formatage ligne nouveau
      if (any(ok)) {
        ind  = which(ok)
        rowfun = function(x) ifelse(is.na(x), "", paste0("\\textcolor{red}{", x, "}"))
        
        # double boucle parce que segfault inexplique avec traitement colonnes ou mutate_each !?
        for (i in ind)
          for (j in 1:ncol(plans_ss))
            plans_ss[i,j] = rowfun(plans_ss[i,j])
      }
      
      print_table(plans_ss, col_format=col_format, header=NULL, ...)
    }
  }
}

#' Print photos to latex
#'
#' @param photos data.frame
#' @param col_format string. column format
#' @param width string. photo max width
#' @param height string. photo max height
#' @param ... further arguments to be passed to print_table
#'
#' @export
#' @importFrom dplyr filter
#' @importFrom dplyr mutate
print_photos = function(photos, col_format="|>{\\centering}m{.55\\linewidth}|m{.4\\linewidth}|", 
                        width = "\\linewidth",
                        height=".3\\textheight", ...) {
  # enleve photos sans commentaires
  if (!is.null(photos) && nrow(photos)>0)
    photos = filter(photos, !is.na(COMMENTAIRE), nzchar(COMMENTAIRE))
  
  # formate insertion photo en latex
  photos = mutate(photos, FICHIER = paste0("\\includegraphics[height=", height, ", width=", width, 
                                           ", keepaspectratio]{", FICHIER, "}"))
  
  print_table(photos, col_format=col_format, ...)
}