##    RTCGA package for R
##
#' @title Information about cohorts from TCGA project
#'
#' @description TODO
#'  
#' @return A list with a tabular information from \href{http://gdac.broadinstitute.org/}{http://gdac.broadinstitute.org/}.
#' 
#' @family RTCGA
#' @rdname mergeTCGA
#' @export
infoTCGA <- function(){
readHTMLTable("http://gdac.broadinstitute.org/")[-38]
}