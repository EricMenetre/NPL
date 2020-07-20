#' A function to round entire dataframe
#'
#' This function enables tue user to round all values in a dataframe. The function isolates double variables and round them.
#'
#' @param df a dataframe under the data frame format or a Tibble
#' @param digits number of decimal wanted
#' @keywords round data frame
#' @export


round_df <- function(df, digits){
  for(i in 1:ncol(df)){
    if(typeof(df[,i]) == "double"){
      df[,i] <- round(df[,i], digits)
    } else {
      next
    }
  }
  return(df)
}
