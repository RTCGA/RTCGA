---
layout: page
---


<h2>Workflow of RTCGA family of packages</h2>
<img src='https://raw.githubusercontent.com/RTCGA/RTCGA/master/RTCGA_workflow_ver3.png'> 

> The Cancer Genome Atlas (TCGA) is a comprehensive and coordinated effort to accelerate our understanding of the molecular basis of cancer through the application of genome analysis technologies, including large-scale genome sequencing ([http://cancergenome.nih.gov/](http://cancergenome.nih.gov/)). 

We converted selected datasets from this study into few separate packages that are hosted on Bioconductor. These R packages make selected datasets easier to access and manage. Data sets in RTCGA.data packages are large and cover complex relations between clinical outcomes and genetic background.

These packages will be useful for at least three audiences: biostatisticians that work with cancer data; researchers that are working on large scale algorithms, for them RTGCA will be a perfect blasting site; teachers that are presenting data analysis method on real data problems.

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
source("https://bioconductor.org/biocLite.R") # downloads bioClite function
{% endhighlight r %}

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
# version of packages held at github.com/RTCGA - I try to keep them with the same state as versions on Bioconductor
?RTCGA::installTCGA()
{% endhighlight r %}

# RTCGA

Data packages are based on the `RTCGA` software package


### Installation of the [`RTCGA`](https://github.com/RTCGA/RTCGA) package: 
To get started, install the latest version of **RTCGA** from Bioconductor:

{% highlight r %}
source("https://bioconductor.org/biocLite.R") # downloads bioClite function
biocLite("RTCGA") # installs a package
{% endhighlight r %}
or use below code to download the development version which is like to be less bugged than the release version on Bioconductor:
{% highlight r %}
if (!require(devtools)) {
    install.packages("devtools")
    require(devtools)
}
install_github("RTCGA/RTCGA", build_vignettes = TRUE)
{% endhighlight r %}
To check Use Cases visit [rtcga.github.io/RTCGA/Usecases/](rtcga.github.io/RTCGA/Usecases/) or run
{% highlight r %}
browseVignettes("RTCGA")
{% endhighlight r %}


<h4> Authors: </h4>

>
> Marcin Kosiński, m.p.kosinski@gmail.com
>
> Przemysław Biecek, przemyslaw.biecek@gmail.com
>
> Witold Chodor, witoldchodor@gmail.com
>

This repository is synchronized with it's [Bioconductor's SVN devel mirror](https://hedgehog.fhcrc.org/bioconductor/trunk/madman/Rpacks/RTCGA).


![RTCGA logo](https://avatars3.githubusercontent.com/u/15612915?v=3&s=300)
