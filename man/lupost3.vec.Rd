\name{lupost3.vec}
\alias{lupost3.vec}
\title{Likelihood of sample specific mutation rate given the background model}
\usage{
  lupost3.vec(t, mutationexist, C, D, uniqueA, tableA)
}
\arguments{
  \item{t}{numeric value of sample-specific mutation rate
  (log-scale)}

  \item{mutationexist}{logical value indicating whether to
  include observed mutations in the current gene}

  \item{C}{subset of matrix \code{muttable} (see
  \code{\link{calculate.bij}}) containing only those rows
  corresponding to the current sample}

  \item{D}{numeric value corresponding to the sum of the
  logarithms of the first column of \code{C}}

  \item{uniqueA}{a numeric vector containing all unique
  values of A (see \code{\link{getA}})}

  \item{tableA}{a numeric vector of the same length of
  \code{uniqueA} that contains the number of instances of
  each value in \code{uniqueA}}
}
\value{
  log likelihood of the sample-specific mutation rate q_j
  under the background mutation model given the observed
  mutations.
}
\description{
  Calculates the log likelihood of the sample specific
  mutation rate under the background mutation model.
  Similar to \code{\link{lupost2.vec}} except that it
  returns the raw value of the likelihood value instead of
  the logarithm and it is not normalized with \code{base}.
}
\note{
  This internal function is not intended to be called by
  the user.
}

