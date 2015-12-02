\name{dCG.type}
\alias{dCG.type}
\title{Get mutation type (5-6) of CpG mutations}
\usage{
  dCG.type(x)
}
\arguments{
  \item{x}{a character of length two where each character
  is either "A","T","G", or "C".  Only the 6 two letter
  codes that begin with "C" or "G" are allowed. For
  example, x could be "CT".}
}
\value{
  an integer indicator of mutation type, where 1=transition
  from CpG C/G and 2=transversion from CpG C/G.  For
  example x="AG" would return 1 (for transition).
}
\description{
  Given a sequence of two characters, the function returns
  the type of mutation: transition from CpG G/C (5), or
  transversion from CpG G/C (6).
}
\details{
  used internally in \code{\link{mut.type.converter}}
}
\note{
  This internal function is not intended to be called by
  the user.
}

