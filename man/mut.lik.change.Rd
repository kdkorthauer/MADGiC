\name{mut.lik.change}
\alias{mut.lik.change}
\title{Calculate change in likelihood due to background mutations}
\usage{
  mut.lik.change(nonsil.mut.type, res, nonsilent, both_log,
    p_inframe, p_frameshift, p, r, s, epsilon, delta, gene)
}
\arguments{
  \item{nonsil.mut.type}{a reformatted mutation table that
  contains an extra two columns: 1. a mutation type
  indicator (1= transition, 2=transversion, and 3=indel),
  2. SIFT score for the mutation.  Second item returned
  from \code{\link{mut.type.converter}}.}

  \item{res}{a gene list obtained from
  \code{\link{generate.sel.exome}} and run through
  \code{\link{multiplyr}} for genes used for nonsilent rate
  estimation}

  \item{nonsilent}{logical value indicating whether genes
  are used for nonsilent rate estimation}

  \item{both_log}{logical value indicating whether genes
  are used for both silent and nonsilent rate estimation}

  \item{p_inframe}{numerical value representing the rate if
  in-frame indel mutations to A/T transitions}

  \item{p_frameshift}{numerical value representing the rate
  if frameshift indel mutations to A/T transitions}

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

  \item{r}{numeric value representing the relative rate
  parameter estimate for the ratio of mutations in genes
  with nonsilent vs only silent mutations (selection bias)}
}
\value{
  a matrix containing the likelihood due to existing
  background mutations, to be utilized in
  \code{\link{calculate.bij}}
}
\description{
  This function calculates the change in likelihood for
  each existing mutation in the reformatted tables obtained
  from \code{\link{mut.type.converter}} given estimates of
  the relative rate parameters from
  \code{\link{fit.background.model}}.
}
\note{
  This internal function is not intended to be called by
  the user.
}

