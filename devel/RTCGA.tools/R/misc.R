#' 
#' Misc functions
#'
#' Misc functions
#'
#' @family RTCGA.tools
#' @rdname misc
#' @export
mergeStages <- function( patient.stage_event.pathologic_stage ){
   levels(patient.stage_event.pathologic_stage) <- c(rep("1",3), rep("2",3), 
                                                     rep("3",2), "4")
   patient.stage_event.pathologic_stage %>%
      as.character %>% as.numeric()
}

#' @export
divideTP53 <- function( TP53 ){
   TP53 <- as.character(TP53)
   TP53 <- ifelse( (TP53  %in% c("")) | is.na(TP53), 
                   "WILD", 
                   TP53 )
   TP53 <- ifelse( grepl( "Misse", TP53 ), 
                   "Missense", 
                   TP53 )
   TP53 <- ifelse( !( TP53 %in% c("WILD", "Missense", NA) ),
                   "Other",
                   TP53 )
   return(TP53)
}