## RTCGA package for R
#' @title Extract Survival Information From RTCGA.clinical Datasets
#'
#' @description Extracts survival information from clicnial datasets from TCGA project.
#'  
#' @param ... A data.frame or data.frames from TCGA study containing clinical informations. See \link[RTCGA.clinical]{clinical}. 
#' 
#' @param extract.cols A character specifing the names of extra columns to be extracted with survival information. 
#' 
#' @param extract.names Logical, whether to extract names of passed data.frames in \code{...}.
#' 
#'    
#' @return A data.frame containing information about times and censoring for specific \code{bcr_patient_barcode}.
#' 
#' 
#' @note Input data.frames should contain columns \code{patient.bcr_patient_barcode}, 
#' \code{patient.vital_status}, \code{patient.days_to_last_followup}, \code{patient.days_to_death}. 
#' It is recommended to use datasets from \link[RTCGA.clinical]{clinical}.
#' 
#' @author 
#' Marcin Kosinski, \email{m.p.kosinski@@gmail.com}
#'
#' @examples 
#' 
#' ## Extracting Survival Data
#' library(RTCGA.clinical)
#' survivalTCGA(BRCA.clinical, OV.clinical, extract.cols = "admin.disease_code") -> BRCAOV.survInfo
#' 
#' # first munge data, then extract survival info
#' library(dplyr)
#' BRCA.clinical %>%
#'     filter(patient.drugs.drug.therapy_types.therapy_type %in%
#'                c("chemotherapy", "hormone therapy")) %>%
#'     rename(therapy = patient.drugs.drug.therapy_types.therapy_type) %>%
#'     survivalTCGA(extract.cols = c("therapy"))  -> BRCA.survInfo.chemo
#'                  
#' # first extract survival info, then munge data                  
#'     survivalTCGA(BRCA.clinical, 
#'                  extract.cols = c("patient.drugs.drug.therapy_types.therapy_type"))  %>%
#'     filter(patient.drugs.drug.therapy_types.therapy_type %in%
#'                c("chemotherapy", "hormone therapy")) %>%
#'     rename(therapy = patient.drugs.drug.therapy_types.therapy_type) -> BRCA.survInfo.chemo
#' 
#' ## Kaplan-Meier Survival Curves
#' kmTCGA(BRCAOV.survInfo, explanatory.names = "admin.disease_code",  pval = TRUE)
#' 
#' kmTCGA(BRCAOV.survInfo, explanatory.names = "admin.disease_code", main = "",
#'        xlim = c(0,4000))
#'  
#' kmTCGA(BRCA.survInfo.chemo, explanatory.names = "therapy", xlim = c(0, 3000), conf.int = FALSE)
#' 
#' @author 
#' Marcin Kosinski, \email{m.p.kosinski@@gmail.com}
#' 
#' @family RTCGA
#' @rdname survivalTCGA
#' @export
survivalTCGA <- function(..., extract.cols = NULL, extract.names = FALSE) {
	assert_that(is.null(extract.cols) | is.character(extract.cols))
	assert_that(length(extract.names) == 1, is.logical(extract.names))
	

 	mapply(rep, 
 		  sapply(substitute(list(...))[-1], deparse), 
 		  lapply(list(...), nrow)) %>%	unlist -> dataset
	
 	if (extract.names){
 	    dataset_or_not <- "dataset"
 	} else {
 	    dataset_or_not <- NULL
 	}

	bind_rows(...) %>%
		mutate(dataset = dataset) %>%
		select(one_of(c(extract.cols,
					 "patient.bcr_patient_barcode",
					 "patient.vital_status",
					 "patient.days_to_last_followup",
					 "patient.days_to_death",
					 dataset_or_not)
					 )) %>%
		mutate(bcr_patient_barcode = toupper(as.character(patient.bcr_patient_barcode))) %>%
		mutate(patient.vital_status = ifelse(patient.vital_status %>%
									as.character() =="dead",1,0),
			  times = ifelse( !is.na(patient.days_to_last_followup),
		 								patient.days_to_last_followup %>%
		 									as.character() %>%
		 									as.numeric(),
		 								patient.days_to_death %>%
		 									as.character() %>%
		 									as.numeric() ) ) %>%
		filter(!is.na(times)) %>%
		select(one_of(c("times",
	 					"patient.vital_status",
	 					dataset_or_not,
	 					"bcr_patient_barcode",
	 					 extract.cols))) %>%
	    mutate(times = as.numeric(times)) %>%
	    as.data.frame() #-> survData
# 	class(survData) <- c("survivalTCGA", class(survData))
# 	attr(survData, "status") <- "patient.vital_status"
# 	attr(survData, "times") <- "times"
# 	attr(survData, "explanatory.names") <- ifelse(length(c(extract.cols, dataset_or_not)) !=0,
# 	                                              c(extract.cols, dataset_or_not),
# 	                                              "1")
	                                              
	#survData
}

