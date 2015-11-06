## RTCGA package for R
#' @title Information about datasets from TCGA project
#'
#' @description The \code{checkTCGA} function let's to check
#'  
#' \itemize{
#'      \item \code{DataSets}: TCGA datasets' names for current release date and cohort.
#'      \item \code{Dates}: TCGA datasets' dates of release.
#'  }
#'   
#' 
#' @details 
#' \itemize{
#'      \item If \code{what='DataSets'} enables to check TCGA datasets' names for current release date and cohort.
#'      \item If \code{what='Dates'} enables to check dates of TCGA datasets' releases.
#'      }
#' @return 
#' \itemize{
#'      \item If \code{what='DataSets'} a vector of available datasets' names to pass to the \link{downloadTCGA} function.
#'      \item If \code{what='Dates'} a vector of available dates to pass to the \link{downloadTCGA} function.
#'      }
#' @param what One of \code{DataSets} or \code{Dates}.     
#' @param cancerType A character of length 1 containing abbreviation (Cohort code - \href{http://gdac.broadinstitute.org/}{http://gdac.broadinstitute.org/})
#'  of types of cancers to check for.
#' @param date A \code{NULL} or character specifying from which date informations should be checked.
#' By default (\code{date = NULL}) the newest available date is used. All available dates can be checked on 
#' \href{http://gdac.broadinstitute.org/runs/}{http://gdac.broadinstitute.org/runs/} or by using \code{checkTCGA('Dates')} 
#' function. Required format \code{'YYYY-MM-DD'}.
#' 
#' 
#' @examples
#' \dontrun{
#' 
#' ############################# 
#' 
#' # names for current release date and cohort
#' checkTCGA('DataSets', 'BRCA' )
#' checkTCGA('DataSets', 'OV', tail(checkTCGA('Dates'))[1] )
#' #checkTCGA('DataSets', 'OV', checkTCGA('Dates')[5] ) # error
#' 
#' # dates of TCGA datasets' releases.
#' checkTCGA('Dates')
#' 
#' ############################# 
#' 
#' # TCGA datasets' names availability for 
#' # current release date and cancer type.
#' 
#' releaseDate <- '2015-06-01'
#' cancerTypes <- c('OV', 'BRCA')
#' 
#' cancerTypes %>% sapply(function(element){
#'   grep(x = checkTCGA('DataSets', element, releaseDate), 
#'       pattern = 'humanmethylation450', value = TRUE) %>%
#'        as.vector()
#'        })
#'        
#' #############################      
#'
#' # TCGA genes' names and availability 
#' # in Merge_rnaseqv2__... dataset 
#' dir.create('data2')
#' sapply( cancerTypes, function(element){
#' tryCatch({
#'     downloadTCGA( cancerTypes = element, 
#'                   dataSet = paste0('rnaseqv2__illuminahiseq_rnaseqv2__unc',
#'                   '_edu__Level_3__RSEM_genes_normalized__data.Level'),
#'                   destDir = 'data2', 
#'                   date = releaseDate )},
#'     error = function(cond){
#'         cat('Error: Maybe there weren't rnaseq data for ', element, ' cancer.\n')
#'     }
#' )
#' })
#' 
#' # Paths to rna-seq data
#' 
#' sapply( cohorts, function( element ){
#' folder <- grep( paste0( '(_',element,'\\.', '|','_',element,'-FFPE)', '.*rnaseqv2'),
#'                list.files('data2/'), value = TRUE)
#' file <- grep( paste0(element, '.*rnaseqv2'), list.files( paste0( 'data2/',folder ) ),
#'               value = TRUE)
#' path <- paste0( 'data2/', folder, '/', file )
#' assign( value = path, x = paste0(element, '.rnaseq.path'), envir = .GlobalEnv)
#' })
#' 
#' rnaseqDir <- 'OV.rnaseq'
#' 
#'                 
#' fread(rnaseqDir, select = c(1),
#'       data.table = FALSE,
#'       colClasses = 'character')[-1, 1]       
#' 
#' }
#' @family RTCGA
#' @aliases checkTCGA
#' @rdname checkTCGA
#' @export
checkTCGA <- function(what, cancerType, date = NULL) {
    assert_that(is.character(what) & length(what) == 1)
    assert_that(is.null(date) || (is.character(cancerType) & (length(cancerType) == 1)))
    assert_that(is.null(date) || (is.character(date) & (length(date) == 1)))
    
    if (what == "DataSets") {
        return(availableDataSets(cancerType, date = date))
    }
    if (what == "Dates") {
        return(availableDates())
    }
}

# Misc function
availableDataSets <- function(cancerType, date = NULL) {
    
    assertthat::assert_that(is.character(cancerType) & (length(cancerType) == 1))
    assertthat::assert_that(is.null(date) || (is.character(date) & (length(date) == 1)))
    
    # ensure which date was specified
    lastReleaseDate <- whichDateToUse(date = date)  #downloadTCGA.r
    
    # get index of page containing datasets fot this date of release and Cohort Code
    filesParentURL <- parentURL(lastReleaseDate, element = cancerType)  #downloadTCGA.r
    
    # get content of index page
    elementIndex <- tryCatch(readLines(filesParentURL), error = function(e) stop(paste("Probably dataset from this date needs authentication. \n \tCouldn't check available datasets' names.", 
        "\n \tTry manually on", filesParentURL)))
    
    # stopped working suddenly after change of indexing of pages like that
    # http://gdac.broadinstitute.org/runs/stddata__2015_04_02/data/BRCA/20150402/ looks bad, but works fine....  need to fix this mess
    dataSetsName <- sapply(elementIndex, function(element) {
        gsub(".*gdac.broadinstitute.org(.*)\".*", "\\1", element)
    })
    
    dataSetsName <- sapply(elementIndex, function(element) {
        unlist(stri_extract_all_regex(pattern = "_.*tar\\.gz", str = element))
    })
    x <- dataSetsName %>% unlist() %>% na.omit() %>% unique()
    
    
    # cat available dataSets' names
    gsub(paste0("_", cancerType), cancerType, unique(grep(x = x, pattern = paste0("_", cancerType), value = TRUE)))
    
}


# Misc function
availableDates <- function() {
    
    if (!exists(x = ".availableDates2", envir = .RTCGAEnv)) {
        # happens only once
        readLines("http://gdac.broadinstitute.org/runs/") %>% assign(x = ".gdacContent", value = ., envir = .RTCGAEnv)
        
        get(".gdacContent", envir = .RTCGAEnv) %>% grep(pattern = "stddata__20", value = TRUE) %>% gsub(pattern = "(<[^>]+>)| |/", replacement = "") %>% 
            substring(first = 10, last = 19) %>% assign(x = ".availableDates", value = ., envir = .RTCGAEnv)
        
        get(".availableDates", envir = .RTCGAEnv) %>% gsub(pattern = "^[^0-9]{10}", replacement = "") %>% gsub(pattern = "_", replacement = "-", 
            fixed = TRUE) %>% assign(x = ".availableDates2", value = ., envir = .RTCGAEnv)
        ############################################ 
        
        xml2::read_html("http://gdac.broadinstitute.org/runs/stddata__latest/") %>% html_nodes("h3") %>% html_text() %>%
            substring(first=1, last=10) %>% gsub(pattern = "_", replacement = "-", fixed = TRUE) %>% 
            assign(x = ".lastWorkingDate", value = ., envir = .RTCGAEnv)
        get(x = ".availableDates2", envir = .RTCGAEnv)[1:grep(get(x = ".lastWorkingDate", envir = .RTCGAEnv), 
                                                              get(x = ".availableDates2", envir = .RTCGAEnv) )] %>%
            assign(x=".availableDates3", value = ., envir = .RTCGAEnv)
    }
    get(x=".availableDates3", envir = .RTCGAEnv)
} 
