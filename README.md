[![Travis-CI Build Status](https://travis-ci.org/RTCGA/RTCGA.svg?branch=master)](https://travis-ci.org/RTCGA/RTCGA)
[![Project Status: Active - The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)                
![RTCGA logo](https://avatars3.githubusercontent.com/u/15612915?v=3&s=50)

# The family of R packages containing TCGA data

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


### Installation of packages from the `RTCGA.data` family: 

Windows users:
> Make sure you have [rtools](http://cran.r-project.org/bin/windows/Rtools/) installed on your computer.

```{R}
# packages that are published to devel version of Bioconductor
BiocInstaller::useDevel() # swiches to devel branchof Bioconductor - don't use this line if you are interested in release versions
source("https://bioconductor.org/biocLite.R") # downloads bioClite function
biocLite("RTCGA.clinical") # installs a package
biocLite("RTCGA.rnaseq")
biocLite("RTCGA.mutations")
biocLite("RTCGA.PANCAN12")
biocLite("RTCGA.CNV")
biocLite("RTCGA.RPPA")
biocLite("RTCGA.mRNA")
biocLite("RTCGA.miRNASeq")
biocLite("RTCGA.methylation")


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

<h5> The list of available datasets: </h5>
```{R}
help(dataType)
# where dataType is one of: 'datasetsTCGA', 'clinical', 'rnaseq'
# 'mutations', 'pancan12', 'CNV', 'RPPA', 'mRNA', 'miRNASeq', 'methylation'
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
> Witold Chorod, witoldchodor@gmail.com
>

This repository is synchronized with it's [Bioconductor's SVN devel mirror](https://hedgehog.fhcrc.org/bioconductor/trunk/madman/Rpacks/RTCGA).
