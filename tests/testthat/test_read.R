test_that("downloadTCGA() function works properly", {
    expect_dimsSize_equal <- function(parameters, dimsSize){
        tmp <- tempdir()
        downloadTCGA( cancerTypes = parameters[[1]],
                      destDir = tmp,
                      date = parameters[[2]])
        
        list.files(tmp) %>%
            grep("Clinical", x = ., value = TRUE) %>%
            file.path(tmp, .)  -> folder
        
        folder %>%
            list.files() %>%
            grep("clin.merged", x = ., value=TRUE) %>%
            file.path(folder, .) %>%
            readTCGA(path = ., "clinical") -> clinical_data
        
        
        
        expect_equal( dim(clinical_data), dimsSize )
        unlink(tmp)
    }
    expect_dimsSize_equal( list( "ACC", "2015-06-01" ), c(92, 1115) )
})