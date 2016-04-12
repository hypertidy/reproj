context("reproj")

## TODO: Rename context
## TODO: Add more tests

llproj <- "+proj=longlat +ellps=WGS84"
laeaproj <- "+proj=laea +ellps=WGS84"

# library(proj4)
# dat <- as.matrix(expand.grid(x = seq(-180, 180), y = seq(-90, 90)))
# dat <- dat[sample(nrow(dat), 10), ]
# pdat <- proj4::ptransform(dat * pi/180, llproj, laeaproj)
# dput(dat)
# dput(pdat)
dat <- structure(c(-162L, -97L, -162L, 40L, -36L, 32L, 32L, -67L, -25L,
            -22L, 14L, -31L, 52L, -49L, -1L, -11L, 38L, 66L, -65L, 32L), .Dim = c(10L,
                                                                                  2L), .Dimnames = list(NULL, c("x", "y")))

pdat <- structure(c(-9752052.25396846, -8119467.86794594, -2678218.88894421,
            3109728.10218706, -3941443.47017694, 3466582.53790106, 2920150.83154972,
            -3147972.12215379, -1374249.03919241, -2146112.98562162, 7815696.43338213,
            -4882405.39621803, 11018883.0376461, -5528095.07432074, -116262.853667621,
            -1263068.91163095, 4276503.16642679, 7629667.99984509, -6926735.4349356,
            3555900.89373428), .Dim = c(10L,
                                                                      2L))

test_that("basic reprojection works", {
  expect_equivalent(reproj(dat, llproj, laeaproj), pdat)
  expect_equivalent(reproj(pdat, laeaproj, llproj), dat)
})
