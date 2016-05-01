[![Travis-CI Build Status](https://travis-ci.org/RTCGA/RTCGA.svg?branch=master)](https://travis-ci.org/RTCGA/RTCGA)
[![Project Status: Active - The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)[![Pending Pull-Requests](http://githubbadges.herokuapp.com/RTCGA/RTCGA/pulls.svg?style=flat)](https://github.com/RTCGA/RTCGA/pulls)
[![Github Issues](http://githubbadges.herokuapp.com/RTCGA/RTCGA/issues.svg)](https://github.com/RTCGA/RTCGA/issues)

# The family of R packages containing TCGA data

The Cancer Genome Atlas (TCGA) is a comprehensive and coordinated effort to accelerate our understanding of the molecular basis of cancer through the application of genome analysis technologies, including large-scale genome sequencing ([http://cancergenome.nih.gov/](http://cancergenome.nih.gov/)). We converted selected datasets from this study into few separate packages that are hosted on Bioconductor. These R packages make selected datasets easier to access and manage. Data sets in RTCGA.data packages are large and cover complex relations between clinical outcomes and genetic background.

These packages will be useful for at least three audiences: biostatisticians that work with cancer data; researchers that are working on large scale algorithms, for them RTGCA will be a perfect blasting site; teachers that are presenting data analysis method on real data problems.

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

```{R}
# packages that are published to devel version of Bioconductor
BiocInstaller::useDevel() # swiches to devel branchof Bioconductor - don't use this line if you are interested in release versions
source("https://bioconductor.org/biocLite.R") # downloads bioClite function
```

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

```{R}
# version of packages held at github.com/RTCGA - I try to keep them with the same state as devel versions of Bioconductor
library(RTCGA)
installTCGA("RTCGA.PANCAN12")
installTCGA("RTCGA.CNV")
installTCGA("RTCGA.RPPA")
installTCGA("RTCGA.mRNA")
installTCGA("RTCGA.miRNASeq")
installTCGA("RTCGA.methylation")
# or for all just type installTCGA()
```

# RTCGA

Packages from the `RTCGA.data` - family/factory are based on the `RTCGA` package


### Installation of the [`RTCGA`](https://github.com/RTCGA/RTCGA) package: 
To get started, install the latest version of **RTCGA** from Bioconductor:

```{R}
BiocInstaller::useDevel() # swiches to devel branch of Bioconductor
source("https://bioconductor.org/biocLite.R") # downloads bioClite function
biocLite("RTCGA") # installs a package
```
or use below code to download the development version which is like to be less bugged than the release version on Bioconductor:
```{R}
if (!require(devtools)) {
    install.packages("devtools")
    require(devtools)
}
install_github("RTCGA/RTCGA", build_vignettes = TRUE)
```
To check Use Cases run
```{R}
browseVignettes("RTCGA")
```


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
