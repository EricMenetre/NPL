#' A function to convert number into words for RMarkdown
#'
#' It is usually conventional that integers below 10 should be written in words instead of numbers. In RMarkdown, when writing results, the the output of the results, the user can put the numbers in the present function to convert it automatically into text. If the result to display is 2, then number_toword(2) will return "two".
#'
#'@param number Integer to convert into word
#'@param cap If TRUE, the first letter of the word will be a capital. Default is FALSE
#'@export

number_to_word <- function(number, cap = FALSE){
  if(cap == FALSE){
    if(number == 0){
      return("zero")
    } else if(number == 1){
      return("one")
    }else if(number == 2){
      return("two")
    } else if(number == 3){
      return("three")
    } else if(number == 4){
      return("four")
    } else if(number == 5){
      return("five")
    } else if(number == 6){
      return("six")
    } else if(number == 7){
      return("seven")
    } else if(number == 8){
      return("eight")
    } else if(number == 9){
      return("nine")
    } else if(number == 10){
      return("ten")
    } else if(number > 10 | number < 0){
      return(number)
    }
  } else if(cap == TRUE){
    if(number == 0){
      return("Zero")
    } else if(number == 1){
      return("One")
    }else if(number == 2){
      return("Two")
    } else if(number == 3){
      return("Three")
    } else if(number == 4){
      return("Four")
    } else if(number == 5){
      return("Five")
    } else if(number == 6){
      return("Six")
    } else if(number == 7){
      return("Seven")
    } else if(number == 8){
      return("Eight")
    } else if(number == 9){
      return("Nine")
    } else if(number == 10){
      return("Ten")
    } else if(number > 10 | number < 0){
      return(number)
    }
  }
}
