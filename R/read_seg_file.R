#' A function to import microstates seg file from Cartool
#' 
#' This function allows the user to open a .seg file from Cartool (usually
#' obtained after a segmentation into microstates) in R. The function rename
#' the columns to put them in a freidly format.
#' @param path path to the .seg file. e.g. "c:/Users/.../segfile.seg"
#' @keywords Cartool, microstates, segmentation, import
#' @export

read_seg_file <- function(path){
  # Import data microstates
  data_ms <- read_delim(path, 
                        "\t", escape_double = FALSE, col_names = FALSE, 
                        trim_ws = TRUE, skip = 2)
  
  ncol_data_ms <- ncol(data_ms)
  data_ms[,ncol_data_ms] <- NULL
  
  
  # Rename columns 
  
  ncol_data <- ncol(data_ms)
  n_conditions <- ncol_data/5
  data_colnames <- NA
  
  GFP <- paste0("GFP_", 1:n_conditions)
  Dis <- paste0("Dis_", 1:n_conditions)
  Seg <- paste0("Seg_", 1:n_conditions)
  GEV <- paste0("GEV_", 1:n_conditions)
  Corr <- paste0("Corr_", 1:n_conditions)
  
  temp <- rbind(GFP, Dis, Seg, GEV, Corr)
  names(data_ms) <- temp
  data_ms$time <- 1:nrow(data_ms)
  return(data_ms)
}