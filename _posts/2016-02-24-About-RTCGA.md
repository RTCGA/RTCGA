---
layout:  post
title: "RTCGA"
comments:  true
published:  true
author: "Marcin Kosiński"
date: 2016-02-24 00:45:00
categories: [RTCGA]
output:
  html_document:
    mathjax:  default
    fig_caption:  true
---




# Boxplots of logarithm of MET gene RNASeq expression for all cancer types


{% highlight r %}
#install.packages('devtools')
#devtools::install_github('RTCGA/RTCGA') # install RTCGA from github 
library(RTCGA)
#installTCGA('RTCGA.rnaseq') # install data package from github
# you can install all RTCGA data with installTCGA()

# load packages that are needed to munge data and visualize them
library(ggplot2)
library(dplyr)
# if you don't have them then you should install them from CRAN
# install.packages(c("ggplot2", "dplyr"))

# load RTCGA.rnaseq package to vizualize RNASeq
library(RTCGA.rnaseq)
# perfrom plot
expressionTCGA(ACC.rnaseq, BLCA.rnaseq, BRCA.rnaseq, 
					 CESC.rnaseq, CHOL.rnaseq, COAD.rnaseq,
					 COADREAD.rnaseq, DLBC.rnaseq, ESCA.rnaseq,
					 GBMLGG.rnaseq, GBM.rnaseq, HNSC.rnaseq, KICH.rnaseq,
					 KIPAN.rnaseq, KIRC.rnaseq, KIRP.rnaseq, LAML.rnaseq,
					 LGG.rnaseq, LIHC.rnaseq, LUAD.rnaseq, LUSC.rnaseq,							 
					 OV.rnaseq, PAAD.rnaseq, PCPG.rnaseq, PRAD.rnaseq,						 
					 READ.rnaseq, SARC.rnaseq, SKCM.rnaseq, STAD.rnaseq,							 
					 STES.rnaseq, TGCT.rnaseq, THCA.rnaseq, THYM.rnaseq,
					 UCEC.rnaseq, UCS.rnaseq, UVM.rnaseq,
					 extract.cols = "MET|4233") %>%
	rename(cohort = dataset,
				 MET = `MET|4233`) %>%	
	filter(substr(bcr_patient_barcode, 14, 15) == "01") %>% #cancer samples
	ggplot(aes(y = log1p(MET),
						 x = reorder(cohort, log1p(MET), median),
						 fill = reorder(cohort, log1p(MET), median))) + 
	geom_boxplot() +
	theme_RTCGA() +
	coord_flip()
{% endhighlight %}

![](https://raw.githubusercontent.com/RTCGA/RTCGA/master/devel/graphs/rnaseq.png)
