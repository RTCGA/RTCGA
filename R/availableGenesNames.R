##    RTCGA package for R
##
#' @title TCGA genes' names and availability in \code{Merge_rnaseqv2__illuminahiseq_rnaseqv2__unc_edu__Level_3__RSEM_genes_normalized__data.Level_3} dataset
#'
#' @description TODO
#' 
#' @param rnaseqDir TODO
#' @param genes TODO
#' 
#' @return TODO
#' 
#' @examples
#' \dontrun{
#' 
#' }
#' 
#' @family RTCGA
#' @rdname availableGenesNames
#' @export
checkGenesNamesAvailability <- function( rnaseqDir, genes ){
    
    assert_that( is.character( rnaseqDir ) & length( rnaseqDir ) == 1 )
    assert_that( is.character( genes ) & length( genes ) > 0 )
    
    availableGenesNames( rnaseqDir )
    sapply( genes, function(element) 
        grep( pattern = element, 
              x = rnaseqv2[-1,1], 
              value = TRUE )    
    )
}

#' @family RTCGA
#' @rdname availableGenesNames
#' @export
availableGenesNames <- function( rnaseqDir ){
    
    assert_that( is.character( rnaseqDir ) & length( rnaseqDir ) == 1 )
    
    fread( rnaseqDir, select = c(1), 
           data.table = FALSE,
           colClasses = "character")[-1,1]
}