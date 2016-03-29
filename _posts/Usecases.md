---
layout:  page
title: "Usecases"
comments:  true
published:  true
author: "Przemyslaw Biecek"
date: "21 March 2016"
categories: [RTCGA, USECASES]
output:
  html_document:
    mathjax:  default
    fig_caption:  true
    toc: true
    section_numbering: true
---

# TCGA and The Curse of BigData

* Goals
* Download clinical datasets
* Prepare data 
* Number of observations in BRCA / next releases
* p-values for selected genes
* Low p-value, small group
{:toc}






# Goals

Here we are presenting some non-standard analyses of RTCGA data.

1. Starting with BRCA cohort, we check how the number of cases is increasing through consecutive releases.

2. We are checking how p-values for simple log-rank model are changing through consecutive releases

3. We are showing that (due to number of genes) some of them have expression confounded with significant clinical outcomes.


{% highlight r %}
library(RTCGA)
{% endhighlight %}

# Download clinical datasets


{% highlight r %}
releaseDates <- checkTCGA("Dates")
library(archivist)
createLocalRepo("UseCases", default = TRUE)
{% endhighlight %}



{% highlight r %}
for(i in releaseDates) {
  try({
    downloadTCGA(
    	"BRCA",
    	dataSet = "Merge_Clinical.Level_1",
    	date = i,
    	destDir = "UseCases"
    	) 
    cat(i,"\n")
  })
}
{% endhighlight %}


# Prepare data 

## Prepare expression dataset with RNAseq


{% highlight r %}
library(RTCGA.rnaseq)
library(dplyr)
BRCA.rnaseq.fil <- BRCA.rnaseq %>%
	filter(substr(bcr_patient_barcode, 14, 15) == "01") %>%
	mutate(bcr_patient_barcode = substr(bcr_patient_barcode, 1, 12))
{% endhighlight %}

## Load all clinical data


{% highlight r %}
files <- list.files(path = "UseCases", pattern="BRCA.clin.mer", recursive = TRUE)
files <- file.path("UseCases",files)

# Here gather some useful statistics
n <- c()
names <- c()

# Collect p-values for these genes
selected <- c(23L, 228L, 259L, 309L, 593L, 664L, 665L, 675L, 676L, 717L, 
             847L, 904L, 1148L, 1287L, 1306L, 1369L, 1429L, 1602L, 1718L, 
             1818L, 1856L, 1985L, 2004L, 2034L, 2169L, 2176L, 2248L, 2389L, 
             2478L, 2514L, 2550L, 2551L, 2555L, 2682L, 2944L, 3008L, 3153L, 
             3189L, 3411L, 3640L, 3803L, 3817L, 3857L, 3960L, 4139L, 4157L, 
             4192L, 4338L, 4588L, 4814L, 5179L, 5270L, 5694L, 5744L, 5764L, 
             6028L, 6033L, 6544L, 6593L, 6680L, 6797L, 6798L, 6831L, 6844L, 
             6847L, 6855L, 6878L, 7009L, 7067L, 7082L, 7261L, 7299L, 7430L, 
             7529L, 7857L, 7971L, 7982L, 8015L, 8265L, 8284L, 8316L, 8694L, 
             8706L, 8832L, 9400L, 9585L, 9593L, 9706L, 9734L, 9778L, 9858L, 
             9872L, 9879L, 10206L, 10235L, 10295L, 10511L, 10634L, 10938L, 
             10963L, 11162L, 11174L, 11197L, 11244L, 11257L, 11262L, 11346L, 
             11554L, 11600L, 11713L, 11793L, 11876L, 11879L, 11890L, 11893L, 
             11915L, 11916L, 11917L, 11947L, 11968L, 11971L, 11979L, 11994L, 
             12007L, 12190L, 12257L, 12391L, 12403L, 12575L, 12912L, 13032L, 
             13105L, 13451L, 13486L, 13531L, 13598L, 13617L, 13815L, 14053L, 
             14129L, 14211L, 14289L, 14291L, 14313L, 14389L, 14423L, 14544L, 
             14703L, 14725L, 14760L, 14910L, 14963L, 15101L, 15315L, 15363L, 
             15392L, 15507L, 15696L, 15762L)


read_and_joinTCGA <- function(file){
	readTCGA(file, dataType = "clinical") -> clin
	c(which(grepl('patient.stage_event.tnm_categories.pathologic_categories.pathologic_t', names(clin), fixed = TRUE)),
	which(grepl('patient.stage.event.tnm.categories.pathologic.categories.pathologic.t', names(clin), fixed = TRUE))) ->
		this.col
	names(clin)[this.col] <- 'stageevent'
	clin %>%
		filter(stageevent != "tx") %>%
		mutate(stageevent = 
					 	substr(stageevent, 1, 2)) %>%
		survivalTCGA(extract.cols = "stageevent",
								 extract.names = FALSE) %>% 
		unique %>%
		left_join(BRCA.rnaseq.fil,
							by = "bcr_patient_barcode")
}
{% endhighlight %}

## Calculate p-values for selected genes


{% highlight r %}
pvalues <- matrix(0, length(files), length(selected)) - 1
library(survival)
for (i in seq_along(files)) {
  try({
    all <- read_and_joinTCGA(files[i])
    for (j in seq_along(selected)) {
      selectedCat <- cut(all[,selected[j]+4], c(-100,median(all[,selected[j]+4], na.rm = TRUE),10^9))
      
      if (min(table(selectedCat)) >= 20) {
        ndf <- data.frame(time = all$times,
        									event = all$patient.vital_status ==1,
        									var = selectedCat)
        pvalues[i,j] <- survdiff(Surv(time, event)~var, data=ndf)$chisq
      }
    }

    n[i] <- nrow(all)
    names[i] <- files[i]
  }, silent = TRUE)
	cat(i, "\n")
}

saveToRepo(names)
{% endhighlight %}



{% highlight text %}
[1] "f9e884084b84794d762a535f3facec85"
{% endhighlight %}



{% highlight r %}
saveToRepo(files)
{% endhighlight %}



{% highlight text %}
[1] "5152ac13bdd09110d9ee9c169a3d9237"
{% endhighlight %}



{% highlight r %}
saveToRepo(pvalues)
{% endhighlight %}



{% highlight text %}
[1] "185cadffc15526273b38bb07fefb1cf2"
{% endhighlight %}



{% highlight r %}
saveToRepo(n)
{% endhighlight %}



{% highlight text %}
[1] "f9e884084b84794d762a535f3facec85"
{% endhighlight %}

# Number of observations in BRCA / next releases


{% highlight r %}
library(lubridate)
library(ggplot2)

dates <- substr(names, 62, 69)
drd <- na.omit(data.frame(data=ymd(dates), v = n))

saveToRepo(drd)
{% endhighlight %}



{% highlight text %}
[1] "7d976bfddc8fefcd0cc8f7d77223dd0e"
{% endhighlight %}



{% highlight r %}
ggplot(drd[-1,], aes(data,v)) + 
  geom_point(size=3) +
  theme_RTCGA() + xlab("Date of the release") + 
  ylab("# of patients") +
  ggtitle("BRCA")
{% endhighlight %}



{% highlight text %}
Error: ggplot2 doesn't know how to deal with data of class POSIXct/POSIXt
{% endhighlight %}



{% highlight r %}
saveToRepo(.Last.value)
{% endhighlight %}



{% highlight text %}
[1] "f9e884084b84794d762a535f3facec85"
{% endhighlight %}

# p-values for selected genes


{% highlight r %}
pvalues <- pvalues[1:length(names),]
{% endhighlight %}



{% highlight text %}
Error in pvalues[1:length(names), ]: subscript out of bounds
{% endhighlight %}



{% highlight r %}
plotPValues <- function(i) {
  drd <- data.frame(data = ymd(substr(names, 62, 69)), 
                    v = pvalues[,i], 
                    p = 1-pchisq(pvalues[,i],1))
  drd <- drd[drd$v > 0,]
  drd <- drd[-1,]
  
  ggplot(drd, aes(data, p, label=signif(p,2))) + 
    geom_point(size=3) +
    xlab("Date of the release") + 
    ylab("p-value (survival model)\n for data from this release") +
    geom_text(data=drd[c(which.max(drd$p), which.min(drd$p)),], color="red", nudge_y = .025) + 
    ggtitle(paste0("Gene: ", colnames(all)[selected[i]])) + theme_RTCGA()
}

plotPValues( 135 )
{% endhighlight %}

![plot of chunk unnamed-chunk-9](/RTCGA/figure/source/Usecases/unnamed-chunk-9-1.png)

{% highlight r %}
plotPValues( 47 )
{% endhighlight %}

![plot of chunk unnamed-chunk-9](/RTCGA/figure/source/Usecases/unnamed-chunk-9-2.png)

# Low p-value, small group


{% highlight r %}
all <- read_and_joinTCGA(files[20])
{% endhighlight %}



{% highlight text %}
Error in if (input == "" || length(grep("\\n|\\r", input)) > 0) {: missing value where TRUE/FALSE needed
{% endhighlight %}



{% highlight r %}
j <- 15789+4
#all[,j] <- as.numeric(as.character(all[,j]))

vv <- cut(all[,j], c(-100,0,100), labels = c("low expression", "high expression"))
{% endhighlight %}



{% highlight text %}
Error in all[, j]: object of type 'builtin' is not subsettable
{% endhighlight %}



{% highlight r %}
ndf <- data.frame(time = pmax(all$times, 1), event = all$patient.vital_status ==1, 
                  var = vv)
{% endhighlight %}



{% highlight text %}
Error in all$times: object of type 'builtin' is not subsettable
{% endhighlight %}



{% highlight r %}
ndf <- na.omit(ndf)
{% endhighlight %}



{% highlight text %}
Error in na.omit(ndf): object 'ndf' not found
{% endhighlight %}



{% highlight r %}
kmTCGA(ndf, times = "time",
			 status = "event",
			 explanatory.names = "var",
			 main = paste("Gene:", colnames(all)[j]))
{% endhighlight %}



{% highlight text %}
Error in is.data.frame(x): object 'ndf' not found
{% endhighlight %}

