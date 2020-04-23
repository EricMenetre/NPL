#' A function to help selecting the best model fitting according to the Chisquare between two models
#' 
#' This function takes as input a list of models and returns a matrix containg all the models and showing the Chisquare difference between all models. The calculation is based on the anova() function, here simply performed for each model against each model
#'
#' @param models A list of lmer or glmer models under the form list(M1 = m1, M2 = m2, ..., Mn = mn). it is also possible to enter the data without names: c(m1, m2, m3) but this way of doing might be confusing when having many models. 
#' @keywords anova models lmer glmer LMM GLMM
#' @export
#' 

cross_anova_models <- function (models){
  
  # Define the names of the models
  if(is.null(names(models))){
    mod <- 1:length(models)
  } else {
    mod <- names(models)
  }
  
  anova_matrix <- matrix(nrow = length(models), ncol = length(models))
  rownames(anova_matrix) <- mod
  colnames(anova_matrix) <- mod
  
  for(rows in 1:length(models)){
    for (columns in 1:length(models)){
      temp <- anova(unlist(models[[mod[rows]]]), unlist(models[[mod[columns]]]))
      anova_matrix[rows, columns] <- round(temp$`Pr(>Chisq)`[2],3)
    }
  }
  
  return(anova_matrix)
}
