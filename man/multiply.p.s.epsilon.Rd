\name{multiply.p.s.epsilon}
\alias{multiply.p.s.epsilon}
\title{Multiply the constants in \code{exome.constants} by the relative rate
  parameters of the background mutation model}
\usage{
  multiply.p.s.epsilon(X, p, s, epsilon, delta, gene)
}
\arguments{
  \item{X}{a list with one entry for each chromosome, where
  each entry is a matrix containing a row for each coding
  base pair and the following columns: 1. base pair
  position, 2. nucleotide number (see
  \code{\link{convert.seq.to.num}}), 3. number of possible
  nonsilent transitions, 4. number of possible nonsilent
  transversions, 5. number of possible silent transitions,
  6. number of possible silent transversions, and 7.
  whether the position is in a CpG dinucleotide.}

  \item{p}{a vector of length 7 containing the mutation
  type relative rate parameters in the following order: A/T
  transition, A/T transversion, non-CpG transition, non-CpG
  transversion, CpG transition, CpG transversion, and
  Indel.}

  \item{s}{a vector of length 3 containing the relative
  rate parameters for the three replication timing regions
  (1=Early, 2=Middle, 3=Late)}

  \item{epsilon}{a vector of length 3 containing the
  relative rate parameters for the three expression levels
  (1=Low, 2=Medium, 3=High)}

  \item{delta}{vector of length 2 where the second element
  represents the relative rate of mutation in olfactory
  receptor (OR) genes compared to all others within a
  similar replication timing and expression level category.
  First element set to 1 (reference category).}

  \item{gene}{a list with one entry for each gene, each
  entry is another list of 5 elements: Ensembl name,
  chromosome, base pairs, replication timing region
  (1=Early, 2=Middle, 3=Late), and expression level (1=Low,
  2=Medium, 3=High).}
}
\value{
  an object of the same structure as exome.constants, but
  columns 3-6 (e, f, c, d) have been multiplied by relative
  rate parameters \code{p}, \code{s}, and \code{epsilon}.
}
\description{
  A function to multiply the constants e, f, c, and d in
  \code{exome.constants} by the relative rate parameters of
  the background mutation model.  The parameters used
  depend on the mutation type, nucleotide context of the
  position, and the replication timing region and
  expression level of the gene that the position resides
  in.
}
\note{
  This internal function is not intended to be called by
  the user.
}

