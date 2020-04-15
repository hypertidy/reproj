reprex::reprex({
  library(quadmesh)
library(raster)
library(sf)
library(lwgeom)
library(reproj)
library(rgdal)
xy <- coordinates(etopo)

## we want "p_?" the matrix of coordinates in LAEA
ll <- "+proj=longlat +datum=WGS84"
prj <- "+proj=laea +datum=WGS84"


mpt <- st_sfc(st_multipoint(xy), crs = ll)
pt <- st_sfc(lapply(split(t(xy), rep(seq_len(nrow(xy)), each = 2)), st_point), crs = ll)
library(bench)

a <- bench::mark(
            lwgeom_mpt = st_coordinates(st_transform_proj(mpt, prj))[, 1:2, drop = FALSE],   # 0.147s
            reproj = reproj(xy, target = prj, source = ll)[, 1:2, drop = FALSE],             # 0.021s
            lwgeom_pt = st_coordinates(st_transform(pt, prj))[, 1:2, drop = FALSE],          # 2.36s
            rgdal = rgdal::project(xy, prj),                                                 # 0.019s
            iterations = 20,
            check = FALSE)

library(dplyr)
a %>% select(expression, median, `itr/sec`, mem_alloc, total_time) %>% arrange(desc(total_time))

})
