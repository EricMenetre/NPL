#' A function to create a banner with the date inside
#' 
#' This function requiering the bannerCommenter package creates a banner with the date of the day inside. It helps keeping track of the changes in the code
#' @keywords date banner
#' @export
#' @example 
#' date.banner()

date.banner <- function() {
  require("bannerCommenter")
  today <- format(Sys.Date(), format = "%A %d.%m.%Y")
  today <- as.character(today)
  open_box(today)
}