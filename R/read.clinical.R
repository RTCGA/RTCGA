## RTCGA package for R
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
read.clinical <- function(clinicalDir, ...) {
    
    assertthat::assert_that(is.character(clinicalDir) & length(clinicalDir) == 1)
    comboClinical <- read.delim(clinicalDir)
    
    colNames <- comboClinical[, 1]
    
    comboClinical <- as.data.frame(t(comboClinical[, -1]), ...)
    names(comboClinical) <- colNames
    
    comboClinical <- as.data.table(comboClinical)
    comboClinical <- comboClinical[, unique(names(comboClinical)), with = FALSE]
    comboClinical <- as.data.frame(comboClinical, ...)
    
    return(comboClinical)
}

# comboClinical <- read.delim('D:/BioBigStat/TCGA/clinicalCombo.txt') 
