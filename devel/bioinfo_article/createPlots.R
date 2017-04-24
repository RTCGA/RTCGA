# script for plots included in the article

#### installations ####

# source("https://bioconductor.org/biocLite.R")
# biocLite("BiocInstaller")
# # 1) library(devtools); install_github('RTCGA/RTCGA') # dev installation
# # 2) biocLite("RTCGA") # release installation
# 
# biocLite("RTCGA.mutations")
# biocLite("RTCGA.clinical")
# 
# devtools::install_github('cttobin/ggthemr')
# install_github('kassambara/survminer')
#### theme set up ####

library(RTCGA)
library(ggthemr)
ggthemr('dust')

#### survival curves ####

library(RTCGA.mutations)
library(dplyr)
# library(survminer)
mutationsTCGA(BRCA.mutations, OV.mutations) %>%
  filter(Hugo_Symbol == 'TP53') %>%
  filter(substr(bcr_patient_barcode, 14, 15) ==
           "01") %>% # cancer tissue
  mutate(bcr_patient_barcode =
           substr(bcr_patient_barcode, 1, 12)) ->
  BRCA_OV.mutations

library(RTCGA.clinical)
survivalTCGA(
  BRCA.clinical,
  OV.clinical,
  extract.cols = "admin.disease_code"
) %>%
  dplyr::rename(disease = admin.disease_code) ->
  BRCA_OV.clinical

BRCA_OV.clinical %>%
  left_join(
    BRCA_OV.mutations,
    by = "bcr_patient_barcode"
  ) %>%
  mutate(TP53 =
           ifelse(!is.na(Variant_Classification), "Mut","WILDorNOINFO")) ->
  BRCA_OV.clinical_mutations

BRCA_OV.clinical_mutations %>%
  select(times, patient.vital_status, disease, TP53) -> BRCA_OV.2plot

kmTCGA(
  BRCA_OV.2plot,
  explanatory.names = c("TP53", "disease"),
  break.time.by = 400,
  xlim = c(0,2000),
  pval = TRUE,
  tables.height = 0.4,
  ggtheme = NULL) -> km_plot
  #ggtheme set with ggthemr
km_plot$plot <- km_plot$plot + guides(col=guide_legend(nrow=2,bycol=TRUE))

pdf("devel/bioinfo_article/figures/surv.pdf", width = 10*2/3, height = 9*2/3, onefile=FALSE)
print(km_plot)
dev.off()

#### PCA ####

library(RTCGA.rnaseq)
# library(dplyr) if did not load at start
expressionsTCGA(BRCA.rnaseq, OV.rnaseq, HNSC.rnaseq) %>%
  dplyr::rename(cohort = dataset) %>%  
  filter(substr(bcr_patient_barcode, 14, 15) == "01") -> BRCA.OV.HNSC.rnaseq.cancer
pcaTCGA(BRCA.OV.HNSC.rnaseq.cancer, "cohort", ggtheme = NULL) -> pca_plot
pdf("devel/bioinfo_article/figures/pca.pdf", width = 10*2/3, height = 9*2/3, onefile=FALSE)
pca_plot + theme(legend.position = "top")
dev.off()


#### boxplots ####
# library(RTCGA.rnaseq)
# # perfrom plot
# # library(dplyr) if did not load at start
# expressionsTCGA(
#   ACC.rnaseq,
#   BLCA.rnaseq,
#   BRCA.rnaseq,
#   OV.rnaseq,
#   extract.cols = "MET|4233"
# ) %>%
#   dplyr::rename(
#     cohort = dataset,
#     MET = `MET|4233`
#   ) %>%  #cancer samples
#   filter(
#     substr(bcr_patient_barcode, 14, 15) == "01" 
#   ) -> ACC_BLCA_BRCA_OV.rnaseq
# boxplotTCGA(
#   ACC_BLCA_BRCA_OV.rnaseq,
#   "reorder(cohort,log1p(MET), median)",
#   "log1p(MET)",
#   xlab = "Cohort Type",
#   ylab = "Logarithm of MET",
#   legend.title = "Cohorts",
#   legend = "bottom",
#   ggtheme = NULL
# ) -> boxplot1
# 
# 
# pdf("devel/bioinfo_article/figures/boxplot.pdf", width = 10*2/3, height = 9*2/3, onefile=FALSE)
# boxplot1 + theme(legend.position = "top")
# dev.off()