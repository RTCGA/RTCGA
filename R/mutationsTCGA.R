## RTCGA package for R
#' @title Gather Mutations for TCGA Datasets
#'
#' @description Function gathers mutations over multiple TCGA datasets and extracts mutations and further informations about them for desired genes.
#' See \link[RTCGA.mutations]{mutations}.
#'  
#' @param ... A data.frame or data.frames from TCGA study containing mutations information (\pkg{RTCGA.mutations}). 
#' 
#' @param extract.names Logical, whether to extract names of passed data.frames in \code{...}.
#' 
#' @param extract.cols A character specifing the names of columns to be extracted with \code{bcr_patient_barcode}. 
#' If \code{NULL} all columns are returned.
#' 
#' @param unique Should the outputed data be \link{unique}. By default it's \code{TRUE}.
#' 
#' @note Input data.frames should contain column \code{bcr_patient_barcode} if \code{extract.cols} is specified. 
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
#' library(RTCGA.mutations)
#' library(dplyr)
#' mutationsTCGA(BRCA.mutations, OV.mutations) %>%
#'   filter(Hugo_Symbol == 'TP53') %>%
#'   filter(substr(bcr_patient_barcode, 14, 15) == "01") %>% # cancer tissue
#'   mutate(bcr_patient_barcode = substr(bcr_patient_barcode, 1, 12)) -> BRCA_OV.mutations
#' 
#' library(RTCGA.clinical)
#' survivalTCGA(BRCA.clinical, OV.clinical, extract.cols = "admin.disease_code") %>%
#'   rename(disease = admin.disease_code)-> BRCA_OV.clinical
#'
#' BRCA_OV.clinical %>%
#'   left_join(BRCA_OV.mutations,
#'   by = "bcr_patient_barcode") %>%
#'   mutate(TP53 = ifelse(!is.na(Variant_Classification), "Mut",
#'  "WILDorNOINFO")) -> BRCA_OV.clinical_mutations
#' 
#' BRCA_OV.clinical_mutations %>%
#'   select(times, patient.vital_status, disease, TP53) -> BRCA_OV.2plot
#' kmTCGA(BRCA_OV.2plot, explanatory.names = c("TP53", "disease"),
#'        break.time.by = 400, xlim = c(0,2000))
#' 
#' @family RTCGA
#' @rdname mutationsTCGA
#' @export
mutationsTCGA <- function(..., extract.cols = c('Hugo_Symbol', 'Variant_Classification', 'bcr_patient_barcode'),
                          extract.names = TRUE, unique = TRUE) {
  if (extract.names) {
    mapply(rep, 
           sapply(substitute(list(...))[-1], deparse), 
           lapply(list(...), nrow)) %>%  unlist %>% as.character -> datasets
    
    expressionsTCGA(..., extract.cols = extract.cols, extract.names = FALSE) %>%
      mutate(dataset = datasets) -> d2return
  } else {
    expressionsTCGA(..., extract.cols = extract.cols, extract.names = FALSE) -> d2return
  }

  if (unique)
    return(unique(d2return))
  else
    d2return

}
