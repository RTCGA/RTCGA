## RTCGA package for R
#' @title TCGA genes' names and availability in \code{Merge_rnaseqv2__...} dataset.
#'
#' @description \code{availableGenesNames} returns all available genes' names from  genes' expressions dataset, 
#' where \code{checkGenesNamesAvailability} checks whether genes specified in \code{genes} are available
#' in \code{Merge_rnaseqv2__illuminahiseq_rnaseqv2__unc_edu__Level_3__RSEM_genes_normalized__data.Level_3} (genes' expressions) dataset.
#' 
#' @param rnaseqDir A directory to a \code{cancerType.rnaseqv2__illuminahiseq_rnaseqv2__unc_edu__Level_3__RSEM_genes_normalized__data.data.txt} file
#' @param genes A character - which genes to check for availability in a dataset.
#' 
#' @return A vector containing genes' names that matched existing names.
#' 
#' @examples
#' \dontrun{
#'    checkGenesNamesAvailability( rnaseqDir, 'TP53' )
#' }
#' 
#' @family RTCGA
#' @rdname availableGenesNames
#' @export
checkGenesNamesAvailability <- function(rnaseqDir, genes) {
    
    assert_that(is.character(rnaseqDir) & length(rnaseqDir) == 1)
    assert_that(is.character(genes) & length(genes) > 0)
    
    sapply(genes, function(element) grep(pattern = element, x = availableGenesNames(rnaseqDir), 
        value = TRUE))
}

#' @family RTCGA
#' @rdname availableGenesNames
#' @export
availableGenesNames <- function(rnaseqDir) {
    
    assert_that(is.character(rnaseqDir) & length(rnaseqDir) == 1)
    
    fread(rnaseqDir, select = c(1), data.table = FALSE, colClasses = "character")[-1, 
        1]
} 
