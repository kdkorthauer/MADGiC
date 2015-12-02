\name{find.prior.param}
\alias{find.prior.param}
\title{Find the maximum likelihood values for the hyperparameters \code{a}
  and \code{b}}
\usage{
  find.prior.param(x, muttable, uniqueA, tableA, S)
}
\arguments{
  \item{x}{a vector of length two with the initial guess
  for \code{a} and \code{b}.  Note that these values are on
  the log scale, i.e. a lower bound of 5E-8 would
  correspond to a=-16.8.}

  \item{S}{an integer corresponding to the number of
  samples in the dataset.}

  \item{muttable}{a matrix containing the likelihood due to
  existing background mutations, see
  \code{\link{mut.lik.change}}}

  \item{uniqueA}{a numeric vector containing all unique
  values of A (see \code{\link{getA}})}

  \item{tableA}{a numeric vector of the same length of
  \code{uniqueA} that contains the number of instances of
  each value in \code{uniqueA}}
}
\value{
  a list containing two items: \item{a}{numeric value for
  the maximum likelihood estimate of the hyperparameter a
  representing the prior for q_j (sample-specific mutation
  rate, q_j~Unif(a,b))} \item{b}{numeric value for the
  maximum likelihood estimate of the hyperparameter a
  representing the prior for q_j (sample-specific mutation
  rate, q_j~Unif(a,b))}
}
\description{
  Calculates the value of (\code{a},\code{b}) that
  maximizes the likelihood of q_j (sample-specific
  background mutation rate) given the relative rate
  parameters.
}
\note{
  This internal function is not intended to be called by
  the user.
}

