# MADGiC
R Package 'MADGiC' 

To Install:
  
  install.packages("devtools")

devtools::install_github("kdkorthauer/MADGiC")

Note: The package was built on R version 2.15.2

The R package MADGiC fits an empirical Bayesian hierarchical model to obtain posterior probabilities that each gene is a driver.
The model accounts for (1) frequency of mutation compared to a
sophisticated background model that accounts for gene-specific factors in
addition to mutation type and nucleotide context, (2) predicted
functional impact (in the form of SIFT scores) of each specific change,
and (3) positional patterns in mutations that have been
deposited into the COSMIC (Catalogue of Somatic Mutations in Cancer)
database. Example data from the The Cancer Genome Atlas (TCGA) project ovarian cohort is provided.

The latest version of the MADGiC R package has been updated to accommodate MAF files annotated with NCBI build 37 as well as 
user-specified expression and replication timing data.  See 'get.post.probs' function for details.

Earlier versions of the source code can be found <A HREF="https://www.biostat.wisc.edu/~kendzior/MADGiC">here</A>.</p>
