##    RTCGA package for R
##
#' @title download
#'
#' @description TODO
#' @family RTCGA
#' @rdname downloadTCGA
#' @export
downloadTCGA <- function( cancerTypes, additionalInfo = "Merge_Clinical.Level_1",
                          writeDirectory ){
   
   
   sapply( cancerTypes, function( element ){
      gdacContent <- readLines( "http://gdac.broadinstitute.org/runs/" )
      lastReleaseDate <- grep( pattern= "stddata__20", 
                              x = gdacContent, 
                              value = TRUE)[length( grep( pattern= "stddata__20", 
                                                         x = gdacContent, 
                                                         value = TRUE ))]
                    # better than regex                                     
#> library("rvest")
#> "<li><a href=\"stddata__2015_02_04/\"> stddata__2015_02_04/</a></li>" %>% 
#+   html() %>% 
#+   html_text()
#[1] " stddata__2015_02_04/"
                                                         
      lastReleaseDate <- stri_extract( str = lastReleaseDate,
                                      regex = "stddata__201[0-9]_[0-9]{2}_[0-9]{2}" )
                                      
                          # this can be done once when package is loaded - need to change this !                                      
      
      elementIndex <- readLines( paste0("http://gdac.broadinstitute.org/runs/", lastReleaseDate,
                                        "/data/", element, "/", paste0(unlist(stri_extract_all(str = "stddata__2015_02_04", 
                                                                                               regex = "[0-9]+")), collapse = "")))
      hrefsToData <- grep( x = elementIndex, pattern = additionalInfo, value = TRUE )
      linksToData <- stri_extract( str = hrefsToData, 
                    regex = "gdac.broadinstitute.org[A-Za-z0-9\\.\\_]+" )[1]
      
      
      
      # this doesn't work yet
      
      !!!!!!!!!!!!!!!!download.file {utils}!!!!!!!!!!!!!!!!!!
      
      DATA <- getBinaryURL( linksToData, ssl.verifypeer = FALSE )
      file.create( paste0(writeDirectory, "/", cancerTypes ) )
      writeBin( DATA, con = paste0(writeDirectory, "/", cancerTypes ) )
   }
   )
}
