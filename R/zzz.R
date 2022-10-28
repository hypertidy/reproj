err <- try(proj4::ptransform(cbind(0, 0), "OGC:CRS84", "+proj=laea"), silent = TRUE)
if (inherits(err, "try-error")) {
  df <- "+proj=longlat +datum=WGS84"
} else {
  df <- "OGC:CRS84"
}

reproj_default_options <- function() {
  list(
  reproj.mock.noproj6 = FALSE,
  reproj.assume.longlat = TRUE,
  reproj.default.longlat = df
)}

.onLoad <- function(libname, pkgname) {
  op <- options()
  rdo <- reproj_default_options()
  toset <- !(names(rdo) %in% names(op))
  if (any(toset)) options(rdo[toset])

  invisible()
}
