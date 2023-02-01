#' @importFrom stats approx
.app <- function(x, nn= 80) do.call(cbind, stats::approx(x[,1], x[,2], n = nn))

.reproj_interp <- function(extent, target, source = NULL, nn = 80) {
  reproj::reproj_xy(.interp_extent(extent, nn = nn), target, source = source)
}
.interp_extent <- function(extent, nn = 80) {
  xl <- extent[1:2]
  yl <- extent[3:4]
  top <- cbind(xl, yl[2])
  right <- cbind(xl[2], yl[2:1])[,2:1] ## rev for same x
  bot <- cbind(xl[2:1], yl[1])
  left <- cbind(xl[1], yl)[,2:1] ## rev for same x
  rbind(.app(top, nn), .app(right, nn)[nn:1,2:1], .app(bot, nn)[nn:1, ], .app(left, nn)[,2:1])
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
#' @param nn number of vertices to use for linear approximation along each edge
#'
#' @return four value extent `c(xmin, xmax, ymin, ymax)`
#' @export
#'
#' @examples
#' reproj_extent(c(0, 10, 0, 20), "+proj=laea", source = "+proj=longlat")
reproj_extent <- function(extent, target, ..., source = NULL, nn = 80) {
  as.vector(apply(.reproj_interp(extent, target, source = source), 2, range))
}

