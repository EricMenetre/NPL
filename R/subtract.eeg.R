#' A function to subtract two EEG epochs
#' 
#' This function creates a new epoch under the .ep format from the subtraction of two files of the same dimension. Careful the function is not written efficiently
#' @param file1 First file to do the subtraction. file2 is subtracted from file1
#' @param file2 Second file to do the subtraction. file2 is subtracted from file1
#' @keywords subtraction EEG
#' @export


subtract.eeg <- function (file1, file2, path_save) {
  data_sub <- data.frame()
  for (i in 1:nrow(file1)){
    for (j in 1:ncol(file1)) {
      data_sub[i,j] <- file2[i,j] - file1[i,j] 
    }
  }
  subtracted_eeg <<- data_sub
  write.table(data_sub, path_save, row.names = F, col.names = F)
  
}