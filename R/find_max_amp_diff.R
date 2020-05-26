#' A function to find the electrode with the maximum aplitude difference between two condition for peak analysis
#' 
#' This function takes a data set imported by the import_epochs.ep() function and evaluates the differences regarding the area under the curve (AUC) for two conditions for each electrode, and performs the difference. The higher the differences of AUC, the more different the conditions.
#' For now, the function takes only datasets with two conditions. If your dataset has a higher number of conditions, please consider applying this function 2 conditions by 2 conditions.
#' Be careful, a minimal difference of AUC does not necessarily mean that there is no difference between two conditions. If the temporal window is large enough, two curves intersecting in an X shape might result to a minimal differences. Differences in time lag between two condition will also have a small AUC difference. This function helps you to chose the right electrodes but do not use it blindly !
#' 
#' @param data A dataset imported with the import_epochs.ep() function
#' @param condition_var variable of data containing the different conditions for each subject. Use the tidy format (simply the column name without $ or data[])
#' @param time_var Variable containing the time information, either in time frames or in ms. Use the tidy format (simply the column name without $ or data[])
#' @param N_electrodes Number of electrodes used in the file.
#' @export

# Function
find_max_amp_diff <- function(data, condition_var, time_var, N_electrodes){
  # Libraries
  require(dplyr)
  require(DescTools)
  
  # Check data
  condition_var <- enquo(condition_var)
  conditions <- data%>%distinct(!!condition_var)
  if(nrow(conditions) != 2){
    return("This function only works with combinations of two conditions. Split your data and perform the comparisons two by two.")
  } else {
    
    # Definition of the dataframe with the results
    elec_names <- colnames(data[,1:N_electrodes])
    output <- data.frame(elec_names)
    output$AUC_cond_1 <- NA
    output$AUC_cond_2 <- NA
    
    # Split in df according to condition
    data_c_1 <- data%>%filter(!!condition_var == as.character(simplify2array(conditions[1,1])))
    data_c_2 <- data%>%filter(!!condition_var == as.character(simplify2array(conditions[2,1])))
    
    # Calculation of the AUC per condition
    time_var <- enquo(time_var)
    for(i in 1:nrow(output)){
      temp_cond_1 <- data_c_1%>%select(output$elec_names[i], !!time_var)%>%as.data.frame()
      temp_cond_1 <- aggregate(temp_cond_1[,1], by=list(c(temp_cond_1[,2])), FUN=mean, na.rm=TRUE)
      

      temp_cond_2 <- data_c_2%>%select(output$elec_names[i], !!time_var)%>%as.data.frame()
      temp_cond_2 <- aggregate(temp_cond_2[,1], by=list(c(temp_cond_2[,2])), FUN=mean, na.rm=TRUE)
      
      output$AUC_cond_1[i] <- abs(AUC(temp_cond_1[,1], temp_cond_1[,2]))
      output$AUC_cond_2[i] <- abs(AUC(temp_cond_2[,1], temp_cond_2[,2]))
    }
    
    output <- output%>%mutate(AUC_difference = abs(AUC_cond_2 - AUC_cond_1))%>%
      arrange(desc(AUC_difference))
    
    names(output)[2:3] <- as.character(simplify2array(conditions))
   
    return(output) 
  }
}

