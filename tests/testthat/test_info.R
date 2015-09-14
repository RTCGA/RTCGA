test_that("infoTCGA() function works properly", {
    expect_equal( dim(infoTCGA()), c(38, 13) )
    expect_is( infoTCGA(), "data.frame" )
    expect_equal("ACC" %in% (sub("-counts", "", x= rownames( infoTCGA()  ) ) ), T)
        
})