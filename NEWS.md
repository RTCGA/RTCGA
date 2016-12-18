# Version 1.5.1

- New version of RTCGA website - http://rtcga.github.io/RTCGA/, based on [pkgdown](http://github.com/hadley/pkgdown/)
- Improved RTCGA workflow graph - https://raw.githubusercontent.com/RTCGA/RTCGA/master/RTCGA_workflow.png
- Added `createTCGA` function which can now create RTCGA.dataType.releaseDate-like data packages. Most of the function result will be published in ExperimentHub on Bioconductor.
- Check new data packages with datasets from `2016-01-28` release date from TCGA
    - https://github.com/RTCGA/RTCGA.clinical.20160128
    - https://github.com/RTCGA/RTCGA.mutations.20160128
    - https://github.com/RTCGA/RTCGA.rnaseq.20160128
    - https://github.com/RTCGA/RTCGA.RPPA.20160128
    - https://github.com/RTCGA/RTCGA.CNV.20160128
    - https://github.com/RTCGA/RTCGA.mRNA.20160128
    - https://github.com/RTCGA/RTCGA.miRNASeq.20160128
    - https://github.com/RTCGA/RTCGA.methylation.20160128

- `readTCGA` now has a `method` for `CNV` datasets.
- You can now download packages from `.20160128` release with `installTCGA` function, which downloads them all by default.
- Improved documentation titles.
- Improved manual page of `installTCGA` after adding packages from `2016-01-08`.
- Provided wider explanation for `?datasetsTCGA` after adding packages from `2016-01-08`.
- Extended biocViews.
- Shortened examples and improved their code appearance.
- Subsitute old URLs in manual pages with new ones - RTCGA website has new architecture.

# Version 1.3.3

- Fixed examples in `expressionsTCGA` that broke after changes in dplyr, while moving to `tibble`s.

# Version 1.1.15

- New functions `heatmapTCGA`, `boxplotTCGA`, `kmTCGA`, `pcaTCGA`, `theme_RTCGA` for plotting [https://rtcga.github.io/RTCGA/Visualizations.html](https://rtcga.github.io/RTCGA/Visualizations.html)
- New functions `mutationsTCGA`, `expressionsTCGA`, `survivalTCGA` for data manipulations.
- New website [https://rtcga.github.io/RTCGA/](https://rtcga.github.io/RTCGA/)

# Version 1.1

- New parameter `allDataSets` for `downloadTCGA` that allows to download all files matching string in the `dataSet` parameter.
- New documentation page `?datasetsTCGA`.
- `readTCGA` has now new `method` for below files 
    - `RPPA` (reverse phase protein array), 
    - `mRNA` (Merge transcriptome agilent),
    - `miRNASeq`
    - `methylation` (methylation datasets)
- `datasetsTCGA` documentation has been extended with new datasets for `rppa` and `mrna`
- `downloadTCGA` now gives a warning when more than one file matches `dataSet` parameter, and downloads the first matched dataset without `FFPE` in the name. If all matching datasets have `FFPE` in the name then the first of them is downloaded.
- `checkTCGA` now downloads also sizes with datasets names when one specifies `what` parameter to `DatSets`.
- Updated tests for `checkTCGA`
- Added new `installTCGA` function that can install all packages from RTCGA family.
- Added new `convertTCGA` function that converts `data.frame`s from RTCGA family to Bioconductor classes.
- New examples in `readTCGA` function documentation concerning the following datasets:
    - `methylation`
    - `RPPA`
    - `mRNA`
    - `miRNASeq`
    - `isoforms`


# Version 1.0

functions
- readTCGA
- infoTCGA
- checkTCGA
- downloadTCGA
