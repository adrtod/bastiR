
#' Read excel file
#' 
#' @param xl_file string. path to the file
#' @param sheets character or integer vector. mandatory sheets to be read
#' @param col_dates character vector. date column names
#' @param origin a Date object, or something which can be coerced by 
#'   \code{as.Date(origin)} to such an object.
#'
#' @export
#' @importFrom readxl excel_sheets
read_xl <- function(xl_file, 
                    sheets = c("LEGENDE", "TACHES", "CEJOUR", "PLANS", "PLANSNOTE"), 
                    col_dates = c("REUNION", "ECHEANCE", "REALISATION", "DATE"), 
                    origin = "1899-12-30") {
  
  xl_sheets = readxl::excel_sheets(xl_file)
  xl = list()
  
  for (s in sheets) {
    if (!(s %in% xl_sheets))
      stop("la feuille de calcul ", s, " est absente ")
    
    # lecture feuille
    xl[[s]] = readxl::read_excel(xl_file, sheet=s)
    
    # codage dates
    for (c in col_dates) {
      if (c %in% colnames(xl[[s]])) {
        xl[[s]][[c]] = as.Date(xl[[s]][[c]], origin = origin)
      }
    }
  }
  
  return(xl)
}


#' Write data.frame to Excel file
#'
#' @param df data.frame or list of data.frames
#' @param out_file string. path to the output excel file
#' @param open logical. activate opening the file in Excel/LibreOffice/OpenOffice
#' @param zip_path string. path containing zip executable on windows
#'
#' @export
#' @importFrom openxlsx write.xlsx
#' @importFrom openxlsx openXL
write_xl <- function(df, 
                     out_file, 
                     open = FALSE,
                     zip_path = "C:\\Rtools\\bin") {
  
  if (.Platform$OS.type == "windows") {
    Sys.setenv(PATH = paste(Sys.getenv("PATH"), zip_path, sep=.Platform$path.sep))
  }
  
  # export
  openxlsx::write.xlsx(df, file = out_file)
  
  # ouvrir Excel
  if (open)
    openxlsx::openXL(out_file)
  
  invisible(out_file)
}
