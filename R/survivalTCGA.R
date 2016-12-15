## RTCGA package for R
#' @title Extract Survival Information from Datasets Included in RTCGA.clinical and RTCGA.clinical.20160128 Packages
#'
#' @description Extracts survival information from clicnial datasets from TCGA project.
#'  
#' @param ... A data.frame or data.frames from TCGA study containing clinical informations. See \link[RTCGA.clinical]{clinical}. 
#' 
#' @param extract.cols A character specifing the names of extra columns to be extracted with survival information. 
#' 
#' @param extract.names Logical, whether to extract names of passed data.frames in \code{...}.
#' 
#' @param barcode.name A character with the name of \code{bcr_patient_barcode} which differs between TCGA releases. 
#' By default is the name from the newest release date \code{tail(checkTCGA('Dates'),1)}.
#' 
#' @param event.name A character with the name of \code{patient.vital_status} which differs between TCGA releases. 
#' By default is the name from the newest release date \code{tail(checkTCGA('Dates'),1)}.
#' 
#' @param days.to.followup.name A character with the name of \code{patient.days_to_last_followup} which differs between TCGA releases. 
#' By default is the name from the newest release date \code{tail(checkTCGA('Dates'),1)}.
#' 
#' @param days.to.death.name A character with the name of \code{patient.days_to_death} which differs between TCGA releases. 
#' By default is the name from the newest release date \code{tail(checkTCGA('Dates'),1)}.
#'    
#' @return A data.frame containing information about times and censoring for specific \code{bcr_patient_barcode}.
#' The name passed in \code{barcode.name} is changed to \code{bcr_patient_barcode}.
#' 
#' 
#' @note Input data.frames should contain columns \code{patient.bcr_patient_barcode}, 
#' \code{patient.vital_status}, \code{patient.days_to_last_followup}, \code{patient.days_to_death} or theyir previous
#' equivalents. 
#' It is recommended to use datasets from \link[RTCGA.clinical]{clinical}.
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
#' @seealso 
#' 
#' \pkg{RTCGA} website \href{http://rtcga.github.io/RTCGA/Visualizations.html}{http://rtcga.github.io/RTCGA/Visualizations.html}.
#'
#' @examples 
#' 
#' ## Extracting Survival Data
#' library(RTCGA.clinical)
#' survivalTCGA(BRCA.clinical, OV.clinical, extract.cols = "admin.disease_code") -> BRCAOV.survInfo
#' 
#' ## Kaplan-Meier Survival Curves
#' kmTCGA(BRCAOV.survInfo, explanatory.names = "admin.disease_code",  pval = TRUE)
#' 
#' kmTCGA(BRCAOV.survInfo, explanatory.names = "admin.disease_code", main = "",
#'        xlim = c(0,4000))
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
#' 
#' kmTCGA(BRCA.survInfo.chemo, explanatory.names = "therapy",
#'        xlim = c(0, 3000), conf.int = FALSE)
#' @author 
#' Marcin Kosinski, \email{m.p.kosinski@@gmail.com}
#' 
#' @family RTCGA
#' @rdname survivalTCGA
#' @export
survivalTCGA <- function(..., extract.cols = NULL, extract.names = FALSE, 
												 barcode.name = "patient.bcr_patient_barcode",
												 event.name = "patient.vital_status",
												 days.to.followup.name = "patient.days_to_last_followup",
												 days.to.death.name = "patient.days_to_death"
												 ) {
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
		select(one_of(
			c(extract.cols,
				barcode.name,
				event.name,
				days.to.followup.name,
				days.to.death.name,
				dataset_or_not)
			)
		) %>%
		mutate_(.dots = setNames(paste0("toupper(as.character(",barcode.name,"))"),
														 'bcr_patient_barcode')) %>%
		#mutate(bcr_patient_barcode = toupper(as.character(patient.bcr_patient_barcode))) %>%
		mutate_(.dots = setNames(paste0("ifelse(as.character(", event.name, ") %in% c('dead', 'deceased'),1,0)"),
														 event.name)) %>%
		mutate_(.dots = setNames(paste0('ifelse(!is.na(', days.to.followup.name, '),',
														 'as.numeric(as.character(',days.to.followup.name, ')),',
														 'as.numeric(as.character(',days.to.death.name,')))'),
														 'times')) %>%
		# mutate(patient.vital_status = ifelse(patient.vital_status %>%
		# 							as.character() %in% c("dead", "deceased"),1,0),
		# 	  times = ifelse( !is.na(patient.days_to_last_followup),
		#  								patient.days_to_last_followup %>%
		#  									as.character() %>%
		#  									as.numeric(),
		#  								patient.days_to_death %>%
		#  									as.character() %>%
		#  									as.numeric() ) ) %>%
		filter(!is.na(times)) %>%
		select(one_of(c("times",
	 					'bcr_patient_barcode',
	 					dataset_or_not,
	 					event.name,
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

