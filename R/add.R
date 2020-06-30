
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Add two numbers
#'
#' @param x,y numbers to add
#'
#' @useDynLib simplec add_
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
add_C <- function(x, y) {
  .C(add_, x, y, numeric(1))[[3]]
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Multiply two numbers
#'
#' @param x,y numbers to multiply
#'
#' @useDynLib simplec mul_
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
mul_C <- function(x, y) {
  .C(mul_, x, y, numeric(1))[[3]]
}
