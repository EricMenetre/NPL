#' Function Screen_sd
#'
#' This function allows to select how many standard deviations above and under the mean to remove for data cleaning.
#'
#' @param RT_var RT variable under the format data$variable.
#' @param min Lowest value of the range of SD to explore. Default is 1
#' @param max Highest value of the range of SD to explore. Default is 4.5
#' @param step Step from which to increase the SD to screen. Default is 0.5. For example with default values : 1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5.
#' @param data Dataframe containing the data. Same as the element before the $ sign in the RT_var parameter.
#' @keywords SD standard deviation screening distribution
#' @export

screen_n_sd <- function(RT_var, min = 1, max = 4.5, step = 0.5, data){
  # Libraries
  library(NPL)
  library(ggplot2)
  library(ggpubr)

  # Create a vector with the values of sd
  n_sd <- seq(from = min, to = max, by = step)

  # Create an empty list with all the possible SD and create one vector without extreme values per list element
  list_RT <- list()
  for(i in 1:length(n_sd)){
    clean.sd(df.var.val = RT_var,
             n.sd = n_sd[i],
             data = data,
             fill = NA)
    list_RT[[i]] <- clean.val

  }
  data_RT <- do.call(cbind, list_RT)
  data_RT <- as.data.frame(data_RT)
  dev.off()
  rm(clean.val)

  # Make a density plot for each element of the list
  list_plots <- list()
  for(i in 1:length(list_RT)){
    med_RT <- median(list_RT[[i]], na.rm = T)
    moy_RT <- mean(list_RT[[i]], na.rm = T)
   plot_temp <- ggplot(data_RT, aes(x = data_RT[,i]))+
      geom_density(fill = "dodgerblue", alpha = 0.3, size = 1)+
      geom_vline(xintercept = med_RT, linetype = 2)+
      geom_vline(xintercept = moy_RT)+
      theme_minimal()+
      labs(title = paste("Distribution for cleaning at", n_sd[i], "sd", sum(!is.na(list_RT[[i]])), "/", length(list_RT[[i]]), "observations"),
           x = "RT")
   print(plot_temp)

  }
  rm(clean.val)
}
