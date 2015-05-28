
#' Prepare photo sheet to be completed
#' 
#' @param photo_files character vector. paths of the photo files
#'
#' @export
#' @importFrom dplyr data_frame
prepare_photo <- function(photo_files) {
  df = data_frame(FICHIER = photo_files, 
                  COMMENTAIRE = as.character(rep(NA, length(photo_files))))
  return(df)
}


#' Export data.frame to Excel file
#'
#' @param df data.frame
#' @param xlfile_out string. path to the output excel file
#' @param open logical. activate opening the file in Excel/LibreOffice/OpenOffice
#'
#' @export
#' @importFrom openxlsx write.xlsx
#' @importFrom openxlsx openXL
export_xl <- function(df, xlfile_out, open = TRUE) {
  # export
  openxlsx::write.xlsx(df, file = xlfile_out)
  
  # ouvrir Excel
  if (open)
    openxlsx::openXL(xlfile_out)
  
  invisible(xlfile_out)
}
