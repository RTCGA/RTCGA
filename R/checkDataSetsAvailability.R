## RTCGA package for R
#' @title TCGA datasets' names availability
#'
#' @description Enables to check TCGA datasets' names availability for current release date and cancer type.
#' 
#' @param cancerTypes A character vector containing abbreviation (Cohort code) of types of cancers to check for 
#' availability of datasets' name on \href{http://gdac.broadinstitute.org/}{http://gdac.broadinstitute.org/}.
#' @param date A \code{NULL} or character specifying from which date datasets' names should be checked for availability.
#' By default (\code{date = NULL}) the newest available date is used. All available dates can be checked on 
#' \href{http://gdac.broadinstitute.org/runs/}{http://gdac.broadinstitute.org/runs/} or by using \link{availableDates} 
#' function. Required format \code{'YYYY-MM-DD'}.
#' @param pattern A character vector of length 1 containing a part of a dataset's name to be checked
#' for availability for current \code{date} parameter. By default phrase \code{'Merge_Clinical.Level_1'}
#' is checked.
#' 
#' @return A vector of available datasets names to pass to the \link{downloadTCGA} function.
#' 
#' @examples
#' \dontrun{
#' checkDataSetsAvailability( 'BRCA' )
#' checkDataSetsAvailability( c('BRCA', 'OV') )
#' checkDataSetsAvailability( 'BRCA', 'Mutation_Packager_Calls.Level' )
#' }
#' 
#' @family RTCGA
#' @rdname checkDataSetsAvailability
#' @export
checkDataSetsAvailability <- function(cancerTypes, pattern = "Merge_Clinical.Level_1", 
    date = NULL) {
    
    assert_that(is.character(cancerTypes) & (length(cancerTypes) > 0))
    
    cancerTypes %>% sapply(function(element) grep(x = availableDataSets(element, date), 
        pattern = pattern, value = TRUE)) %>% as.vector()
    
} 
