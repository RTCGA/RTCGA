## RTCGA package for R
#' @title Information About Cohorts from TCGA Project
#'
#' @description Function restores codes and counts for each cohort from TCGA project.
#'  
#' @return A list with a tabular information from \href{http://gdac.broadinstitute.org/}{http://gdac.broadinstitute.org/}.
#' 
#' @section Issues:
#' 
#' If you have any problems, issues or think that something is missing or is not
#' clear please post an issue on 
#' \href{https://github.com/RTCGA/RTCGA/issues}{https://github.com/RTCGA/RTCGA/issues}.
#' 
#' @author 
#' Marcin Kosinski, \email{m.p.kosinski@@gmail.com}
#' 
#' @seealso 
#' 
#' \pkg{RTCGA} website \href{http://rtcga.github.io/RTCGA/Download.html}{http://rtcga.github.io/RTCGA/Download.html}.
#' 
#' @examples 
#' 
#' infoTCGA()
#' library(magrittr)
#' (cohorts <- infoTCGA() %>% 
#' rownames() %>% 
#'    sub('-counts', '', x=.))
#'    
#' # in knitr chunk -> results='asis'   
#' knitr::kable(infoTCGA())
#' 
#' @family RTCGA
#' @rdname infoTCGA
#' @export
infoTCGA <- function() {
	do.call(rbind, readHTMLTable("http://gdac.broadinstitute.org/")[-39]) -> x
	names(x) <- gsub(names(x), pattern = "\n", replacement = "", fixed = TRUE)
	x
} 
