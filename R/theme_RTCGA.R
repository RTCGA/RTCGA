## RTCGA package for R
#' @title RTCGA Theme For ggplot2
#'
#' @description Additional \pkg{RTCGA} theme for \link[ggplot2]{ggtheme}, based on \link[ggthemes]{theme_pander}.
#'  
#' @param base_size base font size
#' 
#' @param base_family base font family
#' 
#' @param ... Further arguments passed to \link[ggthemes]{theme_pander}.
#' @examples 
#' 
#' library(RTCGA.clinical)
#' survivalTCGA(BRCA.clinical, OV.clinical, extract.cols = "admin.disease_code") -> BRCAOV.survInfo
#' kmTCGA(BRCAOV.survInfo, explanatory.names = "admin.disease_code",
#'        xlim = c(0,4000))
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
#' \pkg{RTCGA} website \href{http://rtcga.github.io/RTCGA/Visualizations.html}{http://rtcga.github.io/RTCGA/Visualizations.html}.
#' 
#' @family RTCGA
#' @rdname theme_RTCGA
#' @export
theme_RTCGA <- function(base_size = 11, base_family = "", ...){
  
  list(theme_pander(gm = TRUE, gM = TRUE, ...) %+replace%
         theme(panel.grid = element_line(), 
               panel.grid.major = element_line(colour = "grey90", size = 0.2),
               panel.grid.minor = element_line(colour = "grey98", size = 0.5),
               legend.position = "top"), 
       scale_colour_tableau(),
       scale_fill_tableau())
  
  
}
