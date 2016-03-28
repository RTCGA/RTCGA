## RTCGA package for R
#' @title RTCGA.data - The Family of R Packages with Data from The Cancer Genome Atlas Study
#'
#' @description
#' Snapshots of the clinical, mutations, CNVs, rnaseq, RPPA, mRNA, miRNASeq and methylation datasets from the \code{2015-11-01}
#' release date (check all dates of release with \code{checkTCGA('Dates')}) are included in the \code{RTCGA.data} family (factory) that contains 9 packages:
#' \itemize{
#'  \item \pkg{RTCGA.rnaseq} \link[RTCGA.rnaseq]{rnaseq}
#'  \item \pkg{RTCGA.clinical} \link[RTCGA.clinical]{clinical}
#'  \item \pkg{RTCGA.mutations} \link[RTCGA.mutations]{mutations}
#'  \item \pkg{RTCGA.CNV} \link[RTCGA.CNV]{CNV}
#'  \item \pkg{RTCGA.RPPA} \link[RTCGA.RPPA]{RPPA}
#'  \item \pkg{RTCGA.mRNA} \link[RTCGA.mRNA]{mRNA}
#'  \item \pkg{RTCGA.miRNASeq} \link[RTCGA.miRNASeq]{miRNASeq}
#'  \item \pkg{RTCGA.methylation} \link[RTCGA.methylation]{methylation}
#'  \item \pkg{RTCGA.PANCAN12} (not from TCGA) 
#'  }
#'
#' @details
#' For more detailed information visit \pkg{RTCGA.data}  website
#' \href{https://rtcga.github.io/RTCGA}{https://rtcga.github.io/RTCGA}. One can install all data packages with \link{installTCGA}.
#'
#'
#' @section Issues:
#' 
#' If you have any problems, issues or think that something is missing or is not
#' clear please post an issue on 
#' \href{https://github.com/RTCGA/RTCGA/issues}{https://github.com/RTCGA/RTCGA/issues}.
#'
#' @author
#' Marcin Kosinski [aut, cre] \email{ m.p.kosinski@@gmail.com } \cr
#' Przemyslaw Biecek [aut] \email{ przemyslaw.biecek@@gmail.com } \cr
#' Witold Chodor [aut] \email{ witoldchodor@@gmail.com }
#' 
#' 
#' @seealso 
#' 
#' \pkg{RTCGA} website \href{http://rtcga.github.io/RTCGA}{http://rtcga.github.io/RTCGA}.
#' 
#' @examples 
#' 
#' 
#' # installation of packages containing snapshots
#' # of TCGA project's datasets
#'
#' \dontrun{
#' 
#' ## RTCGA GitHub development newest versions
#' library(RTCGA)
#' ?installTCGA
#' 
#' ## Bioconductor releases
#' source('http://bioconductor.org/biocLite.R')
#' biocLite(RTCGA.clinical)
#' biocLite(RTCGA.mutations)
#' biocLite(RTCGA.rnaseq)
#' biocLite(RTCGA.CNV)
#' biocLite(RTCGA.RPPA)
#' biocLite(RTCGA.mRNA)
#' biocLite(RTCGA.miRNASeq)
#' biocLite(RTCGA.methylation)
#' 
#' # use cases and examples + more data info
#' browseVignettes('RTCGA')
#' }
#' 
#' @family RTCGA
#' @name datasetsTCGA
#' @aliases datasetsTCGA
#' @aliases RTCGA.data
invisible(NULL) 
