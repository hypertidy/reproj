ok_lon_lat <- function(x, ...) UseMethod("ok_lon_lat")
ok_lon_lat.numeric <- function(x, ...) {
  x[1] > -365 && 
    x[2] < 365 &&
    x[3] > -91 && x[4] < 91
}

ok_lon_lat.matrix <- function(x, ...) {
  ok_lon_lat(c(range(x[, 1L], na.rm = TRUE), range(x[, 2L], na.rm = TRUE)))
}



