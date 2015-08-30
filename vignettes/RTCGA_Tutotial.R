## ---- echo=FALSE------------------------------------------------------------------------------------------------------------------------------------
library(knitr)
opts_chunk$set(comment="", message=FALSE, warning = FALSE, tidy.opts=list(keep.blank.line=TRUE, width.cutoff=150),options(width=150))

## ---- eval=FALSE------------------------------------------------------------------------------------------------------------------------------------
#  source("http://bioconductor.org/biocLite.R")
#  biocLite("RTCGA")

## ---- eval=FALSE------------------------------------------------------------------------------------------------------------------------------------
#  if (!require(devtools)) {
#      install.packages("devtools")
#      library(devtools)
#  }
#  biocLite("MarcinKosinski/RTCGA")

## ---------------------------------------------------------------------------------------------------------------------------------------------------
library(RTCGA)
releaseDate <- tail( checkTCGA('Dates'), 2 )[1]
# if server doesn't respond, just try
# date <- "2015-06-01"

## ---- echo=4----------------------------------------------------------------------------------------------------------------------------------------
if(file.exists("data")){
    unlink("data", recursive = TRUE, force = TRUE)
}
dir.create("data")

## ---------------------------------------------------------------------------------------------------------------------------------------------------
downloadTCGA( cancerTypes = "ACC", destDir = "data", date = releaseDate )

## ---------------------------------------------------------------------------------------------------------------------------------------------------
downloadTCGA( cancerTypes = "ACC", destDir = "data", date = releaseDate,
              dataSet = "rnaseqv2__illuminahiseq_rnaseqv2__unc_edu__Level_3__RSEM_genes_normalized__data.Level" )
# one can check all available dataSets' names with
# checkTCGA('DataSets')

## ---------------------------------------------------------------------------------------------------------------------------------------------------
downloadTCGA( cancerTypes = "ACC", destDir = "data", date = releaseDate,
              dataSet = "Mutation_Packager_Calls.Level" )

## ---- warning=FALSE, results='hide', eval=FALSE-----------------------------------------------------------------------------------------------------
#  
#  list.files( "data/") %>%
#     file.path( "data", .) %>%
#     sapply( untar, exdir = "data/" )
#  

## ---- results='hide', eval=FALSE--------------------------------------------------------------------------------------------------------------------
#  list.files( "data/") %>%
#     file.path( "data", .) %>%
#     grep( pattern = "tar.gz", x = ., value = TRUE) %>%
#     sapply( file.remove )

## ---------------------------------------------------------------------------------------------------------------------------------------------------
list.files( "data/") %>% 
   file.path( "data", .) %>%
   grep("rnaseq", x = ., value = TRUE) %>%    
   file.rename( to = substr(.,start=1,stop=50))

## ---------------------------------------------------------------------------------------------------------------------------------------------------
list.files("data/") %>%
    grep("Clinical", x = ., value = TRUE) %>%
    file.path("data", .)  -> folder

folder %>%
    list.files() %>%
    grep("clin.merged", x = ., value=TRUE) %>%
    file.path(folder, .) %>%
    readTCGA(path = ., "clinical") -> BRCA.clinical

dim(BRCA.clinical)

## ---------------------------------------------------------------------------------------------------------------------------------------------------
list.files("data/") %>%
    grep("rnaseq", x = ., value = TRUE) %>%
    file.path("data", .) -> folder

folder %>%
    list.files() %>%
    grep("illumina", x = ., value=TRUE) %>%
    file.path(folder, .) %>%
    readTCGA(path = ., "rnaseq") -> BRCA.rnaseq

dim(BRCA.rnaseq)

## ---- results='hide'--------------------------------------------------------------------------------------------------------------------------------
list.files("data/") %>%
    grep("Mutation", x = ., value = TRUE) %>%
    file.path("data", .) -> folder

folder %>% 
    readTCGA(path = ., "mutations") -> BRCA.mutations

## ---------------------------------------------------------------------------------------------------------------------------------------------------
dim(BRCA.mutations)

## ---- eval = TRUE, results='asis'-------------------------------------------------------------------------------------------------------------------
# library(devtools)
# install_github('Rapporter/pander')
if( require(pander) ){
infoTCGA() %>%
    pandoc.table()
}

## ---- eval = TRUE-----------------------------------------------------------------------------------------------------------------------------------
(cohorts <- infoTCGA() %>% 
   rownames() %>% 
   sub("-counts", "", x=.))

## ---- eval = TRUE-----------------------------------------------------------------------------------------------------------------------------------
checkTCGA('Dates')

## ---------------------------------------------------------------------------------------------------------------------------------------------------
checkTCGA('DataSets', 'ACC', releaseDate) %>%
    length()

## ---- echo=FALSE, results='hide'--------------------------------------------------------------------------------------------------------------------
unlink("data", recursive = TRUE, force = TRUE)

