## RTCGA package for R
#' @title Read TCGA data to the tidy format
#'
#' @description \code{readTCGA} function allows to read unzipped files: 
#' \itemize{
#'      \item clinical data - \code{Merge_Clinical.Level_1} 
#'      \item rnaseq data (genes' expressions) - \code{rnaseqv2__illuminahiseq_rnaseqv2}
#'      \item genes' mutations data - \code{Mutation_Packager_Calls.Level}
#'      \item Reverse phase protein array data (RPPA) - \code{protein_normalization__data.Level_3}
#'      \item Merge transcriptome agilent data (mRNA) - 
#'      \code{Merge_transcriptome__agilentg4502a_07_3__unc_edu__Level_3__unc_lowess_normalization_gene_level__data.Level_3}
#'      \item miRNASeq data - 
#'      \code{Merge_mirnaseq__illuminaga_mirnaseq__bcgsc_ca__Level_3__miR_gene_expression__data.Level_3} or 
#'      \code{"Merge_mirnaseq__illuminahiseq_mirnaseq__bcgsc_ca__Level_3__miR_gene_expression__data.Level_3"}
#'      \item methylation data - 
#'      \code{Merge_methylation__humanmethylation27}
#'      \item isoforms data - 
#'      \code{Merge_rnaseqv2__illuminahiseq_rnaseqv2__unc_edu__Level_3__RSEM_isoforms_normalized__data.Level_3} 
#'      }
#' from TCGA project. Those files can be easily downloded with \link{downloadTCGA} function. See examples.
#' 
#' @param path See details and examples.
#' 
#' @param dataType One of \code{'clinical', 'rnaseq', 'mutations', 'RPPA', 'mRNA', 'miRNASeq', 'methylation', 'isoforms'} depending on which type of data user is trying to read in the tidy format.
#' @param ... Further arguments passed to the \link{as.data.frame}.
#' 
#' @return 
#' An output:
#' \itemize{
#'      \item If \code{dataType = 'clinical'} a \code{data.frame} with clinical data.
#'      \item If \code{dataType = 'rnaseq'} a \code{data.frame} with rnaseq data.
#'      \item If \code{dataType = 'mutations'} a \code{data.frame} with mutations data.
#'      \item If \code{dataType = 'RPPA'} a \code{data.frame} with RPPA data.
#'      \item If \code{dataType = 'mRNA'} a \code{data.frame} with mRNA data.
#'      \item If \code{dataType = 'miRNASeq'} a \code{data.frame} with miRNASeq data.
#'      \item If \code{dataType = 'methylation'} a \code{data.frame} with methylation data.
#'      \item If \code{dataType = 'isoforms'} a \code{data.frame} with isoforms data.
#' }
#' 
#' @details 
#' All cohort names can be checked using: \code{ sub( x = names( infoTCGA() ), '-counts', '')}.
#' 
#' Parameter \code{path} specification: 
#' \itemize{
#' \item If \code{dataType = 'clinical'} a path to a \code{cancerType.clin.merged.txt} file. 
#' \item If \code{dataType = 'mutations'} a path to the unzziped folder \code{Mutation_Packager_Calls.Level} containing \code{.maf} files.
#' \item If \code{dataType = 'rnaseq'} a path to the uzziped file \code{rnaseqv2__illuminahiseq_rnaseqv2__unc_edu__Level_3__RSEM_genes_normalized__data.Level}.
#' \item If \code{dataType = 'RPPA'} a path to the unzipped file in folder \code{protein_normalization__data.Level_3}.
#' \item If \code{dataType = 'mRNA'} a path to the unzipped file \code{cancerType.transcriptome__agilentg4502a_07_3__unc_edu__Level_3__unc_lowess_normalization_gene_level__data.data.txt}.
#' \item If \code{dataType = 'miRNASeq'} a path to unzipped files \code{cancerType.mirnaseq__illuminahiseq_mirnaseq__bcgsc_ca__Level_3__miR_gene_expression__data.data.txt} or \code{cancerType.mirnaseq__illuminaga_mirnaseq__bcgsc_ca__Level_3__miR_gene_expression__data.data.txt}
#' \item If \code{dataType = 'methylation'} a path to unzipped files \code{cancerType.methylation__humanmethylation27__jhu_usc_edu__Level_3__within_bioassay_data_set_function__data.data.txt}.
#' \item If \code{dataType = 'isoforms'} a path to unzipped files \code{cancerType.rnaseqv2__illuminahiseq_rnaseqv2__unc_edu__Level_3__RSEM_isoforms_normalized__data.data.txt}.
#' }
#' 
#' 
#' @section Issues:
#' 
#' If you have any problems, issues or think that something is missing or is not
#' clear please post an issue on 
#' \href{https://github.com/RTCGA/RTCGA/issues}{https://github.com/RTCGA/RTCGA/issues}.
#' 
#' @author 
#' Marcin Kosinski, \email{m.p.kosinski@@gmail.com}
#' 
#' Witold Chodor, \email{witoldchodor@@gmail.com}
#' 
#' @seealso 
#' 
#' \pkg{RTCGA} website \href{http://rtcga.github.io/RTCGA/Download.html}{http://rtcga.github.io/RTCGA/Download.html}.
#' 
#' @examples 
#' 
#' \dontrun{ 
#' 
#' ##############
#' ##### clinical
#' ##############
#' 
#' dir.create('data')
#' 
#' # downloading clinical data
#' # dataset = "clinical" is default parameter so we may omit it
#' downloadTCGA( cancerTypes = c('BRCA', 'OV'),
#'               destDir = 'data' )
#' 
#'     
#' # reading datasets    
#' sapply( c('BRCA', 'OV'), function( element ){
#'     folder <- grep( paste0( '(_',element,'\\.', '|','_',element,'-FFPE)', '.*Clinical'),
#'                     list.files('data/'),value = TRUE)
#'     path <- paste0( 'data/', folder, '/', element, '.clin.merged.txt')
#'     assign( value = readTCGA( path, 'clinical' ), 
#'             x = paste0(element, '.clin.data'), envir = .GlobalEnv)
#'     })
#'      
#' ############
#' ##### rnaseq
#' ############
#' 
#' dir.create('data2')
#' 
#' # downloading rnaseq data
#' downloadTCGA( cancerTypes = 'BRCA', 
#' dataSet = 'rnaseqv2__illuminahiseq_rnaseqv2__unc_edu__Level_3__RSEM_genes_normalized__data.Level',
#'               destDir = 'data2' )
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
#' ###############
#' ##### mutations
#' ###############
#' 
#' # Example directory in which untarred data will be stored
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
#' #################
#' ##### methylation
#' #################
#' 
#' # Example directory in which untarred data will be stored
#' dir.create('data4')
#' 
#' # Download KIRP methylation data and store it in data4 folder
#' cancerType = "KIRP"
#' downloadTCGA(cancerTypes = cancerType,
#'              dataSet = "Merge_methylation__humanmethylation27",
#'              destDir = "data4")
#' 
#' # Shorten path of subdirectory with KIRP methylation data
#' list.files(path = "data4", full.names = TRUE) %>%
#'     file.rename(from = ., to = file.path("data4", paste0(cancerType, ".methylation")))
#' 
#' # Remove manifest.txt file
#' list.files(path = "data4", full.names = TRUE) %>%
#'     list.files(path = ., full.names = TRUE) %>% 
#'     grep("MANIFEST.txt", x = ., value = TRUE) %>%
#'     file.remove()
#' 
#' # Read KIRP methylation data
#' path <- list.files(path = "data4", full.names = TRUE) %>%
#'     list.files(path = ., full.names = TRUE)
#' 
#' KIRP.methylation <- readTCGA(path, dataType = "methylation")
#' 
#' 
#' ##########
#' ##### RPPA
#' ##########
#' 
#' # Directory in which untarred data will be stored
#' dir.create('data5')
#' 
#' # Download BRCA RPPA data and store it in data5 folder
#' cancerType = "BRCA"
#' downloadTCGA(cancerTypes = cancerType,
#'              dataSet = "protein_normalization__data.Level_3",
#'              destDir = "data5")
#' 
#' # Shorten path of subdirectory with BRCA RPPA data
#' list.files(path = "data5", full.names = TRUE) %>%
#'     file.rename(from = ., to = file.path("data5", paste0(cancerType, ".RPPA")))
#' 
#' # Remove manifest.txt file
#' list.files(path = "data5", full.names = TRUE) %>%
#'     list.files(path = ., full.names = TRUE) %>% 
#'     grep("MANIFEST.txt", x = ., value = TRUE) %>%
#'     file.remove()
#' 
#' # Read BRCA RPPA data
#' path <- list.files(path = "data5", full.names = TRUE) %>%
#'     list.files(path = ., full.names = TRUE)
#' 
#' BRCA.RPPA <- readTCGA(path, dataType = "RPPA")
#' 
#' 
#' ##########
#' ##### mRNA
#' ##########
#' 
#' # Directory in which untarred data will be stored
#' dir.create('data6')
#' 
#' # Download UCEC mRNA data and store it in data6 folder
#' cancerType = "UCEC"
#' downloadTCGA(cancerTypes = cancerType,
#' dataSet = "Merge_transcriptome__agilentg4502a_07_3__unc_edu__Level_3__unc_lowess_normalization_gene_level__data.Level_3",
#'              destDir = "data6")
#' 
#' # Shorten path of subdirectory with UCEC mRNA data
#' list.files(path = "data6", full.names = TRUE) %>%
#'     file.rename(from = ., to = file.path("data6",paste0(cancerType, ".mRNA")))
#' 
#' # Remove manifest.txt file
#' list.files(path = "data6", full.names = TRUE) %>%
#'     list.files(path = ., full.names = TRUE) %>% 
#'     grep("MANIFEST.txt", x = ., value = TRUE) %>%
#'     file.remove()
#' 
#' # Read UCEC mRNA data
#' path <- list.files(path = "data6", full.names = TRUE) %>%
#'     list.files(path = ., full.names = TRUE)
#' 
#' UCEC.mRNA <- readTCGA(path, dataType = "mRNA")
#' 
#' ##############
#' ##### miRNASeq
#' ##############
#' 
#' # Directory in which untarred data will be stored
#' dir.create('data7')
#' 
#' # Download BRCA miRNASeq data and store it in data7 folder
#' # Remember that miRNASeq data are produced by two machines:
#' # Illumina Genome Analyzer and Illumina HiSeq 2000 machines
#' cancerType <- "BRCA"
#' downloadTCGA(cancerTypes = cancerType,
#' dataSet = "Merge_mirnaseq__illuminaga_mirnaseq__bcgsc_ca__Level_3__miR_gene_expression__data.Level_3",
#'              destDir = "data7")
#' 
#' downloadTCGA(cancerTypes = cancerType,
#' dataSet = "Merge_mirnaseq__illuminahiseq_mirnaseq__bcgsc_ca__Level_3__miR_gene_expression__data.Level_3",
#'              destDir = "data7")
#' 
#' # Shorten path of subdirectory with BRCA miRNASeq data
#' list.files(path = "data7", full.names = TRUE) %>%
#'     sapply(function(path){
#'         if (grepl(pattern = "illuminaga", path)){
#'             file.rename(from = grep(pattern = "illuminaga", path, value = TRUE),
#'                         to = file.path("data7",paste0(cancerType, ".miRNASeq.illuminaga")))
#'         } else if (grepl(pattern = "illuminahiseq", path)){
#'             file.rename(from = grep(pattern = "illuminahiseq", path, value = TRUE),
#'                         to = file.path("data7",paste0(cancerType, ".miRNASeq.illuminahiseq")))
#'         }
#'     })
#'     
#' # Remove manifest.txt file
#' list.files(path = "data7", full.names = TRUE) %>%
#'     list.files(path = ., full.names = TRUE) %>% 
#'     grep("MANIFEST.txt", x = ., value = TRUE) %>%
#'     file.remove()
#' 
#' # Read BRCA miRNASeq data
#' path <- list.files(path = "data7", full.names = TRUE) %>%
#'     list.files(path = ., full.names = TRUE)
#' path_illuminaga <- grep("illuminaga", path, fixed = TRUE, value = TRUE)
#' path_illuminahiseq <- grep("illuminahiseq", path, fixed = TRUE, value = TRUE)
#' 
#' BRCA.miRNASeq.illuminaga <- readTCGA(path_illuminaga, dataType = "miRNASeq")
#' BRCA.miRNASeq.illuminahiseq <- readTCGA(path_illuminahiseq, dataType = "miRNASeq")
#' 
#' BRCA.miRNASeq.illuminaga <- cbind(machine = "Illumina Genome Analyzer", BRCA.miRNASeq.illuminaga)
#' BRCA.miRNASeq.illuminahiseq <- cbind(machine = "Illumina HiSeq 2000", BRCA.miRNASeq.illuminahiseq)
#' 
#' BRCA.miRNASeq <- rbind(BRCA.miRNASeq.illuminaga, BRCA.miRNASeq.illuminahiseq)
#' 
#' ##############
#' ##### isoforms
#' ##############
#' 
#' # Directory in which untarred data will be stored
#' dir.create('data8')
#' 
#' # Download ACC isoforms data and store it in data8 folder
#' cancerType = "ACC"
#' downloadTCGA(cancerTypes = cancerType,
#' dataSet = "Merge_rnaseqv2__illuminahiseq_rnaseqv2__unc_edu__Level_3__RSEM_isoforms_normalized__data.Level_3",
#'              destDir = "data8")
#' 
#' # Shorten path of subdirectory with ACC isoforms data
#' list.files(path = "data8", full.names = TRUE) %>%
#'     file.rename(from = ., to = file.path("data8",paste0(cancerType, ".isoforms")))
#' 
#' # Remove manifest.txt file
#' list.files(path = "data8", full.names = TRUE) %>%
#'     list.files(path = ., full.names = TRUE) %>% 
#'     grep("MANIFEST.txt", x = ., value = TRUE) %>%
#'     file.remove()
#' 
#' # Read ACC isoforms data
#' path <- list.files(path = "data8", full.names = TRUE) %>%
#'     list.files(path = ., full.names = TRUE)
#' 
#' ACC.isoforms <- readTCGA(path, dataType = "isoforms")
#' 
#' }
#' 
#' @family RTCGA
#' @rdname readTCGA
#' @export
readTCGA <- function(path, dataType, ...) {
  assertthat::assert_that(is.character(path) & length(path) == 1)
  assertthat::assert_that(is.character(dataType) & length(dataType) == 1)
  assertthat::assert_that(dataType %in% c("clinical", "rnaseq", "mutations", "RPPA", "mRNA",
                                          "miRNASeq", "methylation", "isoforms"))
  
  if (dataType %in% c("clinical", "miRNASeq")) {
    return(read.clinical(path, ...))
  }
  if (dataType %in% c("methylation")) {
    return(read.methylation(path, ...))
  }
  if (dataType %in% c("rnaseq", "RPPA", "mRNA", "isoforms")) {
    return(read.rnaseq(path, ...))
  }
  if (dataType == "mutations") {
    return(read.mutations(path, ...))
  }
}

read.clinical <- function(clinicalDir, ...) {
  
  comboClinical <- fread(clinicalDir, data.table = FALSE)
  
  colNames <- comboClinical[, 1]
  
  comboClinical <- as.data.frame(t(comboClinical[, -1]), ...)
  names(comboClinical) <- colNames
  
  return(comboClinical)
}

read.methylation <- function(methylationDir, ...){
  methylationData <- fread(methylationDir, data.table = FALSE)
  first_row <- methylationData[1,]
  Beta_value_column <- which(first_row == "Beta_value")
  methylationData <- methylationData[,c(1, 3, 4, 5, Beta_value_column)]
  colNames <- methylationData[,1]
  methylationData <- as.data.frame(t(methylationData[,-1]), ...)
  names(methylationData) <- colNames
  row.names(methylationData)[1:3] <- c("TCGA-05.1", "TCGA-05.2", "TCGA-05.3")
  x <- row.names(methylationData)[4]
  row.names(methylationData)[4] <- sub("\\.3$", "", x)
  methylationDataNumeric <- methylationData[-c(1:3), -1]
  apply(methylationDataNumeric, MARGIN = 2, function(x){
    as.numeric(as.character(x))
  }) -> methylationDataNumeric
  methylationDataCodes <- cbind(bcr_patient_barcode = row.names(methylationData)[-c(1:3)],
                                as.data.frame(methylationDataNumeric))
  #attr(methylationDataCodes, "info") <- methylationData[c(1:3), -1]
  return(methylationDataCodes) 
}

read.rnaseq <- function(rnaseqDir, ...) {
  rnaseqData <- fread(rnaseqDir, data.table = FALSE) %>% t()
  colnames(rnaseqData) <- rnaseqData[1, ]
  barcodes <- rownames(rnaseqData)
  rnaseqData <- rnaseqData[-1, -1] %>%
    apply(2, function(x) as.numeric(as.character(x))) %>%
    as.data.frame(x = .) %>%
    cbind(bcr_patient_barcode = barcodes[-1], .)
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
    
    invisible(write.table(x = maf_data, sep = "\t", file = tmp, append = TRUE, col.names = i==1, quote = FALSE, row.names = FALSE))
    
    
    setTxtProgressBar(pb, i)
  }
  close(pb)
  mutations_file <- read.delim(tmp)
  file.remove(tmp)
  return(mutations_file)
} 
