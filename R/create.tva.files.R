#' Function to create the Triggers Validation Files for Cartool
#' 
#' This functions allows the user to create automatically the .tva files based on the behavioral results dataframe
#' @param data Name of the data frame containing the results
#' @param subj.var Name of the subject's ID variable (tidy format, i.e. variable name in the data frame without $ or "")
#' @param CR.var Name of the accuracy variable (tidy format)
#' @param RT.var Name of the RT variable (tidy format)
#' @param trig.var Name of the variable containing the triggers (tidy format)
#' @param path.save Path to the folder where to save the .tva files
#' @keywords tva TVA .tva .TVA trigger validation files
#' @export

create.tva.files <- function(data, subj.var, CR.var, RT.var, trig.var, path.save) {
  require("dplyr")
  
  # Creation of a table containing the name of each subject
  subj.var <- enquo(subj.var)
  CR.var <- enquo(CR.var)
  RT.var <- enquo(RT.var)
  trig.var <- enquo(trig.var)
  
  
  Sujets <<- data%>%
    group_by(!! subj.var)%>%
    summarise(N = n())
  
  names(Sujets)[1] <- "Subjects"
  
  
  for (i in 1:dim(Sujets)) {
    data%>%
      filter(!!subj.var == Sujets$Subjects[i])%>%
      select(!!CR.var, !!RT.var, !!trig.var)%>%
      write.table(paste(path.save,"/", Sujets[i,1],"_TVA_in.tva", sep = ""),
                  sep="\t",
                  col.names = FALSE,
                  row.names = FALSE)
  }
  
  
}