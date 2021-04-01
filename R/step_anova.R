library(tidymodels)
library(Publish)

#' A step_* method used in recipe to filter the features using independent sample t test
#'
#' @param recipe a recipe object
#' @param ... the selected features
#' @param role see recipe description
#' @param trained see recipe description
#' @param ref_dist the selected feature names, you didn't need to assign
#' @param options the options to run step_anova
#' @param skip see recipe description
#' @param id the id of this step
#'
#' @return a recipe object
#' @export
#'
#' @examples
#'
#' data(cells)
#' cells <- mutate(cells) %>% select(-case)
#' colnames(cells)[1] <- 'Label'
#' a_rec <- recipe(Label~., data = cells) %>%
#' step_anova(all_predictors())
step_anova <- function(
  recipe,
  ...,
  role = NA,
  trained = FALSE,
  ref_dist = NA,
  options = list(p_thresh = 0.05),

  skip = F,
  id = rand_id('anova')
)
{
  terms <- ellipse_check(...)

  add_step(
    recipe,
    step_anova_new(
      terms = terms,
      trained = trained,
      role = role,
      ref_dist = ref_dist,
      options = options,
      skip = skip,
      id = id
    )
  )
}

step_anova_new <- function(terms, trained, role, ref_dist, options, skip, id)
{
  step(
    subclass = 'anova',
    terms = terms,
    role = role,
    trained = trained,
    ref_dist = ref_dist,
    options = options,
    skip = skip,
    id = id
  )
}

#'  the general prep function used for step_anova
#'
#' @param x a recipe object
#' @param training the data used in recipe
#' @param info ...
#'
#' @return
#' @export
#'
#' @examples
prep.step_anova <- function(x, training, info = NULL)
{
  col_names <- terms_select(x$terms, info = info)


  u.form <- paste('Label',
                  paste(col_names, collapse = '+'),
                  sep = '~') %>% as.formula()

  u.test <- univariateTable(u.form, data = training, show.totals = F,
                            digits = 3)


  ref_dist <- names(which(u.test$p.values < x$options$p_thresh))

  step_anova_new(
    terms <- x$terms,
    trained = T,
    role = x$role,
    ref_dist = ref_dist,
    options = x$options,
    skip = x$skip,
    id = x$id
  )
}

#'  the general bake function used for step_anova
#'
#' @param object a output of prep
#' @param new_data a new data
#' @param ... other arguments
#'
#' @return
#' @export
#'
#' @examples
bake.step_anova <- function(object, new_data, ...)
{
  as_tibble(new_data %>% select('Label', object$ref_dist))
}
