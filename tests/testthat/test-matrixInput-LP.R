context("matrixInput")

## Mock up configuration and inputs  ----
config <- list(
  inputMode = "matrix",
  problemType = "lp",
  maximize = FALSE
)

## Input data.frame with slam format ----
inputsSlam <- list()
inputsSlam$O <- data.frame(
  variable = c('x', 'y', 'z'),
  coefficient = c(1, 1, 2),
  lb = c(0, 0, 0),
  ub = c(Inf, Inf, Inf),
  type = c("B", "B", "B")
)


inputsSlam$A <- data.frame(
  i = c(1, 1, 1, 2, 2),
  j = c(1, 2, 3, 1, 2),
  v = c(1, 2, 3, 1, 1)
)

inputsSlam$B <- data.frame(
  dir = c("<=", ">="),
  rhs = c(4, 1)
)

## Input data.frame with dense matrix format ----
inputsDense <- list()
inputsDense$O <- inputsSlam$O

inputsDense$A <- data.frame(
  x1 = c(1, 1),
  x2 = c(2, 1),
  x3 = c(3, 0)
)

inputsDense$B <- inputsSlam$B

payloadSlam  <- list(config = config, inputs = inputsSlam)
payloadDense <- list(config = config, inputs = inputsDense)

test_that("linear programming, matrix mode (slam), with glpk", {
  payloadSlam$config$solver <- 'glpk'
  sol <- AlteryxSolve(payloadSlam)
  expect_equal(sol$objval, 1)
})

test_that("linear programming, matrix mode (dense), with glpk", {
  payloadDense$config$solver <- 'glpk'
  sol <- AlteryxSolve(payloadDense)
  expect_equal(sol$objval, 1)
})

test_that("linear programming, matrix mode (slam), with gurobi", {
  skip_on_travis()
  library(gurobi)
  payloadSlam$config$solver <- 'gurobi'
  res <- capture.output(sol <- AlteryxSolve(payloadSlam))
  expect_equal(sol$objval, 1)
})

test_that("linear programming, matrix mode (dense), with gurobi", {
  skip_on_travis()
  library(gurobi)
  payloadDense$config$solver <- 'gurobi'
  res <- capture.output(sol <- AlteryxSolve(payloadDense))
  expect_equal(sol$objval, 1)
})