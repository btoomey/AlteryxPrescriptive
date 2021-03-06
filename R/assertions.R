#' Check input quality
#'
#'
#' @param x object to check
#' @param ... additional parameters
#' @export
#' @import assertthat
checkInputs <- function(x, ...){
  UseMethod('checkInputs')
}


#' Check inputs for matrix mode
#'
#'
#' @param x object to check
#' @param ... additional parameters
#' @export
checkInputs_matrix_mode <- function(x, ...){
  assert_that(
    x %has_name% 'O',
    x %has_name% 'A',
    x$O %has_name% 'variable',
    x$O %has_name% 'coefficient'
  )
  are_equal(NROW(x$O), x$A$ncol)

  is.number(x$O$coefficient)
  is.number(x$O$lb)
  is.number(x$O$ub)
  assert_that(all(x$O$type %in% c('C', 'B', 'I')))

  assert_that(
    x$B %has_name% 'dir',
    x$B %has_name% 'rhs',
    all(x$B$dir %in% c('==', '<=', '>=')))
  is.number(x$B$rhs)
  are_equal(x$A$nrow, NROW(x$B))
}

#' Check inputs for file mode
#'
#'
#' @param x object to check
#' @param ... additional parameters
#' @export
checkInputs_file_mode <- function(x, ...){
  fileSelected = x$config$filePath
  assert_that(
    is.readable(fileSelected)
  )
}


#' Check inputs for manual mode
#'
#'
#' @param x object to check
#' @param ... additional parameters
#' @export
checkInputs_manual_mode <- function(x, ...){
  config <- x$config
  Objective <- config$objective
  FieldList <- config$constraints

  assert_that(
    not_empty(FieldList),
    Objective !=  ""
  )
}


