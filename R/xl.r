
#' Read excel file
#' 
#' @param xl_file string. path to the file
#' @param sheets character or integer vector. mandatory sheets to be read
#' @param col_dates character vector. date column names
#' @param origin a Date object, or something which can be coerced by 
#'   \code{as.Date(origin)} to such an object.
#' @param ... further arguments to pass to \code{\link[openxlsx]{read.xlsx}}
#'
#' @export
#' @importFrom openxlsx getSheetNames
#' @importFrom openxlsx read.xlsx
#' @importFrom dplyr as_data_frame
read_xl <- function(xl_file, 
                    sheets = c("LEGENDE", "TACHES", "CEJOUR", "PLANS", "PLANSNOTE"), 
                    col_dates = c("REUNION", "ECHEANCE", "REALISATION", "DATE"), 
                    origin = "1899-12-30", ...) {
  
  xl_sheets = openxlsx::getSheetNames(xl_file)
  xl = list()
  
  for (s in sheets) {
    if (!(s %in% xl_sheets))
      stop("la feuille de calcul ", s, " est absente ")
    
    # lecture feuille
    xl[[s]] = dplyr::as_data_frame(openxlsx::read.xlsx(xl_file, sheet=s, ...))
    
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
#' @param ... further arguments to pass to \code{\link[openxlsx]{write.xlsx}}
#'
#' @export
#' @importFrom openxlsx write.xlsx
#' @importFrom openxlsx openXL
write_xl <- function(df, 
                     out_file, 
                     open = FALSE,
                     zip_path = "C:\\Rtools\\bin",
                     ...) {
  
  if (.Platform$OS.type == "windows") {
    Sys.setenv(PATH = paste(Sys.getenv("PATH"), zip_path, sep=.Platform$path.sep))
  }
  
  # export
  openxlsx::write.xlsx(df, file = out_file, ...)
  
  # open Excel
  if (open) {
    if (.Platform$OS.type == "windows")
      shell.exec(normalizePath(out_file))
    else
      openxlsx::openXL(out_file)
  }
  
  invisible(out_file)
}