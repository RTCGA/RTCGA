.RTCGAEnv <- new.env()

.onAttach <- function(...) {
    packageStartupMessage("Welcome to the RTCGA (version: ", utils::packageVersion("RTCGA"), ").")
    
    
    # assign( x = '.gdacContent', value = readLines( 'http://gdac.broadinstitute.org/runs/' ), envir = .RTCGAEnv ) assign( x =
    # '.lastReleaseDate', value = stri_extract( grep( pattern= 'stddata__20', x = get( '.gdacContent', envir = .RTCGAEnv), value =
    # TRUE)[length( grep( pattern= 'stddata__20', x = get( '.gdacContent', envir = .RTCGAEnv), value = TRUE ))], regex =
    # 'stddata__201[0-9]_[0-9]{2}_[0-9]{2}'), envir = .RTCGAEnv ) assign( x= '.availableDates', value = stri_extract( grep( pattern=
    # 'stddata__20', x = get( '.gdacContent', envir = .RTCGAEnv), value = TRUE), regex = 'stddata__201[0-9]_[0-9]{2}_[0-9]{2}'), envir =
    # .RTCGAEnv )
    
    
}

.onLoad <- function(libname, pkgname) {
    vig_list = tools::vignetteEngine(package = 'knitr')
    vweave <- vig_list[['knitr::knitr']][c('weave')][[1]]
    vtangle <- vig_list[['knitr::knitr']][c('tangle')][[1]]
    tools::vignetteEngine(pkgname, weave = vweave, tangle = vtangle,
                          pattern = "[.]Rmd$", package = pkgname)
    #register_vignette_engines(pkgname)
}


.onDetach <- function(libpath) {
    .RTCGAEnv <- NULL
}

## no S4 methodology here; speedup :
.noGenerics <- TRUE 
