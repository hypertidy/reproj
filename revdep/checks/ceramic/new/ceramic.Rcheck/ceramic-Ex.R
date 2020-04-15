pkgname <- "ceramic"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
options(pager = "console")
library('ceramic')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("cc_location")
### * cc_location

flush(stderr()); flush(stdout())

### Name: cc_location
### Title: Obtain tiled imagery by location query
### Aliases: cc_location cc_elevation cc_macquarie cc_davis cc_mawson
###   cc_casey cc_heard cc_kingston

### ** Examples

if (!is.null(get_api_key())) {

 img <- cc_location(cbind(147, -42), buffer = 1e5)

 ## this source does not need the Mapbox API, but we won't run the example unless it's set
 dem <- cc_kingston(buffer = 1e4, type = "elevation-tiles-prod")
 raster::plot(dem, col = grey(seq(0, 1, length = 94)))

 ## Mapbox imagery
 im <- cc_macquarie()
 library(raster)
 plotRGB(im)
 }



cleanEx()
nameEx("ceramic_cache")
### * ceramic_cache

flush(stderr()); flush(stdout())

### Name: ceramic_cache
### Title: Ceramic file cache
### Aliases: ceramic_cache slippy_cache
### Keywords: internal

### ** Examples

if (interactive()) {
 ceramic_cache()
}



cleanEx()
nameEx("ceramic_tiles")
### * ceramic_tiles

flush(stderr()); flush(stdout())

### Name: ceramic_tiles
### Title: Tile files
### Aliases: ceramic_tiles

### ** Examples

if (interactive() && !is.null(get_api_key())) {
 tiles <- ceramic_tiles(zoom = 0)
}



cleanEx()
nameEx("get-tiles-constrained")
### * get-tiles-constrained

flush(stderr()); flush(stdout())

### Name: get-tiles-constrained
### Title: Get tiles with specific constraints
### Aliases: get-tiles-constrained get_tiles_zoom get_tiles_dim
###   get_tiles_buffer

### ** Examples

if (!is.null(get_api_key())) {
 ex <- raster::extent(146, 147, -43, -42)
 tile_infoz <- get_tiles_zoom(ex, type = "mapbox.outdoors", zoom = 1)

 tile_infod <- get_tiles_dim(ex, type = "mapbox.outdoors", dim = c(256, 256))

 tile_infob <- get_tiles_buffer(cbind(146.5, -42.5), buffer = 5000, type = "mapbox.outdoors")
}



cleanEx()
nameEx("get_api_key")
### * get_api_key

flush(stderr()); flush(stdout())

### Name: get_api_key
### Title: Get API key for Mapbox service
### Aliases: get_api_key

### ** Examples

get_api_key()



cleanEx()
nameEx("get_tiles")
### * get_tiles

flush(stderr()); flush(stdout())

### Name: get_tiles
### Title: Download Mapbox imagery tiles
### Aliases: get_tiles

### ** Examples

if (!is.null(get_api_key())) {
   tile_info <- get_tiles(raster::extent(146, 147, -43, -42), type = "mapbox.outdoors", zoom = 5)
}



cleanEx()
nameEx("mercator_tile_extent")
### * mercator_tile_extent

flush(stderr()); flush(stdout())

### Name: mercator_tile_extent
### Title: Tile extent
### Aliases: mercator_tile_extent

### ** Examples

mercator_tile_extent(2, 4, zoom = 10)

global <- mercator_tile_extent(0, 0, zoom = 0)
plot(NA, xlim = global[c("xmin", "xmax")], ylim = global[c("ymin", "ymax")])
rect_plot <- function(x) rect(x["xmin"], x["ymin"], x["xmax"], x["ymax"])
rect_plot(mercator_tile_extent(1, 1, zoom = 2))
rect_plot(mercator_tile_extent(2, 1, zoom = 2))
rect_plot(mercator_tile_extent(1, 2, zoom = 2))

rect_plot(mercator_tile_extent(1, 1, zoom = 4))
rect_plot(mercator_tile_extent(2, 1, zoom = 4))
rect_plot(mercator_tile_extent(1, 2, zoom = 4))



cleanEx()
nameEx("plot_tiles")
### * plot_tiles

flush(stderr()); flush(stdout())

### Name: plot_tiles
### Title: Plot slippy map tiles
### Aliases: plot_tiles tiles_to_polygon

### ** Examples

if (!is.null(get_api_key())) {
  get_tiles_zoom(zoom = 1)
  tiles <- ceramic_tiles(zoom = 1)
  plot_tiles(tiles)
}



### * <FOOTER>
###
cleanEx()
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
