reproj_default_options <- function() {
  list(
  reproj.mock.noproj6 = FALSE,
  reproj.assume.longlat = TRUE,
  reproj.default.longlat = "+proj=longlat +datum=WGS84 +no_defs"
)}

.onLoad <- function(libname, pkgname) {
  op <- options()
  rdo <- reproj_default_options()
  toset <- !(names(rdo) %in% names(op))
  if (any(toset)) options(rdo[toset])

  invisible()
}
