\name{get.post.probs}
\alias{get.post.probs}
\title{Main posterior probability calculation}
\usage{
  get.post.probs(maf.file,
    exome.file = system.file("data/exome_36.RData", package = "MADGiC"),
    gene.rep.expr.file = system.file("data/gene.rep.expr.RData", package = "MADGiC"),
    gene.names.file = system.file("data/gene_names.txt", package = "MADGiC"),
    prior.file = system.file("data/prior.RData", package = "MADGiC"),
    alpha = 0.2, beta = 6, N = 20, replication.file = NULL,
    expression.file = NULL)
}
\arguments{
  \item{maf.file}{name of an MAF (Mutation Annotation
  Format) data file containing the somatic mutations.
  Currently, NCBI builds 36 and 37 are supported.}

  \item{exome.file}{name of an .RData file that annotates
  every position of the exome for how many
  transitions/transversions are possible, whether each
  change is silent or nonsilent, and the SIFT scores for
  each possible change}

  \item{gene.rep.expr.file}{name of an .RData file that
  annotates every gene for its Ensembl name, chromosome,
  base pair positions, replication timing region, and
  expression level.}

  \item{gene.names.file}{name of a text file containing the
  Ensembl names of all genes.}

  \item{prior.file}{name of an .RData file containing a
  named vector of prior probabilities that each gene is a
  driver, obtained from positional information in the
  COSMIC database.}

  \item{N}{integer number of simulated datasets to be used
  in the estimation of the null distribution of functional
  impact scores.  The default value is 20 (see
  \code{\link{shuffle.muts}}).}

  \item{expression.file}{(optional) name of a .txt file
  containing gene expression data if user wishes to supply
  one (default is to use an average expression signal of
  the CCLE).  The .txt file should have two columns and no
  header.  The first column should contain the Ensembl Gene
  ID (using Ensembl 54 for hg18) and the second column
  should contain the expression measurements.  These can be
  raw or log-scaled but should be normalized if
  normalization is desired.}

  \item{replication.file}{(optional) name of a .txt file
  containing replication timing data if user wishes to
  supply one (default is to use data from Chen et al.
  (2010)).  The .txt file should have two columns and no
  header.  The first column should contain the Ensembl Gene
  ID (using Ensembl 54 for hg18) and the second column
  should contain the replication timing measurements.}

  \item{alpha}{numeric value of first shape parameter of
  the prior Beta distribution on the probability of
  mutation for driver genes. Default value of 0.2 is chosen
  as a compromise between a cancer type with a relatively
  low mutation rate (Ovarian cancer, fitted value from
  COSMIC of 0.15) and one with a comparatively high
  mutation rate (Squamous cell lung, fitted value from
  COSMIC of 0.27), but results are robust to changes in
  this parameter. Note that intuitively (and empirically),
  a higher mutation rate overall leads to a higher driver
  mutation rate overall - and thus less mass is
  concentrated in the left tail of the distribution.}

  \item{beta}{numeric value of second shape parameter of
  the prior Beta distribution on the probability of
  mutation for driver genes. Default value of 6 is chosen
  as a compromise between a cancer type with a relatively
  low mutation rate (Ovarian cancer, fitted value from
  COSMIC of 6.6) and one with a comparatively high mutation
  rate (Squamous cell lung, fitted value from COSMIC of
  5.83), but results are robust to changes in this
  parameter.  Note that intuitively (and empirically), a
  higher mutation rate overall leads to a higher driver
  mutation rate overall - and thus less mass is
  concentrated in the left tail of the distribution.}
}
\value{
  a named vector of posterior probabilities that each gene
  is a driver
}
\description{
  This function reads in an MAF data file, exome
  annotation, and pre-computed prior information and then
  fits a hierarchical emprical Bayesian model to obtain
  posterior probabilities that each gene is a driver.
}
\details{
  The typical user only need specify the MAF file they wish
  to analyze.  The other fields (exome annotation, gene
  annotation, gene names, and prior probabilities) have
  been precomputed and distributed with this package.
}
\examples{
\dontrun{

# pointer to the MAF file to be analyzed
maf.file <- system.file("data/OV.maf",package="MADGiC")

# calculation of posterior probabilities that each gene is a driver
post.probs <- get.post.probs(maf.file)

# Modify default settings to match TCGA ovarian analysis in paper
post.probs <- get.post.probs(maf.file, N=100, alpha=0.15, beta=6.6)
}
}

