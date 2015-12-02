\name{sift.col}
\alias{sift.col}
\title{Retrieve the column from SIFT oject correspoinding to mutated base number}
\usage{
  sift.col(mutbase)
}
\arguments{
  \item{mutbase}{an integer 1, 2, 3 or 4}
}
\value{
  an integer 4, 5, 6 or 7
}
\description{
  function to match the mutated base to the appropriate
  column of \code{exome.SIFT} (1:4, 2:7, 3:6, 4:5)
}
\details{
  see \code{\link{convert.seq.to.num}} for correspondence
  of base letters to numbers and
  \code{\link{mut.type.converter}} for details of the
  structure of \code{exome.SIFT}.
}
\note{
  This internal function is not intended to be called by
  the user.
}

