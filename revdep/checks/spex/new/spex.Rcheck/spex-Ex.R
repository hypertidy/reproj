pkgname <- "spex"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
options(pager = "console")
library('spex')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("buffer_extent")
### * buffer_extent

flush(stderr()); flush(stdout())

### Name: buffer_extent
### Title: Whole grain buffers
### Aliases: buffer_extent

### ** Examples

library(raster)
buffer_extent(extent(0.1, 2.2, 0, 3), 2)

p <- par(xpd = NA) 
plot(lux)
plot(extent(lux), lty = 2, add = TRUE, col = "grey")
plot(buffer_extent(lux, 0.1), add = TRUE)
abline(v = c(5.7, 6.6), h = c(49.4, 50.2))
title("boundaries on clean alignment to 0.1")
par(p)



graphics::par(get("par.postscript", pos = 'CheckExEnv'))
cleanEx()
nameEx("latitudecircle")
### * latitudecircle

flush(stderr()); flush(stdout())

### Name: latitudecircle
### Title: Latitude circle
### Aliases: latitudecircle

### ** Examples

latitudecircle(seq(0, -65, by = -5))
library(raster)
plot(ice)
circ <- latitudecircle(-71, crs = projection(ice))
plot(circ, add = TRUE)



cleanEx()
nameEx("latmask")
### * latmask

flush(stderr()); flush(stdout())

### Name: latmask
### Title: Latitude mask for polar raster
### Aliases: latmask

### ** Examples

 
library(raster)
plot(latmask(ice, -60))
plot(latmask(ice, -60, trim = TRUE))
ice[!ice > 0] <- NA
plot(ice)
plot(latmask(ice, -55, trim = TRUE))



cleanEx()
nameEx("lux")
### * lux

flush(stderr()); flush(stdout())

### Name: lux
### Title: The 'lux' Spatial Polygons from the 'raster' package.
### Aliases: lux

### ** Examples

library(sp)
plot(lux)



cleanEx()
nameEx("polygonize")
### * polygonize

flush(stderr()); flush(stdout())

### Name: polygonize
### Title: Create a polygon layer from a raster.
### Aliases: polygonize polygonize.RasterLayer qm_rasterToPolygons
###   qm_rasterToPolygons_sp polygonize.RasterStack polygonize.RasterBrick

### ** Examples

#library(raadtools)
library(raster)
r <- raster(volcano)
r[sample(ncell(r), 3000)] <- NA
b <- brick(r, r*1.5)
psf <- qm_rasterToPolygons(r, na.rm = TRUE)
#psp <- qm_rasterToPolygons_sp(r)
#pspr <- rasterToPolygons(r)
#library(rbenchmark)
#benchmark(qm_rasterToPolygons(r), qm_rasterToPolygons_sp(r), rasterToPolygons(r), replications = 2)
#                        test replications elapsed relative user.self sys.self user.child sys.child
# 1    qm_rasterToPolygons(r)            2   0.476    1.000     0.476    0.000          0         0
# 2 qm_rasterToPolygons_sp(r)            2   4.012    8.429     3.964    0.048          0         0
# 3       rasterToPolygons(r)            2   2.274    4.777     2.268    0.008          0         0



cleanEx()
nameEx("spex")
### * spex

flush(stderr()); flush(stdout())

### Name: spex
### Title: Polygon extent
### Aliases: spex spex.default spex.sf

### ** Examples

library(raster)
data(lux)
exlux <- spex(lux)

plot(lux)
plot(exlux, add = TRUE)

## put an extent and a CRS together
spex(extent(0, 1, 0, 1), crs = "+proj=laea +ellps=WGS84")



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
