is_ll <- function(x) grepl("longlat", x) | grepl("lonlat", x) | grepl("4326", x)
to_proj <- function(x) {


  ## integer of 4 or 5 digits,
  ## or is a character string
  if (is.numeric(x) || (nchar(x) %in% c(4, 5, 6) && grepl("^[0-9]{1,5}$", x))) {
    ## here we need PROJ::ok_proj6() pivot
    if (!PROJ::ok_proj6()) {
      ## we are PROJ library version < 6
      x <- sprintf("+init=epsg:%i", as.integer(x))
    } else {
      ## we are PROJ library version >= 6
      x <- sprintf("EPSG:%i", as.integer(x))
    }
  }
  x <- trimws(x, which = "left")
  ## TODO: otherwise doesn't look like a proj string ...
  ## only in older versions, because this might be WKT2 now
  if (!PROJ::ok_proj6() && !substr(x, 1, 1) == "+") warning("not a proj-like string")
  x
}
validate_proj <- function(x) {
  if (!is.character(x)) stop("coordinate system must be character")
  TRUE
}
