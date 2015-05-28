
#' @export
#' @importFrom dplyr data_frame
prepare_photo <- function(photo_files) {
  df = data_frame(FICHIER = photo_files, 
                  COMMENTAIRE = as.character(rep(NA, length(photo_files))))
  return(df)
}


#' @export
#' @importFrom openxlsx write.xlsx
#' @importFrom openxlsx openXL
export_xl <- function(xl, xlfile_out, open = TRUE) {
  # export
  openxlsx::write.xlsx(xl, file = xlfile_out)
  
  # ouvrir Excel
  if (open)
    openxlsx::openXL(xlfile_out)
  
  invisible(xlfile_out)
}
