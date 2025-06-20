# reproj dev

* `reproj_extent` has been reworked to allow 4-column matrix input (xmin,xmax,ymin,ymax), original form (vector) is also accepted
# reproj 0.7.0. `limit` argument is now ignored, with a message about deprecation. 

* PROJ proj_trans returns a matrix with columns matching input, so we align to that here with some protection for older style for revdeps. 

# reproj 0.6.0

* Fix drop problem in 1 row reproj_xy and reproj_xyz. 

* PROJ package is now in Suggests, because a future release will not allow non-functional lib support. 

* `reproj_extent()` now handles more situations, and gains a `limit` argument for
one or two radius values to limit the distance from centre to edges to this value. 
* When encountering strings "WGS84" or "NAD27" these are now replaced by their PROJ  string versions. 

* New function `reproj_extent()` to produce a reprojected extent `xmin,xmax,ymin,ymax`. 

# reproj 0.4.3

* Argument 'four' is now disabled as we cannot support it. 

* Now using longlat-order compliant "OGC:CRS84" string throughout, rather than projstring
 'longlat' or EPSG code 4326.
 
* New helper functions `reproj_xyz()` and `reproj_xy()` to return those specific cases. 

* Removed unused LazyData element from DESCRIPTION. 

# reproj 0.4.2

* Removed tibble dependency (was used to write-in-place
to silicate vertex table). 

* New global option `reproj.mock.noproj6` to simulate when no PROJ function is
available (i.e. force fallback to proj4, no matter what version of that library
is in use).
 
* Now importing PROJ package for use of underlying PROJ  
 library (for versions projlib >= 6.0.0). 
 
* Now checking for longlat condition from more EPSG codes. 

* Now imports crsmeta to obtain meta strings from silicate. 

* New reproj methods for quadmesh and trimesh. 

* `reproj()` gains a new argument `four = FALSE`, this can be used to return
 the fourth (time) coordinate when using PROJ 6 or higher. 
 
* Behaviour has changed in a breaking way, we now can only input 2-columns and
an optional `z_` may be input. 3-columns are always returned unless `four =
TRUE`, and the option `t_` may also be input.
 
* Now using PROJ package, for version 6 or above. 

* Tested on PROJ version 6 version of the R package proj4. 

* Trim whitespace on PROJ strings, you're welcome. 

# reproj 0.4.0

## New behaviour

* New behaviour for `reproj` which will now assume input data is
longitude/latitude if this seems reasonable, and controlled by user-settable
options. See `?reproj` for details.

## New features

* New `reproj` method for `mesh3d` rgl objects. 

* New `reproj` method for `sc` silicate objects. 

# reproj 0.3.0

* Fix bug to remove leading space in PROJ.4 string. 

# reproj 0.2.0

* First viable version. 

