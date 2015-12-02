\name{convert.seq.to.num}
\alias{convert.seq.to.num}
\title{Convert nucleotide sequence to numbers}
\usage{
  convert.seq.to.num(x)
}
\arguments{
  \item{x}{a character vector containing any number of "A",
  "T", "G", and "C".}
}
\value{
  a vector of integers where 1 corresponds to "A", 2
  corresponds to "T", 3 corresponds to "G", and 4
  corresponds to "C".  A 0 is put in place of characters
  that are missing or not one of the four nucleotides.
}
\description{
  This function converts nucleotide sequence to numbers for
  the efficiency of calculation
}
\note{
  This internal function is not intended to be called by
  the user.
}

