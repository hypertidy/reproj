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

  x$vertex[c("x_", "y_", "z_")] <- tibble::as_tibble(mat)
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
  x$vb[1:2, ] <- t(reproj(xy, target = target, source = to_proj(x$crs), ...)[, 1:2, drop = FALSE])
  x
}

