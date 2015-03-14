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
#' dataSet is downloaded (value \code{dataSet = "Merge_Clinical.Level_1"}). Available datasets' names can be checked
#' using \link{availableDataSets} function.
#' @param destDir A character specifying a directory into which \code{dataSet}s will be downloaded.
#' @param date A \code{NULL} or character specifying from which date \code{dataSet}s should be downloaded.
#' By default (\code{date = NULL}) the newest available date is used. All available dates can be checked on 
#' \href{http://gdac.broadinstitute.org/runs/}{http://gdac.broadinstitute.org/runs/} or by using \link{availableDates} 
#' function. Required format \code{"YYYY-MM-DD"}.
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
   
    assert_that( is.character( cancerTypes ) & ( length( cancerTypes ) > 0 )  )
    assert_that( is.character( dataSet ) & ( length( dataSet ) == 1 ) )
    assert_that( is.character( destDir ) )
    assert_that(  is.null( date )  || ( is.character( date ) & ( length( date ) == 1 ) ) )
    
    # check if there was "/" mark at the end of directory
    destDir <- checkDirectory( destDir )
    
   # ensure which date was specified
   lastReleaseDate  <- whichDateToUse( date = date )
    
   
   for ( element in  cancerTypes ){
      
   
       # get index of page containing datasets fot this date of release and Cohort Code
       filesParentURL <- parentURL( lastReleaseDate, element ) 
       
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



parentURL <- function( lastReleaseDate, element ){
    paste0("http://gdac.broadinstitute.org/runs/", lastReleaseDate,
           "/data/", element, "/", paste0(unlist(stri_extract_all(str = lastReleaseDate, # "stddata__2015_02_04"
                                                                  regex = "[0-9]+")), collapse = ""))
}



whichDateToUse <- function( date ){
    if( !is.null( date )  ){
        if( date %in% get( x= ".availableDates2", envir = .RTCGAEnv ) ){ # .availableDates in availableDates function
            paste0("stddata__", gsub(date, "-", "_") )
        }else{
            stop("Wrong date format or unavailable date of release. Use availableDates() function to recieve proper format and available dates.")
        }
    }else{
        if( !exists( ".lastReleaseDate", envir = .RTCGAEnv ) ){
            # happens only once
            assign( x = ".lastReleaseDate", 
                    value = get( x = ".availableDates", envir = .RTCGAEnv)[length(get( x = ".availableDates", envir = .RTCGAEnv))],
                    envir = .RTCGAEnv )
            
            get( ".lastReleaseDate", envir = .RTCGAEnv )            
        }else{
            get( ".lastReleaseDate", envir = .RTCGAEnv ) 
        }
    }
}

