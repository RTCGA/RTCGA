## RTCGA package for R
#' @title Download TCGA Data
#'
#' @description Enables to download TCGA data from specified dates of releases of concrete Cohorts of cancer types.
#' Pass a name of required dataset to the \code{dataSet} parameter. By default the Merged Clinical
#' dataSet is downloaded (value \code{dataSet = 'Merge_Clinical.Level_1'}) from the newest available date of the release.
#' 
#' @param cancerTypes A character vector containing abbreviations (Cohort code) of types of cancers to download from 
#' \href{https://gdac.broadinstitute.org/}{https://gdac.broadinstitute.org/}. For easy access from R check details below.
#' 
#' @param dataSet A part of the name of dataSet to be downloaded from \href{https://gdac.broadinstitute.org/runs/}{https://gdac.broadinstitute.org/runs/}. By default the Merged Clinical dataSet is downloaded (value \code{dataSet = 'Merge_Clinical.Level_1'}). Available datasets' names can be checked using \link{checkTCGA} function.
#' 
#' @param destDir A character specifying a directory into which \code{dataSet}s will be downloaded.
#' 
#' @param date A \code{NULL} or character specifying from which date \code{dataSet}s should be downloaded.
#' By default (\code{date = NULL}) the newest available date is used. All available dates can be checked on 
#' \href{https://gdac.broadinstitute.org/runs/}{https://gdac.broadinstitute.org/runs/} or by using \link{checkTCGA} 
#' function. Required format \code{'YYYY-MM-DD'}.
#' 
#' @param untarFile Logical - should the downloaded file be untarred. Default is \code{TRUE}.
#' @param removeTar Logical - should the downloaded \code{.tar} file be removed after untarring.
#' Default is \code{TRUE}.
#' 
#' @param allDataSets Logical - should download all datasets matching \code{dataSet} parameter or only the first one (without \code{FFPE} phrase if possible).
#' 
#' @details 
#' All cohort names can be checked using: \code{ sub( x = names( infoTCGA() ), '-counts', '' )}.
#' 
#' @return No values. It only downloads files.
#' 
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
#' \pkg{RTCGA} website \href{https://rtcga.github.io/RTCGA/articles/Data_Download.html}{https://rtcga.github.io/RTCGA/articles/Data_Download.html}.
#' 
#' @examples
#' 
#'
#' dir.create('hre')
#' 
#' downloadTCGA(cancerTypes = 'ACC',
#'              dataSet = 'miR_gene_expression',
#'              destDir = 'hre',
#'              date = tail(checkTCGA('Dates'), 2)[1])
#'
#' \dontrun{
#' downloadTCGA(cancerTypes = c('BRCA', 'OV'),
#'              destDir = 'hre',
#'              date = tail(checkTCGA('Dates'), 2)[1])
#' }
#' 
#' 
#' 
#' @family RTCGA
#' @rdname downloadTCGA
#' @export
downloadTCGA <- function(cancerTypes, dataSet = "Merge_Clinical.Level_1", destDir,
												 date = NULL, untarFile = TRUE, removeTar = TRUE, allDataSets = FALSE) {
	
	assert_that(is.character(cancerTypes) & (length(cancerTypes) > 0))
	assert_that(is.character(dataSet) & (length(dataSet) == 1))
	assert_that(is.character(destDir))
	assert_that(is.null(date) || (is.character(date) & (length(date) == 1)))
	assert_that(is.logical(untarFile) & (length(untarFile) == 1))
	assert_that(is.logical(removeTar) & (length(removeTar) == 1))
	assert_that(is.logical(allDataSets) & (length(allDataSets) == 1))
	
	# check if there was '/' mark at the end of directory destDir <- checkDirectory( destDir ) no need since I am using file.path
	# function
	
	# # does the dir exist?  if (!file.exists(destDir)) { dir.create(destDir) }
	
	# ensure which date was specified
	lastReleaseDate <- whichDateToUse(date = date)
	
	
	for (element in cancerTypes) {
		
		
		tryCatch({
			# get index of page containing datasets fot this date of release and Cohort Code
			filesParentURL <- parentURL(lastReleaseDate, element)
			
			
			elementIndexes <- xml2::read_html(filesParentURL) %>% html_nodes("a") %>% html_attr("href") %>% grep(pattern = dataSet, value = TRUE) %>% 
				gsub(pattern = "^[ \t]+", replacement = "") %>% grep(pattern = "gz$", value = TRUE)  #! md5
		}, error = function(con) {
			stop(paste("Data from ", lastReleaseDate, " can not be downloaded. Use other date from checkTCGA('Dates')."))
		})
		
		elementIndexesNO_FFPELength <- elementIndexes %>%
			grep("FFPE", x = . ,
					 value = TRUE,
					 invert = TRUE) %>% 
			length()
		
		linksToData <- ifelse( elementIndexesNO_FFPELength < 1,
													 elementIndexes[1],
													 elementIndexes %>%
													 	grep("FFPE", x = . ,
													 			 value = TRUE,
													 			 invert = TRUE) %>% .[1])
		
		if (length(elementIndexes) > 1 & !allDataSets){
			cat('There were more than one datasets matching the dataSet parameter. \nDownloaded only \n',
					linksToData, "\n\nAll matches were \n\n", paste(elementIndexes, collapse = "\n"), sep="")
		}
		if (allDataSets) {
			linksToData <- elementIndexes
		}                       
		sapply(linksToData, function(linkToData){
			# https://gdac.broadinstitute.org/runs/stddata__2015_02_04/data/BRCA/20150204/
			file.create(file.path(destDir, linkToData))
			download.file(url = paste0(filesParentURL, "/", linkToData), destfile = file.path(destDir, linkToData))
			if (untarFile) {
				untar(file.path(destDir, linkToData), exdir = destDir)
			}
			if (removeTar) {
				file.remove(file.path(destDir, linkToData))
			}
		})
	}
	
}




checkDirectory <- function(directory) {
	# if (is.null(directory)) { directory <- get('.repoDir', envir = .ArchivistEnv) } else {
	if (!grepl("/$", x = directory, perl = TRUE)) {
		directory <- paste0(directory, "/")
	}
	# }
	return(directory)
}



parentURL <- function(lastReleaseDate, element) {
	# 'stddata__2015_02_04' - lastReleaseDate
	paste0("https://gdac.broadinstitute.org/runs/", 
	       lastReleaseDate, "/data/", element, "/", 
	       paste0(unlist(stri_extract_all_regex(str = lastReleaseDate, pattern = "[0-9]+")), collapse = ""),
	       "/"
	       )
}

whichDateToUse <- function(date) {
	if (!is.null(date)) {
		if (date %in% availableDates()) {
			# .availableDates in availableDates function
			paste0("stddata__", gsub(x = date, pattern = "-", replacement = "_"))
		} else {
			stop("Wrong date format or unavailable date of release. Use availableDates() function to recieve proper format and available dates.")
		}
	} else {
		if (!exists(".lastReleaseDate", envir = .RTCGAEnv)) {
			
			if (!exists("..availableDates", envir = .RTCGAEnv)) {
				invisible(availableDates())
			}
			# happens only once
			availableDates() %>% tail(1) %>% gsub(pattern = "-", replacement = "_", fixed = TRUE) %>% paste0("stddata__", .) %>% assign(x = ".lastReleaseDate", 
																																																																	value = ., envir = .RTCGAEnv)
		}
		get(".lastReleaseDate", envir = .RTCGAEnv)
	}
}
