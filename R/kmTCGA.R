## RTCGA package for R
#' @title Plot Kaplan-Meier Estimates of Survival Curves for Survival Data
#'
#' @description Plots Kaplan-Meier estimates of survival curves for survival data.
#' 
#' @param x A \code{data.frame} containing survival information. See \link{survivalTCGA}.
#' 
#' @param times The name of time variable.
#' @param status The name of status variable.
#' @param explanatory.names Names of explanatory variables to use in survival curves plot.
#' @param main Title of the plot.
#' @param risk.table Whether to show risk tables.
#' @param conf.int Whether to show confidence intervals.
#' @param pval Whether to add p-value of the log-rank test to the plot?
#' @param return.survfit Should return survfit object additionaly to survival plot?
#' @param ... Further arguments passed to \link[survminer]{ggsurvplot}.
#' 
#' @examples 
#' 
#' ## Extracting Survival Data
#' library(RTCGA.clinical)
#' survivalTCGA(BRCA.clinical, OV.clinical, extract.cols = "admin.disease_code") -> BRCAOV.survInfo
#' 
#' # first munge data, then extract survival info
#' library(dplyr)
#' BRCA.clinical %>%
#'     filter(patient.drugs.drug.therapy_types.therapy_type %in%
#'                c("chemotherapy", "hormone therapy")) %>%
#'     rename(therapy = patient.drugs.drug.therapy_types.therapy_type) %>%
#'     survivalTCGA(extract.cols = c("therapy"))  -> BRCA.survInfo.chemo
#'                  
#' # first extract survival info, then munge data                  
#'     survivalTCGA(BRCA.clinical, 
#'                  extract.cols = c("patient.drugs.drug.therapy_types.therapy_type"))  %>%
#'     filter(patient.drugs.drug.therapy_types.therapy_type %in%
#'                c("chemotherapy", "hormone therapy")) %>%
#'     rename(therapy = patient.drugs.drug.therapy_types.therapy_type) -> BRCA.survInfo.chemo
#' 
#' ## Kaplan-Meier Survival Curves
#' kmTCGA(BRCAOV.survInfo, explanatory.names = "admin.disease_code",  pval = TRUE)
#' 
#' kmTCGA(BRCAOV.survInfo, explanatory.names = "admin.disease_code", main = "",
#'        xlim = c(0,4000), legend = "right")
#'  
#' kmTCGA(BRCA.survInfo.chemo, explanatory.names = "therapy", xlim = c(0, 3000), conf.int = FALSE)
#' 
#' @author 
#' Marcin Kosinski, \email{m.p.kosinski@@gmail.com}
#' 
#' @family RTCGA
#' @rdname kmTCGA
#' @export
kmTCGA <- function(x, 
									times = "times",
									status = "patient.vital_status",
									explanatory.names = "1",
									main = "Survival Curves",
									risk.table = TRUE,
									conf.int = TRUE,
									return.survfit = FALSE, 
									pval = FALSE,
									...) {
	assert_that(is.data.frame(x))
	assert_that(all(c(times, status, ifelse(explanatory.names == "1", times, explanatory.names)) %in% names(x)))
	assert_that(length(times) == 1, length(status) == 1)
	
	# fit survival estimates
	formu <- eval(as.formula(paste0("survival::Surv(", times, ",", status, ") ~ ",
																	paste0(explanatory.names, collapse = " + "))))
	fit <- survival::survfit(formu, data = x)
				 
	# create survival plot
	ggsurvplot(fit,
						 risk.table = risk.table, 
						 conf.int = conf.int, 
						 pval = pval,
						 main = main,
						 ...) -> survplot
	# customize with RTCGA theme
  survplot$table <- survplot$table + theme_RTCGA()
  survplot$plot <- survplot$plot + theme_RTCGA() 
	# return							
	if (return.survfit) {
		return(list(survplot = survplot, survfit = fit))
	} else{
		survplot
	}
	
}