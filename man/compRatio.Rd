\name{compRatio}
\alias{compRatio}
\title{Cubic spline logistic regression}
\usage{
  compRatio(center, succ, fail, df = 5)
}
\arguments{
  \item{center}{numeric vector of the midpoints of the
  bins}

  \item{succ}{numeric vector of the same length of
  \code{center} that corresponds to the number of
  'successes' (fulls) in each bin}

  \item{fail}{umeric vector of the same length of
  \code{center} that corresponds to the number of
  'failures' (nulls) in each bin}

  \item{df}{the number of degrees of freedom for the spline
  regression (defaults to 5)}
}
\value{
  list object with four elements: \item{z}{numeric vector
  of midpoints} \item{probs}{numeric vector of fitted
  probabilities of success} \item{ratio}{numeric vector of
  the ratio of successes to failures, accounting for total
  numbers of successes and failures} \item{df}{the number
  of degrees of freedom used for the spline regression}
}
\description{
  Performs the cubic spline logistic regression for use in
  the \code{\link{locfdr}} function
}
\note{
  This internal function is not intended to be called by
  the user.
}

