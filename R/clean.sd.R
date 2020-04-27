#' A function to remove extreme RT
#'
#' This function creates a new vector called clean.val containing the RT without the extremes values. Values are defined as extreme when higer than a certain number of standard deviations from the mean of each subject individually
#' Once the function finished running, simply attribute the clean.val vector to your data frame under the form: my_data$my_clean_RT_variable <- clean.val.
#'
#' @param df.var.val Dataframe$column containing the RT
#' @param df.var.group Dataframe$column containing the groupping variable for example the age groups. If your experiment does not include groups, set this argument to "none". Default is "none"
#' @param n.sd Number of standard deviations above the mean where to cut
#' @param data Name of the dataframe containing the data
#' @param fill Value to replace the extreme values by. The default is NA
#' @keywords clean RT standard deviation group
#' @export

clean.sd <- function(df.var.val, df.var.group = "none", n.sd, data, fill = NA) {

  plot.before.cleaning <- qqnorm(df.var.val, main = "Distribution before cleaning") ; qqline(df.var.val)
  hist.before.cleaning <- hist(df.var.val, main = "Distribution of the RT before cleaning")

  if(df.var.group == "none"){
    # Creation of a data frame with the values above or under the general mean of RT regarding the number of SD
    x <- mean(df.var.val, na.rm = T)
    moy.df.test <- data.frame(x)
    x <- sd(df.var.val, na.rm = T)
    sd.df.test <- data.frame(x)
    lim.df.test <- moy.df.test
    lim.df.test$sd <- sd.df.test$x
    lim.df.test$lim.inf <- lim.df.test$x - (n.sd*lim.df.test$sd)
    lim.df.test$lim.sup <- lim.df.test$x + (n.sd*lim.df.test$sd)

    for(i in 1:nrow(data)){
      if(is.na(df.var.val[i])){
        next
      } else if(df.var.val[i] > lim.df.test$lim.sup[1]){
        df.var.val[i] <- fill
      } else if(df.var.val[i] < lim.df.test$lim.inf[1]){
        df.var.val[i] <- fill
      }
    }
    print("Means, standard deviations, inferior and superior limits of the data:")
    print(lim.df.test)

  } else {
  # Creation of a data frame with the values above or under the mean of the group regarding the number of SD
  moy.df.test <- data.frame(aggregate(df.var.val, list(df.var.group), mean, na.rm = TRUE))
  sd.df.test <- data.frame(aggregate(df.var.val, list(df.var.group), sd, na.rm = TRUE))
  lim.df.test <- moy.df.test
  lim.df.test$sd <- sd.df.test$x
  lim.df.test$lim.inf <- lim.df.test$x - (n.sd*lim.df.test$sd)
  lim.df.test$lim.sup <- lim.df.test$x + (n.sd*lim.df.test$sd)
  print("Means, standard deviations, inferior and superior limits of the data:")
  print(lim.df.test)


  # Nettoyage des donn?es

  for (i in 1:nrow(lim.df.test)) {
    for (j in 1:nrow(data)) {
      if (is.na(df.var.val[j])) {
        next
      } else if (lim.df.test$Group.1[i] == df.var.group[j]) {
        if (df.var.val[j] <= lim.df.test$lim.inf[i]) {
          df.var.val[j] <- fill
        } else if (df.var.val[j] >= lim.df.test$lim.sup[i]) {
          df.var.val[j] <- fill
        }
      }
    }
  }
  }

  clean.val <<- df.var.val



  # V?rification du succ?s de l'op?ration
  # D?finition du nombre de valeurs au dessus ou en dessous de la limite pour le premier sujet

  sum.lim.sup <- sum(df.var.val[df.var.val == lim.df.test$Group.1[1]] >= lim.df.test$lim.sup[1], na.rm = TRUE) + sum(df.var.val[df.var.val == lim.df.test$Group.1[2]] >= lim.df.test$lim.sup[2], na.rm = TRUE)
  sum.lim.inf <- sum(df.var.val[df.var.val == lim.df.test$Group.1[1]] <= lim.df.test$lim.inf[1], na.rm = TRUE) + sum(df.var.val[df.var.val == lim.df.test$Group.1[2]] <= lim.df.test$lim.inf[2], na.rm = TRUE)
  sum.lim.tot <- sum(sum.lim.sup, sum.lim.inf)

  if (sum.lim.tot == 0) {
    print("The job is done and work was verified for the first 2 groups. The vector clean.val has been created. You need to add it to your original data.")
  } else if (sum.lim.tot != 0) {
    print("WARNING: BE CAREFUL, SOME EXTREME VALUES REMAIN AT LEAST IN THE FIRST 2 GROUPS")
  }


  plot.before.cleaning
  hist.before.cleaning
  qqnorm(df.var.val, main = "Distribution after cleaning") ; qqline(df.var.val)
  hist(clean.val, main = "Distribution of the RT after cleaning")

  # Normality tests of Kolmogorov-Smirnov anf Shapiro Wilks
  #shap.before <- shapiro.test(df.var.val)
  #shap.after <- shapiro.test(clean.val)
  #ks.before <- ks.test(df.var.val, "pnorm", mean = mean(df.var.val, na.rm = T), sd = sd(df.var.val, na.rm = T))
  #ks.after <- ks.test(clean.val, "pnorm", mean = mean(df.var.val, na.rm = T), sd = sd(df.var.val, na.rm = T))
  #ks.after$statistic
  # results of the normality tests

  #print(paste("Two tests of normality have been performed: the Kolmogorov-Smirnov and Shapiro-Wilks. The W statistic associated to the Shapiro-wilks test before cleaning is", round(shap.before$statistic,2), "and the associate p-val is:", round(shap.before$p.value,2), ". After cleaning, the W equals", round(shap.after$statistic,2)," and the corresponding p-val equals", round(shap.after$p.value,2),"."))
  #print(paste("Regarding the Kolmogorov-Smirnov test, before cleaning, the D statistic is", round(ks.before$statistic,2), "while the corresponding p-val equals", round(ks.before$p.value,2),". After cleaning, the D statistic is", round(ks.after$statistic,2), "and the corresponding p-val equals", round(ks.after$p.value,2)))

}
