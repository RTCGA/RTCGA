## RTCGA package for R
#' @title Install Data Packages from RTCGA Family
#'
#' @description Function installs data packages from \href{https://github.com/RTCGA/}{https://github.com/RTCGA/}. Packages are listed in \link{datasetsTCGA}.
#' 
#' @param packages A character specifing the names of the data packages to be installed. By default installs all packages from \code{.20160128} release.
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
#' installTCGA() # it installs all!!! of them
#' installTCGA('RTCGA.clinical.20160128')
#' }
#' 
#' @family RTCGA
#' @rdname installTCGA
#' @export
installTCGA <- function(packages = c('RTCGA.clinical.20160128', 'RTCGA.mutations.20160128',
																		 'RTCGA.rnaseq.20160128', 'RTCGA.RPPA.20160128',
																		 'RTCGA.mRNA.20160128', 'RTCGA.CNV.20160128',
																		 'RTCGA.miRNASeq.20160128', 'RTCGA.PANCAN12.20160128',
																		 'RTCGA.methylation.20160128'),
												build_vignettes = TRUE, ...){
	assert_that(is.character(packages) & length(packages) > 0 & 
								all(packages %in% c('RTCGA.clinical', 'RTCGA.mutations', 'RTCGA.clinical.20160128', 'RTCGA.mutations.20160128',
																		'RTCGA.rnaseq', 'RTCGA.RPPA', 'RTCGA.rnaseq.20160128', 'RTCGA.RPPA.20160128',
																		'RTCGA.mRNA', 'RTCGA.CNV', 'RTCGA.mRNA.20160128', 'RTCGA.CNV.20160128',
																		'RTCGA.miRNASeq', 'RTCGA.PANCAN12', 'RTCGA.miRNASeq.20160128',
																		'RTCGA.methylation', 'RTCGA.methylation.20160128')) )
	assert_that(is.logical(build_vignettes))
	sapply(packages, function(package){
		devtools::install_github(file.path('RTCGA', package), 
														 build_vignettes = build_vignettes, ...)
	})
	
}