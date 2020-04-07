#' A function to prepare the data to be analyzed in the STEN software
#' 
#' This function removes the spaces and replace them by an underscore
#' @param path Path to the files to rename
#' @keywords STEN delete spaces
#' @export

delete.spaces.STEN <- function(path){
  
  files <- list.files(path)
  files_df <- data.frame(files)
  files_df$ep <- !grepl(".vrb", files_df$files)
  files_df <- files_df[files_df$ep == TRUE,]
  files_df$ep <- NULL
  files_df$files_renamed <- str_replace_all(files_df$files, " ", "_")
  
  for (i in 1:nrow(files_df)){
    file.rename(from = paste(path, "/", files_df$files[i], sep = ""), to = paste(path, "/", files_df$files_renamed[i], sep = ""))
  }
}