##    RTCGA package for R
##
#' @title Merge
#'
#' @description TODO
#' 
#' @param clinicalDir A directory to a \code{cancerType.clin.merged.txt} file. 
#' \code{cancerType} might be \code{BRCA, OV} etc.
#' @param rnaseqDir A directory to a \code{cancerType.rnaseqv2__illuminahiseq_rnaseqv2__unc_edu__Level_3__RSEM_genes_normalized__data.data.txt} file
#' 
#' 
#' @return A new \code{.txt} file is 
#' 
#' @family RTCGA
#' @rdname mergeTCGA
#' @export
mergaTCGA <- function( clinicalDir, names ){
   assertthat::assert_that( is.list( names ) )
   assertthat::assert_that( is.character( clinical ) )
}




#' @family RTCGA
#' @rdname mergeTCGA
#' @export
mergeTCGA_clinical_rnaseq <- function( clinicalDir, rnaseqDir,
                                       genes = c("MDM2") ){
    
    assert_that( is.character(clinicalDir) & length(clinicalDir) == 1)
    assert_that( is.character(rnaseqDir) & length(rnaseqDir) == 1)
    assert_that( is.character(genes) & length(genes) > 0)
    
    rnaseqv2 <- fread( rnaseqDir )
    
    
    # in case column names are not unique :| 
    # mb they are uniqe
    rnaseqv2 <- rnaseqv2[,unique(names(rnaseqv2)),with=FALSE]
    
    rnaseqv2 %>% setnames( x=.,
                           old = names(rnaseqv2), 
                           new =  c("HybridizationREF", 
                                    gsub(  ".", #if a column name has "." instead of "-"
                                           "-", # mb there isn't such any
                                           names(rnaseqv2)[-1],
                                           fixed = TRUE)
                                    ) %>%
        substr(1,12) )
    
    realGenesNames <- genes %>% sapply( function(element) 
        {grep( pattern = element, 
              x = rnaseqv2[[1]], 
              value = TRUE ) }) %>%
        unlist( )
    
    
    
    
    rnaseqv2_short <-  rnaseqv2 %>%
        filter( Hybridizatio %in% realGenesNames )
    
    
    clin.merged <- fread( clinicalDir, nrows = 21)[21, -1, with = FALSE] %>% 
        toupper() %>% 
        as.character() %>%
        data.frame( barcode = . )
    
    
    
#     patientsOrder <- clin.merged[,1] %>%
#         sapply( function(element){
#             grep( x = names(rnaseqv2)[-1], pattern = element, value = TRUE)[1]
#         })
    
    #sum(is.na(patientsOrder))
    
    rnaseqv2_short_frame <- cbind( data.frame( barcode = names(rnaseqv2_short) ),
                                       as.data.frame(t(rnaseqv2_short)) ) 
    # need to remove warning somehow
    
    joinedFrames <- left_join(clin.merged, rnaseqv2_short_frame[-1,], by = "barcode") 
    # ok rows are copied now... so we need to remove some of them 
 
    joinedFrames <- unique( data.table(joinedFrames), by = "barcode" )
    
    for( i in 1:(ncol(joinedFrames)-1)){
    
        write.table( file = clinicalDir, 
                     append = TRUE, 
                     x = strsplit(c(as.character(rnaseqv2_short_frame[1,i+1]), 
                                                     as.character(joinedFrames[[i+1]])), split = "\t"),
                     col.names = FALSE,
                     row.names = FALSE,
                     quote = FALSE, 
                     sep = "\t"
                     )
        
    }    
    
}

#' @family RTCGA
#' @rdname mergeTCGA
#' @export
prepareTCGA_mutations_for_merging <- function( clinicalDir, mutationDir, rnaseqDir ){
    assert_that( is.character(clinicalDir) & length(clinicalDir) == 1)
    assert_that( is.character(rnaseqDir) & length(rnaseqDir) == 1)
    assert_that( is.character(mutationDir) & length(mutationDir) == 1)
    
    mutationDir <- checkDirectory( mutationDir )
    
    genesNames <- availableGenesNames(rnaseqDir)
    
    clin.merged <- fread( clinicalDir, nrows = 21)[21, -1, with = FALSE] %>% 
        toupper() %>% 
        as.character() %>%
        data.frame( barcode = . )
    
    clin.merged[, 1] <- clin.merged[, 1] %>% 
        paste0( "-01")
    
    filesForExistingBARCODES <- clin.merged[, 1] %>%
        sapply( function(element){
            grep( pattern = element,
                  x = list.files( mutationDir ),
                  value = TRUE )
        } ) %>%
        unlist()
    
    mergedMutations <- data.frame( Hugo_Symbol = genesNames )
#     mergedMutations %>%
#         setnames( "Variant_Classification",
#                   names(filesForExistingBARCODES[1])
#         )
    how_many_files <- length(filesForExistingBARCODES)
    for( i in seq_along(filesForExistingBARCODES[1:5]) ){
        
        
        mergedMutationsToAdd <- fread( paste0( mutationDir,
                                          filesForExistingBARCODES[i] ), 
                                  select= c(1,9) )
        mergedMutationsToAdd %>% 
            setnames( "Variant_Classification",
                      names(filesForExistingBARCODES[i])
            )
        mergedMutations <- full_join(mergedMutations,
                                      mergedMutationsToAdd,
                                      by="Hugo_Symbol")    
        cat( "\r Merged ", i, " out of ", how_many_files, " used files.")
    }
    
    
    file.create( paste0(mutationDir, "preparedForMerging.txt"))
    write.table(mergedMutations, 
                file = paste0(mutationDir, "preparedForMerging.txt"),
                quote = FALSE,
                row.names = FALSE,
                col.names = TRUE,
                sep = "\t"
                )
    
    cat( "\n Data prepared for merging using mergeTCGA_clinical_mutations were saved in a file", paste0(mutationDir, "preparedForMerging.txt"))
    return( paste0(mutationDir, "preparedForMerging.txt") )
}


#' @family RTCGA
#' @rdname mergeTCGA
#' @export
mergeTCGA_clinical_mutations <- function( clinicalDir, mutationPreparedDir,
                                       genes = c("TP53") ){
    assert_that( is.character(clinicalDir) & length(clinicalDir) == 1)
    assert_that( is.character(rnaseqDir) & length(rnaseqDir) == 1)
    assert_that( is.character(genes) & length(genes) > 0)
}




