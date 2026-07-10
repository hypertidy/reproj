#' Reproject coordinates.
#'
#' Reproject coordinates from a matrix or data frame by explicitly specifying the
#' 'source' and 'target' projections.
#'
#' The transformation engine is the PROJ package, a wrapper around the PROJ
#' library, so that we can simply give coordinates in data frame
#' or matrix form, with a source projection and a target projection.
#'
#' reproj accepts a wide variety of source and target
#' strings, not just "proj4string", and we are completely subject to the
#' rules and behaviours of the PROJ library. We always assume "visualization
#' order", i.e. longitude then latitude, easting then northing (as X, Y).
#'
#' The basic function [reproj()] takes input in generic form (matrix or data
#' frame) and returns a matrix with columns matching the coordinate columns
#' of the input (2, 3, or 4 of x, y, z, m), by
#' transforming from map projection specified by the  `source` argument to that
#' specified by the `target` argument.  Only column order is respected, column
#' names are ignored.
#'
#' This model of working also allows adding methods for specific data formats
#' that already carry a suitable `source` projection string. Currently we
#' support types from the silicate and quadmesh and rgl packages, and only the
#' `target` string need be specified.
#'
#' This model has obvious flexibility, for packages to import the generic and
#' call it with the correct `source` (from the data format) and the `target`
#' from user, or process controlled mechanism.
#'
#' The `source` argument must be named, and if it is not present a light check
#' is made that the source data could be "longitude/latitude" and transformation
#' to `target` is applied (this can be controlled by setting options).
#'
#'
#' Functions [reproj_xy()] and [reproj_xyz()] are helpers for [reproj()] and always
#' return 2- or 3-column matrix respectively.
#'
#' Note that any integer input for `source` or `target` will be formatted to a
#' character string like "EPSG:<integer_code>" as a simple convenience. Note that
#' there are other authorities besides EPSG, so the pattern "AUTH:code" is a general
#' one and you should really be explicit.
#'
#' Other R packages for transforming coordinates are geared toward data
#' that's in a particular format. It's true that only GDAL provides the full
#' gamut of available geographic map projections, but this leaves a huge variety
#' of workflows and applications that don't need that level of functionality.
#'
#' @section Dependencies:
#'
#' The [PROJ](https://CRAN.r-project.org/package=PROJ) package (>= 0.7.0)
#' does all transformation work, wrapping the PROJ library (>= 6.3.1).
#'
#' @section Global options:
#'
#' ## Assuming longitude/latitude input
#'
#' The behaviour is controlled by user-settable options which on start up are
#' `reproj.assume.longlat = TRUE` and
#' `reproj.default.longlat = "OGC:CRS84"`.
#'
#' If the option `reproj.assume.longlat` is set to FALSE then the `source`
#' argument must be named explicitly, i.e. `reproj(xy, t_srs, source = s_srs)`,
#' this is to help catch mistakes being made.
#'
#' If the option `reproj.assume.longlat` is set to TRUE and the input data
#' appear to be sensible longitude/latitude values, then the value of
#' `reproj.default.longlat` is used as the assumed source projection.
#'
#'
#' @param x coordinates
#' @param source source specification (PROJ.4 string or epsg code)
#' @param target target specification (PROJ.4 string or epsg code)
#' @param four defunct, was 'if `TRUE` return four columns xyzt', use the shape of the input instead
#' @param ... arguments passed to [PROJ::proj_trans()]
#'
#' @return numeric matrix of the transformed coordinates, either 2, 3, or 4 columns depending on the
#' shape of the input. Use [reproj_xy()] or
#' [reproj_xyz()] for those specific 2- and 3-column cases.
#' @export
#' @examples
#' reproj(cbind(147, -42), target = "+proj=laea +datum=WGS84",
#'                          source = getOption("reproj.default.longlat"))
reproj <- function(x, target, ..., source = NULL, four = FALSE) {
  UseMethod("reproj")
}


#' @rdname reproj
#' @export
reproj.matrix <- function(x, target, ..., source = NULL, four = FALSE) {
  ## strip any column names, the contract here is positional (x, y, [z, [m]]),
  ## and PROJ::proj_trans() would otherwise resolve dimensions by name
  colnames(x) <- NULL
  if (isTRUE(four)) {
    stop("argument 'four' is not available currently")
  }
  if (is.null(source) || is.na(source)) {
    if (ok_lon_lat(x) && isTRUE(getOption("reproj.assume.longlat"))) {
      source <- getOption("reproj.default.longlat")
      warning(sprintf("'source' projection not included, but looks like longitude/latitude values:\n   using '%s'", source))

    } else {
      stop("no 'source' projection included, and does not look like longitude/latitude values")
    }
  }

  PROJ::proj_trans(x, target_crs = target, ..., source_crs = source)
}

#' @rdname reproj
#' @export
reproj.data.frame <- function(x, target, ..., source = NULL, four = FALSE) {
  reproj(as.matrix(x), target = target, ..., source = source, four = four)
}


#' @rdname reproj
#' @export
reproj_xy <- function(x, target, ..., source = NULL) {
  reproj(x, target = target, source = source, ...)[,1:2, drop = FALSE]
}

#' @rdname reproj
#' @export
reproj_xyz <- function(x, target, ..., source = NULL) {
  if (ncol(x) > 3L) x <- x[,1:3, drop = FALSE]
  if (ncol(x) == 2L) x <- cbind(x, 0.0)
  reproj(x, target = target, source = source, ...)[,1:3, drop = FALSE]
}


