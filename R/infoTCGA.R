## RTCGA package for R
#' @title Information About Cohorts from TCGA Project
#'
#' @description Function restores codes and counts for each cohort from TCGA project.
#'  
#' @return A list with a tabular information from \href{https://gdac.broadinstitute.org/}{https://gdac.broadinstitute.org/}.
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
#' \pkg{RTCGA} website \href{https://rtcga.github.io/RTCGA/articles/Data_Download.html}{https://rtcga.github.io/RTCGA/articles/Data_Download.html}.
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
  
  theurl <- getURL("https://gdac.broadinstitute.org/", 
                   .opts = list(ssl.verifypeer = FALSE))
  
	do.call(rbind, readHTMLTable(theurl)[-39]) -> x
	names(x) <- gsub(names(x), pattern = "\n", replacement = "", fixed = TRUE)
	x
} 
