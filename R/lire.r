
#' Read excel file
#' 
#' @param xlfile string. path to the file
#' @param sheets character or integer vector. mandatory sheets to be read
#' @param sheets_opt character or integer vector. optional sheets to be read
#' @param col_dates character vector. date column names
#' @param origin a Date object, or something which can be coerced by 
#'   \code{as.Date(origin)} to such an object.
#'
#' @export
#' @importFrom readxl excel_sheets
lire_xl <- function(xlfile, sheets = 1, 
                    sheets_opt = "PHOTO",
                    col_dates = c("DATE", "ECHEANCE"), 
                    origin = "1899-12-30") {
  
  xlsheets = readxl::excel_sheets(xlfile)

  xl = list()
  
  for (s in c(sheets, sheets_opt)) {
    if (!(s %in% xlsheets)) {
      if (s %in% sheets_opt)
        next() # passer au suivant si optionnel
      else
        stop("la feuille de calcul ", s, " est absente ")
    }
    
    # lecture feuille
    xl[[s]] = readxl::read_excel(xlfile, sheet=s)
    
    # codage dates
    for (c in col_dates) {
      if (c %in% colnames(xl[[s]])) {
        xl[[s]][[c]] = as.Date(xl[[s]][[c]], origin = origin)
      }
    }
  }
  
  return(xl)
}
