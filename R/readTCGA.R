## RTCGA package for R
#' @title Read TCGA data to the tidy format
#'
#' @description \code{readTCGA} function allows to read unzipped files: 
#' \itemize{
#'      \item clinical data - \code{Merge_Clinical.Level_1} 
#'      \item rnaseq data (genes' expressions) - \code{Mutation_Packager_Calls.Level}
#'      \item genes' mutations data - \code{rnaseqv2__illuminahiseq_rnaseqv2}
#'      }
#' from TCGA project. Those files can be easily downloded with \link{downloadTCGA} function. See examples.
#' 
#' @param path If \code{dataType = 'clinical'} a directory to a \code{cancerType.clin.merged.txt} file. 
#' If \code{dataType = 'mutations'} a directory to the unzziped folder \code{Mutation_Packager_Calls.Level} containing \code{.maf} files.
#' If \code{dataType = 'rnaseq'} a directory to the uzziped file \code{rnaseqv2__illuminahiseq_rnaseqv2__unc_edu__Level_3__RSEM_genes_normalized__data.Level}.
#' See examples.
#' 
#' @param dataType One of \code{'clinical', 'rnaseq', 'mutations'} depending on which type of data users is trying to read in the tidy format.
#' @param ... Further arguments passed to the \link{as.data.frame}.
#' 
#' @return 
#' An output:
#' \itemize{
#'      \item If \code{dataType = 'clinical'} a \code{data.frame} with clinical data.
#'      \item If \code{dataType = 'rnaseq'} a \code{data.frame} with rnaseq data.
#'      \item If \code{dataType = 'mutations'} a \code{data.frame} with mutations data.
#' }
#' 
#' @details 
#' All cohort names can be checked using: \code{ sub( x = names( infoTCGA() ), '-counts', '')}.
#' 
#' @examples 
#' 
#' \dontrun{ 
#' 
#' ##############
#' ##### clinical
#' ##############
#' 
#' dir.create('hre')
#' 
#' # downloading clinical data
#' downloadTCGA( cancerTypes = c('BRCA', 'OV'), destDir = 'hre' )
#' 
#'     
#' # reading datasets    
#' sapply( c('BRCA', 'OV'), function( element ){
#' folder <- grep( paste0( '(_',element,'\\.', '|','_',element,'-FFPE)', '.*Clinical'),
#'       list.files('hre/'),value = TRUE)
#' path <- paste0( 'hre/', folder, '/', element, '.clin.merged.txt')
#' assign( value = readTCGA( path, 'clinical' ), 
#'          x = paste0(element, '.clin.data'), envir = .GlobalEnv)
#'          })
#'      
#' ##############
#' ##### rnaseq
#' ##############
#' 
#' dir.create('data2')
#' 
#' # downloading rnaseq data
#' downloadTCGA( cancerTypes = 'BRCA', 
#' dataSet = 'rnaseqv2__illuminahiseq_rnaseqv2__unc_edu__Level_3__RSEM_genes_normalized__data.Level',
#' destDir = 'data2' )
#' 
#' # shortening paths and directories
#' list.files( 'data2/') %>% 
#'     file.path( 'data2', .) %>%
#'     file.rename( to = substr(.,start=1,stop=50))
#' 
#' # reading data
#' list.files( 'data2/') %>% 
#'     file.path( 'data2', .) -> folder
#' 
#' folder %>%
#'     list.files %>%
#'     file.path( folder, .) %>%
#'     grep( pattern = 'illuminahiseq', x = ., value = TRUE) -> pathRNA
#' readTCGA( path = pathRNA, dataType = 'rnaseq' ) -> my_data
#' 
#' 
#' ##############
#' ##### mutations
#' ##############
#' 
#' dir.create('data3')
#' 
#' 
#' downloadTCGA( cancerTypes = 'OV', 
#'               dataSet = 'Mutation_Packager_Calls.Level',
#'               destDir = 'data3' )
#' 
#' # reading data
#' list.files( 'data3/') %>% 
#'     file.path( 'data3', .) -> folder
#' 
#' readTCGA(folder, 'mutations') -> mut_file
#' 
#' }
#' 
#' @family RTCGA
#' @rdname readTCGA
#' @export
readTCGA <- function(path, dataType, ...) {
    assertthat::assert_that(is.character(path) & length(path) == 1)
    assertthat::assert_that(is.character(dataType) & length(dataType) == 1)
    assertthat::assert_that(dataType %in% c("clinical", "rnaseq", "mutations"))
    
    if (dataType == "clinical") {
        return(read.clinical(path, ...))
    }
    if (dataType == "rnaseq") {
        return(read.rnaseq(path, ...))
    }
    if (dataType == "mutations") {
        return(read.mutations(path, ...))
    }
    
}

read.clinical <- function(clinicalDir, ...) {
    
    comboClinical <- read.delim(clinicalDir)
    
    colNames <- comboClinical[, 1]
    
    comboClinical <- as.data.frame(t(comboClinical[, -1]), ...)
    names(comboClinical) <- colNames
    
    # comboClinical <- data.table::as.data.table(comboClinical) comboClinical <- comboClinical[, unique(names(comboClinical)), with =
    # FALSE] comboClinical <- as.data.frame(comboClinical, ...)
    
    return(comboClinical)
}

read.rnaseq <- function(rnaseqDir, ...) {
    rnaseqData <- fread(rnaseqDir, data.table = FALSE) %>% t()
    colnames(rnaseqData) <- rnaseqData[1, ]
    barcodes <- rownames(rnaseqData)
    rnaseqData <- rnaseqData[-1, -1] %>% apply(2, function(x) as.numeric(as.character(x))) %>% as.data.frame(x = .) %>% cbind(bcr_patient_barcode = barcodes[-1], 
        .)
    return(rnaseqData)
}

read.mutations <- function(mutationsDir, ...) {
    
    element <- mutationsDir
    
    maf_files <- list.files(element) %>% file.path(element, .) %>% grep(x = ., pattern = "TCGA", value = TRUE)
    # there are extra manifest.txt files
    
    barcodes <- list.files(element) %>% grep(x = ., pattern = "TCGA", value = TRUE) %>% substr(start = 1, stop = 15)
    
    pb <- txtProgressBar(min = 0, max = length(maf_files), style = 3)
    tmp <- tempfile()
    for (i in seq_along(maf_files)) {
        
        maf_data <- read.delim(maf_files[i])
        n_col <- ncol(maf_data) + 1
        maf_data[, n_col] <- barcodes[i]
        names(maf_data)[n_col] <- "bcr_patient_barcode"
        
        write.table(x = maf_data, sep = "\t", file = tmp, append = TRUE, col.names = TRUE, quote = FALSE, row.names = FALSE)
        
        
        setTxtProgressBar(pb, i)
    }
    close(pb)
    mutations_file <- read.delim(tmp)
    file.remove(tmp)
    return(mutations_file)
} 
