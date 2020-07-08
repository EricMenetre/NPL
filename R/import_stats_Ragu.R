#' A function to import stats data from Ragu into R
#'
#' This function turns the .xlsx exports data files from Ragu into a data frame compatible for
#' data analysis in R under the tidy format. To use the function attribute it to an element, just like
#' the read_excel function
#'
#' @param path A path (e.g. "C:\\...") where the Ragu stats Excel file is located on your computer
#' @param n_maps Number of maps given by Ragu for the segmentation, i.e. the number of Excel sheets named "Class_n"
#' @param n_conditions Number of between subjects conditions defined in the Ragu settings
#' @keywords Ragu microstates
#' @export


import_stats_Ragu <- function(path, n_maps, n_conditions){
  library(readxl)
  library(tidyr)
  library(dplyr)
  library(stringr)

  # Each maps are represented as a sheet in the Excel file.
  # We need to create an array with the names of each sheet.
  sheets <- paste("Class_", 1:n_maps, sep = "")
  maps <- paste("Map_", 1:n_maps, sep = "")

  #import the data
  data_list <- list()
  for(i in 1:n_maps){
    data_temp <- read_excel(path, sheet = sheets[i])
    data_temp$maps <- maps[i]
    data_list[[i]] <- data_temp
  }
  data_full <- do.call(rbind, data_list)

  # Re-arrange the data

  #data_AUC
  index_AUC <- 1
  conditions <- 1:(n_conditions+1)
  for(i in 2:length(conditions)){
    if (i == 2){
      index_AUC[i] <- index_AUC[i-1] + 4
    } else {
      index_AUC[i] <- index_AUC[i-1] + 6
    }

  }
  index_AUC[length(index_AUC)+1] <- length(data_full)
  data_AUC <- data_full[,index_AUC]
  data_AUC <- data_AUC%>%
    pivot_longer(
      cols = ends_with("_AUC"),
      names_to = "conditions",
      values_to = "AUC")%>%
    mutate(conditions = str_replace(conditions, "_AUC", ""))

  # data_onset
  index_onset <- 1
  for(i in 2:length(conditions)){
    if (i == 2){
      index_onset[i] <- index_onset[i-1] + 1
    } else {
      index_onset[i] <- index_onset[i-1] + 6
    }

  }
  index_onset[length(index_onset)+1] <- length(data_full)
  data_onset <- data_full[,index_onset]
  data_onset <- data_onset%>%
    pivot_longer(
      cols = ends_with("_On"),
      names_to = "conditions",
      values_to = "onset")%>%
    mutate(conditions = str_replace(conditions, "_On", ""))

  # data_offset
  index_offset <- 1
  for(i in 2:length(conditions)){
    if (i == 2){
      index_offset[i] <- index_offset[i-1] + 2
    } else {
      index_offset[i] <- index_offset[i-1] + 6
    }
  }
  index_offset[length(index_offset)+1] <- length(data_full)
  data_offset <- data_full[,index_offset]
  data_offset <- data_offset%>%
    pivot_longer(
      cols = ends_with("_Off"),
      names_to = "conditions",
      values_to = "offset")%>%
    mutate(conditions = str_replace(conditions, "_Off", ""))



  # data_duration
  index_duration <- 1
  for(i in 2:length(conditions)){
    if (i == 2){
      index_duration[i] <- index_duration[i-1] + 3
    } else {
      index_duration[i] <- index_duration[i-1] + 6
    }
  }
  index_duration[length(index_duration)+1] <- length(data_full)
  data_duration <- data_full[,index_duration]
  data_duration <- data_duration%>%
    pivot_longer(
      cols = ends_with("_Dur"),
      names_to = "conditions",
      values_to = "duration")%>%
    mutate(conditions = str_replace(conditions, "_Dur", ""))

  # data_COG
  index_COG <- 1
  for(i in 2:length(conditions)){
    if (i == 2){
      index_COG[i] <- index_COG[i-1] + 5
    } else {
      index_COG[i] <- index_COG[i-1] + 6
    }
  }
  index_COG[length(index_COG)+1] <- length(data_full)
  data_COG <- data_full[,index_COG]
  data_COG <- data_COG%>%
    pivot_longer(
      cols = ends_with("_COG"),
      names_to = "conditions",
      values_to = "COG")%>%
    mutate(conditions = str_replace(conditions, "_COG", ""))

  #data_GFP
  index_GFP <- 1
  for(i in 2:length(conditions)){
    if (i == 2){
      index_GFP[i] <- index_GFP[i-1] + 6
    } else {
      index_GFP[i] <- index_GFP[i-1] + 6
    }
  }
  index_GFP[length(index_GFP)+1] <- length(data_full)
  data_GFP <- data_full[,index_GFP]
  data_GFP <- data_GFP%>%
    pivot_longer(
      cols = ends_with("_GFP"),
      names_to = "conditions",
      values_to = "GFP")%>%
    mutate(conditions = str_replace(conditions, "_GFP", ""))

  # Merging the data
  data_merged <- data_onset%>%
    left_join(data_offset,by = c("SubjectID", "maps", "conditions"))%>%
    left_join(data_duration,by = c("SubjectID", "maps", "conditions"))%>%
    left_join(data_AUC,by = c("SubjectID", "maps", "conditions"))%>%
    left_join(data_COG,by = c("SubjectID", "maps", "conditions"))%>%
    left_join(data_GFP,by = c("SubjectID", "maps", "conditions"))

  # end
  return(data_merged)

}
