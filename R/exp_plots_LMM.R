#' A function to explore the data before undergoing statistics
#'
#' This function draws some plots to explore the data before moving to the linear mixed models. The graphs do not represent all the needed information. However, it draws the main graph needed to perform a linear mixed model with the subject and items random effects.
#' @param data data frame containing the behavioral results
#' @param DV dependant variable under the form data$DV
#' @param ID ID variable containing the subjetcs names under the form data$ID
#' @param class variable containing the items or other second level variable under the form data$class
#' @keywords exploratory plots LMM mixed models lmer
#' @export

exp_plots_LMM <- function(data, DV, ID, class){
  #PKG
  require(ggplot2)
  require(ggpubr)

  # histogram DV
  hist_dv <- ggplot(data, aes(x = DV))+
    geom_histogram(aes(y = ..density..),
                   fill = "white",
                   color = "black")+
    stat_function(fun = dnorm, args = list(mean = mean(DV, na.rm = T), sd = sd(DV, na.rm = T)), color = "red")+
    theme_minimal()+
    labs(title = "Histogram", x = "Dependant variable")


  # Boxplot DV
  boxplot_dv <- ggplot(data, aes(y = DV))+
    geom_boxplot(size = 0.1)+
    coord_cartesian(xlim = c(-1,1))+
    theme_minimal()+
    theme(axis.text.x = element_blank())+
    labs(title = "Boxplot", y = "Dependant variable")

  # DV by ID
  boxplot_dv_id <- ggplot(data, aes(y = DV, fill = ID))+
    geom_boxplot()+
    theme_minimal()+
    theme(legend.position = "none", axis.text.x = element_blank())+
    labs(y = "Dependant variable", title = "DV by ID")

  # DV by class
  boxplot_dv_class <- ggplot(data, aes(y = DV, fill = class))+
    geom_boxplot()+
    theme_minimal()+
    theme(legend.position = "none", axis.text.x = element_blank())+
    labs(y = "Dependant variable", title = "DV by class")


  # Final result
  box_hist <- ggarrange(hist_dv, boxplot_dv, nrow = 1, ncol = 2)
  return(ggarrange(box_hist, boxplot_dv_id, boxplot_dv_class, nrow = 3))

}
