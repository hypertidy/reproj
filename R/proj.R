is_ll <- function(x) {
  if (is.factor(x)) x <- levels(x)[x]
  x <- tolower(trimws(as.character(x)))
  ss <- substr(trimws(x), 1, 1)
  out <- (grepl("longlat", x) && ss == "+") | (grepl("lonlat", x) && ss == "+")
  if (isTRUE(out)) {
    return(out)  ## shortcut
  } else {
    ## I await my punishment
    codes <- as.character(.epsg_code)  ## internal data
    for (i in seq_along(codes)) {
      ## we might have the code, or an init string, or a new style EPSG:code string
      out <- codes[i] == x ||
        grepl(sprintf("^\\+init=epsg:%s", codes[i]), x) ||
        grepl(sprintf("^epsg:%s", codes[i]), x)
      #print(codes[i])
      if (out) {
        ## we only grepped above so
        codecode <- as.integer(gsub("[^0-9.-]", "", x))
        if (!is.finite(codecode) || codecode >= 10000) {
          out <- FALSE
        }
        return(out)
      }
    }
  }
  FALSE  ## we tried
}
to_proj <- function(x) {


  ## integer of 4 or 5 digits,
  ## or is a character string
  if (is.numeric(x) || (nchar(x) %in% c(4, 5, 6) && grepl("^[0-9]{1,5}$", x))) {
    x <- sprintf("+init=epsg:%i", as.integer(x))
  }
  x <- trimws(x, which = "left")
  ## TODO: otherwise doesn't look like a proj string ...
  if (!substr(x, 1, 1) == "+") warning("not a proj-like string")
  x
}
validate_proj <- function(x) {
  if (!is.character(x)) stop("coordinate system must be character")
  TRUE
}
