#' A function to import epochs in a data frame
#' 
#' This function takes the path to the .ep files and give back a data framed following the tidyformat and under a list with each of the element being the different data frames corresponding to the data of one subject.
#' @param path Path to the data in .ep format
#' @param N_electrodes Number of electrodes of the recording
#' @keywords import epochs
#' @export

import.epochs.ep <- function(path, N_electrodes){
  
  require(readr)
  require(tidyr)
  files <- list.files(path)
  files_df <- data.frame(files)
  files_df$ep <- !grepl(".vrb", files_df$files)
  files_df <- files_df[files_df$ep == TRUE,]
  files_df$ep <- NULL
  subj <- list()
  col_TF <- N_electrodes + 1
  col_subj <- N_electrodes + 2
  for(i in 1:nrow(files_df)) {
    path_temp <- paste(path, "/", files_df$files[i], sep = "")
    subj[[i]] <- read_table2(file = path_temp, col_names = FALSE)
    subj[[i]][col_TF] <- 1:nrow(subj[[i]])
    subj[[i]][col_subj] <- paste("subj_",i,sep = "")
  }
  data <- do.call(rbind.data.frame, subj)
  data_groupped <<- data
  subj_list <<- subj
}