#' List all available labs (tutorials)
#'
#' This function lists all the labs available for Stat 406.
#'
#' @param package Default is "UBCstat406labs"
#' 
#' @details 
#' The intention is to make it easier to list all the labs we have. 
#' This is really just a wrapper for `learnr::available_tutorials("UBCstat406labs")`
#'
#' @return
#' @export
#'
#' @examples
#' show_labs()
show_labs <- function(package="UBCstat406labs"){
  learnr::available_tutorials(package)
}

#' Run a lab in your browser
#'
#' @param name the name of the lab to run. If omitted, lists all available labs.
#' 
#' @details 
#' The intention is to make it easier to run a lab.
#' This is really just a wrapper for `learnr::run_tutorial(name, "UBCstat406labs")`

#'
#' @return
#' @export
#'
#' @examples
#' run_lab() # Lists all our labs
#' \dontrun{
#' run_lab("rsquared") # runs the first lab
#' }
run_lab <- function(name = NULL){
  learnr::run_tutorial(name, "UBCstat406labs")
}

