---
layout:  page
title: "Workflow and Installation"
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




![Workflow of RTCGA package](https://raw.githubusercontent.com/RTCGA/RTCGA/master/RTCGA_workflow_ver3.png)


Data packages submitted to Bioconductor

- [RTCGA.mutations](http://bioconductor.org/packages/3.2/data/experiment/html/RTCGA.mutations.html)
- [RTCGA.rnaseq](http://bioconductor.org/packages/3.2/data/experiment/html/RTCGA.rnaseq.html)
- [RTCGA.clinical](http://bioconductor.org/packages/3.2/data/experiment/html/RTCGA.clinical.html)
- [RTCGA.PANCAN12](http://bioconductor.org/packages/RTCGA.PANCAN12/)
- [RTCGA.mRNA](http://bioconductor.org/packages/RTCGA.mRNA/)
- [RTCGA.miRNASeq](http://bioconductor.org/packages/RTCGA.miRNASeq/)
- [RTCGA.RPPA](http://bioconductor.org/packages/RTCGA.RPPA/)
- [RTCGA.CNV](http://bioconductor.org/packages/RTCGA.CNV/)
- [RTCGA.methylation](http://bioconductor.org/packages/RTCGA.methylation/)


### Installation of packages from the `RTCGA` family: 

Windows users:
> Make sure you have [rtools](http://cran.r-project.org/bin/windows/Rtools/) installed on your computer.


{% highlight r %}
# packages that are published to devel version of Bioconductor
BiocInstaller::useDevel() # swiches to devel branchof Bioconductor - don't use this line if you are interested in release versions
{% endhighlight %}



{% highlight text %}
## Error: 'devel' version requires a more recent R
{% endhighlight %}



{% highlight r %}
source("https://bioconductor.org/biocLite.R") # downloads bioClite function
{% endhighlight %}



{% highlight text %}
## Bioconductor version 3.2 (BiocInstaller 1.20.1), ?biocLite for help
{% endhighlight %}



{% highlight r %}
biocLite("RTCGA.clinical") # installs a package
{% endhighlight %}



{% highlight text %}
## BioC_mirror: https://bioconductor.org
{% endhighlight %}



{% highlight text %}
## Using Bioconductor 3.2 (BiocInstaller 1.20.1), R 3.2.2 (2015-08-14).
{% endhighlight %}



{% highlight text %}
## Installing package(s) 'RTCGA.clinical'
{% endhighlight %}



{% highlight text %}
## 
## The downloaded source packages are in
## 	'/tmp/Rtmpzt7Kqz/downloaded_packages'
{% endhighlight %}



{% highlight text %}
## Old packages: 'bigmemory', 'BiocCheck', 'Biostrings', 'ChIPpeakAnno',
##   'DiagrammeR', 'dygraphs', 'GenomeInfoDb', 'GenomicFeatures',
##   'GenomicRanges', 'glmnet', 'Hmisc', 'IRanges', 'latticeExtra',
##   'limma', 'lme4', 'manipulate', 'maps', 'MBESS', 'mgcv', 'multcomp',
##   'mvtnorm', 'NLP', 'nnet', 'quantreg', 'RcppArmadillo', 'RcppEigen',
##   'regioneR', 'R.oo', 'rtracklayer', 'S4Vectors', 'shiny',
##   'survMisc', 'TH.data', 'tidyr', 'topicmodels', 'visNetwork',
##   'xtable', 'rJava', 'boot', 'MASS', 'Matrix', 'mgcv', 'nlme',
##   'nnet', 'spatial'
{% endhighlight %}



{% highlight r %}
biocLite("RTCGA.rnaseq")
{% endhighlight %}



{% highlight text %}
## BioC_mirror: https://bioconductor.org
{% endhighlight %}



{% highlight text %}
## Using Bioconductor 3.2 (BiocInstaller 1.20.1), R 3.2.2 (2015-08-14).
{% endhighlight %}



{% highlight text %}
## Installing package(s) 'RTCGA.rnaseq'
{% endhighlight %}



{% highlight text %}
## 
## The downloaded source packages are in
## 	'/tmp/Rtmpzt7Kqz/downloaded_packages'
{% endhighlight %}



{% highlight text %}
## Old packages: 'bigmemory', 'BiocCheck', 'Biostrings', 'ChIPpeakAnno',
##   'DiagrammeR', 'dygraphs', 'GenomeInfoDb', 'GenomicFeatures',
##   'GenomicRanges', 'glmnet', 'Hmisc', 'IRanges', 'latticeExtra',
##   'limma', 'lme4', 'manipulate', 'maps', 'MBESS', 'mgcv', 'multcomp',
##   'mvtnorm', 'NLP', 'nnet', 'quantreg', 'RcppArmadillo', 'RcppEigen',
##   'regioneR', 'R.oo', 'rtracklayer', 'S4Vectors', 'shiny',
##   'survMisc', 'TH.data', 'tidyr', 'topicmodels', 'visNetwork',
##   'xtable', 'rJava', 'boot', 'MASS', 'Matrix', 'mgcv', 'nlme',
##   'nnet', 'spatial'
{% endhighlight %}



{% highlight r %}
biocLite("RTCGA.mutations")
{% endhighlight %}



{% highlight text %}
## BioC_mirror: https://bioconductor.org
{% endhighlight %}



{% highlight text %}
## Using Bioconductor 3.2 (BiocInstaller 1.20.1), R 3.2.2 (2015-08-14).
{% endhighlight %}



{% highlight text %}
## Installing package(s) 'RTCGA.mutations'
{% endhighlight %}



{% highlight text %}
## 
## The downloaded source packages are in
## 	'/tmp/Rtmpzt7Kqz/downloaded_packages'
{% endhighlight %}



{% highlight text %}
## Old packages: 'bigmemory', 'BiocCheck', 'Biostrings', 'ChIPpeakAnno',
##   'DiagrammeR', 'dygraphs', 'GenomeInfoDb', 'GenomicFeatures',
##   'GenomicRanges', 'glmnet', 'Hmisc', 'IRanges', 'latticeExtra',
##   'limma', 'lme4', 'manipulate', 'maps', 'MBESS', 'mgcv', 'multcomp',
##   'mvtnorm', 'NLP', 'nnet', 'quantreg', 'RcppArmadillo', 'RcppEigen',
##   'regioneR', 'R.oo', 'rtracklayer', 'S4Vectors', 'shiny',
##   'survMisc', 'TH.data', 'tidyr', 'topicmodels', 'visNetwork',
##   'xtable', 'rJava', 'boot', 'MASS', 'Matrix', 'mgcv', 'nlme',
##   'nnet', 'spatial'
{% endhighlight %}



{% highlight r %}
biocLite("RTCGA.PANCAN12")
{% endhighlight %}



{% highlight text %}
## BioC_mirror: https://bioconductor.org
{% endhighlight %}



{% highlight text %}
## Using Bioconductor 3.2 (BiocInstaller 1.20.1), R 3.2.2 (2015-08-14).
{% endhighlight %}



{% highlight text %}
## Installing package(s) 'RTCGA.PANCAN12'
{% endhighlight %}



{% highlight text %}
## Warning: package 'RTCGA.PANCAN12' is not available (for R version
## 3.2.2)
{% endhighlight %}



{% highlight text %}
## Old packages: 'bigmemory', 'BiocCheck', 'Biostrings', 'ChIPpeakAnno',
##   'DiagrammeR', 'dygraphs', 'GenomeInfoDb', 'GenomicFeatures',
##   'GenomicRanges', 'glmnet', 'Hmisc', 'IRanges', 'latticeExtra',
##   'limma', 'lme4', 'manipulate', 'maps', 'MBESS', 'mgcv', 'multcomp',
##   'mvtnorm', 'NLP', 'nnet', 'quantreg', 'RcppArmadillo', 'RcppEigen',
##   'regioneR', 'R.oo', 'rtracklayer', 'S4Vectors', 'shiny',
##   'survMisc', 'TH.data', 'tidyr', 'topicmodels', 'visNetwork',
##   'xtable', 'rJava', 'boot', 'MASS', 'Matrix', 'mgcv', 'nlme',
##   'nnet', 'spatial'
{% endhighlight %}



{% highlight r %}
biocLite("RTCGA.CNV")
{% endhighlight %}



{% highlight text %}
## BioC_mirror: https://bioconductor.org
{% endhighlight %}



{% highlight text %}
## Using Bioconductor 3.2 (BiocInstaller 1.20.1), R 3.2.2 (2015-08-14).
{% endhighlight %}



{% highlight text %}
## Installing package(s) 'RTCGA.CNV'
{% endhighlight %}



{% highlight text %}
## Warning: package 'RTCGA.CNV' is not available (for R version 3.2.2)
{% endhighlight %}



{% highlight text %}
## Old packages: 'bigmemory', 'BiocCheck', 'Biostrings', 'ChIPpeakAnno',
##   'DiagrammeR', 'dygraphs', 'GenomeInfoDb', 'GenomicFeatures',
##   'GenomicRanges', 'glmnet', 'Hmisc', 'IRanges', 'latticeExtra',
##   'limma', 'lme4', 'manipulate', 'maps', 'MBESS', 'mgcv', 'multcomp',
##   'mvtnorm', 'NLP', 'nnet', 'quantreg', 'RcppArmadillo', 'RcppEigen',
##   'regioneR', 'R.oo', 'rtracklayer', 'S4Vectors', 'shiny',
##   'survMisc', 'TH.data', 'tidyr', 'topicmodels', 'visNetwork',
##   'xtable', 'rJava', 'boot', 'MASS', 'Matrix', 'mgcv', 'nlme',
##   'nnet', 'spatial'
{% endhighlight %}



{% highlight r %}
biocLite("RTCGA.RPPA")
{% endhighlight %}



{% highlight text %}
## BioC_mirror: https://bioconductor.org
{% endhighlight %}



{% highlight text %}
## Using Bioconductor 3.2 (BiocInstaller 1.20.1), R 3.2.2 (2015-08-14).
{% endhighlight %}



{% highlight text %}
## Installing package(s) 'RTCGA.RPPA'
{% endhighlight %}



{% highlight text %}
## Warning: package 'RTCGA.RPPA' is not available (for R version 3.2.2)
{% endhighlight %}



{% highlight text %}
## Old packages: 'bigmemory', 'BiocCheck', 'Biostrings', 'ChIPpeakAnno',
##   'DiagrammeR', 'dygraphs', 'GenomeInfoDb', 'GenomicFeatures',
##   'GenomicRanges', 'glmnet', 'Hmisc', 'IRanges', 'latticeExtra',
##   'limma', 'lme4', 'manipulate', 'maps', 'MBESS', 'mgcv', 'multcomp',
##   'mvtnorm', 'NLP', 'nnet', 'quantreg', 'RcppArmadillo', 'RcppEigen',
##   'regioneR', 'R.oo', 'rtracklayer', 'S4Vectors', 'shiny',
##   'survMisc', 'TH.data', 'tidyr', 'topicmodels', 'visNetwork',
##   'xtable', 'rJava', 'boot', 'MASS', 'Matrix', 'mgcv', 'nlme',
##   'nnet', 'spatial'
{% endhighlight %}



{% highlight r %}
biocLite("RTCGA.mRNA")
{% endhighlight %}



{% highlight text %}
## BioC_mirror: https://bioconductor.org
{% endhighlight %}



{% highlight text %}
## Using Bioconductor 3.2 (BiocInstaller 1.20.1), R 3.2.2 (2015-08-14).
{% endhighlight %}



{% highlight text %}
## Installing package(s) 'RTCGA.mRNA'
{% endhighlight %}



{% highlight text %}
## Warning: package 'RTCGA.mRNA' is not available (for R version 3.2.2)
{% endhighlight %}



{% highlight text %}
## Old packages: 'bigmemory', 'BiocCheck', 'Biostrings', 'ChIPpeakAnno',
##   'DiagrammeR', 'dygraphs', 'GenomeInfoDb', 'GenomicFeatures',
##   'GenomicRanges', 'glmnet', 'Hmisc', 'IRanges', 'latticeExtra',
##   'limma', 'lme4', 'manipulate', 'maps', 'MBESS', 'mgcv', 'multcomp',
##   'mvtnorm', 'NLP', 'nnet', 'quantreg', 'RcppArmadillo', 'RcppEigen',
##   'regioneR', 'R.oo', 'rtracklayer', 'S4Vectors', 'shiny',
##   'survMisc', 'TH.data', 'tidyr', 'topicmodels', 'visNetwork',
##   'xtable', 'rJava', 'boot', 'MASS', 'Matrix', 'mgcv', 'nlme',
##   'nnet', 'spatial'
{% endhighlight %}



{% highlight r %}
biocLite("RTCGA.miRNASeq")
{% endhighlight %}



{% highlight text %}
## BioC_mirror: https://bioconductor.org
{% endhighlight %}



{% highlight text %}
## Using Bioconductor 3.2 (BiocInstaller 1.20.1), R 3.2.2 (2015-08-14).
{% endhighlight %}



{% highlight text %}
## Installing package(s) 'RTCGA.miRNASeq'
{% endhighlight %}



{% highlight text %}
## Warning: package 'RTCGA.miRNASeq' is not available (for R version
## 3.2.2)
{% endhighlight %}



{% highlight text %}
## Old packages: 'bigmemory', 'BiocCheck', 'Biostrings', 'ChIPpeakAnno',
##   'DiagrammeR', 'dygraphs', 'GenomeInfoDb', 'GenomicFeatures',
##   'GenomicRanges', 'glmnet', 'Hmisc', 'IRanges', 'latticeExtra',
##   'limma', 'lme4', 'manipulate', 'maps', 'MBESS', 'mgcv', 'multcomp',
##   'mvtnorm', 'NLP', 'nnet', 'quantreg', 'RcppArmadillo', 'RcppEigen',
##   'regioneR', 'R.oo', 'rtracklayer', 'S4Vectors', 'shiny',
##   'survMisc', 'TH.data', 'tidyr', 'topicmodels', 'visNetwork',
##   'xtable', 'rJava', 'boot', 'MASS', 'Matrix', 'mgcv', 'nlme',
##   'nnet', 'spatial'
{% endhighlight %}



{% highlight r %}
biocLite("RTCGA.methylation")
{% endhighlight %}



{% highlight text %}
## BioC_mirror: https://bioconductor.org
{% endhighlight %}



{% highlight text %}
## Using Bioconductor 3.2 (BiocInstaller 1.20.1), R 3.2.2 (2015-08-14).
{% endhighlight %}



{% highlight text %}
## Installing package(s) 'RTCGA.methylation'
{% endhighlight %}



{% highlight text %}
## Warning: package 'RTCGA.methylation' is not available (for R version
## 3.2.2)
{% endhighlight %}



{% highlight text %}
## Old packages: 'bigmemory', 'BiocCheck', 'Biostrings', 'ChIPpeakAnno',
##   'DiagrammeR', 'dygraphs', 'GenomeInfoDb', 'GenomicFeatures',
##   'GenomicRanges', 'glmnet', 'Hmisc', 'IRanges', 'latticeExtra',
##   'limma', 'lme4', 'manipulate', 'maps', 'MBESS', 'mgcv', 'multcomp',
##   'mvtnorm', 'NLP', 'nnet', 'quantreg', 'RcppArmadillo', 'RcppEigen',
##   'regioneR', 'R.oo', 'rtracklayer', 'S4Vectors', 'shiny',
##   'survMisc', 'TH.data', 'tidyr', 'topicmodels', 'visNetwork',
##   'xtable', 'rJava', 'boot', 'MASS', 'Matrix', 'mgcv', 'nlme',
##   'nnet', 'spatial'
{% endhighlight %}



{% highlight r %}
# version of packages held at github.com/RTCGA - I try to keep them with the same state as devel versions of Bioconductor
library(RTCGA)
{% endhighlight %}



{% highlight text %}
## Welcome to the RTCGA (version: 1.1.14).
{% endhighlight %}



{% highlight r %}
installTCGA("RTCGA.PANCAN12")
{% endhighlight %}



{% highlight text %}
## Skipping install for github remote, the SHA1 (3f9ba6ca) has not changed since last install.
##   Use `force = TRUE` to force installation
{% endhighlight %}



{% highlight text %}
## $RTCGA.PANCAN12
## logical(0)
{% endhighlight %}



{% highlight r %}
installTCGA("RTCGA.CNV")
{% endhighlight %}



{% highlight text %}
## Skipping install for github remote, the SHA1 (9d2e36de) has not changed since last install.
##   Use `force = TRUE` to force installation
{% endhighlight %}



{% highlight text %}
## $RTCGA.CNV
## logical(0)
{% endhighlight %}



{% highlight r %}
installTCGA("RTCGA.RPPA")
{% endhighlight %}



{% highlight text %}
## Skipping install for github remote, the SHA1 (fa1c4f4a) has not changed since last install.
##   Use `force = TRUE` to force installation
{% endhighlight %}



{% highlight text %}
## $RTCGA.RPPA
## logical(0)
{% endhighlight %}



{% highlight r %}
installTCGA("RTCGA.mRNA")
{% endhighlight %}



{% highlight text %}
## Skipping install for github remote, the SHA1 (dffd7dc2) has not changed since last install.
##   Use `force = TRUE` to force installation
{% endhighlight %}



{% highlight text %}
## $RTCGA.mRNA
## logical(0)
{% endhighlight %}



{% highlight r %}
installTCGA("RTCGA.miRNASeq")
{% endhighlight %}



{% highlight text %}
## Skipping install for github remote, the SHA1 (9be686a1) has not changed since last install.
##   Use `force = TRUE` to force installation
{% endhighlight %}



{% highlight text %}
## $RTCGA.miRNASeq
## logical(0)
{% endhighlight %}



{% highlight r %}
installTCGA("RTCGA.methylation")
{% endhighlight %}



{% highlight text %}
## Skipping install for github remote, the SHA1 (951f85f0) has not changed since last install.
##   Use `force = TRUE` to force installation
{% endhighlight %}



{% highlight text %}
## $RTCGA.methylation
## logical(0)
{% endhighlight %}



{% highlight r %}
# or for all just type installTCGA()
{% endhighlight %}

<h5> The list of available datasets: </h5>

{% highlight r %}
help(dataType)
{% endhighlight %}



{% highlight text %}
## No documentation for 'dataType' in specified packages and libraries:
## you could try '??dataType'
{% endhighlight %}



{% highlight r %}
# where dataType is one of: 'datasetsTCGA', 'clinical', 'rnaseq'
# 'mutations', 'pancan12', 'CNV', 'RPPA', 'mRNA', 'miRNASeq', 'methylation'
{% endhighlight %}

# RTCGA

Packages from the `RTCGA.data` - family/factory are based on the `RTCGA` package


### Installation of the [`RTCGA`](https://github.com/RTCGA/RTCGA) package: 
To get started, install the latest version of **RTCGA** from Bioconductor:


{% highlight r %}
BiocInstaller::useDevel() # swiches to devel branch of Bioconductor
{% endhighlight %}



{% highlight text %}
## Error: 'devel' version requires a more recent R
{% endhighlight %}



{% highlight r %}
source("https://bioconductor.org/biocLite.R") # downloads bioClite function
{% endhighlight %}



{% highlight text %}
## Bioconductor version 3.2 (BiocInstaller 1.20.1), ?biocLite for help
{% endhighlight %}



{% highlight r %}
biocLite("RTCGA") # installs a package
{% endhighlight %}



{% highlight text %}
## BioC_mirror: https://bioconductor.org
{% endhighlight %}



{% highlight text %}
## Using Bioconductor 3.2 (BiocInstaller 1.20.1), R 3.2.2 (2015-08-14).
{% endhighlight %}



{% highlight text %}
## Installing package(s) 'RTCGA'
{% endhighlight %}



{% highlight text %}
## 
## The downloaded source packages are in
## 	'/tmp/Rtmpzt7Kqz/downloaded_packages'
{% endhighlight %}



{% highlight text %}
## Old packages: 'bigmemory', 'BiocCheck', 'Biostrings', 'ChIPpeakAnno',
##   'DiagrammeR', 'dygraphs', 'GenomeInfoDb', 'GenomicFeatures',
##   'GenomicRanges', 'glmnet', 'Hmisc', 'IRanges', 'latticeExtra',
##   'limma', 'lme4', 'manipulate', 'maps', 'MBESS', 'mgcv', 'multcomp',
##   'mvtnorm', 'NLP', 'nnet', 'quantreg', 'RcppArmadillo', 'RcppEigen',
##   'regioneR', 'R.oo', 'rtracklayer', 'S4Vectors', 'shiny',
##   'survMisc', 'TH.data', 'tidyr', 'topicmodels', 'visNetwork',
##   'xtable', 'rJava', 'boot', 'MASS', 'Matrix', 'mgcv', 'nlme',
##   'nnet', 'spatial'
{% endhighlight %}
or use below code to download the development version which is like to be less bugged than the release version on Bioconductor:

{% highlight r %}
if (!require(devtools)) {
    install.packages("devtools")
    require(devtools)
}
{% endhighlight %}



{% highlight text %}
## Loading required package: devtools
{% endhighlight %}



{% highlight r %}
install_github("RTCGA/RTCGA", build_vignettes = TRUE)
{% endhighlight %}



{% highlight text %}
## Downloading GitHub repo RTCGA/RTCGA@master
## from URL https://api.github.com/repos/RTCGA/RTCGA/zipball/master
{% endhighlight %}



{% highlight text %}
## Installing RTCGA
{% endhighlight %}



{% highlight text %}
## Skipping install for github remote, the SHA1 (7325e880) has not changed since last install.
##   Use `force = TRUE` to force installation
{% endhighlight %}



{% highlight text %}
## Skipping 7 unavailable packages: ggbiplot, RTCGA.CNV, RTCGA.methylation, RTCGA.miRNASeq, RTCGA.mRNA, RTCGA.PANCAN12, RTCGA.RPPA
{% endhighlight %}



{% highlight text %}
## Skipping 2 packages ahead of CRAN: data.table, survminer
{% endhighlight %}



{% highlight text %}
## Installing 5 packages: GenomeInfoDb, GenomicRanges, IRanges, S4Vectors, tidyr
{% endhighlight %}



{% highlight text %}
## Installing packages into '/home/mkosinski/R/x86_64-pc-linux-gnu-library/3.2'
## (as 'lib' is unspecified)
{% endhighlight %}



{% highlight text %}
## 
## The downloaded source packages are in
## 	'/tmp/Rtmpzt7Kqz/downloaded_packages'
{% endhighlight %}



{% highlight text %}
## '/usr/lib/R/bin/R' --no-site-file --no-environ --no-save  \
##   --no-restore CMD build  \
##   '/tmp/Rtmpzt7Kqz/devtools1a21340439bf/RTCGA-RTCGA-b4612ce'  \
##   --no-resave-data --no-manual
{% endhighlight %}



{% highlight text %}
## 
{% endhighlight %}



{% highlight text %}
## '/usr/lib/R/bin/R' --no-site-file --no-environ --no-save  \
##   --no-restore CMD INSTALL '/tmp/Rtmpzt7Kqz/RTCGA_1.1.14.tar.gz'  \
##   --library='/home/mkosinski/R/x86_64-pc-linux-gnu-library/3.2'  \
##   --install-tests
{% endhighlight %}



{% highlight text %}
## 
{% endhighlight %}



{% highlight text %}
## Reloading installed RTCGA
{% endhighlight %}



{% highlight text %}
## Welcome to the RTCGA (version: 1.1.14).
{% endhighlight %}
To check Use Cases run

{% highlight r %}
browseVignettes("RTCGA")
{% endhighlight %}



{% highlight text %}
## starting httpd help server ...
{% endhighlight %}



{% highlight text %}
##  done
{% endhighlight %}


<h4> Authors: </h4>

>
> Marcin Kosiński, m.p.kosinski@gmail.com
>
> Przemysław Biecek, przemyslaw.biecek@gmail.com
>
> Witold Chorod, witoldchodor@gmail.com
>
