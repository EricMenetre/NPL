#' A function to import the microstates statistics from Cartool to R
#' 
#' This function allows the user to directly import the microstates statistics from Cartool to R. Cartool gives one .csv file per within group comparison. This function takes the path of the folder containing the results, imports only the relevant .csv files and join them in one data frame, ready to analyse it.
#' @param path a character vector containing the path to the directory where the .seg and the statistics are stored.
#' @keywords Cartool microstates statistics import
#' @export


import_stats_Cartool <- function(path){
  library(readr)
  # Select the files designed for R (with the mention ColumnsAsFactors)
  files_names <- list.files(path)
  index <- grep("ColumnsAsFactors",files_names)
  list_data <- list()
  
  # Importation of only the files designed for R
  for(i in 1:length(index)){
    path_file <- paste0(path,"/", files_names[index[i]])
    list_data[[i]] <- read_delim(path_file,";", escape_double = FALSE, trim_ws = TRUE)
  }
  
  # Binding the files together
  data_ms <- do.call(rbind, list_data)
  
  # Return
  return(data_ms)
}

