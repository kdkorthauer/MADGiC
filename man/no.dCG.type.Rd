\name{no.dCG.type}
\alias{no.dCG.type}
\title{Get mutation type (1-4) of non-CpG mutations}
\usage{
  no.dCG.type(x)
}
\arguments{
  \item{x}{a character of length two where each character
  is either "A","T","G", or "C".  For example, x could be
  "AG". 12 possible two-letter codes.}
}
\value{
  an integer indicator of mutation type, where 1=transition
  from A/T, 2=transversion from A/T, 3=transition from
  non-CpG C/G and 4=transversion from non-CpG C/G.  For
  example x="AG" would return 1 (for transition).
}
\description{
  Given a sequence of two characters, the function returns
  the type of mutation: transition from A/T (1),
  transversion from A/T (2), transition from non-CpG G/C
  (3), or transversion from non-CpG G/C (4).
}
\details{
  used internally in \code{\link{mut.type.converter}}
}
\note{
  This internal function is not intended to be called by
  the user.
}

