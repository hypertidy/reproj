pkgname <- "quadmesh"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
options(pager = "console")
library('quadmesh')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("bary_index")
### * bary_index

flush(stderr()); flush(stdout())

### Name: bary_index
### Title: Barycentric triangle index for interpolation
### Aliases: bary_index

### ** Examples

library(raster)
p_srs <- "+proj=stere +lat_0=-90 +lat_ts=-71 +datum=WGS84"
polar <- raster(extent(-5e6, 5e6, -5e6, 5e6), crs = p_srs, res = 25000)
etopo <- aggregate(etopo, fact = 4)
index <- bary_index(etopo, grid = polar)
ok <- !is.na(index$idx)
r <- setValues(polar, NA_integer_)
r[ok] <- colSums(matrix(values(etopo)[index$tri[, index$idx[ok]]], nrow = 3) * t(index$p)[, ok])
plot(r)



cleanEx()
nameEx("mesh_plot")
### * mesh_plot

flush(stderr()); flush(stdout())

### Name: mesh_plot
### Title: Plot as a mesh
### Aliases: mesh_plot mesh_plot.BasicRaster mesh_plot.RasterLayer
###   mesh_plot.TRI mesh_plot.quadmesh

### ** Examples

##mesh_plot(worldll)
## crop otherwise out of bounds from PROJ
rr <- raster::crop(worldll, raster::extent(-179, 179, -89, 89))
mesh_plot(rr, crs = "+proj=laea +datum=WGS84")
mesh_plot(worldll, crs = "+proj=moll +datum=WGS84")
prj <- "+proj=lcc +datum=WGS84 +lon_0=147 +lat_0=-40 +lat_1=-55 +lat_2=-20"
mesh_plot(etopo, crs = prj, add = FALSE, colfun = function(n = 20) grey(seq(0, 1, length = n)))
mesh_plot(worldll, crs = prj, add = TRUE)



cleanEx()
nameEx("qm_as_raster")
### * qm_as_raster

flush(stderr()); flush(stdout())

### Name: qm_as_raster
### Title: Quadmesh to raster
### Aliases: qm_as_raster

### ** Examples

qm_as_raster(quadmesh(etopo))



cleanEx()
nameEx("qsc")
### * qsc

flush(stderr()); flush(stdout())

### Name: qsc
### Title: Quadrilateralized Spherical Cube (QSC)
### Aliases: qsc

### ** Examples

library(rgl); #rgl.clear()
wire3d(qsc())
if ( rgl::rgl.useNULL()) rglwidget()



cleanEx()
nameEx("quadmesh")
### * quadmesh

flush(stderr()); flush(stdout())

### Name: quadmesh
### Title: Create a quad-type mesh for use in rgl.
### Aliases: quadmesh dquadmesh dquadmesh.default quadmesh.BasicRaster
###   quadmesh.matrix

### ** Examples

library(raster)
data(volcano)
r <- setExtent(raster(volcano), extent(0, 100, 0, 200))
qm <- quadmesh(r)



cleanEx()
nameEx("triangmesh")
### * triangmesh

flush(stderr()); flush(stdout())

### Name: triangmesh
### Title: Create a triangle-type mesh for use in rgl.
### Aliases: triangmesh dtriangmesh triangmesh.matrix
###   triangmesh.BasicRaster dtriangmesh.default

### ** Examples

library(raster)
r <- setExtent(raster(volcano), extent(0, nrow(volcano), 0, ncol(volcano)))
tm <- triangmesh(r)
#rgl::shade3d(tm)

## jitter the mesh just enough to show that they are distinct in the discrete case
a <- dtriangmesh(r)
a$vb[3L, ] <- jitter(a$vb[3L, ], factor = 10)
##rgl.clear(); rgl::shade3d(a, col = "grey"); aspect3d(1, 1, 0.2); rglwidget()



cleanEx()
nameEx("triangulate_quads")
### * triangulate_quads

flush(stderr()); flush(stdout())

### Name: triangulate_quads
### Title: Triangles from quads
### Aliases: triangulate_quads

### ** Examples

triangulate_quads(cbind(c(1, 2, 4, 3), c(3, 4, 6, 5)))

qm <- quadmesh(raster::crop(etopo, raster::extent(140, 160, -50, -30)))
tri <- triangulate_quads(qm$ib)
plot(t(qm$vb))
tri_avg <- colMeans(matrix(qm$vb[3, tri], nrow = 3), na.rm = TRUE)
scl <- function(x) (x - min(x))/diff(range(x))
tri_col <- grey(seq(0, 1, length = 100))[scl(tri_avg) * 99 + 1]
## tri is qm$ib converted to triangles for the same vertex set
polygon(t(qm$vb)[rbind(tri, NA), ])
polygon(t(qm$vb)[rbind(tri, NA), ], col = tri_col)



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
