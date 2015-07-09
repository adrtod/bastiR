
#' Prepare photo sheet to be completed
#' 
#' @param photo_files character vector. paths of the photo files
#'
#' @export
#' @importFrom dplyr data_frame
prepare_photos <- function(photo_files = list.files(".", pattern = ".*\\.(jpg|jpeg|JPG|JPEG|png|PNG)")) {
  df = data_frame(FICHIER = photo_files, 
                  COMMENTAIRE = as.character(rep(NA, length(photo_files))))
  return(df)
}

#' Resize photos
#'
#' @param photo_files character vector. paths of the photo files
#' @param folder string. output folder of the resized photos
#' @param max_width maximum photo width
#' @param max_height maximum photo height
#'
#' @export
#' @importFrom tools file_ext
#' @importFrom png readPNG
#' @importFrom jpeg readJPEG
resize_photos <- function(photo_files = list.files(".", pattern = ".*\\.(jpg|jpeg|JPG|JPEG|png|PNG)"),
                          folder = "tmp", max_width = 800, max_height = 600) {
  out = character(0)
  for (i in seq_along(photo_files)) {
    f = photo_files[[i]]
    ext = file_ext(f)
    file_out = file.path(folder, basename(f))
    if (tolower(ext) == "png") {
      readfun = readPNG
      devfun = png
    } else if (tolower(ext) %in% c("jpg", "jpeg")) {
      readfun = readJPEG
      devfun = function(...) jpeg(..., quality = 100)
    } else {
      warning("photo extension not supported:", f)
      next
    }
    img = readfun(f)
    h = dim(img)[1] # height
    w = dim(img)[2] # width
    r = w/h # ratio
    if (w>max_width) {
      w = max_width
      h = w/r
    }
    if (h>max_height) {
      h = max_height
      w = h*r
    }
    devfun(file_out, width = w, height = h)
    par(mar=rep(0,4))
    plot(c(0, 1), c(0, 1), type="n", xlab = "", ylab = "",
         bty="n", xaxt="n", yaxt="n", xaxs="i", yaxs="i")
    rasterImage(img, 0, 0, 1, 1)
    dev.off()
    out = c(out, file_out)
  }
  invisible(out)
}

#' Write data.frame to Excel file
#'
#' @param df data.frame or list of data.frames
#' @param xlfile_out string. path to the output excel file
#' @param open logical. activate opening the file in Excel/LibreOffice/OpenOffice
#' @param zip_path string. path containing zip executable on windows
#'
#' @export
#' @importFrom openxlsx write.xlsx
#' @importFrom openxlsx openXL
write_xl <- function(df, 
                     xlfile_out, 
                     open = FALSE,
                     zip_path = "C:\\Rtools\\bin") {
  
  if (.Platform$OS.type == "windows") {
    tryCatch(shell("zip -v"), 
             warning = function(w)
               Sys.setenv(PATH = paste(Sys.getenv("PATH"), zip_path, sep=";"))
    )
  }
  
  # export
  openxlsx::write.xlsx(df, file = xlfile_out)
  
  # ouvrir Excel
  if (open)
    openxlsx::openXL(xlfile_out)
  
  invisible(xlfile_out)
}
