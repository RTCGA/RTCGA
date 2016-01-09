test_that("convertTCGA() function works properly", {
    data(BRCA.rnaseq, package = "RTCGA.rnaseq")
    expect_is(convertTCGA(BRCA.rnaseq), "ExpressionSet")
    #expect_is(convertTCGA(BRCA.CNV, "CNV"), "GRanges")
    #expect_is(convertPANCAN12(expression.cb1), "ExpressionSet")
})