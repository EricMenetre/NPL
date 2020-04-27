#' A function to remove outlier subjects
#'
#' This function examines the data and gives back which subjects are to be removed because of mean RT above or under a certain number of standard deviations
#' @param group.var Groupping variable for example age group. Use the raw name of the column e.g. group instead of data$group without "" either
#' @param subj.var Subject variable. Use the raw name of the column e.g. subjects instead of data$subjects without "" either
#' @param RT.var Variable containing the reaction times. Use the raw name of the column e.g. RT instead of data$RT without "" either
#' @param N.sd Number of standard deviation above and under the mean where to put the rejection boundary.
#' @param data Name of the dataframe containing the experimental data.
#' @keywords clean subject group RT SD standard deviations
#' @export


clean.subj.group <- function(group.var, subj.var, RT.var, N.sd, data){
  require("dplyr")

  # Not all datasets need to be specifically processed by group, the user should be able to chose. If it is not the case of your data frame, use the function clean.subj

  #dplyr specificity due to the NSE, need for enquo each variable and specify !! in the dplyr functions
  group.var <- enquo(group.var)
  subj.var <- enquo(subj.var)
  RT.var <- enquo(RT.var)

  #creation of a data frame containing the age groups and the subjects names
  subj <- data%>%
    group_by(!!group.var, !!subj.var)%>%
    summarise()%>%
    rename(group = !!group.var)%>%
    rename(subject = !!subj.var)

  # Creation of a data frame containing the criteria according to which each subject will be compared
  criterion <- data.frame(subj$subject)

  # Estimation of the upper and inferior limits for each subject inside each age group, excluding each subject one after the other
  for (i in 1:nrow(subj)) {
    criterion[i,2:5] <- data%>%
      filter(!!group.var == subj$group[i])%>%
      filter(!!subj.var != subj$subject[i])%>%
      summarise(mean.grp = mean(!!RT.var, na.rm = T), sd = sd(!!RT.var, na.rm = T))%>%
      mutate(lim_inf = mean.grp-(N.sd*sd), lim_sup = mean.grp+(N.sd*sd))
  }

  # Estimation of the mean of each subject
  temp <- data%>%
    group_by(!!group.var, !!subj.var)%>%
    summarise(mean.subj = mean(!!RT.var, na.rm = T))

  criterion$mean.subj <- temp$mean.subj

  # Comparing each subject to the criterion
  criterion$criterion <- NA

  for (i in 1:nrow(criterion)){
    if (criterion$mean.subj[i] >= criterion$lim_inf[i] & criterion$mean.subj[i] <= criterion$lim_sup[i]){
      criterion$criterion[i] <- "kept"
    } else if (criterion$mean.subj[i] < criterion$lim_inf[i] | criterion$mean.subj[i] > criterion$lim_sup[i]) {
      criterion$criterion[i] <- "OUT"
    }
  }

  return(criterion)
}
