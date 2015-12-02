\docType{data}
\name{prior}
\alias{prior}
\title{Prior probabilities that each gene is a passenger}
\format{A vector of length 18,926 where each element corresponds to a gene
  and the name of the element is the Ensembl id.  The numeric value lies
  between 0.5 and 0.99 and represents the prior probability that each gene is
  a passenger.}
\description{
  This data set is a named vector of prior probabilities
  that each gene is a passenger. It was obtained using
  positional data in COSMIC (v66), such that the baseline
  prior probability was set to 0.99 and this probability
  was decreased for genes that showed evidence of either
  tumor suppressor activity (mutations clustering at the
  same amino acid positions) or oncogenic activity (a
  higher proportion of truncating mutations than the
  overall proportion).
}
\keyword{datasets}

