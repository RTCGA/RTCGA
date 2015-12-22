## RTCGA package for R
#' @title Convert data from RTCGA family to Bioconductor classes
#'
#' @description Function uses \pkg{Biobase} (\href{http://bioconductor.org/packages/release/bioc/html/Biobase.html}{http://bioconductor.org/packages/release/bioc/html/Biobase.html}) package to transform
#' data from packages from RTCGA data family (\pkg{RTCGA.rnaseq}, \pkg{RTCGA.CNV}, \pkg{RTCGA.RPPA}, \pkg{RTCGA.PANCAN12},
#' \pkg{miRNASeq}, \pkg{mRNA}, \pkg{RTCGA.clinical}, \pkg{RTCGA.mutations}, \pkg{RTCGA.methylation}) to Bioconductor classes.
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
#' @param dataType
#' 
#' @section Biobase:
#'
#' This function use tools from the fantastic \pkg{Biobase}
#' package, so you'll need to make sure to have it installed.
#' 
#' @author 
#' Marcin Kosinski, \email{m.p.kosinski@@gmail.com}
#' 
#' @examples 
#' 
#' \dontrun{
#' library(RTCGA.rnaseq)
#' library(Biobase)
#' convertTCGA(BRCA.rnaseq, "rnaseq") -> BRCA.rnaseq_ExpressionSet
#' }
#' 
#' @family RTCGA
#' @rdname convertTCGA
#' @export
convertTCGA <- function(dataSet, dataType){
    assertthat::assert_that(is.data.frame(dataSet))
    assertthat::assert_that(is.character(dataType) & length(dataType) == 1)
    assertthat::assert_that(dataType %in% c("clinical", "rnaseq", "mutations", "RPPA", "mRNA",
                                            "miRNASeq", "methylation", "CNV", "PANCAN12"))
    if (!requireNamespace("Biobase", quietly = TRUE)) {
        stop("Biobase package required for convertTCGA function.")
    }
}