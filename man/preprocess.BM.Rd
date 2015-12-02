\name{preprocess.BM}
\alias{preprocess.BM}
\title{Pull out sequences, CpG dinucleotide positions, and base pairs at risk
  for mutation subsetted by categories in the background model.}
\usage{
  preprocess.BM(X, gene)
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
  whether the position is in a CpG dinucleotide. May be
  subsetted by a particular gene list (see
  \code{\link{generate.sel.exome}})}

  \item{gene}{a list with one entry for each gene, each
  entry is another list of 5 elements: Ensembl name,
  chromosome, base pairs, replication timing region
  (1=Early, 2=Middle, 3=Late), and expression level (1=Low,
  2=Medium, 3=High).}
}
\value{
  a list with three items: \item{seq.in.chrom}{a list with
  an item for each chromosome that contains a matrix whose
  first column is the position and the second column is the
  nucleotide of a base pair within that chromosomes}
  \item{dCG.in.chrom}{position of the CpG dinucleotide
  coding sequences within chromosomes} \item{type.const}{a
  3 by 12 matrix containing
  E_{1,n,h},F_{2,n,h},E_{3,n,h},F_{4,n,h},E_{5,n,h},F_{6,n,h},
  C_{1,n,h},D_{2,n,h},C_{3,n,h},D_{4,n,h},C_{5,n,h},D_{6,n,h}
  for n=1,2,3, and h=1,2,3}
}
\description{
  A function to gather information about a given gene list
  that will be needed to fit the background mutation model.
  It pulls out the sequence of the genes in the list
  \code{X}, as well as indicates which of the positions
  resides in a CpG dinucleotide pair, and counts how many
  base pairs are at risk for mutation in the 108
  combinations of 6 mutation types x 2 silent/nonsilent
  status x 3 replication timing categories x 3 expression
  level categories.
}
\note{
  This internal function is not intended to be called by
  the user.
}

