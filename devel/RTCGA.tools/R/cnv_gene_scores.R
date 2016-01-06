#' 
#' Copy Number Variation (CNV) scores for gene or region
#'
#' The get.region.cnv.score() function returns Segment_Mean scores for selected region on selected chromosome.
#' By default it's MDM2 (chr12:69240000-69200000).
#' 
#' @param chr A chromosome of the region
#' @param start Start of the region (in bp) on the chromosome
#' @param stop Stop of the region (in bp) on the chromosome
#' 
#' @return A data frame with cnv scores in the Segment_Mean column. 
#' For each segment you will find a log2 - 1 score 
#' (0 means there is no duplication nor deletion)
#' 
#' @source \url{http://gdac.broadinstitute.org/}
#' 
#' @family RTCGA
#' @name get_region_cnv_score
#' @rdname get_region_cnv_score
#' @export
get.region.cnv.score <- function(chr="12", start=69240000, stop=69200000) {
  list_cnv <- data(package="RTCGA.cnv")
  datasets <- list_cnv$results[,"Item"]
  
  filtered <- lapply(datasets, function(dataname) {
    tmp <- get(dataname)
    tmp <- tmp[tmp$Chromosome == chr,]
    tmp <- tmp[pmin(tmp$Start, tmp$End) <= pmax(stop, start) & pmax(tmp$Start, tmp$End) >= pmin(stop, start),]
    data.frame(tmp, cohort=dataname)
  })
  
  do.call(rbind, filtered)
}
