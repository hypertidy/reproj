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

