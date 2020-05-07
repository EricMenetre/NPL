#' Function to estimate the standard error 
#' 
#' This function estimates the standard error of an array. The formula is the square root of the variance / the square root of the sample size.
#' @param x A numerical array
#' @param na.rm argument to set if NA are present in the array and exclude them
#' @export

std_error <- function(x, na.rm = FALSE){
  if(na.rm == TRUE){
    SE <- sqrt(var(x, na.rm = TRUE)/length(x))
  } else if(na.rm == FALSE){
    SE <- sqrt(var(x)/length(x))
  }
 return(SE)
}
