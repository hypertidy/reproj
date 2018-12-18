#' Reproject coordinates. 
#'
#' reproj drives the function `proj4::ptransform` and sorts out the requirements for 
#' it so that we can simply give coordinates in data frame or matrix form, with a source
#' projection and a target projection. 
#' 
#' The `source` argument must be named explicitly, i.e. `reproj(xy, t_srs, source = s_srs)`, 
#' this is to help catch mistakes being made. The `target` is the second argument in `reproj`
#' though it is the third argument in `proj4::ptransform`. This function also converts
#' to radians on input or output as required. 
#' 
#' At the moment reproj always returns a 3-column matrix. 
#' 
#' Ideally `proj4` will be replaced by a more modern interface to the PROJ library. 
#' 
#' On some systems we cannot use an epsg integer code, particularly CRAN's
#' 'winbuilder' because it won't work with "+init=epsg:code" forms. So we 
#' don't test or document examples of those. 
#' 
#' @section Warning: there are a number of limitations to the proj4 package, please use
#' at your own risk. The sf package provides a better supported facility to modern code and
#' for datum transformations. We have not even checked if proj4 can do that. 
#' 
#' @param x coordinates
#' @param source source specification (PROJ.4 string or epsg code)
#' @param target target specification (PROJ.4 string or epsg code)
#' @param ... arguments passed to \code{\link{ptransform}}
#' @importFrom proj4 ptransform
#' @return matrix
#' @export
#' @examples
#' reproj(cbind(147, -42), target = "+proj=laea +datum=WGS84", 
#'                          source = "+proj=longlat +datum=WGS84")
reproj <- function(x, target, ..., source = NULL) {
  UseMethod("reproj")
}

#' @rdname reproj
#' @export
reproj.matrix <- function(x, target, ..., source = NULL) {
  source <- to_proj(source)
  target <- to_proj(target)
  if (is.null(source)) stop("'source' projection must be included, as a named argument")
  validate_proj(source)
  validate_proj(target)
  srcmult <- if (is_ll(source)) {pi/180} else {1}
  tarmult <-  if(is_ll(target)) {180/pi} else {1}
  x[, 1:2] <- x[,1:2] * srcmult
  out <- proj4::ptransform(x, source, target, ...) 
  out[,1:2] <- out[, 1:2] * tarmult
  out
}

#' @rdname reproj
#' @export
reproj.data.frame <- function(x, target, ..., source = NULL) {
  reproj(as.matrix(x), target = target, ..., source = source)
}


