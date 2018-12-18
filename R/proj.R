is_ll <- function(x) grepl("longlat", x) | grepl("lonlat", x) | grepl("4326", x)
to_proj <- function(x) {
  ## integer of 4 or 5 digits,
  ## or is a character string
  if (is.numeric(x) || (nchar(x) %in% c(4, 5) && grepl("^[0-9]{1,5}$", x))) {
    x <- sprintf("+init=epsg:%i", as.integer(x))
  }
  ## TODO: otherwise doesn't look like a proj string ...
  if (!substr(x, 1, 1) == "+") stop("not a proj-like string")
  x
}
validate_proj <- function(x) {
  if (!is.character(x)) stop("coordinate system must be character")
  TRUE
}