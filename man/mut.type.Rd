\name{mut.type}
\alias{mut.type}
\title{Get mutation type (transition or transversion)}
\usage{
  mut.type(x)
}
\arguments{
  \item{x}{a character of length two where each character
  is either "A","T","G", or "C".  For example, x could be
  "AG". 12 possible two-letter codes.}
}
\value{
  an integer indicator of mutation type, where 1=transition
  and 2=transversion.  For example x="AG" would return 1
  (for transition).
}
\description{
  Given a sequence of two characters, the function returns
  whether the mutation is a transition (1) or a
  transversion (2)
}
\details{
  see \code{\link{mut.type.converter}}
}
\note{
  This internal function is not intended to be called by
  the user.
}

