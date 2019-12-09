# reproj dev

* `reproj()` gains a new argument `four = FALSE`, this can be used to return
 the fourth (time) coordinate when using PROJ 6 or higher. 
 
* Now using PROJ package, for version 6 or above. 

* Tested on PROJ version 6 version of the R package proj4. 

* Trim whitespace on PROJ strings, you're welcome. 

# reproj 0.4.0

## New behaviour

* New behaviour for `reproj` which will now assume input data is longitude/latitude 
 if this seems reasonable, and controlled by user-settable options. See `?reproj` 
 for details. 

## New features

* New `reproj` method for `mesh3d` rgl objects. 

* New `reproj` method for `sc` silicate objects. 

# reproj 0.3.0

* Fix bug to remove leading space in PROJ.4 string. 

# reproj 0.2.0

* First viable version. 

