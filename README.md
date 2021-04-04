
<!-- README.md is generated from README.Rmd. Please edit that file -->

# supprecipe

<!-- badges: start -->
<!-- badges: end -->

The goal of supprecipe is to supplement the recipe, especially in
feature engineering.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("yzhizai/supprecipe")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(tidymodels)
#> -- Attaching packages -------------------------------------- tidymodels 0.1.2 --
#> √ broom     0.7.3      √ recipes   0.1.15
#> √ dials     0.0.9      √ rsample   0.0.9 
#> √ dplyr     1.0.2      √ tibble    3.0.4 
#> √ ggplot2   3.3.3      √ tidyr     1.1.2 
#> √ infer     0.5.4      √ tune      0.1.2 
#> √ modeldata 0.1.0      √ workflows 0.2.1 
#> √ parsnip   0.1.5      √ yardstick 0.0.7 
#> √ purrr     0.3.4
#> -- Conflicts ----------------------------------------- tidymodels_conflicts() --
#> x purrr::discard() masks scales::discard()
#> x dplyr::filter()  masks stats::filter()
#> x dplyr::lag()     masks stats::lag()
#> x recipes::step()  masks stats::step()
library(supprecipe)
#> 载入需要的程辑包：tidyverse
#> -- Attaching packages --------------------------------------- tidyverse 1.3.0 --
#> √ readr   1.4.0     √ forcats 0.5.0
#> √ stringr 1.4.0
#> -- Conflicts ------------------------------------------ tidyverse_conflicts() --
#> x readr::col_factor() masks scales::col_factor()
#> x purrr::discard()    masks scales::discard()
#> x dplyr::filter()     masks stats::filter()
#> x stringr::fixed()    masks recipes::fixed()
#> x dplyr::lag()        masks stats::lag()
#> x readr::spec()       masks yardstick::spec()
#> 载入需要的程辑包：Publish
#> 载入需要的程辑包：prodlim
#> 载入需要的程辑包：mRMRe
#> 载入需要的程辑包：survival
#> 载入需要的程辑包：igraph
#> 
#> 载入程辑包：'igraph'
#> The following object is masked from 'package:prodlim':
#> 
#>     neighborhood
#> The following object is masked from 'package:tidyr':
#> 
#>     crossing
#> The following object is masked from 'package:tibble':
#> 
#>     as_data_frame
#> The following objects are masked from 'package:purrr':
#> 
#>     compose, simplify
#> The following objects are masked from 'package:dplyr':
#> 
#>     as_data_frame, groups, union
#> The following objects are masked from 'package:dials':
#> 
#>     degree, neighbors
#> The following objects are masked from 'package:stats':
#> 
#>     decompose, spectrum
#> The following object is masked from 'package:base':
#> 
#>     union
#> 
#> 载入程辑包：'mRMRe'
#> The following object is masked from 'package:infer':
#> 
#>     visualize
## basic example code

data(cells)
cells <- select(cells, -case)
names(cells)[1] <- 'Label' # when use your own data, make sure the first column is your target label, and named it with 'Label'

a.rec <- recipe(Label~., data = cells) %>% 
  step_zv(all_predictors()) %>% 
  step_normalize(all_predictors()) %>% 
  step_anova(all_predictors(), skip = T) %>% 
  step_mrmr(all_predictors(), skip = T)


a.mod <- rand_forest() %>% 
  set_engine('randomForest') %>% 
  set_mode('classification')

a.wflow <- workflow() %>% 
  add_recipe(a.rec) %>% 
  add_model(a.mod)


a.model <- fit(a.wflow, data = cells)

predict(a.model, new_data = cells)
#> # A tibble: 2,019 x 1
#>    .pred_class
#>    <fct>      
#>  1 PS         
#>  2 PS         
#>  3 WS         
#>  4 PS         
#>  5 PS         
#>  6 WS         
#>  7 WS         
#>  8 PS         
#>  9 WS         
#> 10 WS         
#> # ... with 2,009 more rows
```
