library(devtools)
library(rmarkdown)
createTCGA <- function(name,
											 author,
											 email,
											 path, 
											 formatLink,
											 BugReports,
											 check = FALSE, 
											 rstudio = TRUE, 
											 description = 
											 	list(Package = name,
											 			 Version = paste0(releaseDate,".0.0"),
											 			 Date = releaseDate,
											 			 Repository = "Bioconductor",
											 			 BugReports = BugReports,
											 			 Depends =  "R (>= 3.3.0), RTCGA",
											 			 Suggests = "knitr, rmarkdown",
											 			 biocViews = "Annotation Data",
														 VignetteBuilder = "knitr",
														 NeedsCompilation = "no",
											 			 Author = paste0(author, " <", email, ">"),
											 			 Description = paste0(
"Package provides ", name, " datasets from The Cancer Genome
Atlas Project for all cohorts types from
http://gdac.broadinstitute.org/. ", name, " data format is explained here ",
formatLink, " . Data from ", releaseDate, " snapshot.")
											 	)) {
	devtools::create(path = file.path(path, name), description = description, check = check, rstudio = rstudio)
	pkg <- as.package(path)
	path <- file.path(pkg$path, "vignettes", paste0(name, ".Rmd"))
  rmarkdown::draft(path, "createRTCGA", "RTCGA", create_dir = FALSE, 
        edit = FALSE)
}
