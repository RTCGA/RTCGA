---
layout:  page
title: "Installation"
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
BiocInstaller::useDevel() 
# swiches to devel branchof Bioconductor 
# don't use this line if you are interested in release vers
source("https://bioconductor.org/biocLite.R") # downloads bioClite function
{% endhighlight %}

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


{% highlight r %}
# version of packages held at github.com/RTCGA - I try to keep them with the same state as devel versions of Bioconductor
library(RTCGA)
installTCGA("RTCGA.PANCAN12")
installTCGA("RTCGA.CNV")
installTCGA("RTCGA.RPPA")
installTCGA("RTCGA.mRNA")
installTCGA("RTCGA.miRNASeq")
installTCGA("RTCGA.methylation")
# or for all just type installTCGA()
{% endhighlight %}

# RTCGA

Packages from the `RTCGA.data` - family/factory are based on the `RTCGA` package


### Installation of the [`RTCGA`](https://github.com/RTCGA/RTCGA) package: 
To get started, install the latest version of **RTCGA** from Bioconductor:


{% highlight r %}
BiocInstaller::useDevel() # swiches to devel branch of Bioconductor
source("https://bioconductor.org/biocLite.R") 
# downloads bioClite function
biocLite("RTCGA") # installs a package
{% endhighlight %}
or use below code to download the development version which is like to be less bugged than the release version on Bioconductor:

{% highlight r %}
if (!require(devtools)) {
    install.packages("devtools")
    require(devtools)
}
install_github("RTCGA/RTCGA", build_vignettes = TRUE)
{% endhighlight %}
To check Use Cases run

{% highlight r %}
browseVignettes("RTCGA")
{% endhighlight %}


<h4> Authors: </h4>

>
> Marcin Kosiński, m.p.kosinski@gmail.com
>
> Przemysław Biecek, przemyslaw.biecek@gmail.com
>
> Witold Chorod, witoldchodor@gmail.com
>
