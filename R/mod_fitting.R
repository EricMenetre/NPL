#' A function to get the fitting information for a list of lmer of glmer models
#'
#' This function takes as input a list of models and returns the AIC, BIC, log likelihood, deviance and residual degrees of freedom of each one of the models. The models are then ordered according to the smallest AIC.
#'
#' @param models A list of lmer or glmer models under the form list(M1 = m1, M2 = m2, ..., Mn = mn). it is also possible to enter the data without names: c(m1, m2, m3) but this way of doing might be confusing when having many models.
#' @keywords AIC BIC logLik deviance df_resid GLMM LMM lmer glmer
#' @export
#'



mod_fitting <- function(models){

  require(dplyr)
  require(cAIC4)

  # Define the names of the models
  if(is.null(names(models))){
    mod <- 1:length(models)
  } else {
    mod <- names(models)
  }

  # define the AIC, BIC, log likelihood, the deviance and the df_resid of each of the models

  output_fitting <- data.frame(mod)
  output_fitting$AIC <- NA
  output_fitting$BIC <- NA
  output_fitting$logLik <- NA
  output_fitting$deviance <- NA
  output_fitting$df_resid <- NA
  output_fitting$cAIC <- NA
  output_fitting$cAIC_loglik <- NA
  output_fitting$cAIC_DF <- NA
  output_fitting$model_type <- NA
  output_fitting$isREML <- NA
  output_fitting$formula <- NA


  for(i in 1: length(models)){
    if (isLMM(models[[i]]) & !isREML(models[[i]])){
      output_fitting$model_type[i] <- "lmer"
      output_fitting$isREML[i] <- F
      output_fitting$formula[i] <- as.character(formula(models[[i]]))[3]
    temp <- summary(models[[i]])
    output_fitting$AIC[i] <- temp$AICtab[1]
    output_fitting$BIC[i] <- temp$AICtab[2]
    output_fitting$logLik[i] <- temp$AICtab[3]
    output_fitting$deviance[i] <- temp$AICtab[4]
    output_fitting$df_resid[i] <- temp$AICtab[5]
    } else if(isLMM(models[[i]]) & isREML(models[[i]])) {
      output_fitting$model_type[i] <- "lmer"
      output_fitting$isREML[i] <- T
      output_fitting$formula[i] <- as.character(formula(models[[i]]))[3]
      temp <- cAIC(models[[i]])
      output_fitting$cAIC[i] <- temp$caic
      output_fitting$cAIC_loglik[i] <- temp$loglikelihood
      output_fitting$cAIC_DF[i] <- temp$df
    } else if(isGLMM(models[[i]])){
      output_fitting$formula[i] <- as.character(formula(models[[i]]))[3]
      output_fitting$model_type[i] <- "glmer"
      output_fitting$isREML[i] <- NA
      temp <- summary(models[[i]])
      output_fitting$AIC[i] <- temp$AICtab[1]
      output_fitting$BIC[i] <- temp$AICtab[2]
      output_fitting$logLik[i] <- temp$AICtab[3]
      output_fitting$deviance[i] <- temp$AICtab[4]
      output_fitting$df_resid[i] <- temp$AICtab[5]
    }
  }

  return(output_fitting[order(output_fitting$model_type, output_fitting$isREML, output_fitting$cAIC, output_fitting$AIC),])

}
