\name{fit.background.model}
\alias{fit.background.model}
\title{Fit background mutation model}
\usage{
  fit.background.model(mutab, nonsil.mut.type.sampl.sum,
    sil.mut.type.sampl.sum, nonsil.type.const,
    sil.type.const, gene)
}
\arguments{
  \item{mutab}{a matrix containing one row per mutation and
  8 columns (Ensembl gene name, chromosome, position,
  variant type (SNP, In_frame, Frame_shift), reference
  allele, tumor allele 1, tumor allele 2, and sample id.}

  \item{nonsil.mut.type.sampl.sum}{a 3 (expression
  category) by 3(replication timing category) by 6
  (mutation type) matrix containing the total number of
  base pairs eligible for a nonsilent mutation in each
  category (2nd item obtained from
  \code{\link{mut.type.converter}})}

  \item{sil.mut.type.sampl.sum}{a 3 (expression category)
  by 3(replication timing category) by 6 (mutation type)
  matrix containing the total number of base pairs eligible
  for a silent mutation in each category (2nd item obtained
  from \code{\link{mut.type.converter}})}

  \item{nonsil.type.const}{list of 3 objects with
  information about nonsilent coding sequences (see
  \code{\link{preprocess.BM}})}

  \item{sil.type.const}{list of 3 objects with information
  about silent coding sequences (see
  \code{\link{preprocess.BM}})}

  \item{gene}{a list with one entry for each gene, each
  entry is another list of 5 elements: Ensembl name,
  chromosome, base pairs, replication timing region
  (1=Early, 2=Middle, 3=Late), and expression level (1=Low,
  2=Medium, 3=High).}
}
\value{
  a list object with four elements: \item{p}{a vector of
  length 7 containing the mutation type relative rate
  parameters in the following order: A/T transition, A/T
  transversion, non-CpG transition, non-CpG transversion,
  CpG transition, CpG transversion, and Indel.}
  \item{r}{numeric value representing the relative rate
  parameter estimate for the ratio of mutations in genes
  with nonsilent vs only silent mutations (selection bias)}
  \item{s}{a vector of length 3 containing the relative
  rate parameters for the three replication timing regions
  (1=Early, 2=Middle, 3=Late)} \item{epsilon}{a vector of
  length containing the relative rate parameters for the
  three expression levels (1=Low, 2=Medium, 3=High)}
  \item{delta}{a vector of length 2 where the second
  element represents the relative rate of mutation in
  olfactory receptor (OR) genes compared to all others
  within a similar replication timing and expression level
  category.  First element set to 1 (reference category).}
}
\description{
  This function calculates the relative rate parameters of
  the background mutation model, estimated by method of
  moments
}
\note{
  This internal function is not intended to be called by
  the user.
}

