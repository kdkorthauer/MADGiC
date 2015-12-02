\name{number}
\alias{number}
\title{Convert chromosome names (character) to numeric}
\usage{
  number(x)
}
\arguments{
  \item{x}{a character, one of "1", "2", ..., "24", "X",
  "Y"}
}
\value{
  an integer between 1 and 24.  "X" is converted to 23 and
  "Y" is converted to 24.  All other values just change
  classes from character to numeric ("1" -> 1).
}
\description{
  Function that converts character chromosome names
  (including those using "X" and "Y") to numeric values
  1-24
}
\note{
  This internal function is not intended to be called by
  the user.
}

