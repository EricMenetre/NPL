#' A function to create automatically output to report stats results in publications
#' 
#' This function returns a data frame, in which, for each effect, a text output containing the results to export in the publications are produced.
#'
#' @param model_data For "mainef_anova", "chisq", "mainef_Anova" and "summary" methods, put the statistical model. For the "emmeans" method, create an object as: your_model$pairwise..., and in a second step, convert this model in data frame using the as.data.frame() function and use this transformed model as argument.
#' @param method Statistical method employed: either "mainef_anova", in this case an anova(model_data) will be performed, "chisq", then the results of the model will be used, "mainef_Anova" the Anova(model_data) from the car package will be performed. The "summary" method uses the summary(model_data).
#' @export
#' 

report_results <- function(model_data, method){
  if(method == "mainef_anova"){
    anova_table <- anova(model_data)
    
    effects <- paste("F(", anova_table$Df,") = ", round(anova_table$`F value`,2), " p = ", sep = "")
    names_eff <- rownames(anova_table)
    output <- data.frame(names_eff, effects)
    output$p <- round(anova_table$`Pr(>F)`,3)
    output$p <- ifelse(output$p == 0.000, "<0.001", output$p)
    output <-output[1:(nrow(output)-1),]
    output$effects <- paste(output$effects, output$p, sep = "")
    output$p <- NULL
    return(output)
    
  }else if(method == "chisq"){
    if(model_data$p.value < 0.001){
      return(paste("X2 = ",round(model_data$statistic,2), "; p<0.001", sep = ""))
    } else {
      return(paste( "X2 = ",round(model_data$statistic,2), "; p = ", round(model_data$p.value,3), sep = ""))
    }
  }else if(method == "emmeans"){
    post_hoc <- model_data
    contrasts_index <- grep("estimate", colnames(post_hoc))-1
    output <- data.frame(post_hoc[,1:contrasts_index])
    if(sum(grepl("t.ratio", colnames(post_hoc))) == 1){
      output$report <- paste("t(", post_hoc$df,") = ", round(post_hoc$t.ratio,2), "; p ", sep = "")
      output$p <- post_hoc$p.value
      output$p <- ifelse(post_hoc$p.value < 0.001, "<0.001", paste("= ",round(post_hoc$p.value,3)))
      output$report <- paste(output$report, output$p)
      output$p <- NULL
      return(output)
    } else if(sum(grepl("z.ratio", colnames(post_hoc))) == 1){
      output$report <- paste("z = ", round(post_hoc$z.ratio,2), "; p", sep = "")
      output$p <- post_hoc$p.value
      output$p <- ifelse(post_hoc$p.value < 0.001, "<0.001", paste("= ", round(post_hoc$p.value,3), sep = ""))
      output$report <- paste(output$report, output$p)
      output$p <- NULL
      return(output)
    } else{
      print("Unknown format, only results from z and t distributions are available")
    }
  }else if(method == "mainef_Anova"){
    require(car)
    Anova_model <- as.data.frame(Anova(model_data))
    effects <- rownames(Anova_model)
    output <- data.frame(effects)
    output$report <- paste("X2 = ", round(Anova_model$`LR Chisq`,2), "; p", sep = "")
    output$p <- ifelse(round(Anova_model$`Pr(>Chisq)`,3) < 0.001, "<0.001", paste("= ", round(Anova_model$`Pr(>Chisq)`,3), sep = ""))
    output$report <- paste(output$report, output$p)
    output$p <- NULL
    return(output)
   
  } else if(method == "summary"){
    summary_model <- summary(model_data)
    coefs <- as.data.frame(summary_model$coefficients)
    effects <- rownames(coefs)
    output <- data.frame(effects)
    output$report <- paste("t = ", round(coefs$`t value`,2), "; p ", sep = "")
    output$p <- ifelse(round(coefs$`Pr(>|t|)`,3) < 0.001, "<0.001", paste("= ", round(coefs$`Pr(>|t|)`,3), sep = ""))
    output$report <- paste(output$report, output$p, sep = "")
    output$p <- NULL
    return(output)
  }
}
