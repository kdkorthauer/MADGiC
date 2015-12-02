\name{convert.hgnc.to.ensembl}
\alias{convert.hgnc.to.ensembl}
\title{Convert HGNC symbols to Ensembl identifiers using biomaRt}
\usage{
  convert.hgnc.to.ensembl(table, ensembl)
}
\arguments{
  \item{table}{a matrix of MAF data that contains a column
  named "Hugo_Symbol" with the HGNC names}

  \item{ensembl}{an object created by \code{useMart} in the
  \code{biomaRt} package which tells the function which
  version of Ensembl to use}
}
\value{
  a vector of Ensembl identifiers corresponding to the HGNC
  symbols, obtained from \code{biomaRt}.
}
\description{
  This function takes an MAF table and returns a vector of
  Ensembl identifiers corresponding to the HGNC names in
  the "Hugo_Symbol" column.
}
\note{
  This internal function is not intended to be called by
  the user.
}

