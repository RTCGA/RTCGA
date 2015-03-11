##    RTCGA package for R
##
#' @title TCGA datasets' releases names
#'
#' @description Enables to check dates of TCGA datasets releases.
#' 
#' @param cancerType A character of length 1 containing abbreviation (Cohort code) of types of cancers to check for 
#' available datasets' names on \href{http://gdac.broadinstitute.org/}{http://gdac.broadinstitute.org/}.
#' @param date A \code{NULL} or character specifying from which date datasets' names should be checked.
#' By default (\code{date = NULL}) the newest available date is used. All available dates can be checked on 
#' \href{http://gdac.broadinstitute.org/runs/}{http://gdac.broadinstitute.org/runs/} or by using \link{availableDates} 
#' function. Required format \code{"stddata__YYYY_MM_DD"}.
#' 
#' @return A vector of available datasets names to pass to the \link{downloadTCGA} function.
#' 
#' @examples
#' \dontrun{
#' availableDataSets( "BRCA" )
#' availableDataSets( "OV", availableDates()[5] ) # error
#' }
#' 
#' @family RTCGA
#' @rdname availableDataSets
#' @export
availableDataSets <- function( cancerType, date = NULL ){
    
    assert_that( is.character( cancerType ) & ( length( cancerType ) == 1 )  )
    assert_that( is.null( date )  || is.character( date ) )
    
    # ensure which date was specified
    lastReleaseDate  <- whichDateToUse( date = date ) #downloadTCGA.r
    
    # get index of page containing datasets fot this date of release and Cohort Code
    filesParentURL <- parentURL( lastReleaseDate, element = cancerType ) #downloadTCGA.r
    
    # get content of index page
    elementIndex <- tryCatch( readLines( filesParentURL ) , error = function(e) stop( paste( "Probably dataset from this date needs authentication. \n \tCouldn't check available datasets' names.",
                                                                                             "\n \tTry manually on", filesParentURL ))) 
    dataSetsName <- sapply( elementIndex, function(element){
        gsub(".*gdac.broadinstitute.org(.*)\".*", "\\1", element)
    } )
    
    # cat available dataSets' names
    gsub( paste0("_", cancerType), cancerType, 
          unique( grep( x = dataSetsName, pattern = paste0("_",cancerType), value = TRUE ) ) )
    
}