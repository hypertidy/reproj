## PROJ (>= 0.7.0) requires libproj >= 6.3.1, which understands OGC:CRS84
df <- "OGC:CRS84"

reproj_default_options <- function() {
  list(
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
