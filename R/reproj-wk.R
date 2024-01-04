#' Reproject wk vectors
#'
#' Works for the usual types wkt, wkb, geos, xy, and rct. Beware of blithe reprojection of a
#' rct, it's not snapping out to the target bounding box (yet).
#'
#' @inheritParams reproj
#' @return wk vector
#' @export
#'
#' @examples
#' if (requireNamespace("PROJ") && requireNamespace("wk")) {
#'   reproj(wk::xy(147, 0:1, crs = "OGC:CRS84"), "+proj=laea +lon_0=147")
#' }
reproj.wk_vctr <- function(x, target, ..., source = NULL) {
    crs <- attr(x, "crs")
    if (!is.null(source) && is.null(crs) ) {
        crs <- source
    }
    if (is.null(crs) || is.na(crs) || !nzchar(crs)) {
        stop("cannot transform without a valid 'target' and 'source = <source>'")
    }
    haswk <- requireNamespace("wk", quietly = TRUE)
    if (requireNamespace("PROJ", quietly = TRUE) && haswk) {
        proj <- PROJ::proj_create(crs, target)
    } else {
        ## we might decompose and rebuild with wk?
        stop("cannot transform wk without PROJ and wk")
    }
    wk::wk_transform(x, proj)
}

#' @export
reproj.wk_xy <- function(x, target, ..., source = NULL) {
        reproj.wk_vctr(x, target, source = source)
}
