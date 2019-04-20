
<!-- README.md is generated from README.Rmd. Please edit that file -->

[![lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![Travis build
status](https://travis-ci.org/hypertidy/reproj.svg?branch=master)](https://travis-ci.org/hypertidy/reproj)[![AppVeyor
build
status](https://ci.appveyor.com/api/projects/status/github/hypertidy/reproj?branch=master&svg=true)](https://ci.appveyor.com/project/mdsumner/reproj)
[![CRAN
status](https://www.r-pkg.org/badges/version/reproj)](https://cran.r-project.org/package=reproj)[![CRAN\_Download\_Badge](http://cranlogs.r-pkg.org/badges/reproj)](https://cran.r-project.org/package=reproj)[![Coverage
Status](https://img.shields.io/codecov/c/github/hypertidy/reproj/master.svg)](https://codecov.io/github/hypertidy/reproj?branch=master)

# reproj

The goal of reproj is to reproject data between coordinate systems.

The `proj4` package is the only one available for generic data that will
transform between arbitrary coordinate systems specified by *source* and
*target* coordinate systems, and the only one with control over ‘xy’
versus ‘xyz’ input and output. reproj adds some further features by
wrapping the need to convert longitude/latitude data to or from radians.

Other R packages for transforming coordinates are monolithic and do not
expose the underlying facility outside of their specific goals and
contexts. The packages that do this are `rgdal`, `sf` and `lwgeom`. The
all require GDAL by some means, and include many other irrelevant
libraries and restrictions including specific data formats that are
inefficient.

Possible alternatives are `mapproj` and `globe` but these are variously
too specific or difficult to use. If you know of others please let me
know\!

## Warning

There are a number of limitations to the
[proj4](https://CRAN.r-project.org/package=proj4) package that is used,
please use reproj at your own risk. The
[sf](https://CRAN.r-project.org/package=sf) package provides a better
supported facility to modern code and for datum transformations. (We
have not even checked if proj4 can do datum transforms). If a more
generic interface to the PROJ library becomes available we will
configure reproj to use it.

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
(pt <- (reproj(cbind(c(147, 148), c(-42, -45)), target = "+proj=laea +datum=WGS84", source = 4326)))
#>         [,1]      [,2] [,3]
#> [1,] 5969744  -9803200    0
#> [2,] 5362760 -10052226    0

## to another coordinate system
(pt1 <- reproj(pt, target = "+proj=lcc +lat_1=-20 +lat_2=-10 +datum=WGS84", source = "+proj=laea +datum=WGS84"))
#>          [,1]     [,2] [,3]
#> [1,] 12701201 -9158714    0
#> [2,] 12538357 -9514556    0

## and back again

reproj(pt1, target = "+proj=longlat +datum=WGS84", source = "+proj=lcc +lat_1=-20 +lat_2=-10 +datum=WGS84")
#>      [,1] [,2] [,3]
#> [1,]  147  -42    0
#> [2,]  148  -45    0
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

Are you interested in reproj or even contributing? Great\! Please use
the [issues](https://github.com/hypertidy/reproj/issues) tab for
discussions.

This is a wishlist / todo.

  - wrap modern PROJ in an R package with no other dependencies
  - isolate the sf/lwgeom code for PROJ.4 in its own package
  - allow choice of engine for `reproj.method` (this is already possible
    for your own classes)

Please note that the ‘reproj’ project is released with a [Contributor
Code of Conduct](CODE_OF_CONDUCT.md). By contributing to this project,
you agree to abide by its terms.
