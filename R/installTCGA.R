## RTCGA package for R
#' @title Install packages from RTCGA family
#'
#' @description Function installs data packages from \href{https://github.com/RTCGA/}{https://github.com/RTCGA/}. Packages are listed \link{datasetsTCGA}.
#' 
#' @param packages A character specifing the names of the data packages to be installed. By default installs all packages.
#' @param build_vignettes Should vignettes be build.
#' @param ... Further arguments passed to \link[devtools]{install_github}.
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
#' \pkg{RTCGA} website \href{http://rtcga.github.io/RTCGA}{http://rtcga.github.io/RTCGA}.
#' 
#' @examples 
#' 
#' \dontrun{
#' installTCGA()
#' installTCGA('RTCGA.clinical')
#' }
#' 
#' @family RTCGA
#' @rdname installTCGA
#' @export
installTCGA <- function(packages = c('RTCGA.clinical', 'RTCGA.mutations',
                                     'RTCGA.rnaseq', 'RTCGA.RPPA',
                                     'RTCGA.mRNA', 'RTCGA.CNV',
                                     'RTCGA.miRNASeq', 'RTCGA.PANCAN12',
                                     'RTCGA.methylation'),
                        build_vignettes = TRUE, ...){
  assert_that(is.character(packages) & length(packages) > 0 & 
                all(packages %in% c('RTCGA.clinical', 'RTCGA.mutations',
                                    'RTCGA.rnaseq', 'RTCGA.RPPA',
                                    'RTCGA.mRNA', 'RTCGA.CNV',
                                    'RTCGA.miRNASeq', 'RTCGA.PANCAN12',
                                    'RTCGA.methylation')) )
  assert_that(is.logical(build_vignettes))
  sapply(packages, function(package){
    devtools::install_github(file.path('RTCGA', package), 
                             build_vignettes = build_vignettes, ...)
  })
  
}