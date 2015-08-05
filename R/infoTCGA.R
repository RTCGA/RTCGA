## RTCGA package for R
#' @title Information about cohorts from TCGA project
#'
#' @description Function restores codes and counts for each cohort from TCGA project.
#'  
#' @return A list with a tabular information from \href{http://gdac.broadinstitute.org/}{http://gdac.broadinstitute.org/}.
#' 
#' @examples 
#' 
#' infoTCGA()
#' 
#' @family RTCGA
#' @rdname infoTCGA
#' @export
infoTCGA <- function() {
    readHTMLTable("http://gdac.broadinstitute.org/")[-39]
} 
