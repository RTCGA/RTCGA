## RTCGA package for R
#' @title Extract Survival Information From RTCGA.clinical Datasets
#'
#' @description Function restores codes and counts for each cohort from TCGA project.
#'  
#' @param ... A data.frame or data.frames containing from TCGA study containing clinical informations. See \link[RTCGA.clinical]{clinical}.
#' 
#' @param extra.cols A character specifing the names of extra columns to be extracted with survival information. 
#'  
#' @return A data.frame containing information about times and censoring for specific \code{bcr_patient_barcode}.
#' 
#' @note Input data.frames should contain columns \code{patient.bcr_patient_barcode}, 
#' \code{patient.vital_status}, \code{patient.days_to_last_followup}, \code{patient.days_to_death}. 
#' It is recommended to use datasets from \link[RTCGA.clinical]{clinical}.
#' 
#' @examples 
#' 
#' library(RTCGA.clinical)
#' survivalTCGA(BRCA.clinical, OV.clinical) -> BRCAOV.survInfo
#' library(dplyr)
#' survivalTCGA(HNSC.clinical, 
#'    extra.cols = "patient.drugs.drug.therapy_types.therapy_type") %>%
#'    filter(patient.drugs.drug.therapy_types.therapy_type ==
#'           "chemotherapy")-> HNSC.survInfo
#' 
#' @family RTCGA
#' @rdname survivalTCGA
#' @export
survivalTCGA <- function(..., extra.cols = NULL) {
	assert_that(is.null(extra.cols) | is.character(extra.cols))
	bind_rows(...) %>%
			select_(ifelse(is.null(extra.cols), "patient.bcr_patient_barcode", extra.cols),
							"patient.bcr_patient_barcode",
							"patient.vital_status",
							"patient.days_to_last_followup",
							"patient.days_to_death") %>%
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
		select_("times",
						"patient.vital_status",
						"bcr_patient_barcode",
						ifelse(is.null(extra.cols), "bcr_patient_barcode", extra.cols))
		
}