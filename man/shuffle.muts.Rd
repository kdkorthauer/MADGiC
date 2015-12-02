\name{shuffle.muts}
\alias{shuffle.muts}
\title{Simulate new dataset}
\usage{
  shuffle.muts(N, sil.mutab, nonsil.mutab, exome.constants,
    gene, exome.nonsil, exome.SIFT, SEED = NULL, dir = ".",
    allF = TRUE)
}
\arguments{
  \item{N}{integer number of simulated datasets to create}

  \item{sil.mutab}{a matrix containing one row per silent
  mutation and 8 columns (Ensembl gene name, chromosome,
  position, variant type (SNP, In_frame, Frame_shift),
  reference allele, tumor allele 1, tumor allele 2, and
  sample id.}

  \item{nonsil.mutab}{a matrix containing one row per
  nonsilent mutation and 8 columns (Ensembl gene name,
  chromosome, position, variant type (SNP, In_frame,
  Frame_shift), reference allele, tumor allele 1, tumor
  allele 2, and sample id.}

  \item{exome.nonsil}{list object with one item per
  chromosome where each item contains matrix with one row
  per coding base pair and 7 columns: position, nucleotide,
  CpG context, nonsilent indicator (1=nonsilent, 0=silent)
  for mutation to "A", nonsilent indicator for mutation to
  "C", nonsilent indicator for mutation to "G", and
  nonsilent indicator for mutation to "T".}

  \item{SEED}{random seed for reproducible results}

  \item{dir}{directory path where to save the simulated
  datasets for use in \code{\link{locfdr}}}

  \item{allF}{logical value indicating whether or not the
  sample consists of all females whether or not to shuffle
  the observed mutations over the Y chromosome}

  \item{exome.constants}{a list with one entry for each
  chromosome, where each entry is a matrix containing a row
  for each coding base pair and the following columns: 1.
  base pair position, 2. nucleotide number (see
  \code{\link{convert.seq.to.num}}), 3. number of possible
  nonsilent transitions, 4. number of possible nonsilent
  transversions, 5. number of possible silent transitions,
  6. number of possible silent transversions, and 7.
  whether the position is in a CpG dinucleotide.}

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
  NULL
}
\description{
  Shuffle the observed mutations restricted to same
  mutation type, replication region and expression level
}
\note{
  This internal function is not intended to be called by
  the user.
}

