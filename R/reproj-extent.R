wk_reproj <- function(x, trans) {
  as.matrix(wk::wk_transform(wk::xy(x[,1], x[,2]), trans))[, c("x", "y"), drop = FALSE]
}

#' @importFrom PROJ proj_trans_create
#' @importFrom wk wk_transform xy
reproj_ext <- function(x, target, dm = c(64, 64), ..., source = NULL) {
  if (is.null(source)) {
    source <- "EPSG:4326"

  }
  dm1 <- dm + 1  ## use +1 so we have rectangle pixels, entire extent
  xc0 <- seq(0, dm1[1L])
  yc0 <- seq(0, dm1[2L])
  ## repeat for every extent
  xy0 <- cbind(x = xc0, y = rep(yc0, each = length(xc0)))
  xyl <- vector("list", nrow(x))
  trans <- PROJ::proj_trans_create(source, target)

  for (i in seq_len(nrow(x))) {
    offset <- x[i, c(1, 3), drop = TRUE]
    scale <- diff(x[i, ])[c(1, 3)] / dm
    xyl[[i]] <- c(apply(wk_reproj(xy0 * matrix(scale, dim(xy0)[1], 2, byrow = TRUE) + matrix(offset, dim(xy0)[1], 2, byrow = TRUE), trans), 2, range, na.rm = TRUE, finite = TRUE), trans)

  }
  do.call(rbind, xyl)
}


#' Reproject extent
#'
#' A four figure extent (xmin, xmax, ymin, ymax) is used to approximate the boundary of its
#' reprojected version by interpolating new vertices along each edge.
#'
#' This is a simple version of what GDAL's 'SuggestedWarpOutput' does, and similar functions like
#' the raster package 'projectExtent()'.
#'
#' Internal functions unpack the various stages, and might be exposed in future. These stages are
#' 1) interpolate around the boundary with correct ordering (can be used as a polygon or line)
#' 2) reproject the interpolated boundary
#' 3) summarize the interpolated boundary to the new extent
#'
#' @inheritParams reproj
#' @param extent a four element vector of extent `c(xmin, xmax, ymin, ymax)`, or matrix with 4 columns
#' @param dimension a 2 element integer to give the discretization within each extent (defaults to 64x64)
#'
#' @return four value extent `c(xmin, xmax, ymin, ymax)` or a matrix with four columns (matching the input)
#' @export
#'
#' @examples
#' reproj_extent(c(0, 10, 0, 20), "+proj=laea", source = "+proj=longlat")
reproj_extent <- function(extent, target, ..., source = NULL, dimension = c(64, 64)) {
  if (is.list(extent)) {
    if (!length(extent) == 4L) {
      stop("for list/data.frame input 'extent' must be of length 4 (with elements xmin,xmax,ymin,ymax in that order)")
    }
    extent <- do.call(cbind, extent)
  }
  vec_out <- FALSE
  if (!inherits(extent, "array")) {
    extent <- matrix(extent, ncol = 4)
    vec_out <- TRUE
  }
  if (!dim(extent)[2] == 4L) stop("extent should be length 4 or a 4-column matrix")
 args <- list(...)
 if ("limit" %in% names(args)) message("'limit' is deprecated, ignored")
 
   if (is.null(source) || is.na(source)) {
    if (ok_lon_lat(extent[,c(1, 3), drop  = FALSE]) && ok_lon_lat(extent[,c(2, 4), drop  = FALSE]) && isTRUE(getOption("reproj.assume.longlat"))) {
      source <- getOption("reproj.default.longlat")
      warning(sprintf("'source' projection not included, but looks like longitude/latitude values:\n   using '%s'", source))

    } else {
      stop("no 'source' projection included, and does not look like longitude/latitude values")
    }
  }
 out <- reproj_ext(extent, target, dm = dimension, source = source)
 if (vec_out) out <- as.vector(out)
 out
}












#' #' @importFrom stats approx
#' .app <- function(x, nn= 80) do.call(cbind, stats::approx(x[,1], x[,2], n = nn))
#' 
#' .values180 <- function(x) {
#'   x - 180
#' }
#' .reproj_interp <- function(extent, target, source = NULL) {
#'   #reproj::reproj_xy(.interp_extent(extent, nn = nn), target, source = source)
#'   reproj::reproj_xy(.ex_gr(extent, c(256, 256)), target, source = source)
#' }
#' .interp_extent <- function(extent, nn = 80) {
#'   xl <- extent[1:2]
#'   yl <- extent[3:4]
#'   top <- cbind(xl, yl[2])
#'   right <- cbind(xl[2], yl[2:1])[,2:1] ## rev for same x
#'   bot <- cbind(xl[2:1], yl[1])
#'   left <- cbind(xl[1], yl)[,2:1] ## rev for same x
#'   x <- rbind(.app(top, nn), .app(right, nn)[nn:1,2:1], .app(bot, nn)[nn:1, ], .app(left, nn)[,2:1])
#'   v180 <- .values180(x[,1])
#'   if (any(v180)) x[v180, 1] <- x[v180, 1] + 0.01
#'   x
#' }
#' 
#' 
#' .ex_gr <- function(extent,  dm = c(4, 4)) {
#'   xl <- extent[1:2]
#'   yl <- extent[3:4]
#'   top <- cbind(xl, yl[2])
#'   right <- cbind(xl[2], yl[2:1])[,2:1] ## rev for same x
#'   bot <- cbind(xl[2:1], yl[1])
#'   left <- cbind(xl[1], yl)[,2:1] ## rev for same x
#'   xl <- extent[1:2]
#'   yl <- extent[3:4]
#'   ##resx <- vaster:::x_res(x$extent, x$dimension)
#'   xc <- seq(xl[1L], xl[2L], length.out = dm[1L] + 1L)
#'   yc <- seq(yl[1L], yl[2L], length.out = dm[2L] + 1L)
#' 
#'   cbind(x = xc, y = rep(yc, each = length(xc)))
#' 
#' }
#' 
#' old_reproj_extent <- function(extent, target, limit = NULL, ..., source = NULL) {
#'   range_no_inf <- function(x) range(x[is.finite(x)])
#'   out <- as.vector(apply(.reproj_interp(extent, target, source = source), 2, range_no_inf))
#'   if (!is.null(limit)) {
#'     limit <- rep(limit, length.out = 2L)
#'     xminmax <- mean(out[1:2]) + c(-1, 1) * limit[1]
#'     yminmax <- mean(out[3:4]) + c(-1, 1) * limit[2]
#'     out <- c(xminmax, yminmax)
#'   }
#'  out
#' }

