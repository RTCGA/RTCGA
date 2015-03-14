##    RTCGA package for R
##
#' @title TCGA datasets' releases dates
#'
#' @description Enables to check dates of TCGA datasets releases.
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
    
    if( !exists( x= ".availableDates", envir = .RTCGAEnv ) ){
         # happens only once
        assign( x = ".gdacContent", value = readLines( "http://gdac.broadinstitute.org/runs/" ), 
                envir = .RTCGAEnv )
        assign( x= ".availableDates", value = stri_extract( grep( pattern= "stddata__20", 
                                                                  x = get( ".gdacContent", envir = .RTCGAEnv), 
                                                                  value = TRUE), 
                                                            regex = "stddata__201[0-9]_[0-9]{2}_[0-9]{2}"),
                envir = .RTCGAEnv )
        
        
        assign( x = ".availableDates2", value = get( x= ".availableDates", envir = .RTCGAEnv ) %>%
                                                strsplit( split = "__", fixed = TRUE ) %>%
                                                lapply( function( element ){
                                                        element[2]
                                                    }) %>% unlist() %>%
                                                gsub( pattern = "_", replacement = "-" ),
                envir = .RTCGAEnv )
        ############################################
        
        get( x = ".availableDates2", envir = .RTCGAEnv )
    }else{ 
        get( x = ".availableDates2", envir = .RTCGAEnv )
        }
}
    
    
