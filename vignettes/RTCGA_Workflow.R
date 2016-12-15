## ---- include=FALSE-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
htmltools::tagList(rmarkdown::html_dependency_font_awesome())
library(knitr)
opts_chunk$set(
	comment = "",
	fig.width = 12, 
	message = FALSE,
	warning = FALSE,
	tidy.opts = list(
		keep.blank.line = TRUE,	
		width.cutoff = 150
		),
	options(width = 200),
	eval = TRUE
)

