## RTCGA package for R
#' @title RTCGA.data - The Family of R Packages with Data from The Cancer Genome Atlas Study
#'
#' @description
#' Snapshots of the clinical, mutations, cnvs and rnaseq datasets from the \code{2015-06-01}
#' release date are included in the \code{RTCGA.data} family that contains 4 packages:
#' \itemize{
#'  \item \pkg{RTCGA.rnaseq}
#'  \item \pkg{RTCGA.clinical}
#'  \item \pkg{RTCGA.mutations}
#'  \item \pkg{RTCGA.cnv}
#'  }
#'
#' @details
#' For more detailed information visit \pkg{RTCGA.data}  
#' \href{https://mi2-warsaw.github.io/RTCGA.data}{website}.
#'
#' @author
#' Marcin Kosinski [aut, cre] \email{ m.p.kosinski@@gmail.com } \cr
#' Przemyslaw Biecek [aut] \email{ przemyslaw.biecek@@gmail.com }
#' 
#' 
#' @examples 
#' 
#' 
#' # installation of packages containing snapshots
#' # of TCGA project's datasets
#'
#' \dontrun{
#' source('http://bioconductor.org/biocLite.R')
#' biocLite(RTCGA.clinical)
#' biocLite(RTCGA.mutations)
#' biocLite(RTCGA.rnaseq)
#' biocLite(RTCGA.cnv)
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
