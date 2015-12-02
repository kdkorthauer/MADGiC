\name{multiplyr}
\alias{multiplyr}
\title{Multiply the nonsilent constants in a subsetted \code{exome.constants}
  object by the relative rate parameters of the background mutation model}
\usage{
  multiplyr(res, r)
}
\arguments{
  \item{res}{a list with one entry for each chromosome,
  where each entry is a matrix containing a row for each
  coding base pair and the following columns: 1. base pair
  position, 2. nucleotide number (see
  \code{\link{convert.seq.to.num}}), 3. number of possible
  nonsilent transitions, 4. number of possible nonsilent
  transversions, 5. number of possible silent
  transitionsget, 6. number of possible silent
  transversions, and 7. whether the position is in a CpG
  dinucleotide. Is subsetted by a particular gene list to
  include only genes used for nonsilent rate estimation
  (see \code{\link{generate.sel.exome}})}

  \item{r}{numeric value representing the relative rate
  parameter estimate for the ratio of mutations in genes
  with nonsilent vs only silent mutations (selection bias)}
}
\value{
  an object of the same structure as \code{res}, but
  columns 3 and 4 (e, and f) have been multiplied by the
  nonsilent relative rate parameter \code{r}.
}
\description{
  A function to multiply the constants e and f in a
  subsetted \code{exome.constants} object by the relative
  rate parameter for selection bias of the background
  mutation model.  This parameter represents the ratio of
  nonsilent to silent mutations
}
\note{
  This internal function is not intended to be called by
  the user.
}

