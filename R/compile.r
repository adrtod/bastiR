
#' Print taille d'un fichier
#'
#' @param sz taille en octets
#' @keywords internal
print_sz = function(sz) {
  ifelse(sz<1024^2, 
         paste0(format(sz/1024, digits=2), "ko"),
         paste0(format(sz/1024^2, digits=2), "Mo"))
}

#' Resize photos
#'
#' @param photo_files character vector. paths of the photo files
#' @param out_dir string. output directory of the resized photos
#' @param max_width maximum photo width
#' @param max_height maximum photo height
#' @param quality the 'quality' of the output JPEG image, as a percentage.
#' @param quiet logical. disable printing text output to the console
#'
#' @export
#' @importFrom tools file_ext
#' @importFrom png readPNG
#' @importFrom jpeg readJPEG
resize_photos <- function(photo_files = list.files(".", pattern = ".*\\.(jpg|jpeg|JPG|JPEG|png|PNG)"),
                          out_dir = "tmp", max_width = 340, max_height = 340, quality = 95,
                          quiet = FALSE) {
  out = character(0)
  for (i in seq_along(photo_files)) {
    f = photo_files[[i]]
    ext = file_ext(f)
    file_out = file.path(out_dir, basename(f))
    if (tolower(ext) == "png") {
      readfun = readPNG
      devfun = png
    } else if (tolower(ext) %in% c("jpg", "jpeg")) {
      readfun = readJPEG
      devfun = function(...) jpeg(..., quality = quality)
    } else {
      warning("photo extension not supported:", f)
      next
    }
    
    img = readfun(f)
    h = dim(img)[1] # height
    w = dim(img)[2] # width
    r = w/h # ratio
    h2 = h
    w2 = w
    if (w2>max_width) {
      w2 = max_width
      h2 = round(w2/r)
    }
    if (h2>max_height) {
      h2 = max_height
      w2 = round(h2*r)
    }
    
    sz = file.size(f)
    
    if (!quiet)
      cat("  ", basename(f), " : ", w, "x", h, " (", print_sz(sz), ") ==> ", w2, "x", h2, sep="")
    
    devfun(file_out, width = w2, height = h2)
    par(mar=rep(0,4))
    plot(c(0, 1), c(0, 1), type="n", xlab = "", ylab = "",
         bty="n", xaxt="n", yaxt="n", xaxs="i", yaxs="i")
    rasterImage(img, 0, 0, 1, 1)
    dev.off()
    
    sz2 = file.size(file_out)
    
    if (!quiet)
      cat(" (", print_sz(sz2), ") ", format(sz2/sz*100, digits=2),"%\n", sep="")
    
    out = c(out, file_out)
  }
  invisible(out)
}


#' Compilation du compte rendu pdf
#'
#' @param cfg_file cfg_file string. ficher R de configuration
#' @param encoding string. encodage du fichier cfg_file
#' @param quiet logical. desactive les sorties textuelles
#' @param recursive logical. voir \code{\link{dir.create}}
#' @param clean logical. active la supression des fichiers temporaires
#' @param quiet_knit logical. desactive les sorties textuelles de \code{\link[knitr]{knit2pdf}}
#'
#' @return The name of the output pdf file
#' @export
#' @importFrom knitr knit2pdf
compile_cr <- function(cfg_file = "config.r", encoding = "ISO8859-1",
                       quiet = FALSE, recursive = TRUE, clean = TRUE,
                       quiet_knit = TRUE) {
  if (!quiet)
    cat("Compilation du compte rendu pdf :\n")
  
  # chargement des variables du projet
  if (!quiet)
    cat("* Chargement du fichier de configuration :", cfg_file, "\n")
  
  source(cfg_file, local = TRUE, encoding = encoding)
  
  # Retaillage des photos
  
  # lecture fichier
  if (!quiet)
    cat("* Lecture des photos dans :", xl_file_photos, "\n")
  xl_photos = read_xl(xl_file_photos, sheets = "PHOTOS")
  
  photo_files = xl_photos$PHOTOS$FICHIER
  row = !is.na(xl_photos$PHOTOS$COMMENTAIRE) & nzchar(xl_photos$PHOTOS$COMMENTAIRE)
  photo_files = file.path(backup, photo_files[row])
  
  if (!dir.exists(temp)) {
    if (!quiet)
      cat("* Creation du dossier temporaire :", temp, "\n")
    dir.create(temp, recursive = recursive)
  }
  
  if (!quiet)
    cat("* Retaillage des photos dans :", temp, "\n")
  
  resize_photos(photo_files = photo_files, out_dir = temp,
                max_width = max_width, max_height = max_height,
                quality = quality, quiet = quiet)
  
  # render file
  if (!quiet)
    cat("* Compilation du pdf :", paste0(out_name, ".pdf"), "\n")
  
  pdf_file = knitr::knit2pdf(rnw_file, paste0(out_name, ".tex"),
                             encoding = encoding, 
                             quiet = quiet_knit, clean = clean)
  
  # clean
  if(clean) {
    if (!quiet)
      cat("* Suppression des fichiers et dossiers temporaires\n")
    
    file.remove(paste0(out_name, ".tex"))
    
    # supprime temp
    unlink(temp, recursive = TRUE)
  }
  
  if (!quiet) {
    cat("* Fichier pdf produit :", pdf_file,"\n")
    
    cat("\nEtapes suivantes pour le prochain compte rendu :\n")
    cat('1. Editer "', cfg_file, '"\n', sep="")
    cat("2. Placer les photos dans le dossier approprie\n")
    cat("3. Preparer le compte rendu avec :\n")
    cat('    prepare_cr("', cfg_file, '")\n', sep="")
  }
  
  invisible(pdf_file)
}
