ok_lon_lat <- function(x, ...) {
  if (is.null(dim(x))) {
    ## assume it's an extent
  x[1] > -365 && 
    x[2] < 365 &&
    x[3] > -91 && x[4] < 91
} else {
  ok_lon_lat(c(range(x[, 1L, drop = TRUE], na.rm = TRUE), range(x[, 2L, drop = TRUE], na.rm = TRUE)))
}
}



