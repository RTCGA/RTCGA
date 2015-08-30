## ---- echo=FALSE, message=FALSE, warning = FALSE----------------------------------------------------------------------------------------------------
library(knitr)
opts_chunk$set(comment="", message=FALSE, warning = FALSE, tidy.opts=list(keep.blank.line=TRUE, width.cutoff=150),options(width=150), eval = FALSE)

## ---------------------------------------------------------------------------------------------------------------------------------------------------
#  

## ---- eval=FALSE------------------------------------------------------------------------------------------------------------------------------------
#  source("https://bioconductor.org/biocLite.R")
#  biocLite("RTCGA.clinical")
#  biocLite("RTCGA.rnaseq")
#  biocLite("RTCGA.mutations")
#  biocLite("RTCGA.cnv")

## ---- echo=FALSE, eval = FALSE, results='asis'------------------------------------------------------------------------------------------------------
#  library(dplyr)
#  library(XML)
#  library(stringi)
#  readHTMLTable("http://gdac.broadinstitute.org/") -> df
#   info <- df[[39]][,1:3]
#  
#  # this function produces information correspoding to Table nr 1
#  
#  show_dims_RTCGA <- function( package_name ){
#     data(package = paste0("RTCGA.", package_name))$results[,3] %>%
#        sapply( function(element){
#           #get(element, envir = .GlobalEnv) %>% dim()
#           data(list=element,
#                package = paste0("RTCGA.", package_name),
#                envir = .GlobalEnv)
#           get(element, envir = .GlobalEnv) %>% dim() -> res
#           rm(list = element, envir = .GlobalEnv)
#           return(res)
#        }) %>% t -> df
#  
#      df_dims <- data.frame( "Cohort" =
#                                      stri_extract_all_regex(row.names(df),
#                                                  pattern = paste0("[^\\.",package_name,"]")) %>%
#                                                  lapply( stri_flatten) %>%
#                                                  unlist,
#                                  package_name = paste0(df[,1]," x ",df[,2])
#      )
#      names(df_dims)[2] <- package_name
#      return(df_dims)
#  }
#  
#  library(RTCGA.clinical)
#  library(RTCGA.rnaseq)
#  library(RTCGA.mutations)
#  library(RTCGA.cnv)
#  library(pander)
#  left_join( x = info , y = show_dims_RTCGA("clinical"), by = "Cohort") %>%
#     left_join( y = show_dims_RTCGA("cnv"), by="Cohort") %>%
#     left_join( y = show_dims_RTCGA("mutations"), by="Cohort") %>%
#     left_join( y = show_dims_RTCGA("rnaseq"), by="Cohort") %>%
#     pandoc.table()
#  

## ---- eval = FALSE----------------------------------------------------------------------------------------------------------------------------------
#  library(RTCGA.clinical)
#  library(RTCGA.rnaseq)
#  library(RTCGA.mutations)
#  library(RTCGA.cnv)

## ---- eval = FALSE----------------------------------------------------------------------------------------------------------------------------------
#  ?clinical
#  ?rnaseq
#  ?mutations
#  ?cnv

## ---- eval = FALSE----------------------------------------------------------------------------------------------------------------------------------
#  data(cohort.package)

## ---- eval = FALSE----------------------------------------------------------------------------------------------------------------------------------
#  library(dplyr)
#  library(RTCGA.clinical)
#  #library(devtools);biocLite("mi2-warsaw/RTCGA.tools")
#  library(RTCGA.tools)
#  library(survival)
#  library(survMisc)
#  
#  LUAD.clinical %>%
#     mutate(
#        patient.vital_status = ifelse(LUAD.clinical$patient.vital_status %>% as.character() =="dead",1,0),
#        barcode = patient.bcr_patient_barcode %>% as.character(),
#        times = ifelse( !is.na(patient.days_to_last_followup),
#                   patient.days_to_last_followup %>% as.character() %>% as.numeric(),
#                   patient.days_to_death %>% as.character() %>% as.numeric() ),
#        stage = RTCGA.tools::mergeStages(LUAD.clinical$patient.stage_event.pathologic_stage)
#     ) %>%
#     rename(
#        therapy = patient.drugs.drug.therapy_types.therapy_type
#     ) %>%
#     filter( !is.na(times) ) -> LUAD.clinical.selected
#  
#  LUAD.clinical.selected %>%
#     survfit( Surv(times, patient.vital_status) ~ stage, data = .) %>%
#     survMisc:::autoplot.survfit( titleSize=12, type="CI" ) %>%
#     .[[2]] -> km_plot_luad
#  km_plot_luad

## ---- eval = FALSE, warning=FALSE-------------------------------------------------------------------------------------------------------------------
#  library(RTCGA.mutations)
#  library(ggthemes)
#  LUAD.clinical.selected %>%
#        left_join( y = LUAD.mutations %>%
#                      filter( Hugo_Symbol == "TP53") %>%
#                      mutate( barcode = barcode %>% as.character %>% tolower %>% substr(1,12) ) %>%
#                      select( barcode, Variant_Classification),
#                   by = "barcode") %>%
#                      mutate( Variant_Classification = divideTP53(Variant_Classification) ) ->
#     LUAD.clinical.mutations.selected
#  
#  (coxph(Surv(times, patient.vital_status)~ as.factor(stage)+Variant_Classification,
#        data = LUAD.clinical.mutations.selected) -> LUAD.coxph)

## ---- eval = FALSE----------------------------------------------------------------------------------------------------------------------------------
#  
#  qplot(predict(LUAD.coxph, type="lp"),residuals(LUAD.coxph))+
#     theme_tufte(base_size=20)+
#     xlab("Linear combinations")+
#     ylab("Martingale residuals")+
#     geom_hline(yintercept=0, col ="orange", size = 3)
#  

## ---- eval = FALSE----------------------------------------------------------------------------------------------------------------------------------
#  rbind(ACC.rnaseq, CHOL.rnaseq, GBM.rnaseq, PCPG.rnaseq, UVM.rnaseq) -> rnaseq_sample
#  # which columns contain only zeros
#  rnaseq_sample[,-1] %>% colSums() -> rnaseq_col_sums
#  which(rnaseq_col_sums == 0) -> columns_with_only0
#  # pca
#  rnaseq_sample[, -c(1,columns_with_only0+1)] %>%
#     prcomp( scale = TRUE ) -> PCA
#  # labels for pca
#  lapply(list(ACC.rnaseq, CHOL.rnaseq, GBM.rnaseq, PCPG.rnaseq, UVM.rnaseq), nrow) -> rnaseq_nrow
#  mapply(rep,
#         c("ACC.rnaseq", "CHOL.rnaseq", "GBM.rnaseq", "PCPG.rnaseq", "UVM.rnaseq"),
#         rnaseq_nrow) %>%
#     unlist -> rnaseq_pca_labels
#  # biplot
#  #library(devtools);install_github("vqv/ggbiplot")
#  library(ggbiplot)
#  rownames(PCA$rotation) <- 1:nrow(PCA$rotation)
#  ggbiplot(PCA, obs.scale = 1, var.scale = 1,
#    groups = rnaseq_pca_labels, ellipse = TRUE, circle = TRUE, var.axes=FALSE) +
#    theme(legend.direction = 'horizontal', legend.position = 'top') -> biplot_rnaseq
#  biplot_rnaseq

## ---- eval=FALSE------------------------------------------------------------------------------------------------------------------------------------
#  [1] http://cancergenome.nih.gov/
#  
#  [2] http://gdac.broadinstitute.org/
#  
#  [3] http://cran.r-project.org/bin/windows/Rtools/
#  
#  [4] https://wiki.nci.nih.gov/display/TCGA/TCGA+barcode
#  
#  [9] Cox D. R., (1972) \textit{Regression models and life-tables (with discussion)}, Journal of the Royal Statistical Society Series B 34:187-220.
#  
#  [5]  Kaplan, E. L.; Meier, P. (1958). "Nonparametric estimation from incomplete observations". J. Amer. Statist. Assn. 53 (282): 457-481. JSTOR 2281868.
#  
#  

