#' A function to prepare the signal's data for the brainperm function (permuco4brain)
#'
#' This function build a list containing each individual's average signal and transforms it into a 3D matrix to be analyzed with the brainperm() function from the permuco4brain package. For this function to work you will need to install the readr package and the abind package
#'
#' @param path path to the folder containing the averaged signal per subjects and condition (tip: name the files wisely)
#' @param N_electrodes Number of electrodes included in the montage: either 128 or 64
#' @param files_extension Format of the files needed to be imported. Supported format are ".ep", ".txt", ".asc".
#' @keywords permuco import mass univariate
#' @export

import_data_permuco <- function(path, N_electrodes, files_extension){

  library(readr)
  require(abind)
  setwd(path)

  list_data <- list()
  list_files <- list.files()
  list_files <- list_files[grep(files_extension, list_files)]

  if(N_electrodes == 128){
    electrodes_names <- c(paste0("A", 1:32), paste0("B", 1:32), paste0("C", 1:32), paste0("D", 1:32))
  } else if(N_electrodes == 64){
    electrodes_names <- c(paste0("A", 1:32), paste0("B", 1:32))
  } else {
    print("Unknown montage; either 128 or 64 electrodes")
  }

  for(i in 1:length(list_files)){
    temp <- read_table2(list_files[i],
                        col_names = FALSE)
    temp <- temp[,1:N_electrodes]
    colnames(temp) <- electrodes_names
    list_data[[i]] <- temp
  }

  signal_test <- abind(list_data, along = 3)
  signal_test <-aperm(signal_test, c(3,1,2))

  return(signal_test)
}
