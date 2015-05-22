#' @title Calculates coocurence matrix for given tumor
#'
#' @description First you need to download MAF files from TCGA Mutation_Packager_Calls.
#' The format is: mutations for one patient are stored in one MAF file.
#' This functions read data from all MAF files, filter out only patients with mutations in gene 'gene'.
#' For given gene calculates cooccurence of mutations in different genes and poistions of mutations in gene 'gene'.
#' 
#' @return A cooccurence matrix.
#' 
#' @param path path to the folder with MAF files
#' @param gene name of gene
#' @param position name of collumn with position of mutation 
#' @param onlyMissense should mutations be limited only to missense
#' @param minCount only positions with counts greater or equal will be retured
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
                                  onlyMissense = TRUE,
                                  minCount = 5) {
  
  allPatients <- lapply(list.files(path, pattern = ".maf"), function(p) {
      t <- read.table(paste0(path,"/",p), header=TRUE, fill=TRUE, sep="\t", quote="\"")
      colnames(t) <- tolower(colnames(t))
      cbind(t[,c("hugo_symbol", "variant_classification",position)], 
            patientID = strsplit(p, split=".", fixed=T)[[1]][1])
  })
  allPatientsDF <- do.call(rbind, allPatients)
  # only digits
  allPatientsDF[,position] <- gsub(as.character(allPatientsDF[,position]), 
                                   pattern="[^0-9]+", replacement="")
  
  # patients with change in gene
  ids <- unique(as.character(allPatientsDF[allPatientsDF$hugo_symbol == gene,"patientID"]))
  mutatedPatientsDF <- unique(allPatientsDF[allPatientsDF$patientID %in% ids,])
  
  toChange <- mutatedPatientsDF[mutatedPatientsDF$hugo_symbol == gene, ]
  if (nrow(toChange)==0) return(toChange)
  for (i in 1:nrow(toChange)) {
      mutatedPatientsDF[mutatedPatientsDF$patientID == toChange[i,"patientID"],position] = toChange[i,position]
  }
  
  tab <- table(factor(mutatedPatientsDF$hugo_symbol), factor(mutatedPatientsDF[,position]))
  tab <- tab[,tab[gene,] >= minCount]
  tab <- tab[rowSums(tab) > 0,]
  tab <- tab[order(-rowSums(tab)),]
  tab
}

