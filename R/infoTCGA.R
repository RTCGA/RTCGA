## RTCGA package for R
#' @title Information about cohorts from TCGA project
#'
#' @description Function restores codes and counts for each cohort from TCGA project.
#'  
#' @return A list with a tabular information from \href{http://gdac.broadinstitute.org/}{http://gdac.broadinstitute.org/}.
#' 
#' @author 
#' Marcin Kosinski, \email{m.p.kosinski@@gmail.com}
#' @examples 
#' 
#' infoTCGA()
#' library(magrittr)
#' (cohorts <- infoTCGA() %>% 
#' rownames() %>% 
#'    sub('-counts', '', x=.))
#' 
#' @family RTCGA
#' @rdname infoTCGA
#' @export
infoTCGA <- function() {
	do.call(rbind, readHTMLTable("http://gdac.broadinstitute.org/")[-39])
} 
