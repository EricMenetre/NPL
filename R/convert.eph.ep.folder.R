#' A function to convert an entire folder from .eph to .ep
#' 
#' This package uses .ep format. Use this function to convert a folder containing .eph files into .ep files
#' 
#' @param path Path to the folder containing some .eph files
#' @keywords folder convert ep .ep .eph
#' @export


convert.eph.ep.folder <- function(path){
  files <- list.files(path)
  index <- grep(".eph$", files)
  files <- files[index]
  
  lapply(files, convert.eph.ep)
}