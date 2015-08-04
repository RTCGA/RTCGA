## RTCGA package for R
#' @title Read TCGA data to the tidy format
#'
#' @description TODO \code{cancerType} might be \code{BRCA, OV} etc.
#' 
#' @param path If \code{dataType = "clinical"} a directory to a \code{cancerType.clin.merged.txt} file. 
#' 
#' @param dataType One of \code{"clinical", "rnaseq", "mutations"}
#' @param ... Further arguments passed to the \link{as.data.frame}.
#' 
#' @return 
#' An output:
#' \itemize{
#'      \item If \code{dataType = "clinical"} a \code{data.frame} with clinical data.
#'      \item If \code{dataType = "rnaseq"} a \code{data.frame} with rnaseq data.
#'      \item If \code{dataType = "mutations"} a \code{data.frame} with mutations data.
#' }
#' 
#' @details 
#' All cohort names can be checked using: \code{ sub( names( infoTCGA() ), "-counts", "", x=.)}.
#' 
#' @examples 
#' 
#' \dontrun{
#' 
#' 
#' ##############
#' ##### clinical
#' ##############
#' 
#' dir.create("hre/")
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
#'          
#' ##############
#' ##### rnaseq
#' ##############
#' 
#' dir.create("data2/")
#' 
#' # downloading rnaseq data
#' downloadTCGA( cancerTypes = 'BRCA', 
#' dataSet = "rnaseqv2__illuminahiseq_rnaseqv2__unc_edu__Level_3__RSEM_genes_normalized__data.Level",
#' destDir = "data2/" )
#' 
#' # untarring files
#' list.files( "data2/") %>% 
#'     paste0( "data2/", .) %>%
#'     sapply( untar, exdir = "data2/" )
#' 
#' # removing *.tar.gz files   
#' list.files( "data2/") %>% 
#'     paste0( "data2/", .) %>%
#'     grep( pattern = "tar.gz", x = ., value = TRUE) %>%
#'     sapply( file.remove )
#' # shortening paths and directories
#' list.files( "data2/") %>% 
#'     paste0( "data2/", .) %>%
#'     file.rename( to = substr(.,start=1,stop=50))
#' 
#' # reading data
#' list.files( "data2/") %>% 
#'     paste0( "data2/", .) -> folder
#' 
#' folder %>%
#'     list.files %>%
#'     paste0( folder, "/", .) %>%
#'     grep( pattern = "illuminahiseq", x = ., value = TRUE) -> pathRNA
#' readTCGA( path = pathRNA, dataType = "rnaseq" ) -> my_data
#' 
#' 
#' ##############
#' ##### mutations
#' ##############
#' 
#' dir.create("data3/")
#' 
#' 
#' downloadTCGA( cancerTypes = 'OV', 
#'               dataSet = "Mutation_Packager_Calls.Level",
#'               destDir = "data3/" )
#' # untarring files
#' list.files( "data3/") %>% 
#'     paste0( "data3/", .) %>%
#'     sapply( untar, exdir = "data3/" )
#' 
#' # removing *.tar.gz files   
#' list.files( "data3/") %>% 
#'     paste0( "data3/", .) %>%
#'     grep( pattern = "tar.gz", x = ., value = TRUE) %>%
#'     sapply( file.remove )
#' 
#' # reading data
#' list.files( "data3/") %>% 
#'     paste0( "data3/", .) -> folder
#' 
#' readTCGA(folder, "mutations") -> mut_file
#' 
#' }
#' 
#' @family RTCGA
#' @rdname readTCGA
#' @export
readTCGA <- function( path, dataType, ... ){
    assertthat::assert_that(is.character(path) & length(path) == 1)
    assertthat::assert_that(is.character(dataType) & length(dataType) == 1)
    assertthat::assert_that(path %in% c("clinical", "rnaseq", "mutations"))
    
    if( dataType == "clinical" ){
        return(read.clinical(path, ...))
    }
    if( dataType == "rnaseq" ){
        return(read.rnaseq(path, ...))
    }
    if( dataType == "mutations" ){
        return(read.mutations(path, ...))
    }
    
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
    fread(rnaseqDir, data.table = FALSE) %>%
        t() -> rnaseqData
    colnames(rnaseqData) <- rnaseqData[1,]
    barcodes <- rownames(rnaseqData)
    rnaseqData <- rnaseqData[-1,-1] %>%
        apply( 2, function(x) as.numeric(as.character(x))) %>% 
        as.data.frame(x=.) %>%
        cbind(bcr_patient_barcode=barcodes[-1],.)
    return(rnaseqData)
}

read.mutations <- function(mutationsDir, ...){
    
    element <- mutationsDir
    
    list.files(element) %>%
        paste0( element, "/", .) %>%
        grep( x =., pattern="TCGA", value = TRUE) -> maf_files 
    # there are extra manifest.txt files
    
    list.files(element) %>%
        grep( x =., pattern="TCGA", value = TRUE) %>%
        substr(start = 1, stop = 15) -> barcodes
    
    pb <- txtProgressBar(min = 0,
                         max = length(maf_files),
                         style = 3)
    tempfile()->tmp
    for( i in seq_along(maf_files)){
        
        maf_data <- read.delim(maf_files[i])
        n_col <- ncol(maf_data)+1
        maf_data[,n_col] <- barcodes[i]
        names(maf_data)[n_col] <- "bcr_patient_barcode"
        
        write.table(x = maf_data,
                    sep = "\t",
                    file= tmp,
                    append=TRUE,
                    col.names=TRUE,
                    quote = FALSE,
                    row.names = FALSE
        )
        
        
        setTxtProgressBar(pb, i)
    }
    close(pb)
    read.delim(tmp) -> mutations_file
    file.remove(tmp)
    return(mutations_file)
}


# comboClinical <- read.delim('D:/BioBigStat/TCGA/clinicalCombo.txt') 
