\name{mut.base}
\alias{mut.base}
\title{Convert nucleotide sequence to column numbers in
  \code{exome.SIFT}}
\usage{
  mut.base(x)
}
\arguments{
  \item{x}{a character vector containing any number of "A",
  "T", "G", and "C".}
}
\value{
  a vector of integers where 4 corresponds to "A", 5
  corresponds to "T", 6 corresponds to "G", and 7
  corresponds to "C".
}
\description{
  This function converts nucleotide sequence to column
  numbers in the \code{exome.SIFT} object that they
  correspond to
}
\note{
  This internal function is not intended to be called by
  the user.
}

