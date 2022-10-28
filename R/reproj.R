#' Reproject coordinates.
#'
#' Reproject coordinates from a matrix or data frame by explicitly specifying the
#' 'source' and 'target' projections.
#'
#' We currently use the proj4 package.
#'
#' The [reproj()] and related functions drive [proj4::ptransform()] and sort out
#' the requirements for it so that we can simply give coordinates in data frame
#' or matrix form, with a source projection and a target projection.
#'
#' If using PROJ, reproj can pass in a wider variety of source and target
#' strings, not just "proj4string" and we are completely subject to the new
#' rules and behaviours of the PROJ library. We always assume "visualization
#' order", i.e. longitude then latitude, easting then northing (as X, Y).
#'
#' The basic function [reproj()] takes input in generic form (matrix or data
#' frame) and returns a 3-column matrix, by
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
#' The function [reproj()] always returns a 3-column matrix _unless_ `four =
#' TRUE`, and [PROJ::ok_proj6()] is `TRUE` and then a 4-column matrix is returned.
#'
#' Functions [reproj_xy()] and [reproj_xyz()] are helpers for [reproj()] and always
#' return 2- or 3-column matrix respectively.
#'
#' Note that any integer input for `source` or `target` will be formatted to a
#' character string like "EPSG:<integer_code>" as a simple convenience. Note that
#' there are other authorities besides EPSG, so the pattern "AUTH:code" is a general
#' one and you should really be explicit.
#'
#' Until recently the `proj4` package was the only one available for generic
#' data that will transform between arbitrary coordinate systems specified by
#' _source_ and _target_ coordinate systems and with control over 'xy' versus
#' 'xyz' input and output.  This package adds some further features by wrapping
#' the need to convert longitude/latitude data to or from radians.
#'
#' Other R packages for transforming coordinates are geared toward data
#' that's in a particular format. It's true that only GDAL provides the full
#' gamut of available geographic map projections, but this leaves a huge variety
#' of workflows and applications that don't need that level of functionality.
#'
#' @section Dependencies:
#'
#' * The [PROJ](https://CRAN.r-project.org/package=PROJ) package is a stub atm
#'  and is not used.
#'
#' The proj4 package works perfectly well with the PROJ-lib at versions 4, 5, 6,
#' or 7 and if this is preferred reproj can be set to ignore the PROJ R package
#' (see
#' [reproj-package](https://hypertidy.github.io/reproj/reference/reproj-package.html)).
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
#' this is to help catch mistakes being made. The `target` is the second
#' argument in `reproj` though it is the third argument in `proj4::ptransform`.
#' This function also converts to radians on input or output as required.
#'
#' If the option `reproj.assume.longlat` is set to TRUE and the input data
#' appear to be sensible longitude/latitude values, then the value of
#' `reproj.default.longlat` is used as the assumed source projection.
#'
#' ## Controlling use or PROJ or proj4
#'
#' See [reproj-package] for another option set `reproj.mock.noproj6` for package
#' testing for expert use.
#'
#' @section Warning:
#'
#' There are a number of limitations to the PROJ library please use at your own
#' risk. The sf package provides a better supported facility. The libproj package
#' will be used if it makes it to CRAN.
#'
#' @param x coordinates
#' @param source source specification (PROJ.4 string or epsg code)
#' @param target target specification (PROJ.4 string or epsg code)
#' @param four if `TRUE`, and PROJ version 6 is available return four columns xyzt (not just three xyz)
#' @param ... arguments passed to [proj4::ptransform()]
#'
#' @importFrom proj4 ptransform
#' @return numeric matrix of the transformed coordinates, either 2, 3, or 4 columns depending on the
#' shape of the input, or the argument 'four' in [reproj()]. Use [reproj_xy()] or
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
  } else {
    source <- to_proj(source)
  }
  target <- to_proj(target)  ## just sprintf("EPSG:%i", target) or sprintf("+init=epsg:%i", target)
  if (PROJ::ok_proj6()) {

    if (dim(x)[2L] == 2L) {
      out <- PROJ::proj_trans(x, target = target, ..., source = source)
      out <- cbind(do.call(cbind, out), 0)

    }
    if (dim(x)[2L] == 3L) {
      out <- PROJ::proj_trans(x[,1:2, drop = FALSE], target = target, ..., source = source,
                                      z_ = x[, 3L, drop = TRUE])
      out <- do.call(cbind, out)
      if (!four) out <- out[ , 1:3, drop = FALSE]
    }
    if (dim(x)[2L] > 3L) {
      out <- PROJ::proj_trans(x[,1:2, drop = FALSE], target = target, ..., source = source,
                                      z_ = x[, 3L, drop = TRUE],
                                      t_ = x[, 4L, drop = TRUE])
      out <- do.call(cbind, out)
      if (!four) out <- out[ , 1:3, drop = FALSE]
    }


    if (four) {
      if (dim(out)[2] == 2) {
        out <- cbind(out, 0, 0)
      }
      if (dim(out)[2] == 3) {
        out <- cbind(out, 0)
      }
    }
  } else {

    target <- to_proj(target)
    validate_proj(target)


    source <- to_proj(source)
    validate_proj(source)

    srcmult <- if (is_ll(source)) {pi/180} else {1}
    tarmult <-  if(is_ll(target)) {180/pi} else {1}

    x[, 1:2] <- x[,1:2] * srcmult
    out <- proj4::ptransform(x, source, target, ...)
    out[,1:2] <- out[, 1:2] * tarmult
    if (four) warning("argument 'four' is ignored when PROJ version 6 not available")
  }
  out
}

#' @rdname reproj
#' @export
reproj.data.frame <- function(x, target, ..., source = NULL, four = FALSE) {
  reproj(as.matrix(x), target = target, ..., source = source, four = four)
}


#' @rdname reproj
#' @export
reproj_xy <- function(x, target, ..., source = NULL) {
  reproj(x, target = target, source = source, ...)[,1:2]
}

#' @rdname reproj
#' @export
reproj_xyz <- function(x, target, ..., source = NULL) {
  reproj(x, target = target, source = source, ...)[,1:3]
}


