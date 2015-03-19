##    RTCGA package for R
##
#' @title Read from txt fo;e
#'
#' @description TODO
#' 
#' @param clinicalDir A directory to a \code{cancerType.clin.merged.txt} file. 
#' \code{cancerType} might be \code{BRCA, OV} etc.
#' 
#' 
#' @return A data.frame with clinical data.
#' 
#' @family RTCGA
#' @rdname read.clinical
#' @export
read.clinical <- function( clinicalDir, ...){
    
    assertthat::assert_that( is.character(clinicalDir) & length(clinicalDir) ==1 )
    comboClinical <- read.delim( clinicalDir )
    
    colNames <- comboClinical[,1]
    
    comboClinical <- as.data.frame(t(comboClinical[, -1]), ...)
    names(comboClinical) <- colNames
    
    return(comboClinical)
}