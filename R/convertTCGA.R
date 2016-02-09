## RTCGA package for R
#' @title Convert data from RTCGA family to Bioconductor classes
#'
#' @description Functions use \pkg{Biobase} (\href{http://bioconductor.org/packages/release/bioc/html/Biobase.html}{http://bioconductor.org/packages/release/bioc/html/Biobase.html}) package to transform
#' data from packages from RTCGA data family to Bioconductor classes (\pkg{RTCGA.rnaseq}, \pkg{RTCGA.RPPA}, \pkg{RTCGA.PANCAN12},
#' \pkg{mRNA}, \pkg{RTCGA.methylation} to \link[Biobase]{ExpressionSet} and \pkg{RTCGA.CNV} to \link[GenomicRanges]{GRanges}). For \pkg{RTCGA.PANCAN12} there is sense to convert
#' \code{expression.cb1, expression.cb2, cnv.cb}.
#' 
#' @details
#' 
#' This functionality is motivated by that we were asked to offer the data in Bioconductor-friendly classes because many users already
#' have their data in one of the core infrastructure classes. Data of the same type in compatible
#' containers promotes interoperability and makes it easy to combine and organize.
#' 
#' Bioconductor classes were designed to capitalize on the biological structure of the data. If
#' data have a range-based component it's natural, for Bioconductor users, to store and access
#' these as a GRanges where they can extract position, strand etc. in the same way. Similarly for
#' ExpressionSet. This class holds expression data along with experiment metadata and comes with
#' built in accessors to extract and manipulate data. The idea is to offer a common API to the
#' data; extracting the start position in a GRanges is always start(). With a data.frame it is
#' different each time (unless select() is implemented) as the column names and organization of
#' data can be different.
#' 
#' AnnotationHub and the soon to come ExperimentHub will host many different types of data. A
#' primary goal moving forward is to offer similar data in a consistent format. For example, CNV
#' data in AnnotationHub is offered as a GRanges and as more CNV are added we will ask that they
#' too are packaged as GRanges. The aim is that streamlined data on the back-end will make for a
#' more intuitive experience on the front-end.
#' 
#' @param dataSet A data.frame to be converted to \link[Biobase]{ExpressionSet} or \link[GenomicRanges]{GRanges}.
#' @param dataType One of \code{expression} or \code{CNV} (for \pkg{RTCGA.CNV} datasets).
#' 
#' @return Functions return an \link[Biobase]{ExpressionSet} or a \link[GenomicRanges]{GRanges} for \pkg{RTCGA.CNV}
#' 
#' @section Biobase and GenomicRanges:
#'
#' This function use tools from the fantastic \pkg{Biobase} (and \pkg{GenomicRanges} for CNV)
#' package, so you'll need to make sure to have it installed.
#' 
#' @author 
#' Marcin Kosinski, \email{m.p.kosinski@@gmail.com}
#' 
#' @examples 
#' 
#'
#' ########
#' ########
#' # Expression data
#' ########
#' ########
#' library(RTCGA.rnaseq)
#' library(Biobase)
#' convertTCGA(BRCA.rnaseq) -> BRCA.rnaseq_ExpressionSet
#' \dontrun{
#' library(RTCGA.PANCAN12)
#' convertPANCAN12(expression.cb1) -> PANCAN12_ExpressionSet
#' library(RTCGA.RPPA)
#' convertTCGA(BRCA.RPPA) -> BRCA.RPPA_ExpressionSet
#' library(RTCGA.methylation)
#' convertTCGA(BRCA.methylation) -> BRCA.methylation_ExpressionSet
#' library(RTCGA.mRNA)
#' convertTCGA(BRCA.mRNA) -> BRCA.mRNA_ExpressionSet 
#' ########
#' ########
#' # CNV
#' ########
#' ########
#' library(RTCGA.CNV)
#' library(GRanges)
#' convertTCGA(BRCA.CNV, "CNV") -> BRCA.CNV_GRanges
#' 
#' }
#' 
#' @family RTCGA
#' @rdname convertTCGA
#' @export
convertTCGA <- function(dataSet, dataType = "expression"){
	assertthat::assert_that(is.data.frame(dataSet))
	assertthat::assert_that(is.character(dataType) & length(dataType) == 1)
	assertthat::assert_that(dataType %in% c("expression", "CNV"))
	
	if (dataType == "CNV") {
		# GRanges
		if (!requireNamespace("GenomicRanges", quietly = TRUE)) {
			stop("GenomicRanges package required for convertTCGA function for CNV data.")
		}
		GenomicRanges::GRanges(seqnames = 
													 	S4Vectors::Rle(paste0("chr",dataSet[,2]), # chromosome
													 								 rep(1,nrow(dataSet)) # counts
													 	),
													 ranges = IRanges::IRanges(start = dataSet$Start,
													 													end = dataSet$End),
													 #strand = rep("*", nrow(dataType)), - no information in those data
													 Num_Probes = dataSet$Num_Probes,
													 Sample = dataSet$Sample,
													 Segment_Mean = dataSet$Segment_Mean
		) 
	} else {
		# ExpressionSet
		if (!requireNamespace("Biobase", quietly = TRUE)) {
			stop("Biobase package required for convertTCGA function for expression data.")
		}
		t(as.matrix(dataSet[,-1])) -> rnaseqMatrix
		colnames(rnaseqMatrix) <- as.character(dataSet[,1])
		Biobase::ExpressionSet(assayData = rnaseqMatrix)
	}
	
	
}

#' @rdname convertTCGA
#' @export
convertPANCAN12 <- function(dataSet){
	assertthat::assert_that(is.data.frame(dataSet))
	# ExpressionSet
	if (!requireNamespace("Biobase", quietly = TRUE)) {
		stop("Biobase package required for convertTCGA function for expression data.")
	}                        
	as.matrix(dataSet[,-1]) -> exprMatrix
	colnames(exprMatrix) <- as.character(dataSet[,1])
	Biobase::ExpressionSet(assayData = exprMatrix)
	
}