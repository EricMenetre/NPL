#' A function to transfer tanova results from Ragu to Cartool
#'
#' This function takes the .txt files from the RAGU software and transforms it into a .ep files. The p-values are dichotomized. p-val < 0.05 are took down to 0 wilhe the p-val > 0.05 are set to 1.
#' @param file .txt file containing the tanova results from RAGU
#' @param sig_cut_off Significance threshold according to which dichotomize the data. Default is 0.05
#' @keywords tanova RAGU cartool
#' @export


tanova.ragu.to.cartool <- function(file, sig_cut_off = 0.05){
  library(readr)
  tanova <- read_delim(file,"\t", escape_double = FALSE, trim_ws = TRUE)
  for (i in 2:ncol(tanova)){
    for(j in 1:nrow(tanova)){
      if (tanova[j,i] < sig_cut_off){
        tanova[j,i] <- 1
      } else {
        tanova[j,i] <- 0
      }
    }
    name <- paste("tanova_results_", i-1,".ep", sep = "")
    write.table(tanova[,i], name, col.names = FALSE, row.names = FALSE)
  }
}
