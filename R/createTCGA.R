


#' @section devtools and rmarkdown:
#'
#' This function use tools from the fantastic \pkg{devtools} and \pkg{rmarkdown}
#' packages, so you'll need to make sure to have them installed.

createTCGA <- function(name,
											 author,
											 email,
											 path,
											 dataSet,
											 dataSetFile,
											 dataType,
											 formatLink,
											 releaseDate = tail(checkTCGA('Dates'),1), 
											 BugReports = "https://github.com/RTCGA/RTCGA/issues",
											 check = FALSE, 
											 rstudio = TRUE, 
											 description = 
											 	list(Package = paste0("RTCGA.",name, ".",gsub("-", "", releaseDate)),
											 			 Version = paste0(gsub("-", "", releaseDate),".0.0"),
											 			 Date = releaseDate,
											 			 Title = paste0(name, " datasets from The Cancer Genome Atlas Project"),
											 			 Repository = "Bioconductor",
											 			 BugReports = BugReports,
											 			 Depends =  "R (>= 3.3.0), RTCGA",
											 			 Suggests = "knitr, rmarkdown",
											 			 biocViews = "Annotation Data",
														 VignetteBuilder = "knitr",
														 License = "GPL-2",
														 NeedsCompilation = "no",
											 			 `Authors@R` = paste0(author, " <", email, ">"),
											 			 Description = paste0("Package provides ", name, " datasets from The Cancer Genome Atlas Project for all cohorts types from http://gdac.broadinstitute.org/. ", name, " data format is explained here ", formatLink, " . Data from ", releaseDate, " snapshot.")
											 	)) {

	if (!requireNamespace("rmarkdown", quietly = TRUE)) {
    stop("rmarkdown package required for createTCGA function")
	}
	if (!requireNamespace("devtools", quietly = TRUE)) {
    stop("devtools package required for createTCGA function")
	}
	
	
	cat("Creating package skeleton ... \n")
	devtools::create(path = file.path(path, name), 
									 description = description,
									 check = check,
									 rstudio = rstudio)
	pkg <- devtools::as.package(file.path(path, name))
	cat("Creating vignettes directory ... \n")
	vig.path <- file.path(pkg$path, "vignettes", paste0(name, ".Rmd"))
	dir.create(file.path(pkg$path, "vignettes"))
	file.create(vig.path)
	
	name <- name
	releaseDate <- releaseDate
	dataSetFile <- dataSetFile
	
	
	cat("Creating vignette ... \n")
	readLines(system.file("createTCGA.Rmd",package = "RTCGA")) %>%
	  gsub( "`r name`", name, . ) %>%
		gsub( "`r releaseDate`", releaseDate, . ) %>%
		gsub( "`r author`", author, . ) %>%
		gsub( "dataSetFile", dataSetFile, . ) %>%
		gsub( "\"dataType\"", paste0("\"", dataType, "\""), . ) %>%
		gsub( "`r gsub('-', '', releaseDate)`", gsub('-', '', releaseDate), .) %>%
		cat(file=vig.path, sep="\n")
	
	cat("Rendering vignette: downloading data ... \n")
  rmarkdown::render(input = vig.path)
  
  cat("Setting eval to FALSE in vignette after first run ... \n")
  readLines(vig.path) %>%
    gsub( "eval=TRUE", "eval=TRUE", . ) %>%
  	cat(file=vig.path, sep="\n")
  cat("Creating documentation  ... \n")
  # create documentation
  
}

