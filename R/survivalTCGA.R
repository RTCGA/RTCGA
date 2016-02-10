## RTCGA package for R
#' @title Extract Survival Information From RTCGA.clinical Datasets
#'
#' @description Function restores codes and counts for each cohort from TCGA project.
#'  
#' @param ... A data.frame or data.frames from TCGA study containing clinical informations. See \link[RTCGA.clinical]{clinical}.
#' 
#' @param extract.cols A character specifing the names of extra columns to be extracted with survival information. 
#' 
#' @param extract.names Logical, whether to extract names of passed data.frames in \code{...}.
#'  
#' @return A data.frame containing information about times and censoring for specific \code{bcr_patient_barcode}.
#' 
#' @note Input data.frames should contain columns \code{patient.bcr_patient_barcode}, 
#' \code{patient.vital_status}, \code{patient.days_to_last_followup}, \code{patient.days_to_death}. 
#' It is recommended to use datasets from \link[RTCGA.clinical]{clinical}.
#' 
#' @examples 
#' 
#' ## Extracting Survival Data
#' library(RTCGA.clinical)
#' survivalTCGA(BRCA.clinical, OV.clinical, extract.cols = "admin.disease_code") -> BRCAOV.survInfo
#' library(dplyr)
#' survivalTCGA(HNSC.clinical, 
#'    extract.cols = c("patient.drugs.drug.therapy_types.therapy_type",
#'    								 "admin.disease_code")) %>%
#'    filter(patient.drugs.drug.therapy_types.therapy_type ==
#'           "chemotherapy")-> HNSC.survInfo
#'           
#' ## Kaplan-Meier Survival Curves
#' library(survminer)
#' library(survival)
#' ggsurvplot(survfit(Surv(times, patient.vital_status)~admin.disease_code,
#' 									 data = BRCAOV.survInfo),
#'					 risk.table = TRUE,
#' 					 ggtheme = theme_RTCGA(base_size = 16,
#' 					 											 base_family = "serif"),
#' 					 break.time.by = 800,
#' 					 palette = c("#FF9E29", "#86AA00"))
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
	
	if (extract.names) {
	 	mapply(rep, 
	 				 sapply(substitute(list(...))[-1], deparse), 
	 				 lapply(list(...), nrow)) %>%	unlist -> dataset
		
		bind_rows(...) %>%
			mutate(dataset = dataset) %>%
			select(one_of(c(extract.cols,
										 "patient.bcr_patient_barcode",
										 "patient.vital_status",
										 "patient.days_to_last_followup",
										 "patient.days_to_death",
										 "dataset"))) %>%
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
						 					"dataset",
						 					"bcr_patient_barcode",
						 					 extract.cols)))
	} else {
		mapply(rep, 
					 sapply(substitute(list(...))[-1], deparse), 
					 lapply(list(...), nrow)) %>%	unlist -> dataset
		
		bind_rows(...) %>%
			#mutate(dataset = dataset) %>%
			select(one_of(c(extract.cols,
											"patient.bcr_patient_barcode",
											"patient.vital_status",
											"patient.days_to_last_followup",
											"patient.days_to_death"))) %>%
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
			filter(times > 0) %>%
			select(one_of(c("times",
											"patient.vital_status",
											
											"bcr_patient_barcode",
											extract.cols)))
	}
}