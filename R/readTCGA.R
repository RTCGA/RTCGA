## RTCGA package for R
#' @title Read TCGA data to the tidy format
#'
#' @description TODO
#' 
#' @param path If \code{dataType = "clinical"} a directory to a \code{cancerType.clin.merged.txt} file. 
#' \code{cancerType} might be \code{BRCA, OV} etc.
#' @param dataType TODO
#' @param ... Further arguments passed to the \link{as.data.frame}.
#' 
#' @return 
#' An output:
#' \itemize{
#'      \item If \code{dataType = "clinical"} a \code{data.frame} with clinical data.
#' }
#' 
#' @examples 
#' 
#' \dontrun{
#' 
#' ##############
#' ##### clinical
#' ##############
#' 
#' # downloading clinical data
#' downloadTCGA( cancerTypes = c("BRCA", "OV"), destDir = "hre/" )
#' 
#' # untarring files
#' list.files( "hre/") %>% 
#' paste0( "hre/", .) %>%
#'    sapply( untar, exdir = "hre/" )
#'    
#' # removing *.tar.gz files   
#' list.files( "hre/") %>% 
#' paste0( "hre/", .) %>%
#'     grep( pattern = "tar.gz", x = ., value = TRUE) %>%
#'     sapply( file.remove )
#'     
#' # reading datasets    
#' sapply( c("BRCA", "OV"), function( element ){
#' folder <- grep( paste0( "(_",element,"\\.", "|","_",element,"-FFPE)", ".*Clinical"),
#'       list.files("hre/"),value = TRUE)
#' path <- paste0( "hre/", folder, "/", element, ".clin.merged.txt")
#' assign( value = readTCGA( path, "clinical" ), 
#'          x = paste0(element, ".clin.data"), envir = .GlobalEnv)
#'          })
#' }
#' 
#' @family RTCGA
#' @rdname readTCGA
#' @export
readTCGA <- function( path, dataType, ... ){
    assertthat::assert_that(is.character(path) & length(path) == 1)
    assertthat::assert_that(is.character(dataType) & length(dataType) == 1)
    
    if( dataType == "clinical" )
        read.clinical(path, ...)
    if( dataType == "rnaseq" )
        read.rnaseq(path, ...)
    if( dataType == "mutations" )
        read.mutations(path, ...)
    
}
read.clinical <- function(clinicalDir, ...) {
    
    comboClinical <- read.delim(clinicalDir)
    
    colNames <- comboClinical[, 1]
    
    comboClinical <- as.data.frame(t(comboClinical[, -1]), ...)
    names(comboClinical) <- colNames
    
    comboClinical <- as.data.table(comboClinical)
    comboClinical <- comboClinical[, unique(names(comboClinical)), with = FALSE]
    comboClinical <- as.data.frame(comboClinical, ...)
    
    return(comboClinical)
}

read.rnaseq <- function(rnaseqDir, ...){
    
}

read.mutations <- function(mutationsDir, ...){
    
}


# comboClinical <- read.delim('D:/BioBigStat/TCGA/clinicalCombo.txt') 
