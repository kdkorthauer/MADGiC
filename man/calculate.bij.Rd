\name{calculate.bij}
\alias{calculate.bij}
\title{Calculate the background mutation probability for every gene/sample
  combination}
\usage{
  calculate.bij(gid, gene, p, s, epsilon, delta,
    exome.constants.mult, sample.name, muttable,
    nonsil.mut.type, a, b, uniqueA, tableA)
}
\arguments{
  \item{gid}{a character vector containing the Ensembl gene
  ids of all genes}

  \item{exome.constants.mult}{an object returned by
  \code{\link{multiply.p.s.epsilon}}}

  \item{sample.name}{a character vector containing the
  names of all samples}

  \item{muttable}{a matrix containing the likelihood due to
  existing background mutations, see
  \code{\link{mut.lik.change}}}

  \item{nonsil.mut.type}{a matrix with one row for every
  observed mutation, with 10 columns in this order:
  Ensemble gene id, chromosome, position, mutation type
  (SNP or In_frame or Frame_shift), reference allele, tumor
  allele 1, tumor allele 2, sample id, mutation type
  (1=transition or 2=transversion), and SIFT score}

  \item{a}{numeric value for the maximum likelihood
  estimate of the hyperparameter a representing the prior
  for q_j (sample-specific mutation rate, q_j~Unif(a,b))}

  \item{b}{numeric value for the maximum likelihood
  estimate of the hyperparameter b representing the prior
  for q_j (sample-specific mutation rate, q_j~Unif(a,b))}

  \item{uniqueA}{a numeric vector containing all unique
  values of A (see \code{\link{getA}})}

  \item{tableA}{a numeric vector of the same length of
  \code{uniqueA} that contains the number of instances of
  each value in \code{uniqueA}}

  \item{gene}{a list with one entry for each gene, each
  entry is another list of 5 elements: Ensembl name,
  chromosome, base pairs, replication timing region
  (1=Early, 2=Middle, 3=Late), and expression level (1=Low,
  2=Medium, 3=High).}

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
}
\value{
  a list with one entry for each gene where each entry
  contains a vector with the probability of mutation for
  each sample
}
\description{
  This function calcuates the empirical Bayes estimate of a
  mutation occurring in every gene and sample according to
  the background mutation model
}
\details{
  the return value is only calculated for genes with two or
  more mutations to save on computation time.
}
\note{
  This internal function is not intended to be called by
  the user.
}

