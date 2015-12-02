\name{calculate.post.probs}
\alias{calculate.post.probs}
\title{Calculate posterior probability of being a driver}
\usage{
  calculate.post.probs(bij, sample.name, nonsil.mut.type,
    gid, exome.SIFT, f0, f1, alpha = 0.2, beta = 6, p0)
}
\arguments{
  \item{bij}{list object with one entry per gene, where
  each entry is a numeric vector containing 1-the
  probability of a mutation in each sample under the
  background mutation model}

  \item{nonsil.mut.type}{table of mutations, object
  obtained from \code{\link{mut.type.converter}}}

  \item{f0}{numeric vector containing the estimated null
  density of FI scores obtained from \code{\link{locfdr}}}

  \item{f1}{numeric vector containing the estimated
  non-null density of FI scores obtained from
  \code{\link{locfdr}}}

  \item{alpha}{numeric value of first shape parameter of
  the prior Beta distribution on the probability of
  mutation for driver genes. Default value of 0.2 is chosen
  as a compromise between a cancer type with a relatively
  low mutation rate (Ovarian cancer, fitted value from
  COSMIC of 0.15) and one with a comparatively high
  mutation rate (Squamous cell lung, fitted value from
  COSMIC of 0.27), but results are robust to changes in
  this parameter. Note that intuitively (and empirically),
  a higher mutation rate overall leads to a higher driver
  mutation rate overall - and thus less mass is
  concentrated in the left tail of the distribution.}

  \item{beta}{numeric value of second shape parameter of
  the prior Beta distribution on the probability of
  mutation for driver genes. Default value of 6 is chosen
  as a compromise between a cancer type with a relatively
  low mutation rate (Ovarian cancer, fitted value from
  COSMIC of 6.6) and one with a comparatively high mutation
  rate (Squamous cell lung, fitted value from COSMIC of
  5.83), but results are robust to changes in this
  parameter.  Note that intuitively (and empirically), a
  higher mutation rate overall leads to a higher driver
  mutation rate overall - and thus less mass is
  concentrated in the left tail of the distribution.}

  \item{exome.SIFT}{list object with one item per
  chromosome where each item contains matrix with one row
  per coding base pair and 7 columns: position, nucleotide,
  CpG context, FI score for mutation to "A", FI score for
  mutation to "C", FI score for mutation to "G", and FI
  score for mutation to "T".}

  \item{p0}{vector of prior probabilities for each gene
  being a driver. This is precomputed from COSMIC and
  loaded into package.  See paper for details.}

  \item{sample.name}{a character vector containing the
  names of all samples}

  \item{gid}{a character vector containing the Ensembl gene
  ids of all genes}
}
\value{
  named vector of posterior probabilities that each gene is
  a driver.
}
\description{
  This function calculates the posterior probability for
  every gene being a driver
}
\note{
  This internal function is not intended to be called by
  the user.
}

