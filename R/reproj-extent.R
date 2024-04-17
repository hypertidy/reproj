#' @importFrom stats approx
.app <- function(x, nn= 80) do.call(cbind, stats::approx(x[,1], x[,2], n = nn))

.values180 <- function(x) {
  x - 180
}
.reproj_interp <- function(extent, target, source = NULL) {
  #reproj::reproj_xy(.interp_extent(extent, nn = nn), target, source = source)
  reproj::reproj_xy(.ex_gr(extent, c(256, 256)), target, source = source)
}
.interp_extent <- function(extent, nn = 80) {
  xl <- extent[1:2]
  yl <- extent[3:4]
  top <- cbind(xl, yl[2])
  right <- cbind(xl[2], yl[2:1])[,2:1] ## rev for same x
  bot <- cbind(xl[2:1], yl[1])
  left <- cbind(xl[1], yl)[,2:1] ## rev for same x
  x <- rbind(.app(top, nn), .app(right, nn)[nn:1,2:1], .app(bot, nn)[nn:1, ], .app(left, nn)[,2:1])
  v180 <- .values180(x[,1])
  if (any(v180)) x[v180, 1] <- x[v180, 1] + 0.01
  x
}


.ex_gr <- function(extent,  dm = c(4, 4)) {
  xl <- extent[1:2]
  yl <- extent[3:4]
  top <- cbind(xl, yl[2])
  right <- cbind(xl[2], yl[2:1])[,2:1] ## rev for same x
  bot <- cbind(xl[2:1], yl[1])
  left <- cbind(xl[1], yl)[,2:1] ## rev for same x
  xl <- extent[1:2]
  yl <- extent[3:4]
  ##resx <- vaster:::x_res(x$extent, x$dimension)
  xc <- seq(xl[1L], xl[2L], length.out = dm[1L] + 1L)
  yc <- seq(yl[1L], yl[2L], length.out = dm[2L] + 1L)

  cbind(x = xc, y = rep(yc, each = length(xc)))

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
#' @param extent a four element vector of extent `c(xmin, xmax, ymin, ymax)`
#' @param limit if used, a one or two element numeric vector to give the maximum radius to the edge of the extent from the middle
#'
#' @return four value extent `c(xmin, xmax, ymin, ymax)`
#' @export
#'
#' @examples
#' reproj_extent(c(0, 10, 0, 20), "+proj=laea", source = "+proj=longlat")
reproj_extent <- function(extent, target, limit = NULL, ..., source = NULL) {
  range_no_inf <- function(x) range(x[is.finite(x)])
  out <- as.vector(apply(.reproj_interp(extent, target, source = source), 2, range_no_inf))
  if (!is.null(limit)) {
    limit <- rep(limit, length.out = 2L)
    xminmax <- mean(out[1:2]) + c(-1, 1) * limit[1]
    yminmax <- mean(out[3:4]) + c(-1, 1) * limit[2]
    out <- c(xminmax, yminmax)
  }
 out
}

