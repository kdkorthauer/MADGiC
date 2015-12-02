\name{getA}
\alias{getA}
\title{Compute A - the likelihood of a mutation at every position}
\usage{
  getA(nonsil.exclus, sil.exclus, both, p, r, s, epsilon,
    delta, gene)
}
\arguments{
  \item{nonsil.exclus}{oject obtained from
  \code{\link{generate.sel.exome}} representing the
  exclusively nonsilent genes}

  \item{sil.exclus}{oject obtained from
  \code{\link{generate.sel.exome}} representing the
  exclusively silent genes}

  \item{both}{oject obtained from
  \code{\link{generate.sel.exome}} representing the genes
  with nonsilent mutations also used for silent mutation
  detection}

  \item{r}{numeric value representing the relative rate
  parameter estimate for the ratio of mutations in genes
  with nonsilent vs only silent mutations (selection bias)}

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
  a numeric vector containting the likelihood of a mutation
  at every position.
}
\description{
  This function computes the likelihood of a mutation
  occurring at each position in the exome according to the
  background mutation model
}
\note{
  This internal function is not intended to be called by
  the user.
}

