#' a step_* method used in recipe to filter the features using MRMR method
#'
#' @param recipe a recipe object
#' @param ... the selected features
#' @param role see recipe description
#' @param trained see recipe description
#' @param ref_dist the final selected feature names
#' @param options containing the number of features to remain
#' @param skip see recipe description
#' @param id see recipe description
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
#' step_mrmr(all_predictors(), options = list(num_feature = 30))
step_mrmr <- function(
  recipe,
  ...,
  role = NA,
  trained = FALSE,
  ref_dist = NA,
  options = list(num_feature = 30),

  skip = F,
  id = rand_id('mrmr')
)
{
  terms <- ellipse_check(...)

  add_step(
    recipe,
    step_mrmr_new(
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

step_mrmr_new <- function(terms, trained, role, ref_dist, options, skip, id)
{
  recipes::step(
    subclass = 'mrmr',
    terms = terms,
    role = role,
    trained = trained,
    ref_dist = ref_dist,
    options = options,
    skip = skip,
    id = id
  )
}

#' The general prep function used for step_mrmr
#'
#' @param x a recipe object
#' @param training the training data
#' @param info ...
#'
#' @importFrom recipes prep
#' @return
#' @export
#'
#' @examples
prep.step_mrmr <- function(x, training, info = NULL)
{
  col_names <- terms_select(x$terms, info = info)

  levs <- training$Label
  training <- mutate(training, Label = ifelse(Label == levs[1], 0, 1))
  t_idx <- which(names(training) == 'Label')
  dt.mrmr <- mRMR.data(as.data.frame(training))
  fs <- new('mRMRe.Filter',
            data = dt.mrmr,
            target_indices = t_idx,
            levels = x$options$num_feature)

  ref_dist = featureNames(fs)[solutions(fs)[[1]]]

  step_mrmr_new(
    terms <- x$terms,
    trained = T,
    role = x$role,
    ref_dist = ref_dist,
    options = x$options,
    skip = x$skip,
    id = x$id
  )
}

#' The general bake function for step_mrmr
#'
#' @param object output of prep
#' @param new_data new data
#' @param ... other arguments
#' @importFrom recipes bake
#' @return
#' @export
#'
#' @examples
bake.step_mrmr <- function(object, new_data, ...)
{
  as_tibble(new_data %>% select('Label', object$ref_dist))
}
