test_that("four = TRUE is an error", {
  expect_error(
    reproj(cbind(147, -42), "EPSG:3112", source = "OGC:CRS84", four = TRUE),
    "not available"
  )
})

test_that("missing source errors for non-longlat data", {
  expect_error(
    reproj(cbind(1e6, 5e6), "EPSG:4326"),
    "no 'source' projection"
  )
})

test_that("missing source warns and assumes longlat for plausible data", {
  expect_warning(
    out <- reproj(cbind(147, -42), "EPSG:3112"),
    "looks like longitude/latitude"
  )
  expect_equal(unname(out[1, 1]), 1100523.652, tolerance = 1e-6)
})

test_that("assume.longlat option off forces explicit source", {
  old <- options(reproj.assume.longlat = FALSE)
  on.exit(options(old))
  expect_error(reproj(cbind(147, -42), "EPSG:3112"), "no 'source' projection")
})

test_that("column names are ignored, contract is positional", {
  ## misleading names must not cause reordering
  m <- cbind(y = 147, x = -42)
  named <- reproj(m, "EPSG:3112", source = "OGC:CRS84")
  bare <- reproj(cbind(147, -42), "EPSG:3112", source = "OGC:CRS84")
  expect_equal(unname(named), unname(bare))
})

test_that("z and m columns transform and return", {
  out3 <- reproj(cbind(147, -42, 1000), "EPSG:4978", source = "EPSG:4326")
  expect_equal(ncol(out3), 3L)
  expect_equal(out3[1, ], c(x = -3981791.574, y = 2585805.683, z = -4246272.967),
    tolerance = 1e-6)
  out4 <- reproj(cbind(147, -42, 0, 5), "EPSG:3112", source = "OGC:CRS84")
  expect_equal(ncol(out4), 4L)
  expect_equal(unname(out4[1, 4]), 5)
})

test_that("data frame and integer input work", {
  df <- data.frame(x = 147L, y = -42L)
  out <- reproj(df, "EPSG:3112", source = "OGC:CRS84")
  expect_equal(out[1, 1:2], c(x = 1100523.652, y = -4780604.059), tolerance = 1e-6)
})

test_that("reproj_xy and reproj_xyz shapes", {
  ## xy from 3-column input
  expect_equal(dim(reproj_xy(cbind(147, -42, 1), target = "EPSG:3112", source = "OGC:CRS84")), c(1L, 2L))
  ## xyz pads 2-column input with zero z
  out <- reproj_xyz(cbind(147, -42), target = "EPSG:3112", source = "OGC:CRS84")
  expect_equal(dim(out), c(1L, 3L))
  expect_equal(unname(out[1, 3]), 0)
  ## xyz trims 4-column input
  expect_equal(dim(reproj_xyz(cbind(147, -42, 0, 1), target = "EPSG:3112", source = "OGC:CRS84")), c(1L, 3L))
  ## single row does not drop dimensions
  expect_true(is.matrix(reproj_xy(cbind(147, -42), target = "EPSG:3112", source = "OGC:CRS84")))
})

test_that("numeric epsg codes are accepted for source and target", {
  out <- reproj(cbind(1100523.652, -4780604.059), 4326, source = 3112)
  expect_equal(unname(out[1, 1:2]), c(147, -42), tolerance = 1e-6)
})

test_that("ok_lon_lat handles NA coordinates", {
  expect_warning(
    out <- reproj(cbind(c(147, NA), c(-42, NA)), "EPSG:3112"),
    "looks like longitude/latitude"
  )
  expect_true(all(is.na(out[2, ]) | is.nan(out[2, ])))
})
