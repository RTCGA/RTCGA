##    RTCGA package for R
##
#' @title Download TCGA data
#'
#' @description Enables to download TCGA data from specified dates of releases of concrete Cohorts of cancer types.
#' Pass a name of required dataset to the \code{dataSet} parameter. By default the Merged Clinical
#' dataSet is downloaded (value \code{dataSet = "Merge_Clinical.Level_1"}) from the newest available date of release.
#' 
#' @param cancerTypes A character vector containing abbreviations (Cohort code) of types of cancers to download from 
#' \href{http://gdac.broadinstitute.org/}{http://gdac.broadinstitute.org/}.
#' @param dataSet A part of the name of dataSet to be downloaded from 
#' \href{http://gdac.broadinstitute.org/runs/}{http://gdac.broadinstitute.org/runs/}. By default the Merged Clinical
#' dataSet is downloaded (value \code{dataSet = "Merge_Clinical.Level_1"}).
#' @param destDir A character specifying a directory into which \code{dataSet}s will be downloaded.
#' @param date A \code{NULL} or character specifying from which date \code{dataSet}s should be downloaded.
#' By default (\code{date = NULL}) the newest available date is used. All available dates can be checked on 
#' \href{http://gdac.broadinstitute.org/runs/}{http://gdac.broadinstitute.org/runs/} or by using \link{availableDates} 
#' function. Required format \code{"stddata__YYYY_MM_DD"}.
#' 
#' @examples
#' 
#' \dontrun{
#' 
#' dir.create( "hre")
#' 
#' downloadTCGA( cancerTypes = "BRCA", dataSet = "miR_gene_expression", 
#' destDir = "hre/" )
#'
#' downloadTCGA( cancerTypes = c("BRCA", "OV"), destDir = "hre/" )
#' }
#' 
#' 
#' 
#' @family RTCGA
#' @rdname downloadTCGA
#' @export
downloadTCGA <- function( cancerTypes, dataSet = "Merge_Clinical.Level_1",
                          destDir, date = NULL ){
   
    assert_that( is.character( cancerTypes ) & ( length( cancerTypes ) > 1 )  )
    assert_that( is.character( dataSet ) & ( length( dataSet ) > 1 ) )
    assert_that( is.character( destDir ) )
    assert_that( is.null( date )  || is.character( date ) )
    
    
    destDir <- checkDirectory( destDir )
    
    if( !is.null( date )  ){
        if( date %in% get( x= ".availableDates", envir = .RTCGAEnv ) ){ # .availableDates in zzz.r
        lastReleaseDate <- date # paste0("stddata__",date)
        }else{
            stop("Wrong date format or unavailable date of release. Use availableDates() function to recieve proper format and available dates.")
        }
    }else{
        lastReleaseDate <- get( ".lastReleaseDate", envir = .RTCGAEnv ) # zzz.r file in source code
    }
   
    
   invisible(     
   sapply( cancerTypes, function( element ){
      
          
                                                      
      filesParentURL <- paste0("http://gdac.broadinstitute.org/runs/", lastReleaseDate,
                           "/data/", element, "/", paste0(unlist(stri_extract_all(str = lastReleaseDate, # "stddata__2015_02_04"
                                                                                  regex = "[0-9]+")), collapse = ""))                          
      
      elementIndex <- readLines( filesParentURL )
      # taking first element is not smart..
      hrefsToData <- grep( x = elementIndex, pattern = dataSet, value = TRUE )[1] %>% html() %>% html_text()
      
      # removing white spaces at the beggining...
      linksToData <- stri_extract( str = hrefsToData, 
                    regex = "[\\S]+" )
      
      #http://gdac.broadinstitute.org/runs/stddata__2015_02_04/data/BRCA/20150204/
      
      
          
      
      
          
      file.create( paste0( destDir, linksToData ) )
      download.file( url = paste0( filesParentURL, "/", linksToData ), destfile = paste0( destDir, linksToData ) )
      
         }
   )
   )
    
}




checkDirectory <- function(directory){
#     if (is.null(directory)) {
#         directory <- get(".repoDir", envir = .ArchivistEnv)
#     }
#     else {
        if (!grepl("/$", x = directory, perl = TRUE)) {
            directory <- paste0(directory, "/")
        }
#    }
    return(directory)
}

