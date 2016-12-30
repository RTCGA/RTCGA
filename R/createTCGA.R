## RTCGA package for R
#' @title Create RTCGA.dataType.releaseDate-like Packages with TCGA Datasets
#'
#' @description This uber functionality allows to create packages with datasets from the TCGA project. 
#' Example of such a package created with \code{createTCGA} is \url{https://github.com/RTCGA/RTCGA.clinical.20160128}.
#' Resulted package is a package of type \href{http://www.bioconductor.org/packages/3.4/bioc/vignettes/ExperimentHubData/inst/doc/ExperimentHubData.html}{ExperimentHubData},
#' it consists of regular structure like \code{R} and \code{man} directories and also cosists of a vignette and \code{README.md} file where the whole 
#' construction process is decribed. The only part which must be pre-specified by a user is a \code{DESCRIPTION} file with additional extra records: 
#' \code{TCGAdataSet}, \code{TCGAreleaseDate} (\code{releaseDate} and \code{dataSet} to be used in \code{downloadTCGA}) and \code{TCGAdataType} (a type of data to be used in \link{readTCGA}).
#'  
#' @return A fully equpied package, ready to be shipped on Bioconductor's ExperimentHub.
#' 
#' @param description A regular \href{http://r-pkgs.had.co.nz/description.html}{DESCRIPTION} file with additional extra records: \code{TCGAdataSet}, \code{TCGAreleaseDate} (\code{releaseDate} and \code{dataSet} to be used in \code{downloadTCGA}) and \code{TCGAdataType} (a type of data to be used in \link{readTCGA}).
#' @param cohorts Names of cancer type cohorts to be included in the package. For possible names check \link{infoTCGA}.
#' @param tempDir The name of temporary directory in which the data will be stored during package creation.
#' @param clean A logical: should the \code{tempDir} directory be removed after package creation.
#' 
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
#' \pkg{RTCGA} website \href{http://rtcga.github.io/RTCGA/}{http://rtcga.github.io/RTCGA/}.
#' 
#' @examples 
#'
#' \dontrun{
#' 
#' # https://github.com/RTCGA/RTCGA.clinical.20160128
#' # RTCGA.clinical.20160128 was created with
#' cat(
#'  readLines(
#'    'https://raw.githubusercontent.com/RTCGA/RTCGA.clinical.20160128/master/DESCRIPTION'
#' ), file = 'DESC', sep = '\n')
#' createTCGA('DESC', clean = TRUE)
#' 
#' } 
#'
#' 
#' @family RTCGA
#' @rdname createTCGA
#' @export
createTCGA <- function(description = file.path(getwd(), 'DESCRIPTION'),
                       cohorts = sub("-counts", "", rownames(infoTCGA())),
                       tempDir = "data_tmp", clean = FALSE){
  
  if (!requireNamespace("devtools", quietly = TRUE)) {
    stop("devtools package required for createTCGA function")
  }
  # check input parameters
  assert_that(is.character(description), length(description) == 1)
  assert_that(is.character(tempDir), length(tempDir) == 1, !file.exists(tempDir))
  assert_that(is.logical(clean), length(clean) == 1)
  assert_that(is.character(cohorts), length(cohorts) >= 1, 
              any(cohorts %in% sub("-counts", "", rownames(infoTCGA()))))
  
  # convert DESCRIPTION to named list
  desc.val <- read.dcf(description)
  desc.val.list <- as.list(desc.val)
  names(desc.val.list) <- colnames(desc.val)
  assert_that(all(c('TCGAdataSet', 'TCGAreleaseDate', 'TCGAdataType') %in% names(desc.val.list)))
  
  # extract parameters needed to download data from TCGA
  dataType <- desc.val.list$TCGAdataType
  releaseDate <- desc.val.list$TCGAreleaseDate
  releaseDate2 <- gsub("-", "", desc.val.list$TCGAreleaseDate)
  dataSet <- desc.val.list$TCGAdataSet
  author <- desc.val.list$Author
  call <- deparse(match.call())
  
  # download desired datasets
  cat("Creating temporary directory", tempDir, "... \n")
  dir.create(tempDir)
  cat("Downloading data ... \n")
  sapply(cohorts, function(element){
    tryCatch({
      downloadTCGA( 
        cancerTypes = element, 
        destDir = tempDir, 
        dataSet = dataSet,
        date = releaseDate )
      }, error = 
        function(cond){ 
          cat("Error: Maybe there weren't", dataType, "data for ", element, " cancer.\n")
        }
      )
    })
  
  cat("Cleaning download directory... \n")
  # shorten paths so that they are shorter than 256 signs - windows issue
  list.files("data_tmp", full.names = TRUE) %>%
    file.rename(to = substr(., start = 1, stop = 50))
  
  # clean directory
  # If there were not dataType data for some cohorts we should remove corresponding NA files.
  list.files("data_tmp", full.names = TRUE, recursive = TRUE, pattern = "NA|MANIFEST") %>%
    file.remove() # it might not be needed actually
  # and sometimes the appearance of MANIFEST files breaks the workflow
  # I assume there is one file in one folder | for clinical datasets there is special case with IF
  
  # we need helper environment
  createEnv <- new.env()

  # assign paths to datasets 
  if (dataType == "mutations") {
    ddl.files <- list.files("data_tmp", full.names = TRUE)  
  } else {
    ddl.files <- list.files("data_tmp", full.names = TRUE, recursive = TRUE)  
  }
  if (dataType == "clinical") {
    ddl.files <- grep(pattern = "clin.merged.txt", x = ddl.files, value = TRUE)
  }
  
  sapply(cohorts, function(cohort){
    assign(value = grep(cohort, ddl.files, value = TRUE), 
           envir = createEnv,
           x = paste0(cohort, ".", dataType, ".path"))
  }) -> dev_null
  
  cat("Reading and converting data... \n")
  # read data to transform them to unique data format
  ls(pattern = "\\.path", envir = createEnv) %>%
    sapply(function(element){
      tryCatch({
         readTCGA(get(element, envir = createEnv),
                  dataType = dataType) -> r_file
            if(dataType %in% c("clinical", "mutations")){
             ## remove non-ASCII strings:
               for( i in 1:ncol(r_file)){
                 r_file[, i] <- iconv(r_file[, i],
                                      "UTF-8",
                                      "ASCII",
                                      sub="")
               } 
            }
            
         assign(value = r_file,
                x = paste0(sub("\\.path", "", x = element), ".", releaseDate2),
                envir = createEnv)
      }, error = function(cond){
         cat('There was a problem with reading data for', element, '- probably the file wasn\'t downloaded.\n')
      }) 
     invisible(NULL)
    }) -> dev_null
  
  # saving data to .rda format
  cat("Saving converted data to .rda format... \n")
  if ((dataType == "methylation") && ("OV" %in% cohorts)){
    # one of methylation datasets is too big - it's better to split it on 2 separate datasets
    OV <- get(paste0("OV.methylation.", releaseDate2), envir = createEnv)
    OV.1 <- OV[1:(floor(nrow(OV)/2)), ]
    OV.2 <- OV[(floor(nrow(OV)/2)+1):nrow(OV), ]
    assign(x = paste0("OV.methylation1.", releaseDate2), envir = createEnv, value = OV.1)
    assign(x = paste0("OV.methylation2.", releaseDate2), envir = createEnv, value = OV.2)
    rm(list=paste0("OV.methylation.", releaseDate2), envir = createEnv)
  }
  ls(pattern = dataType, envir = createEnv) %>%
    grep("path", x = ., value = TRUE, invert = TRUE) -> use_data_input
  
  dir.create("data")
  mapply(save, list = use_data_input, 
         file = file.path("data", paste0(use_data_input, ".rda")),
         MoreArgs = list(envir = createEnv, compress = "xz")) -> dev_null
  rm(createEnv)
  
  cat("Customizing the vignette and README.md file... \n")
  vig.path <- file.path("vignettes", paste0(desc.val.list$Package, ".Rmd"))
	dir.create("vignettes")
  file.create(vig.path)
  # I am not proud of this solution
  # but how many times have you customized the output of a vignette
  # depending on the input of an automatical package creation?
  createREADMEtcga(desc.val.list$Package, dataType, releaseDate, releaseDate2, 
                   dataSet, use_data_input, file = "README.md")
  createVIGNETTEtcga(desc.val.list$Package, dataType, releaseDate, releaseDate2, 
                     dataSet, use_data_input, file = vig.path, author = author)
  createNOTEStcga(readme = "README.md", vignette = vig.path, releaseDate)
  
  # create manual pages
  cat("Creating documentation pages... \n")
  createMANtcga(desc.val.list$Package, dataType, releaseDate, releaseDate2, use_data_input)
  # one need to roxygenize the manual page
  devtools::document(roclets=c('rd', 'collate', 'namespace'))

  cat("Adding .Rbuildignore file for package completness... \n")
  # .RBuildignore
  file.create(".Rbuildignore")
  cat("^.*\\.Rproj$\n^\\.Rproj\\.user$", file = ".Rbuildignore")
  # NAMESPACE
  # file.create("NAMESPACE")
  # cat("exportPattern(\"^[[:alpha:]]+\")\nimport(RTCGA)", file = "NAMESPACE")
  
  cat("Extending package to ExpressionHubData format... \n")
  ## zzz.R file
  createZZZtcga(desc.val.list$Package)
  ## make-data.R file
  dir.create('inst/scripts/', recursive = TRUE)
  file.create('inst/scripts/make-data.R')
  cat("library(RTCGA)\n", call, file = 'inst/scripts/make-data.R')
  ## make-metadata.R file
  createMETADATAtcga(use_data_input, desc.val.list$Title, desc.val.list$Description, releaseDate)
  
  cat("Finished creating new RTCGA.dataType.releaseDate-like package with", dataType,
      "data from the", releaseDate, "release date.", "\n")
  
  if(clean){
    unlink(tempDir, recursive = TRUE)
  }
}



createVIGNETTEtcga <- function(package, dataType, releaseDate, releaseDate2, dataSet, use_data_input, file, author){
cat(
"---
title: \"Using `RTCGA` package to download", dataType, "data that are included in", package, "package\" 
subtitle: \"Date of datasets release:", releaseDate, "\"
author: \"", author, "\"
date: \"", as.character(Sys.Date()), "\"
output: rmarkdown::html_vignette 
vignette: > 
  %\\VignetteIndexEntry{Using RTCGA package to download", dataType, "data that are included in", package, "package\"}
  %\\VignetteEngine{knitr::rmarkdown}
  %\\VignetteEncoding{UTF-8}
---
\n
```{r, echo=FALSE}
library(knitr)
opts_chunk$set(
	comment = \"\",
	message = FALSE,
	warning = FALSE,
	tidy.opts = list(
		keep.blank.line = TRUE,
		width.cutoff= 150),
	options(width= 150),
	eval = FALSE
)
```\n", file = file
)
  createREADMEtcga(package, dataType, releaseDate, releaseDate2, dataSet, use_data_input, file, first_append = TRUE)
}

createREADMEtcga <- function(package, dataType, releaseDate, releaseDate2, dataSet, use_data_input, file, first_append = FALSE){
    cat("#", package, "\n
This package was created with [`RTCGA::createTCGA()`](http://rtcga.github.io/RTCGA/staticdocs/createTCGA.html) function and is a part of [RTCGA](http://rtcga.github.io/RTCGA/) project. It consist of
data from [The Cancer Genome Atlas Project](https://cancergenome.nih.gov/abouttcga). \n
Datasets existing in this package were downloaded automatically from [Firehose Broad GDAC](http://gdac.broadinstitute.org/) portal. They were taken
from the", releaseDate, "release date. All release dates are available [here](http://gdac.broadinstitute.org/runs/). Datasets were downloaded with the use of `RTCGA::downloadTCGA()` function and were transposed with `RTCGA::readTCGA()` function.\n
The package contains following datasets, which names corresponds to: the cohort type, data type and release date. Cohort types can be checked
with `RTCGA::infoTCGA()`, release dates with `RTCGA::checkTCGA('Dates')` and data types with e.g. `RTCGA::checkTCGA('DataSets', 'BRCA')` calls. 
The used data type for this package was `", dataSet, "` - all those information are included in the `DESCRIPTION` file. To see
the manual page for included datasets run ", paste0("`?", dataType, ".", releaseDate2, "`"), "in R console. \n\n", file = file, append = first_append)
  sapply(use_data_input, function(dataset){
    cat("- ", dataset, "\n", append = TRUE, file = file)
  }) -> dev_null
  cat("\n", file = file, append = TRUE)
  cat("Optionally, the data can be loaded through the [ExperimentHub](http://www.bioconductor.org/packages/3.4/bioc/vignettes/ExperimentHubData/inst/doc/ExperimentHubData.html) interface.\n
```{r, eval=FALSE}
library(ExperimentHub)
eh <- ExperimentHub()
myfiles <- query(eh, ", paste0('"', package, '"'),")
myfiles[[1]]  ## load the first resource in the list
```\n\n", file = file, append = TRUE)
  cat("\n# Installation \n
To install this package from GitHub use
```{r, eval=FALSE}
library(RTCGA) \n",
paste0("installTCGA(\"", package, "\")"),
"\n```\n
Make sure you have [Rtools](https://cran.r-project.org/bin/windows/Rtools/) installed on your computer, if you are trying devtools on Windows.", 
      file = file, append = TRUE)
}

createNOTEStcga <- function(readme, vignette, releaseDate) {
  notes <- paste0("\n# Notes\n\nNote that this package is a data package with datasets from ", releaseDate, " release date. There are few data packages already on Bioconductor with datasets from \"2015-11-01\". To read more check `?RTCGA::datasetsTCGA`.")
cat(notes, file = readme, append = TRUE)
cat(notes, file = vignette, append = TRUE)
}

createMANtcga <- function(package, dataType, releaseDate, releaseDate2, use_data_input){
  dir.create("R")
  file.create(out_file <- file.path("R", paste0(dataType, "_datasets.R")))
  
cat(
"#' 
#\'", dataType, "datasets from TCGA project from", releaseDate, "release date
#\'
#\' Package provides", dataType, "datasets from The Cancer Genome Atlas Project for all cohorts types from \\url{http://gdac.broadinstitute.org/}.
#\' Data were downloaded using \\link{RTCGA-package} and contain snapshots for the release date:", paste0("\\code{", releaseDate, "}"), ". Visit \\pkg{RTCGA} site: \\url{http://rtcga.github.io/RTCGA/}.
#\' Use cases, examples and information about datasets in", paste0("\\pkg{", package, "}"), " can be found here: \\code{browseVignettes(\"RTCGA\")}. Link to the data format explanation is in the package DESCRIPTION file.
#\' 
#\' @details \\code{browseVignettes(\"RTCGA\")}
#\' 
#\' @param metadata A logical indicating whether load data into the workspace (default, \\code{FALSE}) or to only display the object's metadata (\\code{TRUE}). See examples.
#\' 
#\' @examples
#\' 
#\' \\dontrun{
#\' ", paste0(use_data_input[1], "(metadata = TRUE)"),"
#\' ", paste0(use_data_input[1], "(metadata = FALSE)"),"
#\' ", paste0(use_data_input[1], ""),"
#\' }
#\' 
#\' @import RTCGA
#\' @import ExperimentHub
#\' @importFrom utils read.csv
#\' @importFrom AnnotationHub query
#\' @format NULL
#\' @source \\url{http://gdac.broadinstitute.org/}
#\' 
#\' @aliases", paste0(use_data_input, collapse = ","), "
#\' @name", paste0(dataType, ".", releaseDate2), "
#\' @rdname", paste0(dataType, ".", releaseDate2), paste0("\n#'\n\"", use_data_input[1], "\""), file = out_file)
if(length(use_data_input[-1]) > 0){
  sapply(use_data_input[-1], function(element){
    cat("\n#' @name", paste0(dataType, ".", releaseDate2), "\n#' @rdname", paste0(dataType, ".", releaseDate2), paste0("\n#' @format NULL \n#'\n\"",element,"\""),
        file = out_file, append = TRUE)
  })
}
}

createZZZtcga <- function(package){
  file.create("R/zzz.R")
cat(
'.onLoad <- function(libname, pkgname) {
    titles <- read.csv(system.file("extdata", "metadata.csv", 
                      package =', paste0('"', package, '"),'),'
                      stringsAsFactors=FALSE)$Title
    rda <- gsub(".rda", "", titles, fixed=TRUE)
    if (!length(rda))
        stop("no .rda objects found in metadata")

    ## Functions to load resources by name:
    ns <- asNamespace(pkgname)
    sapply(rda, 
        function(xx) {
            func = function(metadata = FALSE) {
                if (!isNamespaceLoaded("ExperimentHub"))
                    attachNamespace("ExperimentHub")
                eh <- AnnotationHub::query(ExperimentHub(), ', paste0('"', package, '"'),')
                ehid <- names(AnnotationHub::query(eh, xx))
                if (!length(ehid))
                    stop(paste0("resource ", xx, 
                         "not found in ExperimentHub"))
                if (metadata)
                    eh[ehid]
                else eh[[ehid]]
            }
            assign(xx, func, envir=ns)
            namespaceExport(ns, xx)
        })
}', file = "R/zzz.R"  
)
}


createMETADATAtcga <- function(use_data_input, title, description, releaseDate){
  file.create('inst/scripts/make-metadata.R')
cat(
'meta <- data.frame(
    Title =', paste0('c("', paste0(use_data_input, collapse = '","'), '")'), ',
    Description = rep("',description,'",', length(use_data_input), '),
    BiocVersion = rep("3.4",', length(use_data_input), '),
    SourceUrl = "http://gdac.broadinstitute.org/",
    SourceVersion = ', paste0('"',releaseDate, '"'), ',
    DataProvided = "TCGA",
    Maintainer = "Bioconductor Package Maintainer <maintainer@bioconductor.org>",
    RDataClass = rep("data.frame",', length(use_data_input), '),
    ResourceName = ',paste0('c("', paste0(use_data_input, collapse = '","'), '")'),')
write.csv(meta, file = "inst/extdata/metadata.csv", row.names = FALSE)
', file = 'inst/scripts/make-metadata.R'
)
  dir.create('inst/extdata/', recursive = TRUE)
  source('inst/scripts/make-metadata.R')
}
