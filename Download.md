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

Before you read this section, please make sure you are aware of that we have prepared some datasets for you in below packages


|package           |installation                    |help           |vignettes                              |
|:-----------------|:-------------------------------|:--------------|:--------------------------------------|
|RTCGA.rnaseq      |`biocLite('RTCGA.rnaseq')`      |`?rnaseq`      |`browseVignettes('RTCGA.rnaseq')`      |
|RTCGA.clinical    |`biocLite('RTCGA.clinical')`    |`?clinical`    |`browseVignettes('RTCGA.clinical')`    |
|RTCGA.mutations   |`biocLite('RTCGA.mutations')`   |`?mutations`   |`browseVignettes('RTCGA.mutations')`   |
|RTCGA.mRNA        |`biocLite('RTCGA.mRNA')`        |`?mRNA`        |`browseVignettes('RTCGA.mRNA')`        |
|RTCGA.miRNASeq    |`biocLite('RTCGA.miRNASeq')`    |`?miRNASeq`    |`browseVignettes('RTCGA.miRNASeq')`    |
|RTCGA.PANCAN12    |`biocLite('RTCGA.PANCAN12')`    |`?pancan12`    |`browseVignettes('RTCGA.PANCAN12')`    |
|RTCGA.RPPA        |`biocLite('RTCGA.RPPA')`        |`?RPPA`        |`browseVignettes('RTCGA.RPPA')`        |
|RTCGA.CNV         |`biocLite('RTCGA.CNV')`         |`?CNV`         |`browseVignettes('RTCGA.CNV')`         |
|RTCGA.methylation |`biocLite('RTCGA.methylation')` |`?methylation` |`browseVignettes('RTCGA.methylation')` |



# Cohorts Names and Number of Cases

The Cancer Genome Atlas provides data via [`Broad GDAC Firehose`](http://gdac.broadinstitute.org/). The number of cases in the most popular datasets can be checked with the following code that is based on the [`Broad GDAC Firehose`](http://gdac.broadinstitute.org/).


{% highlight r %}
knitr::kable(infoTCGA())
{% endhighlight %}



|                |Cohort   |BCR  |Clinical |CN   |LowP |Methylation |mRNA |mRNASeq |miR |miRSeq |RPPA |MAF |rawMAF |
|:---------------|:--------|:----|:--------|:----|:----|:-----------|:----|:-------|:---|:------|:----|:---|:------|
|ACC-counts      |ACC      |92   |92       |90   |0    |80          |0    |79      |0   |80     |46   |90  |0      |
|BLCA-counts     |BLCA     |412  |412      |410  |112  |412         |0    |408     |0   |409    |344  |130 |395    |
|BRCA-counts     |BRCA     |1098 |1097     |1089 |19   |1097        |526  |1093    |0   |1078   |887  |977 |0      |
|CESC-counts     |CESC     |307  |307      |295  |50   |307         |0    |304     |0   |307    |173  |194 |0      |
|CHOL-counts     |CHOL     |51   |45       |36   |0    |36          |0    |36      |0   |36     |30   |35  |0      |
|COAD-counts     |COAD     |460  |458      |451  |69   |457         |153  |457     |0   |406    |360  |154 |367    |
|COADREAD-counts |COADREAD |631  |629      |616  |104  |622         |222  |623     |0   |549    |491  |223 |489    |
|DLBC-counts     |DLBC     |58   |48       |48   |0    |48          |0    |48      |0   |47     |33   |48  |0      |
|ESCA-counts     |ESCA     |185  |185      |184  |51   |185         |0    |184     |0   |184    |126  |185 |0      |
|FPPP-counts     |FPPP     |38   |38       |0    |0    |0           |0    |0       |0   |23     |0    |0   |0      |
|GBM-counts      |GBM      |613  |595      |577  |0    |420         |540  |160     |565 |0      |238  |290 |290    |
|GBMLGG-counts   |GBMLGG   |1129 |1110     |1090 |52   |936         |567  |676     |565 |512    |668  |576 |806    |
|HNSC-counts     |HNSC     |528  |528      |522  |108  |528         |0    |520     |0   |523    |212  |279 |510    |
|KICH-counts     |KICH     |113  |113      |66   |0    |66          |0    |66      |0   |66     |63   |66  |66     |
|KIPAN-counts    |KIPAN    |973  |941      |883  |0    |892         |88   |889     |0   |873    |756  |644 |799    |
|KIRC-counts     |KIRC     |537  |537      |528  |0    |535         |72   |533     |0   |516    |478  |417 |451    |
|KIRP-counts     |KIRP     |323  |291      |289  |0    |291         |16   |290     |0   |291    |215  |161 |282    |
|LAML-counts     |LAML     |200  |200      |197  |0    |194         |0    |179     |0   |188    |0    |197 |0      |
|LGG-counts      |LGG      |516  |515      |513  |52   |516         |27   |516     |0   |512    |430  |286 |516    |
|LIHC-counts     |LIHC     |377  |377      |370  |0    |377         |0    |371     |0   |372    |63   |198 |373    |
|LUAD-counts     |LUAD     |585  |522      |516  |120  |578         |32   |515     |0   |513    |365  |230 |542    |
|LUSC-counts     |LUSC     |504  |504      |501  |0    |503         |154  |501     |0   |478    |328  |178 |0      |
|MESO-counts     |MESO     |87   |87       |87   |0    |87          |0    |87      |0   |87     |63   |0   |0      |
|OV-counts       |OV       |602  |591      |586  |0    |594         |574  |304     |570 |453    |426  |316 |469    |
|PAAD-counts     |PAAD     |185  |185      |184  |0    |184         |0    |178     |0   |178    |123  |150 |184    |
|PCPG-counts     |PCPG     |179  |179      |175  |0    |179         |0    |179     |0   |179    |80   |179 |0      |
|PRAD-counts     |PRAD     |499  |499      |492  |115  |498         |0    |497     |0   |494    |352  |332 |498    |
|READ-counts     |READ     |171  |171      |165  |35   |165         |69   |166     |0   |143    |131  |69  |122    |
|SARC-counts     |SARC     |261  |261      |257  |0    |261         |0    |259     |0   |259    |223  |247 |0      |
|SKCM-counts     |SKCM     |470  |470      |469  |118  |470         |0    |469     |0   |448    |353  |343 |366    |
|STAD-counts     |STAD     |443  |443      |442  |107  |443         |0    |415     |0   |436    |357  |289 |395    |
|STES-counts     |STES     |628  |628      |626  |158  |628         |0    |599     |0   |620    |483  |474 |395    |
|TGCT-counts     |TGCT     |150  |134      |150  |0    |150         |0    |150     |0   |150    |118  |149 |0      |
|THCA-counts     |THCA     |503  |503      |499  |98   |503         |0    |501     |0   |502    |222  |402 |496    |
|THYM-counts     |THYM     |124  |124      |123  |0    |124         |0    |120     |0   |124    |90   |123 |0      |
|UCEC-counts     |UCEC     |560  |548      |540  |106  |547         |54   |545     |0   |538    |440  |248 |0      |
|UCS-counts      |UCS      |57   |57       |56   |0    |57          |0    |57      |0   |56     |48   |57  |0      |
|UVM-counts      |UVM      |80   |80       |80   |51   |80          |0    |80      |0   |80     |12   |80  |0      |


Furthermore `infoTCGA()` enables to extract possible cohorts names from TCGA Study. 

**Cohorts' names stand for abbreviations of real names of cancer types.**


{% highlight r %}
library(magrittr)
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

