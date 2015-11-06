test_that("checkTCGA() function works properly", {
    expect_equal( length(checkTCGA('Dates')) >= 60, T )
    expect_is( checkTCGA('Dates'), "character" )
    expect_equal( "2015-06-01" %in% checkTCGA('Dates'), T )
    expect_error( checkTCGA('DataSets', 'OV', checkTCGA('Dates')[5] ) )
    expect_equal( length(checkTCGA('DataSets', 'OV', "2015-06-01" )) == 252, T )
    expect_is( checkTCGA('DataSets', 'OV', tail(checkTCGA('Dates'))[1]), "character" )
})