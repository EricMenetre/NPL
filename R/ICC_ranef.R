#' A function to extimate the ICC (intra-class correlation)
#'
#' This function allows, for a given lmer model, to estimate by how much a random effect explains the total variance of the model. Moreover, if the ICC is high, the difference inside the element of the class are important (large differences among the subjects for example). And if the ICC is small, it implies a coherence inside the class.
#'
#' @param model A lmer or glmer model from the lme4 package
#' @keywords ICC lmer glmer variance
#' @export

ICC_ranef <- function(model){
  require(nlme)
  var_mod <- as.data.frame(VarCorr(model))
  var_names <- var_mod$grp[1:(NROW(var_mod)-1)]
  output <- data.frame(var_names)
  output$ICC <- NA

  var_tot <- sum(var_mod$vcov)

  for(i in 1:nrow(output)){
    output$ICC[i] <- paste(round((var_mod$vcov[i]/var_tot)*100,2), "%", sep = "")
  }

  return(output)
}


