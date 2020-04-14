#' A function to verify the postulates of an lmer element
#' 
#' This function allows to check if the intercepts or slopes of the effects are normally distributed, if the residuals are normally distributed and if there is an homogeneity of the variances in the residuals. All the plots that the function returns should show a globally normal distribution.
#' @param model The model for which the postulates need to be checked
#' @keywords postulates, residuals, homoscedasticity
#' @export

LMM_check <- function(model){
  #PKG
  require(ggplot2)
  require(lme4)
  require(tibble)
  
  # Are the random effects normally distributed ?
  int_list <- ranef(model)
  plot_list <- list()
  for(i in 1:length(int_list)){
    if (i == 1){
      int <- enframe(int_list[[i]][,1],value = "int", name = NULL)
      plot_list[[i]] <- ggplot(int, aes(x = int))+
        geom_histogram(aes(y = ..density..),
                       fill = "white",
                       color = "black")+
        stat_function(fun = dnorm, args = list(mean = mean(int$int), sd = sd(int$int)), color = "red")+
        theme_minimal()+
        labs(title = "Distribution of the random effects", x = paste("Random effects of", names(int_list[i])))
      
    } else{
      int <- tibble::enframe(int_list[[i]][,1],value = "int", name = NULL)
      plot_list[[i]] <- ggplot(int, aes(x = int))+
        geom_histogram(aes(y = ..density..),
                       fill = "white",
                       color = "black")+
        stat_function(fun = dnorm, args = list(mean = mean(int$int), sd = sd(int$int)), color = "red")+
        theme_minimal()+
        labs(x = paste("Random effects of", names(int_list[i])))
    }
  }
  
  distr_random_effects <- do.call(ggarrange, plot_list)
  
  #Are the residuals normally distributed ?
  res <- enframe(residuals(model), name = NULL)
  plot_resid <- ggplot(res, aes(x = value))+
    geom_histogram(aes(y = ..density..),
                   fill = "white",
                   color = "black")+
    stat_function(fun = dnorm, args = list(mean = mean(res$value), sd = sd(res$value)), color = "red")+
    theme_minimal()+
    labs(x = "Residuals", title = "distribution of the residuals")
  
  # Homoscedasticity of the residuals
  pred <- enframe(fitted(model), name = NULL)
  data_homosc <- data.frame(res$value, pred$value)
  plot_homosc <- ggplot(data_homosc, aes(x = pred.value, y =res.value))+
    geom_point()+
    theme_minimal()+
    labs(x = "Predicted values", y = "Residuals", title = "Homoscedasticity")
  res_plots <- ggarrange(plot_resid, plot_homosc)
  
  # Final result
  return(ggarrange(distr_random_effects, res_plots, nrow = 2))
  
}