\name{mut.type.converter}
\alias{mut.type.converter}
\title{Get total counts of mutations for each replication timing, expression,
  and mutation type category and reformatted mutation table}
\usage{
  mut.type.converter(mutab, exome.SIFT, seq.in.chrom,
    dCG.in.chrom, gene)
}
\arguments{
  \item{seq.in.chrom}{a list with an item for each
  chromosome that contains a matrix whose first column is
  the position and the second column is the nucleotide of a
  base pair within that chromosomes (first item returned
  from \code{\link{preprocess.BM}})}

  \item{dCG.in.chrom}{a list with an item for each
  chromosome that contains a vector of the position of the
  CpG dinucleotide coding sequences (second item returned
  from \code{\link{preprocess.BM}})}

  \item{mutab}{a matrix containing one row per mutation and
  8 columns (Ensembl gene name, chromosome, position,
  variant type (SNP, In_frame, Frame_shift), reference
  allele, tumor allele 1, tumor allele 2, and sample id.}

  \item{gene}{a list with one entry for each gene, each
  entry is another list of 5 elements: Ensembl name,
  chromosome, base pairs, replication timing region
  (1=Early, 2=Middle, 3=Late), and expression level (1=Low,
  2=Medium, 3=High).}

  \item{exome.SIFT}{list object with one item per
  chromosome where each item contains matrix with one row
  per coding base pair and 7 columns: position, nucleotide,
  CpG context, FI score for mutation to "A", FI score for
  mutation to "C", FI score for mutation to "G", and FI
  score for mutation to "T".}
}
\value{
  a list object with two elements:
  \item{mut.per.type.sum}{a 3 by 3 by 6 matrix with the
  total counts of mutations in each of the 3 replication
  timing regions, 3 expression level categories, and 6
  mutation types (indels counted separately since every
  base pair is at risk for this type of mutation).}
  \item{mutab}{a reformatted mutation table that contains
  an extra two columns: 1. a mutation type indicator (1=
  transition, 2=transversion, and 3=indel), 2. SIFT score
  for the mutation.}
}
\description{
  This function reads in a mutation table and returns the
  total counts of mutations in each of the replication
  timing regions, expression level categories, and mutation
  types. It also returns a reformatted mutation table.
}
\note{
  This internal function is not intended to be called by
  the user.
}

