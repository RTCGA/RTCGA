## RTCGA package for R
#' @title RTCGA Theme For ggplot2
#'
#' @description Additional theme for \link[ggplot2]{ggtheme}.
#'  
#' @param base_size base font size
#' 
#' @param base_family base font family
#' @examples 
#' 
#'
#' library(RTCGA.clinical)
#' survivalTCGA(BRCA.clinical, OV.clinical) -> BRCAOV.survInfo
#' library(survminer)
#' library(survival)
#' ggsurvplot(survfit(Surv(times, patient.vital_status)~dataset,
#' 									 data = BRCAOV.survInfo),
#'					 risk.table = TRUE,
#' 					 ggtheme = theme_RTCGA(base_size = 16,
#' 					 											 base_family = "serif"),
#' 					 break.time.by = 800,
#' 					 palette = c("#FF9E29", "#86AA00"))
#' 					 
#' @author 
#' Marcin Kosinski, \email{m.p.kosinski@@gmail.com}
#' 
#' @family RTCGA
#' @rdname theme_RTCGA
#' @export
theme_RTCGA <- function(base_size = 11, base_family = ""){
	theme_grey(base_size = base_size, base_family = base_family) %+replace% 
		theme(axis.text = element_text(size = rel(0.8)),
					axis.ticks = element_line(colour = "black"), 
					legend.key = element_blank(), 
					panel.background = element_blank(),
					legend.background = element_blank(),
					panel.border = element_blank(),
					panel.grid.major = element_line(colour = "grey90", size = 0.2),
					panel.grid.minor = element_line(colour = "grey98", size = 0.5),
					strip.background = element_rect(fill = "grey80", colour = "grey50", size = 0.2))
}
