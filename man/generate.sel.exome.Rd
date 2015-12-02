\name{generate.sel.exome}
\alias{generate.sel.exome}
\title{Select the part of exome.constants that belongs to a list of genes}
\usage{
  generate.sel.exome(genelist, gene, exome.constants)
}
\arguments{
  \item{genelist}{a vector containing gene names to subset
  on}

  \item{gene}{a list with one entry for each gene, each
  entry is another list of 5 elements: Ensembl name,
  chromosome, base pairs, replication timing region
  (1=Early, 2=Middle, 3=Late), and expression level (1=Low,
  2=Medium, 3=High).}

  \item{exome.constants}{a list with one entry for each
  chromosome, where each entry is a matrix containing a row
  for each coding base pair and the following columns: 1.
  base pair position, 2. nucleotide number (see
  \code{\link{convert.seq.to.num}}), 3. number of possible
  nonsilent transitions, 4. number of possible nonsilent
  transversions, 5. number of possible silent transitions,
  6. number of possible silent transversions, and 7.
  whether the position is in a CpG dinucleotide.}
}
\value{
  an object of the same structure as
  \code{exome.constants}, but only containing positions
  that reside in the genes of \code{genelist}
}
\description{
  A function to pull only those base pairs that reside
  within a list of genes from the object
  \code{exome.constants}
}
\note{
  This internal function is not intended to be called by
  the user.
}

