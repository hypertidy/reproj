## fixtures, plain structures matching the shapes reproj methods expect
mk_mesh3d <- function(z = c(0, 1000), crs = "EPSG:4326") {
  structure(list(
    vb = rbind(c(147, 148), c(-42, -43), z, c(1, 1)),
    it = matrix(1:2),
    crs = crs
  ), class = "mesh3d")
}

mk_quadmesh <- function() {
  structure(list(
    vb = rbind(c(147, 148), c(-42, -43), c(0, 0), c(1, 1)),
    ib = matrix(1:2),
    crs = "+proj=longlat +datum=WGS84",
    raster_metadata = list(xmn = 147)
  ), class = c("quadmesh", "mesh3d"))
}

mk_sc <- function(z = NULL) {
  v <- data.frame(x_ = c(147, 148), y_ = c(-42, -43))
  if (!is.null(z)) v$z_ <- z
  structure(list(
    vertex = v,
    meta = data.frame(proj = "OGC:CRS84", ctime = format(Sys.time()))
  ), class = "sc")
}

test_that("reproj.mesh3d transforms all three coordinate rows", {
  m <- reproj(mk_mesh3d(), "EPSG:4978")
  expect_s3_class(m, "mesh3d")
  expect_equal(dim(m$vb), c(4L, 2L))
  ## geocentric: z participates, first point z = 0
  expect_equal(unname(m$vb[1:3, 1]), c(-3981168.321, 2585400.937, -4245603.836),
    tolerance = 1e-6)
  ## homogeneous coordinate untouched
  expect_equal(unname(m$vb[4, ]), c(1, 1))
  ## z = 1000 differs from z = 0 (z genuinely transformed, not passed through)
  m0 <- reproj(mk_mesh3d(z = c(0, 0)), "EPSG:4978")
  expect_false(isTRUE(all.equal(m$vb[3, 2], m0$vb[3, 2])))
})

test_that("reproj.mesh3d honors the source argument over x$crs", {
  m <- mk_mesh3d(crs = "bogus, ignored when source given")
  out <- reproj(m, "EPSG:4978", source = "EPSG:4326")
  expect_equal(unname(out$vb[1, 1]), -3981168.321, tolerance = 1e-6)
})

test_that("reproj.quadmesh transforms, warns, and demotes to mesh3d", {
  qm <- mk_quadmesh()
  expect_warning(out <- reproj(qm, "EPSG:3112"), "cannot be preserved")
  expect_false(inherits(out, "quadmesh"))
  expect_s3_class(out, "mesh3d")
  expect_null(out$raster_metadata)
  expect_null(out$crs)
  expect_equal(unname(out$vb[1:2, 1]), c(1100523.652, -4780604.059),
    tolerance = 1e-6)
  expect_equal(dim(out$vb), c(4L, 2L))
})

test_that("reproj.triangmesh routes through the quadmesh method", {
  tm <- mk_quadmesh()
  class(tm) <- c("triangmesh", "mesh3d")
  expect_warning(out <- reproj(tm, "EPSG:3112"), "cannot be preserved")
  expect_equal(unname(out$vb[1:2, 1]), c(1100523.652, -4780604.059),
    tolerance = 1e-6)
})

test_that("reproj.sc transforms vertices and appends meta", {
  x <- mk_sc()
  out <- reproj(x, "EPSG:3112")
  expect_s3_class(out, "sc")
  expect_equal(out$vertex$x_[1], 1100523.652, tolerance = 1e-6)
  expect_equal(out$vertex$y_[1], -4780604.059, tolerance = 1e-6)
  ## all-zero z is dropped
  expect_null(out$vertex$z_)
  ## new meta row on top records the target
  expect_equal(out$meta$proj[1], "EPSG:3112")
  expect_equal(nrow(out$meta), 2L)
})

test_that("reproj.sc retains non-zero z", {
  x <- mk_sc(z = c(10, 20))
  out <- reproj(x, "EPSG:3112")
  expect_false(is.null(out$vertex$z_))
  ## laea-family projected CRS leaves z untouched
  expect_equal(out$vertex$z_, c(10, 20), tolerance = 1e-8)
})

test_that("reproj.quadmesh normalizes the verbose towgs84 longlat string (#10)", {
  qm <- mk_quadmesh()
  qm$crs <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0"
  expect_warning(out <- reproj(qm, "EPSG:3112"), "cannot be preserved")
  expect_equal(unname(out$vb[1:2, 1]), c(1100523.652, -4780604.059),
    tolerance = 1e-6)
})
