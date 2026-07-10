ex <- c(140, 150, -45, -40)
ex_3112 <- c(492232.7948, 1381977.6702, -5151054.1756, -4509755.9570)

test_that("reproj_extent vector input returns a vector extent", {
  out <- reproj_extent(ex, "EPSG:3112", source = "OGC:CRS84")
  expect_type(out, "double")
  expect_null(dim(out))
  expect_length(out, 4L)
  expect_equal(out, ex_3112, tolerance = 1e-6)
  ## a valid extent
  expect_true(out[1] < out[2] && out[3] < out[4])
})

test_that("reproj_extent matrix input returns a matrix, one row per extent", {
  m <- rbind(ex, c(100, 110, -50, -45))
  out <- reproj_extent(m, "EPSG:3112", source = "OGC:CRS84")
  expect_true(is.matrix(out))
  expect_equal(dim(out), c(2L, 4L))
  expect_equal(unname(out[1, ]), ex_3112, tolerance = 1e-6)
})

test_that("reproj_extent list/data.frame input works and validates length", {
  out <- reproj_extent(as.list(ex), "EPSG:3112", source = "OGC:CRS84")
  expect_equal(as.vector(out), ex_3112, tolerance = 1e-6)
  expect_error(
    reproj_extent(list(1, 2, 3), "EPSG:3112", source = "OGC:CRS84"),
    "length 4"
  )
})

test_that("reproj_extent rejects wrong-width matrix", {
  expect_error(
    reproj_extent(cbind(1, 2, 3), "EPSG:3112", source = "OGC:CRS84"),
    "4-column"
  )
})

test_that("reproj_extent deprecated limit argument messages and is ignored", {
  expect_message(
    out <- reproj_extent(ex, "EPSG:3112", source = "OGC:CRS84", limit = 1e5),
    "deprecated"
  )
  expect_equal(out, ex_3112, tolerance = 1e-6)
})

test_that("reproj_extent assumes longlat with a warning when source missing", {
  expect_warning(
    out <- reproj_extent(ex, "EPSG:3112"),
    "looks like longitude/latitude"
  )
  expect_equal(out, ex_3112, tolerance = 1e-6)
})

test_that("reproj_extent errors when source missing and input not longlat-like", {
  expect_error(
    reproj_extent(c(0, 2e6, 0, 1e6), "EPSG:4326"),
    "does not look like longitude/latitude"
  )
})

test_that("reproj_extent identity transform returns the input extent", {
  expect_equal(reproj_extent(ex, "OGC:CRS84", source = "OGC:CRS84"), ex,
    tolerance = 1e-9)
})

test_that("reproj_extent respects dimension argument", {
  coarse <- reproj_extent(ex, "EPSG:3112", source = "OGC:CRS84", dimension = c(2, 2))
  fine <- reproj_extent(ex, "EPSG:3112", source = "OGC:CRS84", dimension = c(256, 256))
  ## both are valid extents in the same ballpark as the reference
  for (out in list(coarse, fine)) {
    expect_true(all(is.finite(out)))
    expect_true(out[1] < out[2] && out[3] < out[4])
    expect_equal(out, ex_3112, tolerance = 0.01)
  }
})

test_that("longlat guard tolerates assume.longlat option off", {
  withr_like <- function(expr) {
    old <- options(reproj.assume.longlat = FALSE)
    on.exit(options(old))
    expr
  }
  withr_like(
    expect_error(reproj_extent(ex, "EPSG:3112"), "no 'source' projection")
  )
})
