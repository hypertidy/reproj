#' @keywords internal
"_PACKAGE"

## usethis namespace: start
## usethis namespace: end
NULL

#' Reproject data from source to target coordinate system.
#'
#' reproj provides helpers for easily reprojecting generic data, using the
#' PROJ package as the reprojection engine.
#'
#' The function `reproj` is designed to take an input data set `x` and then a
#' `target` coordinate system specification. The `source` argument is not positional
#' (must be named) and must be provided.
#' The coordinate system string may be anything accepted by the PROJ library (libproj). 
#'
#' Methods are provided for data frame and matrix, add S3 methods for
#' you classes in your own package. For classed objects, or objects with a known
#' method for finding the 'source' coordinate system your method can provide
#' that logic.
#'
#' See [reproj] for global options to control assumptions about data that
#' is input in longitude latitude form.
#' @name reproj-package
NULL
