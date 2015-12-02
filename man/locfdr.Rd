\name{locfdr}
\alias{locfdr}
\title{Estimation of non-null density}
\usage{
  locfdr(nonsil.mutab, exome.SIFT, dir = "./simulated",
    N = 100)
}
\arguments{
  \item{dir}{a character string that contains the directory
  path to the simulated datasets}

  \item{N}{a numeric value that corresponds to how many
  simulated datasets are contained in the directory
  \code{dir}}

  \item{nonsil.mutab}{a matrix containing one row per
  nonsilent mutation and 8 columns (Ensembl gene name,
  chromosome, position, variant type (SNP, In_frame,
  Frame_shift), reference allele, tumor allele 1, tumor
  allele 2, and sample id.}

  \item{exome.SIFT}{list object with one item per
  chromosome where each item contains matrix with one row
  per coding base pair and 7 columns: position, nucleotide,
  CpG context, FI score for mutation to "A", FI score for
  mutation to "C", FI score for mutation to "G", and FI
  score for mutation to "T".}
}
\value{
  a list object with three elements: \item{f0}{numeric
  vector containing the estimated null density of FI scores
  over \code{nbins} bins} \item{f1}{numeric vector
  containing the estimated non-null density of FI scores
  over \code{nbins} bins} \item{nbins}{numeric value that
  represents how many bins were used for the spline
  regression}
}
\description{
  This function utilizes the algorithm for local false
  discovery rate (locfdr) estimation from Efron (2001) to
  estimate the non-null density of SIFT scores.  Null
  scores are obtained from the simulated datasets created
  using \code{\link{shuffle.muts}}
}
\note{
  This internal function is not intended to be called by
  the user.
}

