
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
## basic example code

data(cells)
cells <- select(cells, -case)
names(cells)[1] <- 'Label' # when use your own data, make sure the first column is your target label, as names with 'Label'

a_recipe <- recipe(Label~., data = cells) %>% 
  step_zv(all_predictors()) %>% 
  step_anova(all_predictors(), options = list(p_thresh = 0.05)) %>% 
  step_mrmr(all_predictors(), options = list(num_feature = 30))
```
