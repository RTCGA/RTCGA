#' @title Calculates coocurence matrix for given tumor
#'
#' @description First you need to download MAF files from TCGA Mutation_Packager_Calls.
#' The format is: mutations for one patient are stored in one MAF file.
#' This functions read data from all MAF files, filter out only patients with mutations in gene 'gene'.
#' For given gene calculates cooccurence of mutations in different genes and poistions of mutations in gene 'gene'.
#' 
#' @return A cooccurence matrix.
#' 
#' @examples
#' \dontrun{
#' calculate_cooccurence()
#' }
#' 
#' @family RTCGA
#' @rdname calculate_cooccurence
#' @export

calculate_cooccurence <- function(path = "gdac.broadinstitute.org_BRCA.Mutation_Packager_Calls.Level_3.2015020400.0.0/", 
                                  gene = "TP53", 
                                  position = "amino_acid_change_WU",
                                  onlyMissense = TRUE) {

  allPatients <- lapply(list.files(path, pattern = ".maf"), function(p) {
      t <- read.table(paste0(path,"/",p), header=TRUE, fill=TRUE, sep="\t", quote="\"")
      cbind(t[,c("Hugo_Symbol", "Variant_Classification",position)], 
            patientID = strsplit(p, split=".", fixed=T)[[1]][1])
  })
  allPatientsDF <- do.call(rbind, allPatients)
  # only digits
  allPatientsDF[,position] <- gsub(as.character(allPatientsDF[,position]), 
                                   pattern="[^0-9]+", replacement="")
  
  # patients with change in gene
  ids <- unique(as.character(allPatientsDF[allPatientsDF$Hugo_Symbol == gene,"patientID"]))
  pos <- unique(as.character(allPatientsDF[allPatientsDF$Hugo_Symbol == gene,position]))
  gen <- unique(as.character(allPatientsDF$Hugo_Symbol))
  
  mutatedPatientsDF <- unique(allPatientsDF[allPatientsDF$patientID %in% ids,])
  
  table(mutatedPatientsDF$Hugo_Symbol, mutatedPatientsDF[,position])
}

