
<!-- README.md is generated from README.Rmd. Please edit that file -->

# simplec - demo package for calling C code with `.C()`

<!-- badges: start -->

![](https://img.shields.io/badge/cool-useless-green.svg)
<!-- badges: end -->

`simplec` is a small demo package showing how C code could be included
in a package and called with `.C()`

**In general:** Consider using `.Call()` or `Rcpp` instead of `.C()`

This is one of a series of small demo packages for  
calling other languages from R:

  - [{simplec}](https://github.com/coolbutuseless/simplec) - calling C
    with `.C()`
  - [{simplecall}](https://github.com/coolbutuseless/simplecall) -
    calling C with `.Call()`
  - [{simplercpp}](https://github.com/coolbutuseless/simplercpp) -
    calling C++ with `{Rcpp}`
  - [{simplefortran}](https://github.com/coolbutuseless/simplefortran) -
    calling Fortran with `.Fortran()`

## Rough comparison of `.C()`, `.Call()`, `{Rcpp}` (and `.Fortran()`)

|                | .C()                                                   | .Call()                                                      | Rcpp                                                                                                       |
| -------------- | ------------------------------------------------------ | ------------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------- |
| Overview       | No real understanding of R objects                     | Need to understand SEXP macros & internals                   | C++ classes hide the complexity of the SEXP internals                                                      |
| What code?     | Basic C code. Numeric calcs.                           | Complex C code. Can manipulate R objects from C              | Complex C and C++ code involving numerics and R objects                                                    |
| Pros           | Simple to understand and use                           | Simple. No unnecessary copying.                              | Great documentation. Wrapping of R objects very intuitive.                                                 |
| Cons           | Too simple for most interesting things                 | Need to understand SEXP & R internals                        |                                                                                                            |
| Cons           | Performs copying of data to call functions             |                                                              |                                                                                                            |
| Demo R package | [{simplec}](https://github.com/coolbutuseless/simplec) | [{simplecall}](https://github.com/coolbutuseless/simplecall) | [{simplercpp}](https://github.com/coolbutuseless/simplercpp)                                               |
| Compiled size  | 17 kB                                                  | 17 kB                                                        | 92 kB (stripping can bring this down: see [issue1](https://github.com/coolbutuseless/simplercpp/issues/1)) |

|                | .Fortran()                                                         |
| -------------- | ------------------------------------------------------------------ |
| Overview       | No real understanding of R objects                                 |
| What code?     | Basic Fortran code. Numeric calcs.                                 |
| Pros           | Simple to understand and use                                       |
| Cons           | Too simple for most interesting things                             |
| Cons           | Performs copying of data to call functions                         |
| Cons           | Need to know Fortran\!                                             |
| Demo R package | [{simplefortran}](https://github.com/coolbutuseless/simplefortran) |
| Compiled size  | 17 kB                                                              |

``` 
                         |
```

## Installation

You can install from [GitHub](https://github.com/coolbutuseless/simplec)
with:

``` r
# install.package('remotes')
remotes::install_github('coolbutuseless/simplec)
```

## What’s in the box?

Package contains 2 C functions, and 2 functions in R which call the C
functions using `.C()`.

| C function                                | R function    |
| ----------------------------------------- | ------------- |
| `add_(double *x, double *y, double *res)` | `add_C(x, y)` |
| `mul_(double *x, double *y, double *res)` | `mul_C(x, y)` |

## What’s in the R functions?

  - A call using `.C()`
  - First argument is the C function name e.g. `add_`
  - `x` and `y` arguments are passed through from the R function
  - the third argument to the function is space in which to store the
    result i.e. `numeric(1)`
  - `.C()` returns as many arguments as you gave it originally
  - We only want to return the actual result, which is the third
    argument, hence `[[3]]`
  - `@useDynLib [packagename] [C function name]` is used to generate the
    NAMESPACE entry `useDynLib(simplec,add_)`

<!-- end list -->

``` r
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Add two numbers
#'
#' @param x,y numbers to add
#'
#' @useDynLib simplec add_
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
add_C <- function(x, y) {
  .C(add_, x, y, numeric(1))[[3]]
}
```

## What’s in the C functions?

  - C function returns `void`
  - all arguments passed as pointers
  - Actual result must be stored in one of the arguments

<!-- end list -->

    void add_(double* x, double* y, double* res) {
      res[0] = x[0] + y[0];
    }

## How do R variables map to C variables?

  - See [R manual on writing
    Extensions](https://cran.r-project.org/doc/manuals/R-exts.html#Interface-functions-_002eC-and-_002eFortran)
    for more info

| R         | C                |
| --------- | ---------------- |
| logical   | int \*           |
| integer   | int \*           |
| double    | double \*        |
| complex   | Rcomplex \*      |
| character | char \*\*        |
| raw       | unsigned char \* |

## What does the C function look like in R?

  - An object of class `NativeSymbolInfo`
  - Holds an `externalptr` to the loaded function

<!-- end list -->

``` r
simplec:::add_
#> $name
#> [1] "add_"
#> 
#> $address
#> <pointer: 0x7f9780cb1c30>
#> attr(,"class")
#> [1] "RegisteredNativeSymbol"
#> 
#> $dll
#> DLL name: simplec
#> Filename:
#>         /Library/Frameworks/R.framework/Versions/4.0/Resources/library/simplec/libs/simplec.so
#> Dynamic lookup: FALSE
#> 
#> $numParameters
#> [1] 3
#> 
#> attr(,"class")
#> [1] "CRoutine"         "NativeSymbolInfo"
```

## Resources

  - [Peter Dalgaard’s Keynote from
    UseR 2004](http://www.ci.tuwien.ac.at/Conferences/useR-2004/Keynotes/Dalgaard.pdf)
    discusses R’s language interfaces
  - [Using R — Calling C Code ‘Hello
    World’](http://mazamascience.com/WorkingWithData/?p=1067)
  - [Hadley’s Advanced R book chapter - ‘Rs C
    interface’](http://adv-r.had.co.nz/C-interface.html)
  - [Rcpp](https://cran.r-project.org/package=Rcpp)

## Acknowledgements

  - R Core for developing and maintaining such a wonderful language.
  - CRAN maintainers, for patiently shepherding packages onto CRAN and
    maintaining the repository
