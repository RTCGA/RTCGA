## RTCGA package for R
#' @title Gather Expressions for TCGA Datasets
#'
#' @description Function gathers expressions over multiple TCGA datasets and extracts expressions for desired genes.
#' See \link[RTCGA.rnaseq]{rnaseq}, \link[RTCGA.mRNA]{mRNA}, \link[RTCGA.RPPA]{RPPA}, \link[RTCGA.miRNASeq]{miRNASeq}, \link[RTCGA.methylation]{methylation}.
#'  
#' @param ... A data.frame or data.frames from TCGA study containing expressions informations. 
#' 
#' @param extract.names Logical, whether to extract names of passed data.frames in \code{...}.
#' 
#' @param extract.cols A character specifing the names of columns to be extracted with \code{bcr_patient_barcode}. 
#' If \code{NULL} (by default) all columns are returned.
#' 
#' @note Input data.frames should contain column \code{bcr_patient_barcode} if \code{extract.cols} is specified. 
#' 
#' 
#' @examples 
#' 
#' ## for all examples
#' library(dplyr)
#' library(tidyr)
#' library(ggplot2) 
#' 
#' ## RNASeq expressions
#' library(RTCGA.rnaseq)
#' expressionsTCGA(BRCA.rnaseq, OV.rnaseq, HNSC.rnaseq,
#' 							 extract.cols = "VENTX|27287") %>%
#' 	rename(cohort = dataset,
#' 				 VENTX = `VENTX|27287`) %>%	
#'  filter(substr(bcr_patient_barcode, 14, 15) == "01") %>% #cancer samples
#' 	ggplot(aes(y = log1p(VENTX),
#' 						 x = reorder(cohort, log1p(VENTX), median),
#' 						 fill = cohort)) + 
#' 	geom_boxplot() +
#' 	theme_RTCGA() +
#' 	scale_fill_brewer(palette = "Dark2")
#' 	
#' ## mRNA expressions	
#' library(tidyr)
#' library(RTCGA.mRNA)
#' expressionsTCGA(BRCA.mRNA, COAD.mRNA, LUSC.mRNA, UCEC.mRNA,
#' 							 extract.cols = c("ARHGAP24", "TRAV20")) %>%
#' 	rename(cohort = dataset) %>%
#' 	select(-bcr_patient_barcode) %>%
#' 	gather(cohort) -> data2plot
#' names(data2plot)[2] <- "mRNA"
#' data2plot %>%
#' 	ggplot(aes(y = value,
#' 						 x = reorder(cohort, value, mean),
#' 						 fill = cohort)) + 
#' 	geom_boxplot() +
#' 	theme_RTCGA() +
#' 	scale_fill_brewer(palette = "Set3") +
#' 	facet_grid(mRNA~.) +
#' 	theme(legend.position = "top")
#'
#'
#' ## RPPA expressions
#' library(RTCGA.RPPA)
#' expressionsTCGA(ACC.RPPA, BLCA.RPPA, BRCA.RPPA,
#' 							 extract.cols = c("4E-BP1_pS65", "4E-BP1")) %>%
#' 	rename(cohort = dataset) %>%
#' 	select(-bcr_patient_barcode) %>%
#' 	gather(cohort) -> data2plot
#' names(data2plot)[2] <- "RPPA"
#' data2plot %>%
#' 	ggplot(aes(fill = cohort, 
#' 						 y = value,
#' 						 x = RPPA)) +
#' 	geom_boxplot() +
#' 	theme_dark(base_size = 15) +
#' 	scale_fill_manual(values = c("#eb6420", "#207de5", "#fbca04")) +
#' 	coord_flip() +
#' 	theme(legend.position = "top") +
#' 	geom_jitter(alpha = 0.5, col = "white", size = 0.6, width = 0.7)
#'
#'
#'
#' ## miRNASeq expressions 
#' library(RTCGA.miRNASeq)
#' # miRNASeq has bcr_patienct_barcode in rownames...
#' mutate(ACC.miRNASeq, 
#'    bcr_patient_barcode = substr(rownames(ACC.miRNASeq), 1, 25)) -> ACC.miRNASeq.bcr
#' mutate(CESC.miRNASeq, 
#'    bcr_patient_barcode = substr(rownames(CESC.miRNASeq), 1, 25)) -> CESC.miRNASeq.bcr
#' mutate(CHOL.miRNASeq, 
#'    bcr_patient_barcode = substr(rownames(CHOL.miRNASeq), 1, 25)) -> CHOL.miRNASeq.bcr
#' mutate(LAML.miRNASeq, 
#'    bcr_patient_barcode = substr(rownames(LAML.miRNASeq), 1, 25)) -> LAML.miRNASeq.bcr
#' mutate(PAAD.miRNASeq, 
#'    bcr_patient_barcode = substr(rownames(PAAD.miRNASeq), 1, 25)) -> PAAD.miRNASeq.bcr
#' mutate(THYM.miRNASeq, 
#'    bcr_patient_barcode = substr(rownames(THYM.miRNASeq), 1, 25)) -> THYM.miRNASeq.bcr
#' mutate(LGG.miRNASeq, 
#'    bcr_patient_barcode = substr(rownames(LGG.miRNASeq), 1, 25)) -> LGG.miRNASeq.bcr
#' mutate(STAD.miRNASeq, 
#'    bcr_patient_barcode = substr(rownames(STAD.miRNASeq), 1, 25)) -> STAD.miRNASeq.bcr
#' 
#' 
#' expressionsTCGA(ACC.miRNASeq.bcr, CESC.miRNASeq.bcr, CHOL.miRNASeq.bcr, 
#'  					 LAML.miRNASeq.bcr, PAAD.miRNASeq.bcr, THYM.miRNASeq.bcr,
#'  					 LGG.miRNASeq.bcr, STAD.miRNASeq.bcr,
#'  					 extract.cols = c("machine", "hsa-mir-101-1", "miRNA_ID")) %>%
#' 							 rename(cohort = dataset) %>%
#' 	filter(miRNA_ID == "read_count") %>%
#' 	select(-bcr_patient_barcode, -miRNA_ID) %>%
#' 	gather(cohort, machine) -> data2plot
#' names(data2plot)[3:4] <- c("drop","value")
#' data2plot %>%
#' 	select(-drop) %>%
#' 	mutate(value = as.numeric(value)) %>%
#' 	ggplot(aes(x = cohort,
#' 						 y = log1p(value),
#' 						 fill = as.factor(machine)) )+
#' 	geom_boxplot() +
#'	theme_RTCGA(base_size = 13) +
#' 	coord_flip() +
#' 	theme(legend.position = "top") +
#' 	scale_fill_brewer(palette = "Paired") +
#' 	ggtitle("hsa-mir-101-1")
#' 
#' 
#' @family RTCGA
#' @rdname expressionsTCGA
#' @export
expressionsTCGA <- function(..., extract.cols = NULL, extract.names = TRUE) {
	assert_that(is.null(extract.cols) | is.character(extract.cols))
	assert_that(length(extract.names) == 1, is.logical(extract.names))
	
	
	dots <- list(...)
	lapply(dots, function(x){
		x <- x %>% purrr::map_if(is.factor, as.character)
	}) -> dots
	
	if (extract.names) {
		mapply(rep, 
					 sapply(substitute(list(...))[-1], deparse), 
					 lapply(list(...), nrow)) %>%	unlist %>% as.character -> dataset
		
		if(is.null(extract.cols)) {
			bind_rows(dots) %>%
				mutate(dataset = dataset) %>%
				select(everything())
		} else {
			bind_rows(dots) %>%
				mutate(dataset = dataset) %>%
				select(one_of(c("bcr_patient_barcode",
												"dataset",
												extract.cols)))
		}
	} else {
# 		mapply(rep, 
# 					 sapply(substitute(list(...))[-1], deparse), 
# 					 lapply(list(...), nrow)) %>%	unlist -> dataset
		
		if(is.null(extract.cols)) {
			bind_rows(dots) %>%
# 				mutate(dataset = dataset) %>%
				select(everything())
		} else {
			bind_rows(dots) %>%
		#		mutate(dataset = dataset) %>%
				select(one_of(c("bcr_patient_barcode",
												"dataset",
												extract.cols)))
		}
	}
}