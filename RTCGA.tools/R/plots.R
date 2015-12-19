#' 
#' Plot functions
#'
#' Plot functions
#' 
#' @examples
#' 
#' \dontrun{
#' library(RTCGA.clinical)
#' clinicalStageSurvival(LUAD.clinical, xlims = c(0,2000))
#' 
#' library(RTCGA.rnaseq)
#' rnaseqBiplot(cohorts = c("ACC", "CHOL", "GBM", "PCPG", "UVM"))
#' 
#' library(RTCGA.mutations)
#' mutationsBox(c("BRCA", "HNSC", "LUSC", "PRAD", "STES"),
#'  "TP53", "MDM2")
#'  mutationsBox(c("BRCA", "HNSC", "LUSC", "PRAD", "STES"),
#'   "TP53", "ETF1")
#' }
#' 
#' @family RTCGA.tools
#' @import dplyr
#' @import ggplot2
#' @import scales
#' @import survMisc
#' @import survival
#' @import ggthemes
#' @import stringi
#' @import ggbiplot
#' @rdname plots
#' @export
clinicalStageSurvival <- function(clinical, xlims = c(0,2000),
                                  title = "Marks show times with censoring"){
   stopifnot(is.data.frame(clinical) & all(dim(clinical) > 0))
   stopifnot(is.character(title) & length(title) == 1)
   stopifnot(c("patient.vital_status",
               "patient.days_to_last_followup",
               "patient.days_to_death",
               "patient.stage_event.pathologic_stage") %in% names(clinical))
   
   clinical %>%
   mutate(
      patient.vital_status = ifelse(LUAD.clinical$patient.vital_status %>%
                                       as.character() =="dead",1,0),
      barcode = patient.bcr_patient_barcode %>% as.character(),
      times = ifelse( !is.na(patient.days_to_last_followup),
                 patient.days_to_last_followup %>% as.character() %>% as.numeric(),
                 patient.days_to_death %>% as.character() %>% as.numeric() ),
      stage = stri_extract_all_regex(LUAD.clinical$patient.stage_event.pathologic_stage,
                                     pattern = "i|v") %>%
         lapply(stri_flatten) %>%
         unlist %>%
         toupper()
   ) %>%
      filter(!is.na(stage),
             !is.na(times)) %>%
   survfit( Surv(times, patient.vital_status) ~ stage, data = .) %>%
   survMisc:::autoplot.survfit( titleSize=12, type="CI", palette = "Set1",
                                alpha = 0.7, survLineSize=2,
                                pX = 0.3, sigP =3, title = title ) -> km_plot
   km_plot[[1]] <- km_plot[[1]] +
      scale_x_continuous(breaks=c(seq(xlims[1], xlims[2], by = round((xlims[2] - xlims[1])/4,0)),10000)) +
      coord_cartesian(xlim = c(xlims[1]-150,xlims[2]+150)) +
      theme_bw(base_size = 22, base_family = "serif") + 
        theme(legend.background = element_blank(), legend.key = element_blank(), 
            panel.background = element_blank(), panel.border = element_blank())
   
   km_plot[[2]] <- km_plot[[2]] +
      scale_x_continuous(breaks=c(seq(xlims[1], xlims[2],
                                      by = round((xlims[2] - xlims[1])/4,0)),10000)) +
      coord_cartesian(xlim = xlims)+
      theme_bw(base_size = 22, base_family = "serif") + 
        theme(legend.background = element_blank(), legend.key = element_blank(), 
            panel.background = element_blank(), panel.border = element_blank())
      
   
   survMisc::autoplot(km_plot)
      
}


#' @export
rnaseqBiplot <- function(cohorts, pointSize = 4, axisBreaks = 5, title = ""){
   stopifnot(is.character(cohorts) & length(cohorts) > 1)
   stopifnot(is.character(title) & length(title) == 1)
   stopifnot(paste0(cohorts,".rnaseq") %in% data(package = "RTCGA.rnaseq")$results[,3])
   stopifnot(is.numeric(pointSize) & length(pointSize) == 1)
   stopifnot(is.numeric(axisBreaks) & length(axisBreaks) == 1)
   
   cohorts_list <- list()
   for(i in cohorts){
      data(list=paste0(i, ".rnaseq"), 
           package = "RTCGA.rnaseq",
           envir = .GlobalEnv)
      cohorts_list[[i]] <- get(paste0(i, ".rnaseq"), envir = .GlobalEnv)
   }
   # concatenate to 1 file
   do.call(rbind, cohorts_list) -> rnaseq_sample
   
   # which columns contain only zeros
   rnaseq_sample[,-1] %>% colSums() -> rnaseq_col_sums
   which(rnaseq_col_sums == 0) -> columns_with_only0
   # pca
   rnaseq_sample[, -c(1,columns_with_only0+1)] %>%
      prcomp( scale = TRUE ) -> PCA
   # labels for pca
   lapply(cohorts_list, nrow) -> rnaseq_nrow
   mapply(rep, 
          cohorts, 
          rnaseq_nrow) %>%
      unlist -> rnaseq_pca_labels
   # biplot
   #library(devtools);install_github("vqv/ggbiplot")
   
   rownames(PCA$rotation) <- 1:nrow(PCA$rotation)
   ggbiplot(PCA, obs.scale = 1, var.scale = 1,
            groups = rnaseq_pca_labels, ellipse = TRUE, circle = TRUE,
            var.axes=FALSE, alpha = 0.2)  -> biplot_rnaseq 
   
   biplot_rnaseq + theme_bw(base_size = 22, base_family = "serif") + 
      theme(legend.background = element_blank(), legend.key = element_blank(), 
            panel.background = element_blank(), panel.border = element_blank(),
            legend.direction = 'horizontal', legend.position = 'top') +
      geom_point(size=pointSize, aes(colour = rnaseq_pca_labels)) +
      scale_color_brewer(palette = "Set1", guide = guide_legend(title = "Cohorts")) +
      scale_y_continuous(breaks=seq(round(range(PCA$x[,2]),digits = -1)[1],
                                    round(range(PCA$x[,2]),digits = -1)[2],
                                    length.out = axisBreaks)) +
      scale_x_continuous(breaks=seq(round(range(PCA$x[,1]),digits = -1)[1],
                                    round(range(PCA$x[,1]),digits = -1)[2],
                                    length.out = axisBreaks)) +
      geom_abline(slope =  0, intercept =0, linetype = 2, alpha = 0.5) +
      geom_vline(xintercept = 0, linetype = 2, alpha = 0.5) +
      ggtitle(title)
   
}

#' @export
mutationsBox <- function(cohorts, mutationGene, expressionGene, alpha = 0.2, 
                                       title = "", coef = 10e6){
   stopifnot(is.character(cohorts) & length(cohorts) > 1)
   stopifnot(paste0(cohorts,".rnaseq") %in% data(package = "RTCGA.rnaseq")$results[,3])
   stopifnot(paste0(cohorts,".mutations") %in% data(package = "RTCGA.mutations")$results[,3])
   stopifnot(is.character(title) & length(title) == 1)
   stopifnot(is.numeric(coef) & length(coef) == 1)
   
   cohorts_list_rnaseq <- list()
   for(i in cohorts){
      data(list=paste0(i, ".rnaseq"), 
           package = "RTCGA.rnaseq",
           envir = .GlobalEnv)
      cohorts_list_rnaseq[[i]] <- get(paste0(i, ".rnaseq"), envir = .GlobalEnv) %>%
         select(contains(expressionGene), bcr_patient_barcode)
   }
   # concatenate to 1 file
   do.call(rbind, cohorts_list_rnaseq) -> rnaseq_sample
   
   
   lapply(cohorts_list_rnaseq, nrow) -> rnaseq_nrow
   mapply(rep, 
          cohorts, 
          rnaseq_nrow) %>%
      unlist -> rnaseq_labels
   
   
   cohorts_list_mutations <- list()
   for(i in cohorts){
      data(list=paste0(i, ".mutations"), 
           package = "RTCGA.mutations",
           envir = .GlobalEnv)
      cohorts_list_mutations[[i]] <- get(paste0(i, ".mutations"), envir = .GlobalEnv) %>%
         filter(Hugo_Symbol == mutationGene) %>%
         select(Variant_Classification, bcr_patient_barcode) %>%
         rename(mutations_Gene = Variant_Classification)
      
   }
   # concatenate to 1 file
   do.call(rbind, cohorts_list_mutations) -> mutations_sample
   
   left_join(rnaseq_sample %>%
                mutate(bcr_patient_barcode = substr(bcr_patient_barcode,1,12),
                       Cohort = rnaseq_labels),
             mutations_sample%>%
                mutate(bcr_patient_barcode = substr(bcr_patient_barcode,1,12)),
             by = "bcr_patient_barcode") -> joined_sample
   
   joined_sample %>%
      group_by(mutations_Gene) %>%
      summarise(count = n()) %>%
      arrange(desc(count)) %>%
      top_n(2,count)%>%
      select(mutations_Gene)%>%
      unlist -> most_2_popular
   
   most_2_popular[is.na(most_2_popular)] <- "Wild"
   
   joined_sample[is.na(joined_sample[,4]), 4] <- "Wild"
   
   joined_sample %>%
      mutate(mutations_Gene = 
                ifelse(mutations_Gene == most_2_popular[1],
                                     mutations_Gene, ifelse(mutations_Gene == most_2_popular[2],
                                                            mutations_Gene,"Other"))) -> d2viz
   names(d2viz)[1] <- "expressionGene"
   
   
   breaksS <- round(range(d2viz[,1]), 0)
   round(10^(round(seq(log10(breaksS)[1], log10(breaksS)[2], length.out = 7),2)), -3) %>%
      unique() -> breaksS
   
   breaksS[which(breaksS == 0)] <-1
   
   d2viz %>%
      ggplot() +
      geom_boxplot(aes(y = expressionGene, x = mutations_Gene,
                       fill = mutations_Gene), coef = coef) +
      theme_bw(base_size = 22, base_family = "serif") + 
      theme(legend.background = element_blank(), legend.key = element_blank(), 
            panel.background = element_blank(), panel.border = element_blank(),
            legend.direction = 'horizontal', legend.position = 'top') +
      geom_jitter(aes(y = expressionGene, x = mutations_Gene), alpha = alpha,
                  position = position_jitter(width = 0.25)) +
      scale_y_log10(breaks = breaksS, labels = comma(breaksS, digits = 1)) +
      coord_flip() +
      scale_fill_brewer(palette = "Set1", guide = guide_legend(title = "Levels"))+
      ylab(paste0("log10 of ",expressionGene)) +
      xlab(paste0(mutationGene)) + facet_grid(Cohort~.) +
      ggtitle(title)
   
}