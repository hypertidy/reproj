get_proj_sc <- function(x, ...) {
  crsmeta::crs_proj(x)
}
get_vertex_sc <- function(x, ...) {
  x$vertex
}
get_meta_sc <- function(x, ...) {
  x$meta
}
#' @rdname reproj
#' @export
reproj.sc <- function(x, target = NULL, ..., source = NULL) {
if (is.null(source)) source <- get_proj_sc(x)

  verts <- get_vertex_sc(x)
  verts$z_ <- if (is.null(x$vertex[["z_"]])) 0 else x$vertex$z_
  if (inherits(x, "QUAD") && is.null(x$vertex)) {
    x$vertex <- verts
    x$quad <- NULL
  }
  mat <- as.matrix(verts[c("x_", "y_", "z_")])
  mat <- reproj::reproj(mat,
                 source = source,
                 target = target)
  colnames(mat) <- c("x_", "y_", "z_")

  x$vertex[c("x_", "y_", "z_")] <- as.data.frame(mat)
  meta <- get_meta_sc(x)
  ## take a punt
  if (all(x$vertex$z_ == 0)) x$vertex$z_ <- NULL
  meta["ctime"] <- Sys.time()
  meta["proj"] <- target
  x$meta <- rbind(meta, x$meta)
  x

}

#' @rdname reproj
#' @export
reproj.mesh3d <- function(x, target, ..., source = NULL) {
  xy <- t(x$vb[1:2, , drop = FALSE])
  x$vb[1:2, ] <- t(reproj(cbind(xy, z = x$vb[3, , drop = TRUE]), target = target, source = to_proj(x$crs), ...))
  x
}
#' @rdname reproj
#' @export
reproj.quadmesh <- function(x, target, ..., source = NULL) {
  existingproj <- x$crs
  if (existingproj == "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0") {
    existingproj <- "+proj=longlat +datum=WGS84"  ## pretty harmless https://github.com/hypertidy/reproj/issues/10
  }
  x$vb[1:3, ] <- t(reproj::reproj(t(x$vb[1:3, , drop = FALSE]), target = target, source = existingproj))
  x$raster_metadata <- x$crs <- NULL
  warning("quadmesh raster information cannot be preserved after reprojection, dropping to mesh3d class")
  class(x) <- setdiff( class(x), "quadmesh")
  x
}
#' @rdname reproj
#' @export
reproj.triangmesh <- function(x, target, ..., source = NULL) {
  reproj.quadmesh(x, target = target, source = source)
}
