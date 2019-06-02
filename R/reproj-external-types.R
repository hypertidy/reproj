#' @rdname reproj
#' @export
reproj.sc <- function(x, target, ..., source = NULL) {
  x[["vertex"]][c("x_", "y_")] <- reproj(as.matrix(x[["vertex"]][c("x_", "y_")]), target = target, ..., source = x$meta$proj[1L])[, 1:2, drop = FALSE]
  x[["meta"]] <- rbind(tibble::tibble(proj = target, ctime = Sys.time()), x[["meta"]])
  x
}

#' @rdname reproj
#' @export
reproj.mesh3d <- function(x, target, ..., source = NULL) {
  xy <- t(x$vb[1:2, , drop = FALSE])
  x$vb[1:2, ] <- t(reproj(xy, target = target, source = x$crs, ...)[, 1:2, drop = FALSE])
  x
}

