## RTCGA package for R
#' @title Plot Two Main Components of Principal Component Analysis
#'
#' @description Plots Two Main Components of Principal Component Analysis
#' 
#' @param x A \code{data.frame} containing i.e. expressions information. See \link{expressionTCGA}.
#' @param group.names Names of group variable to use in labels of the plot.
#' @param return.pca Should return pca object additionaly to pca plot?
#' @param ... Further arguments passed to \link{prcomp}.
#' @param center As in \link{prcomp}.
#' @param scale As in \link{prcomp}.
#' @param var.scale As in \link{ggbiplot}.
#' @param obs.scale As in \link{ggbiplot}.
#' @param ellipse As in \link{ggbiplot}.
#' @param circle As in \link{ggbiplot}.
#' @param var.axes As in \link{ggbiplot}.
#' @param alpha As in \link{ggbiplot}.
#' @param title The title of a plot.
#' 
#' @examples 
#' library(dplyr)
#' 
#' #' ## RNASeq expressions
#' library(RTCGA.rnaseq)
#' expressionTCGA(BRCA.rnaseq, OV.rnaseq, HNSC.rnaseq) %>%
#' 	rename(cohort = dataset) %>%	
#' 	filter(substr(bcr_patient_barcode, 14, 15) == "01") -> BRCA.OV.HNSC.rnaseq.cancer
#' 
#' pcaTCGA(BRCA.OV.HNSC.rnaseq.cancer, "cohort")
#' 
#' @author 
#' Marcin Kosinski, \email{m.p.kosinski@@gmail.com}
#' 
#' @family RTCGA
#' @rdname pcaTCGA
#' @export
pcaTCGA <- function(x, 
									  group.names,
										title = "",
										return.pca = FALSE,
										scale = TRUE,
										center = TRUE,
										var.scale = 1,
										obs.scale = 1,
										ellipse = TRUE,
										circle = TRUE,
										var.axes = FALSE,
										alpha = 0.2,
									  ...) {
	assert_that(is.data.frame(x))
	assert_that(group.names %in% names(x), length(group.names) == 1, length(group.names) == 1)

	# HERE FIX
	x[, c(which(names(x) == group.names))] %>% colSums() -> pca.col.sums
	which(pca.col.sums == 0) -> pca.col.sums.only0
	# pca
	x[, -c(which(names(x) == group.names),pca.col.sums.only0)] %>%
		prcomp( scale = scale, center = center, ... ) -> PCA
	
	rownames(PCA$rotation) <- 1:nrow(PCA$rotation) # no idea why this is neccessary anymore
	ggbiplot(PCA, obs.scale = obs.scale, var.scale = var.scale,
					 groups = group.names, ellipse = ellipse, circle = circle,
					 var.axes=var.axes, alpha = alpha) + theme_RTCGA() +
	scale_fill_pander() +
	scale_colour_pander() +
	ggtitle(title) -> pca.plot

	if (return.pca) {
		return(list(pca = PCA, pcaplot = pca.plot))
	} else {
		pca.plot
	}

	
}