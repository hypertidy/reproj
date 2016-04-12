#' Title
#'
#' @param x coordinates
#' @param source source PROJ.4 string
#' @param target target PROJ.4 string
#' @param ... arguments passed to \code{\link{ptransform}}
#' @importFrom proj4 ptransform
#' @return matrix
#' @export
reproj <- function(x, ...) {
  UseMethod("reproj")
}

#' @rdname reproj
#' @export
reproj.matrix <- function(x, source, target, ...) {
  srcmult <- if (is_ll(source)) {pi/180} else {1}
  tarmult <-  if(is_ll(target)) {180/pi} else {1}
  proj4::ptransform(x * srcmult, source, target, ...)[,1:2] * tarmult
}

## maybe use x/y name detection here?
#' @rdname reproj
#' @export
reproj.data.frame <- function(x, ...) {
  NextMethod("reproj", as.matrix(x))
}

#' @rdname reproj
#' @export
reproj.tbl_df <- reproj.data.frame

is_ll <- function(x) grepl("longlat", x) | grepl("lonlat", x)
