##    RTCGA package for R
##
#' @title TCGA datasets' releases dates
#'
#' @description Enables to check dates of TCGA datasets' releases.
#' 
#' @return A vector of available dates to pass to the \link{downloadTCGA} function.
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
    
    if( !exists( x= ".availableDates2", envir = .RTCGAEnv ) ){
         # happens only once
         readLines( "http://gdac.broadinstitute.org/runs/" ) %>%
                 assign( x = ".gdacContent", value = ., envir = .RTCGAEnv )

         get( ".gdacContent", envir = .RTCGAEnv) %>%
             grep(pattern= "stddata__20",  value = TRUE) %>%
             gsub(pattern="(<[^>]+>)| |/", replacement="") %>%
             assign( x= ".availableDates", value=., envir = .RTCGAEnv)  

         get( ".availableDates", envir = .RTCGAEnv) %>%
                 gsub(pattern="^[^0-9]+", replacement="") %>%
                 gsub(pattern="_", replacement="-", fixed = TRUE) %>%
                 assign( x = ".availableDates2", value = ., envir = .RTCGAEnv )
        ############################################
    }
  get( x = ".availableDates2", envir = .RTCGAEnv )
}
    
    
