## RTCGA package for R
#' @title Plot Two Main Components of Principal Component Analysis
#'
#' @description Plots Two Main Components of Principal Component Analysis
#' 
#' @param x A \code{data.frame} containing i.e. expressions information. See \link{expressionsTCGA}.
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
#' @param add.lines Should axis lines be added to plot.
#' 
#' @return If \code{return.pca = TRUE} then a list containing a PCA plot (of class \code{ggplot}) and a \code{pca} model, the result of \link{prcomp} function.
#' If not, then only PCA plot is returned.
#' @author 
#' Marcin Kosinski, \email{m.p.kosinski@@gmail.com}
#'
#' @examples 
#' 
#' \dontrun{
#' library(dplyr)
#' ## RNASeq expressions
#' library(RTCGA.rnaseq)
#' expressionsTCGA(BRCA.rnaseq, OV.rnaseq, HNSC.rnaseq) %>%
#' 	rename(cohort = dataset) %>%	
#' 	filter(substr(bcr_patient_barcode, 14, 15) == "01") -> BRCA.OV.HNSC.rnaseq.cancer
#' 
#' pcaTCGA(BRCA.OV.HNSC.rnaseq.cancer, "cohort")
#' pcaTCGA(BRCA.OV.HNSC.rnaseq.cancer, "cohort", add.lines = FALSE)
#' pcaTCGA(BRCA.OV.HNSC.rnaseq.cancer, "cohort", return.pca = TRUE) -> pca.rnaseq
#' pca.rnaseq$plot
#' pca.rnaseq$pca
#' }
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
										alpha = 0.8,
										add.lines = TRUE,
									  ...) {
	assert_that(is.data.frame(x))
	assert_that(group.names %in% names(x), length(group.names) == 1, length(group.names) == 1)


	x[sapply(x,is.numeric)] -> x.numeric
	x.numeric %>% colSums() -> pca.col.sums
	which(pca.col.sums == 0) -> pca.col.sums.only0
	x.numeric[, -pca.col.sums.only0] -> x.numeric.nonconstant
	# pca
	x.numeric.nonconstant %>%
		prcomp( scale = scale, center = center, ... ) -> PCA
	
	#rownames(PCA$rotation) <- 1:nrow(PCA$rotation) # no idea why this is neccessary anymore
	ggbiplot(PCA, obs.scale = obs.scale, var.scale = var.scale,
					 groups = x[,group.names] %>% unlist, ellipse = ellipse, circle = circle,
					 var.axes=var.axes, alpha = alpha) + 
		theme_RTCGA() +
		ggtitle(title) -> pca.plot
	
	if (add.lines){
		pca.plot <- pca.plot +
			geom_abline(slope =  0, intercept = 0, linetype = 2, alpha = 0.5) +
			geom_vline(xintercept = 0, linetype = 2, alpha = 0.5)
	}

	if (return.pca) {
		return(list(pca = PCA, pcaplot = pca.plot))
	} else {
		pca.plot
	}

	
}