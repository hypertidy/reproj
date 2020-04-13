#' Reproject data from source to target coordinate system.
#'
#' reproj provides helpers for easily reprojecting generic data, by depending
#' on a reprojection engine (proj4 for now).
#'
#' The function `reproj` is designed to take an input data set `x` and then a
#' `target` coordinate system specification. The `source` argument is not positional
#' (must be named) and must be provided.
#' Currently the coordinate system may be a 'PROJ string' or 'EPSG code' either
#' as  a number or text.
#'
#' Methods are provided for data frame and matrix, add S3 methods for
#' you classes in your own package. For classed objects, or objects with a known
#' method for finding the 'source' coordinate system your method can provide
#' that logic.
#'
#' See [reproj] for global options to control assumptions about data that
#' is input in longitude latitude form.
#'
#' There is an option set at start up `reproj.mock.noproj6` which is designed
#' for testing the support in the PROJ package. Even if this package is
#' functional this option can be set to true so that reproj falls-back to
#' use the proj4 package instead.
#' @name reproj-package
#' @docType package
NULL
