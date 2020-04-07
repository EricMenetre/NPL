#' A function to concatenate EEG data
#' 
#' This function allows to create .ep files (Cartool format) with the concatenation of EEGs. The function takes as input the path to a folder containing forward and backward files and concatenate them according to different parameters.
#' @param path_FW Path to the forward .ep files to concatenate
#' @param path_BW Path to the backward .ep files to conacatenate
#' @param name_subj Character vector containing a name (usually subjects) per concatenated file. The length of this vector should match the numner of element present in path_FW and path_BW
#' @param TF_del Number of time frames to delete. The time frames will be half deleted from the FW and half deleted from the BW
#' @param path_save Path to the folder where the concatenated files chould be saved.
#' @keywords concatenate EEG
#' @export
#' 


concatenate.EEG <- function( path_FW, path_BW, name_subj, TF_del, path_save){
  N_electrodes <- 128
  import_data <- function(path_list, FWBW, names, N_electrodes){
    require(readr)
    require(tidyr)
    data <- list()
    col_TF <- N_electrodes + 1
    col_subj <- N_electrodes + 2
    col_FWBW <- N_electrodes + 3
    for(i in 1:length(path_list)) {
      data[[i]] <- read_table2(file = path_list[i], col_names = FALSE)
      data[[i]][col_TF] <- 1:nrow(data[[i]])
      data[[i]][col_subj] <- names[i]
      data[[i]][col_FWBW] <- FWBW
    }
    subj <<- data
  } 
  
  # Import the FW and the BW  
  import_data(path_list = path_FW, FWBW = "FW",names =  name_subj, N_electrodes = N_electrodes)
  FW <- subj
  import_data(path_list = path_BW, FWBW = "BW",names =  name_subj, N_electrodes = N_electrodes)
  BW <- subj
  
  
  # delete the overlap --> Need to decide if the function needs the RT or the TF to delete
  subj_concat_full <- list()
  for (i in 1:length(FW)){
    if (TF_del[i] <= 0){
      subj_concat_full[[i]] <- rbind(FW[[i]], BW[[i]])
    } else {
      subj_concat_full[[i]] <- rbind(FW[[i]][1:(nrow(FW[[i]])-round((TF_del/2))),],
                                     BW[[i]][round((TF_del/2)):nrow(BW[[i]]),])
    }
  }
  concatenation_data <<- subj_concat_full
  
  # save each element of the list in a folder
  
  for (i in 1:length(path_save)){
    write.table(subj_concat_full[[i]][1:128], path_save[i], row.names = FALSE, col.names = FALSE)
  }
  
}
