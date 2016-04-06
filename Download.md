---
layout:  page
title: "TCGA Data Download"
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

{:toc}




{% highlight r %}
library(RTCGA)
{% endhighlight %}

# Available Datasets

Before you read this section, please make sure you are aware of that we have prepared some datasets for you in below packages. `browseVignettes` is a function.


|package           |installation                    |help           |browseVignettes       |
|:-----------------|:-------------------------------|:--------------|:---------------------|
|RTCGA.rnaseq      |`biocLite('RTCGA.rnaseq')`      |`?rnaseq`      |`'RTCGA.rnaseq'`      |
|RTCGA.clinical    |`biocLite('RTCGA.clinical')`    |`?clinical`    |`'RTCGA.clinical'`    |
|RTCGA.mutations   |`biocLite('RTCGA.mutations')`   |`?mutations`   |`'RTCGA.mutations'`   |
|RTCGA.mRNA        |`biocLite('RTCGA.mRNA')`        |`?mRNA`        |`'RTCGA.mRNA'`        |
|RTCGA.miRNASeq    |`biocLite('RTCGA.miRNASeq')`    |`?miRNASeq`    |`'RTCGA.miRNASeq'`    |
|RTCGA.PANCAN12    |`biocLite('RTCGA.PANCAN12')`    |`?pancan12`    |`'RTCGA.PANCAN12'`    |
|RTCGA.RPPA        |`biocLite('RTCGA.RPPA')`        |`?RPPA`        |`'RTCGA.RPPA'`        |
|RTCGA.CNV         |`biocLite('RTCGA.CNV')`         |`?CNV`         |`'RTCGA.CNV'`         |
|RTCGA.methylation |`biocLite('RTCGA.methylation')` |`?methylation` |`'RTCGA.methylation'` |



# Cohorts Names and Number of Cases

The Cancer Genome Atlas provides data via [`Broad GDAC Firehose`](http://gdac.broadinstitute.org/). The number of cases in the most popular datasets can be checked with the following code that is based on the [`Broad GDAC Firehose`](http://gdac.broadinstitute.org/).


{% highlight r %}
library(magrittr)
infoTCGA() %>%
 # select less variables so that tables fits webpage
 dplyr::select(Cohort, BCR, Clinical, Methylation, mRNASeq) %>%
 head() %>% # without that you can see all cohorts
 knitr::kable()
{% endhighlight %}



|            |Cohort |BCR  |Clinical |Methylation |mRNASeq |
|:-----------|:------|:----|:--------|:-----------|:-------|
|ACC-counts  |ACC    |92   |92       |80          |79      |
|BLCA-counts |BLCA   |412  |412      |412         |408     |
|BRCA-counts |BRCA   |1098 |1097     |1097        |1093    |
|CESC-counts |CESC   |307  |307      |307         |304     |
|CHOL-counts |CHOL   |51   |45       |36          |36      |
|COAD-counts |COAD   |460  |458      |457         |457     |


Furthermore `infoTCGA()` enables to extract possible cohorts names from TCGA Study. 

**Cohorts' names stand for abbreviations of real names of cancer types.**


{% highlight r %}
(cohorts <- infoTCGA() %>% 
rownames() %>% 
   sub('-counts', '', x=.))
{% endhighlight %}



{% highlight text %}
 [1] "ACC"      "BLCA"     "BRCA"     "CESC"     "CHOL"     "COAD"     "COADREAD" "DLBC"     "ESCA"     "FPPP"    
[11] "GBM"      "GBMLGG"   "HNSC"     "KICH"     "KIPAN"    "KIRC"     "KIRP"     "LAML"     "LGG"      "LIHC"    
[21] "LUAD"     "LUSC"     "MESO"     "OV"       "PAAD"     "PCPG"     "PRAD"     "READ"     "SARC"     "SKCM"    
[31] "STAD"     "STES"     "TGCT"     "THCA"     "THYM"     "UCEC"     "UCS"      "UVM"     
{% endhighlight %}

# Datasets dates of release

The Cancer Genome Atlas provides datasets in many dates of release. You can check them with the following command.


{% highlight r %}
checkTCGA('Dates')
{% endhighlight %}



{% highlight text %}
 [1] "2011-10-26" "2011-11-15" "2011-11-28" "2011-12-06" "2011-12-30" "2012-01-10" "2012-01-24" "2012-02-17"
 [9] "2012-03-06" "2012-03-21" "2012-04-12" "2012-04-25" "2012-05-15" "2012-05-25" "2012-06-06" "2012-06-23"
[17] "2012-07-07" "2012-07-25" "2012-08-04" "2012-08-25" "2012-09-13" "2012-10-04" "2012-10-18" "2012-10-20"
[25] "2012-10-24" "2012-11-02" "2012-11-14" "2012-12-06" "2012-12-21" "2013-01-16" "2013-02-03" "2013-02-22"
[33] "2013-03-09" "2013-03-26" "2013-04-06" "2013-04-21" "2013-05-08" "2013-05-23" "2013-06-06" "2013-06-23"
[41] "2013-07-15" "2013-08-09" "2013-09-23" "2013-10-10" "2013-11-14" "2013-12-10" "2014-01-15" "2014-02-15"
[49] "2014-03-16" "2014-04-16" "2014-05-18" "2014-06-14" "2014-07-15" "2014-09-02" "2014-10-17" "2014-12-06"
[57] "2015-02-02" "2015-02-04" "2015-04-02" "2015-06-01" "2015-08-21" "2015-11-01" "2016-01-28"
{% endhighlight %}

# Datasets names for a specific cohort type

The Cancer Genome Atlas provides various datasets for different cohort types. For example you can check all names of datasets provided for `BRCA` with (second dimension stand for dataset size).


{% highlight r %}
checkTCGA(
	'DataSets',
	cancerType = 'BRCA',
	date = '2016-01-28'
) %>% dim
{% endhighlight %}



{% highlight text %}
[1] 43  2
{% endhighlight %}

This lists only `.zip` files.

# Data Download

If you know which cohort type you are interested in and which dataset name you are looking for and which release date suits you, you can download a dataset provided by TCGA Study with the following command.



{% highlight r %}
dir.create("download_folder")
downloadTCGA(
	cancerTypes = "BRCA",
	dataSet = "Merge_Clinical.Level_1",
	destDir = "download_folder"
)
{% endhighlight %}

You can specify `cancerTypes` as a vector of characters if you would like to download the same dataset type for many cohorts. 
Moreover you can just specify an abbreviation ora fragment of dataset name. 
You can also specify `date` argument if you would like to download datasets from previous (not the newest) releases.
All downloaded datasets are untarred and their `.tar` files are deleted after untarring. You can also change this behaviour with `untarFile` and `removeTar` arguments. Sometimes more than one dataset fits the character provieded in `dataSet` argument, then the first without `FPPP` string is downloaded if possible. If you are interested in all datasets then you can change `allDataSets` (by default `FALSE`) parameter to `TRUE`.


# Read Specific Datasets

For specific datasets it is possible to read downloaded file into the tidy format. Fore more information check

{% highlight r %}
?readTCGA
{% endhighlight %}

