## code to prepare `DATASET` dataset goes here

library(quadmesh)
library(raster)
.mesh3d <- quadmesh(crop(worldll, extent(100, 150, -60, -30)))
data(wrld_simpl, package = "maptools")
.sc <- silicate::SC(subset(wrld_simpl, NAME %in% c("Australia", "New Zealand")))
usethis::use_data(.sc, .mesh3d, internal = TRUE)
