reproj_default_options <- list(
  reproj.assume.longlat = TRUE,
  reproj.default.longlat = "+proj=longlat +datum=WGS84 +no_defs"
)

.onLoad <- function(libname, pkgname) {
  op <- options()
  toset <- !(names(reproj_default_options) %in% names(op))
  if (any(toset)) options(reproj_default_options[toset])
  
  invisible()
}