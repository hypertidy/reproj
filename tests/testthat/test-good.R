test_that("multiplication works", {
  expect_true(inherits(reproj(cbind(150, 0), "+proj=laea", source = "+proj=longlat"), "matrix"))

 expect_true(inherits(reproj_xy(cbind(150, 0), "+proj=laea", source = "+proj=longlat"), "matrix"))
 skip()
 expect_true(inherits(reproj_xyz(cbind(150, 0), "+proj=laea", source = "+proj=longlat"), "matrix"))
 
})
