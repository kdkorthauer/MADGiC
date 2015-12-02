\name{lupost.vec}
\alias{lupost.vec}
\title{Likelihood of mutations in a single gene and sample given the
  background model}
\usage{
  lupost.vec(t, mutationexist, C, D, uniqueB, tableB,
    uniqueA, tableA, base)
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

  \item{uniqueB}{similar to \code{uniqueA} except
  restricted to the current gene}

  \item{tableB}{similar to \code{tableA} except restricted
  to the current gene}

  \item{base}{minimum value of the log likelihood of the
  sample-specific mutation rate q_j given the background
  model}

  \item{uniqueA}{a numeric vector containing all unique
  values of A (see \code{\link{getA}})}

  \item{tableA}{a numeric vector of the same length of
  \code{uniqueA} that contains the number of instances of
  each value in \code{uniqueA}}
}
\value{
  likelihood of mutations in a single gene and sample given
  the background model and sample-specific mutation rate
  \code{t}
}
\description{
  Calculates, for a given gene and sample, the likelihood
  of mutations in a given gene under the background
  mutation model and current value of the sample-specific
  mutation rate
}
\note{
  This internal function is not intended to be called by
  the user.
}

