test_that("downloadTCGA() function works properly", {
    expect_size_equal <- function(parameters, size){
        tmp <- tempdir()
        downloadTCGA( cancerTypes = parameters[[1]],
                      destDir = tmp,
                      date = parameters[[2]],
                      removeTar = FALSE,
                      untarFile = FALSE)
        expect_equal( file.size( 
                                grep(
                                     pattern = "tar",
                                     x =  file.path(tmp,
                                                    grep(pattern = parameters[[1]],
                                                            list.files(tmp),
                                                            value = TRUE)
                                                    ),
                                     value = TRUE
                                 )
                                ),
                      size
        )
        unlink(tmp)
    }
    expect_size_equal( list( "ACC", "2015-06-01" ), 151456)
})