\docType{data}
\name{exome}
\alias{exome}
\title{Exome annotation for human genome build NCBI 36/hg18}
\format{Each list item (one per chromosome) contains a matrix with one row
  per position and the following 15 columns: 1 - base pair position, 2 -ame
  nucleotide (integer representation, see \code{\link{convert.seq.to.num}}),
  3 - number of possible nonsilent transitions, 4 - number of possible
  nonsilent transversions, 5 - number of possible silent transitions, 6 -
  number of possible silent transversions, 7 - indicator of whether position
  is in a CpG dinucleotide, 8 - FI score for mutation to "A", 9 -FI score for
  mutation to "C", 10 - FI score for mutation to "G", 11 - FI score for
  mutation to "T",  12 - nonsilent indicator (1=nonsilent, 0=silent) for
  mutation to "A", 13 - nonsilent indicator for mutation to "C", 14 -
  nonsilent indicator for mutation to "G", and 15 - nonsilent indicator for
  mutation to "T".}
\description{
  This data set contains a list with an item for each
  chromosome where each item is a matrix with a row for
  each position and 15 columns that contain information
  about how many of each type of mutation are possible,
  what their FI (functional impact, here we use SIFT
  scores) are, and whether each type of change is
  nonsilent. This object is broken down into 3 objects in
  the function \code{\link{get.post.probs}}, each
  containing columns 1, 2, and 7: \code{exome.constants}
  (and columns 3-6), \code{exome.SIFT} (and columns 8:11),
  and \code{exome.nonsil} (and columns 12-15).
}
\keyword{datasets}

