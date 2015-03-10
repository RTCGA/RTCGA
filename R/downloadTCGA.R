##    RTCGA package for R
##
#' @title download
#'
#' @description TODO
#' 
#' @examples
#' 
#' \dontrun{
#' 
#' dir.create( "hre")
#' 
#' downloadTCGA( cancerTypes = "BRCA", additionalInfo = "miR_gene_expression", 
#' destDir = "hre/" )
#'
#' downloadTCGA( cancerTypes = c("BRCA", "OV"), destDir = "hre/" )
#' }
#' 
#' @family RTCGA
#' @rdname downloadTCGA
#' @export
downloadTCGA <- function( cancerTypes, additionalInfo = "Merge_Clinical.Level_1",
                          destDir, date = NULL ){
   
    destDir <- archivist:::checkDirectory( destDir )
    
    if( !is.null( date )  ){
        if( date %in% availableDates ){ #TODO availableDates in zzz.r
        lastReleaseDate <- paste0("stddata__",date)
        }
    }else{
        lastReleaseDate <- get( ".lastReleaseDate", envir = .RTCGAEnv ) # zzz.r file in source code
    }
    
   last = 0
   for ( element in cancerTypes) {
      filesParentURL <- paste0("http://gdac.broadinstitute.org/runs/", lastReleaseDate,
                           "/data/", element, "/", paste0(unlist(stri_extract_all(str = lastReleaseDate, # "stddata__2015_02_04"
                                                                                  regex = "[0-9]+")), collapse = ""))                          
      
      elementIndex <- readLines( filesParentURL )
      # taking first element is not smart..
      hrefsToData <- grep( x = elementIndex, pattern = additionalInfo, value = TRUE )[1] %>% html() %>% html_text()
      
      # removing white spaces at the beggining...
      linksToData <- stri_extract( str = hrefsToData, 
                    regex = "[\\S]+" )
      
      #http://gdac.broadinstitute.org/runs/stddata__2015_02_04/data/BRCA/20150204/
      
          
      file.create( paste0( destDir, linksToData ) )
      last = download.file( url = paste0( filesParentURL, "/", linksToData ), destfile = paste0( destDir, linksToData ) )
      }
    invisible(last)
    
}
