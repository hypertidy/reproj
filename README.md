
<!-- README.md is generated from README.Rmd. Please edit that file -->

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Travis build
status](https://travis-ci.org/hyptidy/reproj.svg?branch=master)](https://travis-ci.org/hypertidy/reproj)[![AppVeyor
build
status](https://ci.appveyor.com/api/projects/status/github/mdsumner/reproj?branch=master&svg=true)](https://ci.appveyor.com/project/mdsumner/reproj)
[![CRAN
status](https://www.r-pkg.org/badges/version/reproj)](https://cran.r-project.org/package=reproj)

# reproj

The goal of reproj is to reproject data between coordinate systems.

## Warning

There are a number of limitations to the
[proj4](https://CRAN.r-project.org/package=proj4) package that is used
by reproj, please use reproj at your own risk. The
[sf](https://CRAN.r-project.org/package=sf) package provides a better
supported facility to modern code and for datum transformations. We have
not even checked if proj4 can do that. If a more generic interface to
the PROJ library becomes available we will configure reproj to use it.

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
reproj(cbind(c(147, 148), c(-42, -45)), target = "+proj=laea +datum=WGS84", source = 4326)
#>         [,1]      [,2] [,3]
#> [1,] 5969744  -9803200    0
#> [2,] 5362760 -10052226    0
```

Please note that the ‘reproj’ project is released with a [Contributor
Code of Conduct](CODE_OF_CONDUCT.md). By contributing to this project,
you agree to abide by its terms.
