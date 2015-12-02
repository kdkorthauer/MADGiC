\name{sift.colA}
\alias{sift.colA}
\title{Retrieve the column from SIFT oject correspoinding to mutated base letter}
\usage{
  sift.colA(mutbase)
}
\arguments{
  \item{mutbase}{a character "A", "C", "G", or "T"}
}
\value{
  an integer 4, 5, 6 or 7
}
\description{
  function to match the mutated base to the appropriate
  column of \code{exome.SIFT} ("A":4, "C":7, "G":6, "T":5)
}
\details{
  Similar to \code{\link{sift.col}} except uses the
  character of bases instead of numerical indicator.  See
  \code{\link{mut.type.converter}} for details of the
  structure of \code{exome.SIFT}.
}
\note{
  This internal function is not intended to be called by
  the user.
}

