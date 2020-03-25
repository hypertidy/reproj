## code to prepare `DATASET` dataset goes here

library(quadmesh)
library(raster)
.mesh3d <- quadmesh(crop(worldll, extent(100, 150, -60, -30)))
data(wrld_simpl, package = "maptools")
.sc <- silicate::SC(subset(wrld_simpl, NAME %in% c("Australia", "New Zealand")))

## I will surely pay for this
epsg <- rgdal::make_EPSG()
idx <- grep("\\+proj\\=longlat", epsg$prj4)
.epsg_code <- sort(unique(epsg$code[idx]))

usethis::use_data(.sc, .mesh3d, .epsg_code, internal = TRUE)
