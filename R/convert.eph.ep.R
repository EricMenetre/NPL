#' A function to convert .eph files into .ep files
#' 
#' This package uses the simple .ep format. This function converts the .eph into .ep format
#' @param file Path or dataframe containing the .eph file
#' @keywords convert eph ep .eph .ep
#' @export


convert.eph.ep <- function(file){
  library(readr)
  data <- read_delim(file, "\t", escape_double = FALSE, col_names = FALSE, 
                     trim_ws = TRUE, skip = 1)
  
  filename <- paste(file, "_converted.ep", sep = "")
  
  write.table(data, file = filename, row.names = FALSE, col.names = FALSE)
  
}
