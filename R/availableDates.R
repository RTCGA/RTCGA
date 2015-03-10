##    RTCGA package for R
##
#' @title TCGA datasets releases dates
#'
#' @description Enables to check dates of TCGA datasets releases.
#' 
#' @return Vector of available dates to pass to the \link{downloadTCGA} function.
#' 
#' @examples
#' \dontrun{
#' availableDates()
#' }
#' 
#' @family RTCGA
#' @rdname availableDates
#' @export
availableDates <- function( ){
    get( x= ".availableDates", envir = .RTCGAEnv )
}