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
mergeTCGA <- function( clinicalDir, rnaseqDir = NULL, mutationDir = NULL, genes ){
   assert_that( is.character( genes ) )
   assert_that( is.character( clinicalDir ) )
   assert_that( xor( is.character( rnaseqDir ), is.character( mutationDir ) ) )        
   assert_that( xor( is.null( rnaseqDir ), is.null( mutationDir ) ) ) 
    
   if( is.null( rnaseqDir ) && is.character( mutationDir ) ) 
       mergeTCGA_clinical_mutations( clinicalDir = clinicalDir,
                                     mutationDir = mutationDir,
                                     genes = genes )
   
   if( is.character( rnaseqDir ) && is.null( mutationDir ) ) 
       mergeTCGA_clinical_rnaseq( clinicalDir = clinicalDir,
                                  rnaseqDir = rnaseqDir,
                                  genes = genes )
}




# #' @family RTCGA
# #' @rdname mergeTCGA
# #' @export
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
    
    
    clin.merged <- getPatientsBarcodes( clinicalDir )
        
    
    
    
#     patientsOrder <- clin.merged[,1] %>%
#         sapply( function(element){
#             grep( x = names(rnaseqv2)[-1], pattern = element, value = TRUE)[1]
#         })
    
    #sum(is.na(patientsOrder))
    
    rnaseqv2_short_frame <- cbind( data.frame( barcode = names(rnaseqv2_short), 
                                               stringsAsFactors = FALSE ),
                                       as.data.frame(t(rnaseqv2_short))) 
    # need to remove warning somehow
    
    joinedFrames <- left_join(clin.merged, rnaseqv2_short_frame[-1,], by = "barcode") 
    # ok rows are copied now... so we need to remove some of them 
 
    joinedFrames <- unique( data.table(joinedFrames), by = "barcode" )
    
    for( i in 1:(ncol(joinedFrames)-1)){
    
        write.table( file = clinicalDir, 
                     append = TRUE, 
                     x = strsplit(c(as.character(rnaseqv2_short_frame[1,i+1]), 
                                                     as.character(joinedFrames[[i+1]])), 
                                  split = "\t"),
                     col.names = FALSE,
                     row.names = FALSE,
                     quote = FALSE, 
                     sep = "\t"
                     )
        
    }    
    
}

# #' @family RTCGA
# #' @rdname mergeTCGA
# #' @export
# prepareTCGA_mutations_for_merging <- function( clinicalDir, mutationDir ){
#     assert_that( is.character(clinicalDir) & length(clinicalDir) == 1)
#     assert_that( is.character(mutationDir) & length(mutationDir) == 1)
#     
#     mutationDir <- checkDirectory( mutationDir )
#     
#     #genesNames <- availableGenesNames(rnaseqDir)
#     
#     clin.merged <- getPatientsBarcodes( clinicalDir )
#     
#     clin.merged[, 1] <- clin.merged[, 1] %>% 
#         paste0( "-01")
#     
#     filesForExistingBARCODES <- clin.merged[, 1] %>%
#         sapply( function(element){
#             grep( pattern = element,
#                   x = list.files( mutationDir ),
#                   value = TRUE )
#         } ) %>%
#         unlist()
#     
#     genesNames <- filesForExistingBARCODES %>%
#         sapply( function(element){
#             fread( paste0(mutationDir, element), 
#                    select = c(1), 
#                    skip = 1, sep = "\t")
#         }) %>%
#         unlist() %>%
#         unique()
#         
#     genesNames <- sort( genesNames )
#     
#     mergedMutations <- data.frame(  patient.bcr_patient_barcode = as.character( genesNames ), 
#                                     stringsAsFactors =  FALSE )
#     
#     file.create( paste0(mutationDir, "preparedForMerging.txt"))
#     
#     write.table( strsplit( mergedMutations[, 1], split = "\t"), 
#                 file = paste0(mutationDir, "preparedForMerging.txt"),
#                 quote = FALSE,
#                 row.names = TRUE,
#                 col.names = FALSE,
#                 sep = "\t"
#     )
#     
#     
#     # then do this for every file:
#     # join with genes names
#     # and write to a preparedForMerging.txt
#     
# #     mergedMutations %>%
# #         setnames( "Variant_Classification",
# #                   names(filesForExistingBARCODES[1])
# #         )
#     how_many_files <- length(filesForExistingBARCODES)
#     for( i in seq_along(filesForExistingBARCODES) ){
#         
#         
#         mergedMutationsToAdd <- fread( paste0( mutationDir,
#                                           filesForExistingBARCODES[i] ), 
#                                   select= c(1,9) )
#         mergedMutationsToAdd %>% 
#             setnames( "Variant_Classification",
#                       names(filesForExistingBARCODES[i])
#             )
#         mergedMutations <- full_join(mergedMutations,
#                                       mergedMutationsToAdd,
#                                       by="Hugo_Symbol")    
#         cat( "\r Merged ", i, " out of ", how_many_files, " used files.")
#     }
#     
#     
#     file.create( paste0(mutationDir, "preparedForMerging.txt"))
#     write.table(mergedMutations, 
#                 file = paste0(mutationDir, "preparedForMerging.txt"),
#                 quote = FALSE,
#                 row.names = FALSE,
#                 col.names = TRUE,
#                 sep = "\t"
#                 )
#     
#     cat( "\n Data prepared for merging using mergeTCGA_clinical_mutations were saved in a file", paste0(mutationDir, "preparedForMerging.txt"))
#     return( paste0(mutationDir, "preparedForMerging.txt") )
# }


#' @family RTCGA
#' @rdname mergeTCGA
#' @export
mergeTCGA_clinical_mutations <- function( clinicalDir, mutationDir,
                                       genes = "TP53" ){
    assert_that( is.character(clinicalDir) & length(clinicalDir) == 1)
    assert_that( is.character(mutationDir) & length(mutationDir) == 1)
    assert_that( is.character(genes) & length(genes) == 1)
    
    #to be fixed :)
    gene <- genes
    
    mutationDir <- checkDirectory( mutationDir )
         
    clin.merged <- getPatientsBarcodes( clinicalDir )
    
    
    
    MutationfilesName <-list.files( mutationDir )
        
    genesAndVariants <- clin.merged[, 1] %>%
        sapply( function(element){
            fileDir <- grep( element,
                  MutationfilesName,
                  value = TRUE)[1] 
            if( !is.na(fileDir) ){
                fread( paste0(mutationDir,fileDir) ) %>%
                as.data.frame( ) %>%
                filter( Hugo_Symbol %in% gene ) %>%
                select(  Variant_Classification )
            }else{
                return("NA")
            }
        }) %>% 
        unlist()
    
    
    write.table( file = clinicalDir, 
                 append = TRUE, 
                 x = strsplit( c(as.character( gene ), 
                                genesAndVariants ), split = "\t"),
                 col.names = FALSE,
                 row.names = FALSE,
                 quote = FALSE, 
                 sep = "\t"
    )
 
    
}







getPatientsBarcodes <- function( clinicalDir ){

clin.merged <- read.delim( clinicalDir ) %>% # fread error
    filter( .[,1] == "patient.bcr_patient_barcode" ) 
clin.merged <- clin.merged %>%
    sapply( toupper) %>%
    data.frame( barcode = . ) 
clin.merged <- clin.merged[-1,1] %>%
    as.data.frame( .,
                 stringsAsFactors = FALSE )
names(clin.merged) <- "barcode"
return(clin.merged)

}

# md <- data.frame(barcode = toupper(sapply(a[,-1], as.character)))


# gdy nie dopisalo sie danych z rnaseq to wykonywalo sie poprawnie,
# jednak pozniej wystapil taki blad:
# mozliwe, ze write.tables musi sie oknczyc albo zaczynac specjalnym znakiem

# > fread( clinicalDir )
# Error in fread(clinicalDir) : 
#     Expected sep ('	') but new line, EOF (or other non printing character) ends field 376 on line 7 when detecting types: TP53	NA	NA	NA	NA	Nonsense_Mutation	NA	Missense_Mutation	Nonsense_Mutation	NA	NA	NA	NA	Missense_Mutation	NA	NA	NA	Nonsense_Mutation	NA	Missense_Mutation	NA	NA	NA	NA	NA	NA	NA	NA	NA	NA	NA	NA	NA	NA	NA	NA	NA	NA	NA	NA	NA	NA	NA	NA	NA	NA	NA	NA	NA	NA	NA	NA	NA	NA	NA	NA	NA	NA	NA	NA	NA	NA	NA	Missense_Mutation	Missense_Mutation	Missense_Mutation	Missense_Mutation	Nonsense_Mutation	Missense_Mutation	Missense_Mutation	Missense_Mutation	Missense_Mutation	Missense_Mutation	Nonsense_Mutation	Missense_Mutation	Missense_Mutation	Frame_Shift_Del	Missense_Mutation	Missense_Mutation	NA	NA	NA	NA	Missense_Mutation	Missense_Mutation	Silent	NA	Missense_Mutation	Missense_Mutation	Missense_Mutation	Missense_Mutation	NA	NA	NA	Frame_Shift_Del	Missense_Mutation	NA	NA	Frame_Shift_Del	Missense_Mutation	Frame_Shift_Ins	Missense_Mutation	Frame_Shift_Del	Frame_Shift_Ins	Frame_Shift_Del	NA	NA	Nons
