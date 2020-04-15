# quadmesh

<details>

* Version: 0.4.0
* Source code: https://github.com/cran/quadmesh
* URL: https://github.com/hypertidy/quadmesh
* BugReports: https://github.com/hypertidy/quadmesh/issues
* Date/Publication: 2019-04-06 06:10:03 UTC
* Number of recursive dependencies: 127

Run `revdep_details(,"quadmesh")` for more info

</details>

## Newly broken

*   checking tests ...
    ```
     ERROR
    Running the tests in 'tests/testthat.R' failed.
    Last 13 lines of output:
      [4]  6372760 -  6372742 ==  18.044
      [5]  -111267 -  -111267 ==  -0.315
      [6] -2894397 - -2894389 ==  -8.195
      [7] -3090883 - -3090874 ==  -8.752
      [8] -4560277 - -4560264 == -12.912
      [9] -5925015 - -5924998 == -16.776
      ...
      
      == testthat results  ===========================================================
      [ OK: 31 | SKIPPED: 2 | WARNINGS: 1 | FAILED: 2 ]
      1. Failure: mesh_plot works (@test-image.R#24) 
      2. Failure: globe conversion works (@test-reproject.R#42) 
      
      Error: testthat unit tests failed
      Execution halted
    ```

