.ok_PROJ <- function() {
    requireNamespace("PROJ", quietly = TRUE)
}


is_ll <- function(x) {
  if (is.factor(x)) x <- levels(x)[x]
  x <- tolower(trimws(as.character(x)))
  ss <- substr(trimws(x), 1, 1)
  out <- (grepl("longlat", x) && ss == "+") | (grepl("lonlat", x) && ss == "+") | (grepl("ogc:crs84", x))
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
    ## here we need PROJ::ok_proj6() pivot
    if (!.ok_PROJ()) {
      ## we are PROJ library version < 6
      x <- sprintf("+init=epsg:%i", as.integer(x))
    } else {
      ## we are PROJ library version >= 6
      x <- sprintf("EPSG:%i", as.integer(x))
    }
  }
  x <- trimws(x, which = "left")
  ## fix the weird sf/raster thing where raster::projection() is just the datum string
  if (x == "NAD27") x <- "+proj=longlat +datum=NAD27"
  if (x == "WGS84") x <- "+proj=longlat +datum=WGS84"

  if (x == "WGS 84") x <- "+proj=longlat +datum=WGS84"

  if (.ok_PROJ()) {
    ok <- try(PROJ::proj_crs_text(x), silent = TRUE)
    if (inherits(ok, "try-error") || is.na(ok) || !nzchar(ok)) {
      stop("not a string PROJ can understand")
    }
  }
  x
}
validate_proj <- function(x) {
  if (!is.character(x)) stop("coordinate system must be character")
  TRUE
}
