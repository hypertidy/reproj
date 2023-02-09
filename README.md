
<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/reproj)](https://cran.r-project.org/package=reproj)
[![CRAN_Download_Badge](http://cranlogs.r-pkg.org/badges/reproj)](https://cran.r-project.org/package=reproj)
[![R-CMD-check](https://github.com/hypertidy/reproj/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/hypertidy/reproj/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

# reproj

The goal of reproj is to reproject data between coordinate systems.

The basic function `reproj()` takes input in diverse forms (matrix, data
frame) and returns a 3-column matrix, by transforming from map
projection specfied by the `source` argument to that specified by the
`target` argument.

The functions `reproj_xy()` and `reproj_xyz()` drive the underlying
`reproj()` for those specific cases for convenience.

We cannot currently do time-dependent transformations.

Matrix and data frame is the basic data structure in R, and this model
also allows adding methods for specific data formats that already carry
a suitable `source` projection string. Currently we support types from
the silicate and quadmesh and rgl packages, and only the `target` string
need be specified. This model has obvious flexibility, for packages to
import the generic and call it with the correct `source` (from the data
format) and the `target` from user, or process controlled mechanism.

The `source` argument must be named, and if it is not present a light
check is made that the source data could be “longitude/latitude” and
transformation to `target` is applied (this can be controlled by setting
options).

Until recently the `proj4` package was the only one available for
generic data that will transform between arbitrary coordinate systems
specified by *source* and *target* coordinate systems and with control
over ‘xy’ versus ‘xyz’ input and output. This package adds some further
features by wrapping the need to convert longitude/latitude data to or
from radians.

Other R packages for transforming coordinates are not geared toward data
that’s not in a particular format. It’s true that only GDAL provides the
full gamut of available geographic map projections, but this leaves a
huge variety of workflows and applications that don’t need that level of
functionality. sf and terra both have raw ‘project()’ functions but they
have inconvenient interfaces, or don’t support some transformations or
the return of missing values.

## Dependencies

- The [PROJ](https://CRAN.r-project.org/package=PROJ) package is used
  preferentially if is functional, using the underlying ‘PROJ-lib’ at
  version 6 or higher.
- The [proj4](https://CRAN.r-project.org/package=proj4) package is used
  if PROJ is not functional.

The proj4 package works perfectly well with the PROJ-lib.

## Warning

Whether a particular source-\>target transformation pathway is
appropriate for your application is your responsibility.

## Installation

You can install the dev version of reproj from
[github](https://github.com/hypertidy/reproj/) with:

``` r
remotes::install_github("hypertidy/reproj")
```

## Example

This example shows how to convert between coordinate systems:

``` r
library(reproj)
(pt <- (reproj(cbind(c(147, 148), c(-42, -45)), target = "+proj=laea +datum=WGS84", source = "OGC:CRS84")))
#>           x_        y_  
#> [1,] 5969744  -9803200 0
#> [2,] 5362760 -10052226 0

## to another coordinate system
(pt1 <- reproj(pt, target = "+proj=lcc +lat_1=-20 +lat_2=-10 +datum=WGS84", source = "+proj=laea +datum=WGS84"))
#>            x_       y_ z_
#> [1,] 12701201 -9158714  0
#> [2,] 12538357 -9514556  0

## and back again

reproj(pt1, target = "OGC:CRS84", source = "+proj=lcc +lat_1=-20 +lat_2=-10 +datum=WGS84")
#>       x_  y_ z_
#> [1,] 147 -42  0
#> [2,] 148 -45  0
```

Note that the output is always in ‘xyz’ form, even if the z value is
implied zero. The input may also be ‘xyz’ and it is the user’s job to
ensure this is specified correctly. It’s not possible to automate every
case, because among the three main cases:

- longitude latitude and elevation,
- projected xy and elevation,
- geocentric xyz with embedded elevation (an offset to the radius
  `+a/+b` in PROJ terms),

it is not possible to easily capture the intended task. reproj sits at
the simplest level of flexibility and control, and doesn’t impose any
restrictions of converting between these cases.

## Contributions

Are you interested in reproj or even contributing? Great! Please use the
[issues](https://github.com/hypertidy/reproj/issues) tab for
discussions.

This is a wishlist / todo.

- see libproj make it to CRAN for the long term

------------------------------------------------------------------------

Please note that the ‘reproj’ project is released with a [Contributor
Code of
Conduct](https://hypertidy.github.io/reproj/CODE_OF_CONDUCT.html). By
contributing to this project, you agree to abide by its terms.
