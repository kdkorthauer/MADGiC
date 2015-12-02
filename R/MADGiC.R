#' @name exome
#' @title Exome annotation for human genome build NCBI 36/hg18
#' @description This data set contains a list with an item for each chromosome
#'   where each item is a matrix with a row for each position and 15 columns
#'   that contain information about how many of each type of mutation are
#'   possible, what their FI (functional impact, here we use SIFT scores) are,
#'   and whether each type of change is nonsilent. This object is broken down
#'   into 3 objects in the function \code{\link{get.post.probs}}, each containing
#'   columns 1, 2, and 7: \code{exome.constants} (and columns 3-6),
#'   \code{exome.SIFT} (and columns 8:11), and \code{exome.nonsil}
#'   (and columns 12-15).
#' @docType data
#' @usage exome
#' @format Each list item (one per chromosome) contains a matrix with one row
#'   per position and the following 15 columns: 1 - base pair position, 2 -ame
#'   nucleotide (integer representation, see \code{\link{convert.seq.to.num}}),
#'   3 - number of possible nonsilent transitions, 4 - number of possible
#'   nonsilent transversions, 5 - number of possible silent transitions, 6 -
#'   number of possible silent transversions, 7 - indicator of whether position
#'   is in a CpG dinucleotide, 8 - FI score for mutation to "A", 9 -FI score for
#'   mutation to "C", 10 - FI score for mutation to "G", 11 - FI score for 
#'   mutation to "T",  12 - nonsilent indicator (1=nonsilent, 0=silent) for
#'   mutation to "A", 13 - nonsilent indicator for mutation to "C", 14 -
#'   nonsilent indicator for mutation to "G", and 15 - nonsilent indicator for 
#'   mutation to "T".
NULL

#' @name gene_names
#' @title Ensembl names for all genes in the exome
#' @description This data set is a text file that contains all the Ensembl names
#'   of coding genes in build 36.
#' @docType data
#' @usage gene_names
#' @format one Ensembl name per line ("ENSG###########") for 19,238 lines.
#' @source Distributed with code of Youn and Simon 2011.
NULL

#' @name prior
#' @title Prior probabilities that each gene is a passenger
#' @description This data set is a named vector of prior probabilities that each
#'   gene is a passenger. It was obtained using positional data in COSMIC (v66), such
#'   that the baseline prior probability was set to 0.99 and this probability
#'   was decreased for genes that showed evidence of either tumor suppressor
#'   activity (mutations clustering at the same amino acid positions) or
#'   oncogenic activity (a higher proportion of truncating mutations than the
#'   overall proportion).
#' @docType data
#' @usage prior
#' @format A vector of length 18,926 where each element corresponds to a gene
#'   and the name of the element is the Ensembl id.  The numeric value lies
#'   between 0.5 and 0.99 and represents the prior probability that each gene is
#'   a passenger.
NULL

#' @name gene.rep.expr
#' @title Gene annotation list
#' @description This dataset contains a list with an item for each gene (18,926)
#'   that contains information about the basepairs, length, replication timing
#'   and expression level.
#' @docType data
#' @usage gene.rep.expr
#' @format Each gene is a 5 item list: 1. Ensembl ID, 2. chromosome, 3. coding
#'   base pairs, 4. replication timing category (1=Early, 2=Middle, 3=Late), and
#'   5. expression level category (1=Low, 2=Medium, 3=High).
NULL

#' @name OV.maf
#' @title TCGA Ovarian MAF (Mutation Annotation Format) file
#' @description Contains all somatic mutation data from TCGA Ovarian project,
#'   downloaded from the TCGA data portal on October 1, 2013 and collected into
#'   one file
#' @docType data
#' @format See
#'   \url{https://wiki.nci.nih.gov/display/TCGA/Mutation+Annotation+Format+(MAF)+Specification}
#'    for details about MAF files.
NULL

#' @title Main posterior probability calculation
#' @description This function reads in an MAF data file, exome annotation, and
#'   pre-computed prior information and then fits a hierarchical emprical
#'   Bayesian model to obtain posterior probabilities that each gene is a
#'   driver.
#' @details The typical user only need specify the MAF file they wish to
#'   analyze.  The other fields (exome annotation, gene annotation, gene names,
#'   and prior probabilities) have been precomputed and distributed with this
#'   package.
#' @param maf.file name of an MAF (Mutation Annotation Format) data file
#'   containing the somatic mutations.  Currently, NCBI builds 36 and 37 are supported.
#' @param exome.file name of an .RData file that annotates every position of the
#'   exome for how many transitions/transversions are possible, whether each
#'   change is silent or nonsilent, and the SIFT scores for each possible change
#' @param gene.rep.expr.file name of an .RData file that annotates every gene
#'   for its Ensembl name, chromosome, base pair positions, replication timing
#'   region, and expression level.
#' @param gene.names.file name of a text file containing the Ensembl names of
#'   all genes.
#' @param prior.file name of an .RData file containing a named vector of prior
#'   probabilities that each gene is a driver, obtained from positional
#'   information in the COSMIC database.
#' @inheritParams calculate.post.probs
#' @param N integer number of simulated datasets to be used in the estimation of
#'   the null distribution of functional impact scores.  The default value is 20 
#'   (see \code{\link{shuffle.muts}}).
#' @param expression.file (optional) name of a .txt file containing gene expression
#' 	data if user wishes to supply one (default is to use an average expression
#' 	signal of the CCLE).  The .txt file should have two columns and no header.
#' 	The first column should contain the Ensembl Gene ID (using Ensembl 54 for hg18) 
#' 	and the second column should contain the expression measurements.  These can 
#' 	be raw or log-scaled but should be normalized if normalization is desired. 
#' @param replication.file (optional) name of a .txt file containing replication timing
#' 	data if user wishes to supply one (default is to use data from Chen et al. (2010)).
#' 	The .txt file should have two columns and no header.
#' 	The first column should contain the Ensembl Gene ID (using Ensembl 54 for hg18) 
#' 	and the second column should contain the replication timing measurements.  
#' @return a named vector of posterior probabilities that each gene is a driver
#' @import abind biomaRt data.table
#' @examples \dontrun{
#' 
#' # pointer to the MAF file to be analyzed
#' maf.file <- system.file("data/OV.maf",package="MADGiC") 
#' 
#' # calculation of posterior probabilities that each gene is a driver 
#' post.probs <- get.post.probs(maf.file) 
#' 
#' # Modify default settings to match TCGA ovarian analysis in paper  
#' post.probs <- get.post.probs(maf.file, N=100, alpha=0.15, beta=6.6) 
#' }
#' @export
get.post.probs <- function(maf.file, exome.file=system.file("data/exome_36.RData", package="MADGiC"), 
                     gene.rep.expr.file=system.file("data/gene.rep.expr.RData",package="MADGiC"),
                     gene.names.file=system.file("data/gene_names.txt", package="MADGiC"), 
                     prior.file=system.file("data/prior.RData",package="MADGiC"),
                     alpha=0.2, beta=6, N=20, replication.file=NULL, expression.file=NULL) {
  
  maf.table <- read.delim(maf.file, header=TRUE, sep="\t", stringsAsFactors=FALSE)
  for(i in 1:ncol(maf.table))
    maf.table[,i]=as.character(maf.table[,i])
  maf.table=as.matrix(maf.table)
  
  # remove entries with missing chromosome names
  maf.table <- maf.table[!is.na(maf.table[,5]),]
  
  # ensembl version depends on NCBI build
  needs.liftover <- TRUE
  ncbi.version <- as.character(unique(maf.table[,4]))
  ncbi.version <- strsplit(ncbi.version, split=".", fixed=TRUE)
  if (sum(unlist(ncbi.version) > 37) > 0) {stop(paste0("Build ", max(ncbi.version), " not supported at this time.")) }
  if (length(ncbi.version) == 1) {
    ncbi.version <- unlist(ncbi.version)[1]
    if (ncbi.version == 36) { needs.liftover <- FALSE }
  } 
  if (needs.liftover) {
    require(rtracklayer)
    ncbi.version <- unique(unlist(lapply(ncbi.version, function(x) unlist(x)[1])))
    if ("37" %in% ncbi.version) {
      is.37 <- which(maf.table[,4]==37)
      # convert 37 to 36
      chain <- import.chain(system.file("data/hg19ToHg18.over.chain", package="MADGiC"))
      gr <- GRanges(
        seqnames=paste("chr",as.character(maf.table[is.37,5]), sep=""),
        ranges=IRanges(start=as.numeric(as.character(maf.table[is.37,6])), end=as.numeric(as.character(maf.table[is.37,7]))),
        strand=maf.table[is.37,8])
      grnew <- liftOver(gr, chain)
      maf.table[is.37,5] <- substring(as.character(seqnames(grnew)), first=4)
      maf.table[is.37,6] <- as.numeric(start(grnew))
      maf.table[is.37,7] <- as.numeric(end(grnew))
      ncbi.version <- 36
    }
  }
  rm(chain)
  rm(gr)
  rm(grnew)
  rm(is.37)
  
  maf.table <- maf.table[!is.na(maf.table[,5]),]
  nonsilent.maf.table <- maf.table[maf.table[,9] != "Silent",]   ### table of nonsilent mutations
  silent.maf.table <- maf.table[maf.table[,9] == "Silent",]   ### table of nonsilent mutations
  rm(maf.table)
  
  if (ncbi.version == 36) { 
    ens.version <- "may2009.archive.ensembl.org/biomart/martservice/"
    ensembl=useMart("ENSEMBL_MART_ENSEMBL",host=ens.version, dataset = "hsapiens_gene_ensembl") 
  } else {
    stop(paste("build number ", ncbi.version, " not supported", sep=""))
  }
  
  # change coding of indels in nonsilent.maf.table
  type.col <- which(colnames(nonsilent.maf.table)=="Variant_Type")
  class.col <- which(colnames(nonsilent.maf.table)=="Variant_Classification")
  
  which.indels <- which(nonsilent.maf.table[,type.col] %in% c("INS", "DEL"))
  if (length(which.indels)>0) {
    indel.labels <- nonsilent.maf.table[which.indels, class.col]
    if (sum(indel.labels %in% c("Frame_Shift_Del", "Frame_Shift_Ins")) > 0) indel.labels[indel.labels %in% c("Frame_Shift_Del", "Frame_Shift_Ins")] <- "Frame_shift"
    if (sum(indel.labels %in% c("In_Frame_Del", "In_Frame_Ins")) > 0)  indel.labels[indel.labels %in% c("In_Frame_Del", "In_Frame_Ins")] <- "In_frame"
    nonsilent.maf.table[which.indels, type.col] <- indel.labels
  }
  rm(type.col)
  rm(class.col)
  rm(indel.labels)
  
  Extra.type <- which(!(nonsilent.maf.table[,10] %in% c("SNP", "DNP", "TNP", "ONP", "Frame_shift", "In_frame")))
  for (i in 1:length(Extra.type)){
    alleles <- c(nonsilent.maf.table[Extra.type[i],11], nonsilent.maf.table[Extra.type[i], 12],nonsilent.maf.table[Extra.type[i], 13]) 
    maxchar <- max(nchar(alleles))
    if ("-" %in% alleles ) {
      nonsilent.maf.table[Extra.type[i], 10] <- "Frame_shift"
      if (maxchar %% 3 == 0) nonsilent.maf.table[Extra.type[i], 10] <- "In_frame"
    } else{
      nonsilent.maf.table[Extra.type[i], 10] <- "SNP"
      if (maxchar > 1) nonsilent.maf.table[Extra.type[i], 10] <- "DNP"
      if (maxchar > 2) nonsilent.maf.table[Extra.type[i], 10] <- "TNP"
      if (maxchar > 3) nonsilent.maf.table[Extra.type[i], 10] <- "ONP"
    }
  }
  rm(Extra.type)
  rm(alleles)
  rm(maxchar)
  
  # save only what is needed for computations
  silent.mutation.table <- cbind(Ensembl_gene_id=convert.hgnc.to.ensembl(silent.maf.table,ensembl), silent.maf.table[,c(5,6,10:13,16)])
  nonsilent.mutation.table <- cbind(Ensembl_gene_id=convert.hgnc.to.ensembl(nonsilent.maf.table,ensembl), nonsilent.maf.table[,c(5,6,10:13,16)])
  silent.mutation.table <- silent.mutation.table[silent.mutation.table[,2] %in% c(1:24,"X","Y"),]
  nonsilent.mutation.table <- nonsilent.mutation.table[nonsilent.mutation.table[,2] %in% c(1:24,"X","Y"),]
  
  ### number of samples
  S=length(unique(c(silent.mutation.table[,8], nonsilent.mutation.table[,8])))          
  
  # get ensembl ids of all protein-coding genes
  all.gene.name <- as.vector(as.matrix(read.table( gene.names.file, header=FALSE)[,1]));
  
  gene.ptr <- load(gene.rep.expr.file)
  gene.rep.expr <- get(gene.ptr)
  rm(gene.ptr)
  gid <- unlist(sapply(gene.rep.expr, function(x) x[[1]]))
  
  exome.ptr <- load(exome.file)
  exome <- get(exome.ptr)
  rm(exome.ptr)
  exome.constants <- exome.SIFT <- exome.nonsil <- exome
  for(i in 1:length(exome)){
    exome.constants[[i]] <- exome[[i]][,1:7]
    exome.SIFT[[i]] <- exome[[i]][,c(1,2,7:11)]
    exome.nonsil[[i]] <- exome[[i]][,c(1,2,7,12:15)]
  }
  rm(exome)
  
  if(length(expression.file)>0){
    print(paste0("Loading expression file ", expression.file))
    expression <- read.table(expression.file, header=FALSE, stringsAsFactors=FALSE)
    colnames(expression) <- c("gid", "ex")
    matching <- sum(expression$gid %in% gid)
    print(paste0("Found ", matching, " genes with expression data"))
    
    # reorder to match gid object
    x <- match(gid, expression$gid)
    x <- x[!is.na(x)]
    expression <- expression[x,]
    
    # find tertiles of expression
    cutoffs <- quantile(expression$ex, c(0.333,0.666), na.rm=T)
    expression$cat <- 1
    expression$cat[expression$ex > cutoffs[1] & expression$ex < cutoffs[2]] <- 2
    expression$cat[expression$ex > cutoffs[2]] <- 3

    for (j in 1:length(exome.constants)){
    	on.chr <- unlist(lapply(gene.rep.expr, function(x) x[[2]]==j))  # pull out all genes on chrom i
    	gene.chr <- gene.rep.expr[on.chr]
    	names <- unlist(lapply(gene.chr, function(x) x[[1]])) 
    	x <- match(names, expression$gid)

    	if(!is.null(gene.chr)) {
      		cat <- expression$cat[x]
      		gene.chr <- lapply(1:length(gene.chr), function(i) list(gene.chr[[i]][[1]], gene.chr[[i]][[2]], gene.chr[[i]][[3]], 
                                                              gene.chr[[i]][[4]], cat[i], gene.chr[[i]][[6]] ))
    	}
   	gene.rep.expr[on.chr] <- gene.chr
   	}
  }
    
  if(length(replication.file)>0){
    print(paste0("Loading replication timing file ", replication.file))
    replication <- read.table(replication.file, header=FALSE, stringsAsFactors=FALSE)
    colnames(replication) <- c("gid", "repl")
    matching <- sum(replication$repl %in% gid)
    print(paste0("Found ", matching, " genes with replication timing data"))
    
    # reorder to match gid object
    x <- match(gid, replication$gid)
    x <- x[!is.na(x)]
    replication <- replication[x,]
    
    # find tertiles of replication
    cutoffs <- quantile(replication$repl, c(0.333,0.666), na.rm=T)
    replication$cat <- 1
    replication$cat[replication$repl > cutoffs[1] & replication$repl < cutoffs[2]] <- 2
    replication$cat[replication$repl > cutoffs[2]] <- 3

    for (j in 1:length(exome.constants)){
    	on.chr <- unlist(lapply(gene.rep.expr, function(x) x[[2]]==j))  # pull out all genes on chrom i
    	gene.chr <- gene.rep.expr[on.chr]
    	names <- unlist(lapply(gene.chr, function(x) x[[1]])) 
    	x <- match(names, expression$gid)

    	if(!is.null(gene.chr)) {
      		cat <- replication$cat[x]
      		gene.chr <- lapply(1:length(gene.chr), function(i) list(gene.chr[[i]][[1]], gene.chr[[i]][[2]], gene.chr[[i]][[3]], 
                                                              cat[i], gene.chr[[i]][[5]] , gene.chr[[i]][[6]] ))
    	}
   	gene.rep.expr[on.chr] <- gene.chr
   	}
  }
  
  nosam= 1:length(gid)
  for(i in 1:length(gid) )
    nosam[i]= sum(as.character(nonsilent.mutation.table[,1])==gid[i], na.rm=T)
  
  nonsilent_passenger_gene=gid[nosam<=1]     ### names of genes having at most one nonsilent mutations
  rm(nosam)
  
  res=generate.sel.exome(nonsilent_passenger_gene,  gene.rep.expr,  exome.constants)   ### sequence of genes having at most one nonsilent mutatons
  nonsil.type.const=preprocess.BM(res, gene.rep.expr)
  rm(res)
  
  all.gene.name=as.matrix(all.gene.name)         ### names of genes used for detecting silent mutations
  sil.type.const=preprocess.BM(exome.constants, gene.rep.expr)  ### sequence of genes used for silent mutation detection - exome.constants
  
  nonsilent_passenger_exclusive_gene= nonsilent_passenger_gene[ !(nonsilent_passenger_gene %in% all.gene.name )  ]
  silent_exclusive_gene= all.gene.name[ !(all.gene.name %in% nonsilent_passenger_gene )  ]
  both_gene= nonsilent_passenger_gene[ nonsilent_passenger_gene %in% all.gene.name   ]
  
  rm(all.gene.name)
  
  nonsil.mutab=nonsilent.mutation.table
  sil.mutab= silent.mutation.table
  
  # get N simulated (null) datasets 
  system("mkdir ./simulated")
  shuffle.muts(N, sil.mutab, nonsil.mutab, exome.constants, gene.rep.expr, exome.nonsil, exome.SIFT, SEED=889, 
               dir="./simulated", allF=TRUE)
  rm(exome.nonsil)
  
  ##### calculate p_{7},p_{8}  ##########################################################################################################
  x=nonsil.mutab[!is.na(match(nonsil.mutab[,1],nonsilent_passenger_gene)),4]
  p_inframe=sum(x=="In_frame")/(sum(x=="In_frame")+ sum(x=="Frame_shift") )
  p_frameshift=sum(x=="Frame_shift")/(sum(x=="In_frame")+ sum(x=="Frame_shift") )
  if(p_inframe==0 | p_frameshift==0 | sum(x=="In_frame")+ sum(x=="Frame_shift") <=5 )
  {
    p_inframe= 1/3
    p_frameshift= 2/3
  }
  rm(x)
  rm(nonsilent.mutation.table)
  #####  calculate p_{i}, i=1,2...,6 and selection bias r ##############################################################################
  
  temp1 <- mut.type.converter(nonsil.mutab, exome.SIFT, nonsil.type.const[[1]], nonsil.type.const[[2]], gene.rep.expr)
  nonsil.mut.type.sampl.sum <-temp1[[1]]
  nonsil.mut.type <- temp1[[2]]
  rm(temp1)
  
  rm(silent.mutation.table)
  temp2 <- mut.type.converter(sil.mutab, exome.SIFT, sil.type.const[[1]], sil.type.const[[2]], gene.rep.expr)
  sil.mut.type.sampl.sum <- temp2[[1]]
  sil.mut.type <- temp2[[2]]
  rm(temp2)
  
  # now *.mut.type.sampl.sum has a third dimension for the three expression categories
  temp=  fit.background.model(nonsil.mutab, nonsil.mut.type.sampl.sum, sil.mut.type.sampl.sum, nonsil.type.const, sil.type.const, gene.rep.expr)
  p=temp[[1]]
  r=temp[[2]]  #selection bias
  s=temp[[3]]  # rep timing
  epsilon=temp[[4]] # expression
  delta=temp[[5]]  # OR genes
  rm(temp)
  
  ##### Calculating the likelihood of background mutations #############################################################################
  
  exome.constants.mult=multiply.p.s.epsilon(exome.constants,p,s,epsilon, delta,gene.rep.expr)  # replace e_{k},f_{k},c_{k},d_{k} with (e_{k}*p_{t_{k}}, f_{k}*p_{v_{k}}, c_{k}*p_{t_{k}}, d_{k}*p_{v_{k}})*s_{k}
  rm(exome.constants)
  
  res=generate.sel.exome(nonsilent_passenger_exclusive_gene, gene.rep.expr, exome.constants.mult)
  nonsil.exclus=multiplyr(res,r)
  
  sil.exclus=generate.sel.exome(silent_exclusive_gene,gene.rep.expr,exome.constants.mult)
  
  res=generate.sel.exome(both_gene,gene.rep.expr,exome.constants.mult)
  both=multiplyr(res,r)
  
  a= mut.lik.change(nonsil.mut.type,nonsil.exclus,TRUE,FALSE,p_inframe,p_frameshift,p,r,s,epsilon,delta, gene.rep.expr)
  b= mut.lik.change(nonsil.mut.type,both,TRUE,TRUE,p_inframe,p_frameshift,p,r,s,epsilon,delta,gene.rep.expr)
  c= mut.lik.change(sil.mut.type,sil.exclus,FALSE,FALSE,p_inframe,p_frameshift,p,r,s,epsilon,delta,gene.rep.expr)
  d= mut.lik.change(sil.mut.type,both,FALSE,TRUE,p_inframe,p_frameshift,p,r,s,epsilon,delta,gene.rep.expr)
  
  B= rbind(a,b,c,d)
  B=B[B[,2]!="0",]
  muttable=B       ###  the change of the likelihood due to existing background mutations
  rm(B)
  rm(a)
  rm(b)
  rm(c)
  rm(d)
  
  A <- getA(nonsil.exclus, sil.exclus, both, p, r, s, epsilon, delta, gene.rep.expr)
  A <- signif(A,digits=14)
  rm(nonsil.exclus)
  rm(sil.exclus)
  rm(both)
  uniqueA=unique(A)
  tableA=as.vector(table(A))    ###  the likelihood of no background mutations
  rm(A)
  ####### find the parameter a,b of the prior of q_i by maximizing the marginal likelihood over (a,b) ###################################
  
  y= try(optim(c(-25,-20),find.prior.param,muttable=muttable,uniqueA=uniqueA,tableA=tableA,S=S), silent=TRUE)
  if(class(y) == "try-error"){ y= optim(c(-20,-10),find.prior.param,muttable=muttable,uniqueA=uniqueA,tableA=tableA,S=S) }
  a=y$par[1]
  b=y$par[2]
  
  
  ######################################################################################################################################
  
  sample.name=unique(c(sil.mutab[,8],nonsil.mutab[,8]))     ### sample id
  if(S>length(sample.name))
    sample.name=c(sample.name,1:(S-length(sample.name)))
  
  ##### estimate f0,f1 ###############################################################################################################################
  
  temp<-locfdr(nonsil.mutab, exome.SIFT, dir="./simulated", N)
  f0 <- temp[[1]]
  f1 <- temp[[2]]
  nbins <- temp[[3]]
  rm(temp)
  
  ##### calculate bij  ##########################################################################################################3
  
   
  bij <- calculate.bij( gid, gene.rep.expr, p, s, epsilon, delta, exome.constants.mult, sample.name,muttable,nonsil.mut.type,a,b,uniqueA,tableA)


  rm(exome.constants.mult)

  load(prior.file)
  x <- match(gid,names(prior))
  prior <- prior[x]
  
  pp <- calculate.post.probs(bij, sample.name, nonsil.mut.type, gid, exome.SIFT, 
	                             f0, f1, alpha=alpha, beta=beta, p0=prior)
  system("rm -r ./simulated")
  
  return(pp)
}

#' @title Convert nucleotide sequence to numbers
#' @description This function converts nucleotide sequence to numbers for the 
#'   efficiency of calculation
#' @param x a character vector containing any number of "A", "T", "G", and "C".
#' @return a vector of integers where 1 corresponds to "A", 2 corresponds to 
#'   "T", 3 corresponds to "G", and 4 corresponds to "C".  A 0 is put in place 
#'   of characters that are missing or not one of the four nucleotides.
#' @note This internal function is not intended to be called by the user.
convert.seq.to.num<-function(x)
{
  y=rep(0,length(x))
  y[x=="A"]=1
  y[x=="T"]=2
  y[x=="G"]=3
  y[x=="C"]=4
  return(y)
}

#' @title Select the part of exome.constants that belongs to a list of genes
#' @description A function to pull only those base pairs that reside within a 
#'   list of genes from the object \code{exome.constants}
#' @param genelist a vector containing gene names to subset on
#' @param gene a list with one entry for each gene, each entry is another list 
#'   of 5 elements: Ensembl name, chromosome, base pairs, replication timing 
#'   region (1=Early, 2=Middle, 3=Late), and expression level (1=Low, 2=Medium, 
#'   3=High).
#' @param exome.constants a list with one entry for each chromosome, where each 
#'   entry is a matrix containing a row for each coding base pair and the 
#'   following columns: 1. base pair position, 2. nucleotide number (see 
#'   \code{\link{convert.seq.to.num}}), 3. number of possible nonsilent 
#'   transitions, 4. number of possible nonsilent transversions, 5. number of 
#'   possible silent transitions, 6. number of possible silent transversions, 
#'   and 7. whether the position is in a CpG dinucleotide.
#' @return an object of the same structure as \code{exome.constants}, but only 
#'   containing positions that reside in the genes of \code{genelist}
#' @note This internal function is not intended to be called by the user.
generate.sel.exome<-function(genelist, gene, exome.constants)
{
  res<-sel.exome<-vector("list",24)
  if(length(genelist)>0)
  {
    for(i in 1:length(gene))
      if(sum(gene[[i]][[1]]==genelist,na.rm=T)>0)
        res[[ gene[[i]][[2]] ]]= c( res[[ gene[[i]][[2]] ]], gene[[i]][[3]])
    
    for(i in 1:length(res))
      if(length(res[[i]])>0)
      {
        x=match( sort(unique(res[[i]])), exome.constants[[i]][,1] )
        sel.exome[[i]]=exome.constants[[i]][x,]
      }
  }
  return(sel.exome)
}


#' @title Multiply the constants in \code{exome.constants} by the relative rate 
#'   parameters of the background mutation model
#' @description A function to multiply the constants e, f, c, and d in 
#'   \code{exome.constants} by the relative rate parameters of the background 
#'   mutation model.  The parameters used depend on the mutation type, 
#'   nucleotide context of the position, and the replication timing region and 
#'   expression level of the gene that the position resides in.
#' @param X a list with one entry for each chromosome, where each entry is a 
#'   matrix containing a row for each coding base pair and the following 
#'   columns: 1. base pair position, 2. nucleotide number (see 
#'   \code{\link{convert.seq.to.num}}), 3. number of possible nonsilent 
#'   transitions, 4. number of possible nonsilent transversions, 5. number of 
#'   possible silent transitions, 6. number of possible silent transversions, 
#'   and 7. whether the position is in a CpG dinucleotide.
#' @param p a vector of length 7 containing the mutation type relative rate 
#'   parameters in the following order: A/T transition, A/T transversion, 
#'   non-CpG transition, non-CpG transversion, CpG transition, CpG transversion,
#'   and Indel.
#' @param s a vector of length 3 containing the relative rate parameters for the
#'   three replication timing regions (1=Early, 2=Middle, 3=Late)
#' @param epsilon a vector of length 3 containing the relative rate parameters 
#'   for the three expression levels (1=Low, 2=Medium, 3=High)
#' @param delta vector of length 2 where the second element represents the relative rate of mutation
#'   in olfactory receptor (OR) genes compared to all others within a similar 
#'   replication timing and expression level category.  First element set to 1 (reference category).
#' @param gene a list with one entry for each gene, each entry is another list 
#'   of 5 elements: Ensembl name, chromosome, base pairs, replication timing 
#'   region (1=Early, 2=Middle, 3=Late), and expression level (1=Low, 2=Medium, 
#'   3=High).
#' @return an object of the same structure as exome.constants, but columns 3-6 (e, 
#'   f, c, d) have been multiplied by relative rate parameters \code{p}, 
#'   \code{s}, and \code{epsilon}.
#' @note This internal function is not intended to be called by the user.
### multiply the estimated p_{t_{k}},p_{v_{k}} and s_{k} to e_{k},f_{k},c_{k},d_{k}
multiply.p.s.epsilon<-function(X,p,s,epsilon,delta,gene){  
  
  for(i in 1:24){
    if(!is.null(X[[i]])){
      res=  X[[i]]
      totalmat=matrix(res[,3:6] ,ncol=4)  ### e, f, c, d
      dCG=as.logical(res[,7])       ### position of the nucleotide C or G within dCG
      
      AT = which(res[,2]<=2 )       ### position of the nucleotide A or T
      CG = which(res[,2]>2 )
      x= CG %in% which(dCG)
      oCG= CG[!x]                   ### position of the nucleotide C or G within non dCG
      dCG <- which(dCG)
      
      on.chr <- unlist(lapply(gene, function(x) x[[2]]==i))  # pull out all genes on chrom i
      gene.chr <- gene[on.chr]
      
      allsites <- NULL
      for (n in 1:3){  # loop over replication regions
        # missing expression
        for (d in 1:3){
          me  <- unlist(lapply(gene.chr, function(x) if( !is.na(x[[4]]) & is.na(x[[5]]) & !is.na(x[[6]]) ) {if(x[[4]]==n & x[[6]]==d){x[[3]]}} ))  
          pos.me <- match(me, res[,1])
          allsites <- c(allsites,pos.me)
          
          ATpos.me <- AT[AT %in% pos.me];
          oCGpos.me <- oCG[oCG %in% pos.me]
          dCGpos.me <- dCG[dCG %in% pos.me]  # ignore expression since it is missing
          
          totalmat[ ATpos.me , ]=cbind( totalmat[ATpos.me,1]*p[1] ,totalmat[ATpos.me,2]*p[2] ,    totalmat[ATpos.me,3]*p[1] ,totalmat[ATpos.me,4]*p[2] )*s[n]*delta[d]
          totalmat[oCGpos.me, ]=cbind( totalmat[oCGpos.me,1]*p[3],totalmat[oCGpos.me,2]*p[4] ,    totalmat[oCGpos.me,3]*p[3] ,totalmat[oCGpos.me,4]*p[4])*s[n]*delta[d]
          totalmat[dCGpos.me , ]=cbind( totalmat[dCGpos.me,1]*p[5] ,totalmat[dCGpos.me,2]*p[6] ,    totalmat[dCGpos.me,3]*p[5] ,totalmat[dCGpos.me,4]*p[6])*s[n]*delta[d]
        }
        
        #missing expression AND or
        me  <- unlist(lapply(gene.chr, function(x) if( !is.na(x[[4]]) & is.na(x[[5]]) & is.na(x[[6]]) ) {if(x[[4]]==n){x[[3]]}} ))  # missing expression
        pos.me <- match(me, res[,1])
        allsites <- c(allsites,pos.me)
        
        ATpos.me <- AT[AT %in% pos.me];
        oCGpos.me <- oCG[oCG %in% pos.me]
        dCGpos.me <- dCG[dCG %in% pos.me]  # ignore expression since it is missing
        
        totalmat[ ATpos.me , ]=cbind( totalmat[ATpos.me,1]*p[1] ,totalmat[ATpos.me,2]*p[2] ,    totalmat[ATpos.me,3]*p[1] ,totalmat[ATpos.me,4]*p[2] )*s[n]
        totalmat[oCGpos.me, ]=cbind( totalmat[oCGpos.me,1]*p[3],totalmat[oCGpos.me,2]*p[4] ,    totalmat[oCGpos.me,3]*p[3] ,totalmat[oCGpos.me,4]*p[4])*s[n]
        totalmat[dCGpos.me , ]=cbind( totalmat[dCGpos.me,1]*p[5] ,totalmat[dCGpos.me,2]*p[6] ,    totalmat[dCGpos.me,3]*p[5] ,totalmat[dCGpos.me,4]*p[6])*s[n]
        
        for (h in 1:3){  # loop over expression categories
          if (n == 1){
            # missing rep timing cat
            for (d in 1:3){
              mr <- unlist(lapply(gene.chr, function(x) if( !is.na(x[[5]]) & is.na(x[[4]]) & !is.na(x[[6]])) {if(x[[5]]==h & x[[6]]==d){x[[3]]}} ))  # missing rep timing so ignore it	
              pos.mr <- match(mr, res[,1])
              allsites <- c(allsites, pos.mr)   
              
              ATpos.mr <- AT[AT %in% pos.mr]
              oCGpos.mr <- oCG[oCG %in% pos.mr];
              dCGpos.mr <- dCG[dCG %in% pos.mr]; 
              
              totalmat[ ATpos.mr , ]=cbind( totalmat[ATpos.mr,1]*p[1] ,totalmat[ATpos.mr,2]*p[2] ,    totalmat[ATpos.mr,3]*p[1] ,totalmat[ATpos.mr,4]*p[2] )*epsilon[h]*delta[d]
              totalmat[oCGpos.mr, ]=cbind( totalmat[oCGpos.mr,1]*p[3],totalmat[oCGpos.mr,2]*p[4] ,    totalmat[oCGpos.mr,3]*p[3] ,totalmat[oCGpos.mr,4]*p[4])*epsilon[h]*delta[d]
              totalmat[dCGpos.mr , ]=cbind( totalmat[dCGpos.mr,1]*p[5] ,totalmat[dCGpos.mr,2]*p[6] ,    totalmat[dCGpos.mr,3]*p[5] ,totalmat[dCGpos.mr,4]*p[6])*epsilon[h]*delta[d]
            }
            
            # missing rep timing cat AND or
            mr <- unlist(lapply(gene.chr, function(x) if( !is.na(x[[5]]) & is.na(x[[4]]) & is.na(x[[6]])) {if(x[[5]]==h){x[[3]]}} ))  # missing rep timing so ignore it	
            pos.mr <- match(mr, res[,1])
            allsites <- c(allsites, pos.mr)   
            
            ATpos.mr <- AT[AT %in% pos.mr]
            oCGpos.mr <- oCG[oCG %in% pos.mr];
            dCGpos.mr <- dCG[dCG %in% pos.mr]; 
            
            totalmat[ ATpos.mr , ]=cbind( totalmat[ATpos.mr,1]*p[1] ,totalmat[ATpos.mr,2]*p[2] ,    totalmat[ATpos.mr,3]*p[1] ,totalmat[ATpos.mr,4]*p[2] )*epsilon[h]
            totalmat[oCGpos.mr, ]=cbind( totalmat[oCGpos.mr,1]*p[3],totalmat[oCGpos.mr,2]*p[4] ,    totalmat[oCGpos.mr,3]*p[3] ,totalmat[oCGpos.mr,4]*p[4])*epsilon[h]
            totalmat[dCGpos.mr , ]=cbind( totalmat[dCGpos.mr,1]*p[5] ,totalmat[dCGpos.mr,2]*p[6] ,    totalmat[dCGpos.mr,3]*p[5] ,totalmat[dCGpos.mr,4]*p[6])*epsilon[h]
          }
          
          # missing only or
          bps <- unlist(lapply(gene.chr, function(x) if( !is.na(x[[4]]) & !is.na(x[[5]]) & is.na(x[[6]]) ){if(x[[4]]==n & x[[5]]==h){x[[3]]}} )) 
          pos <- match(bps, res[,1])
          allsites <- c(allsites, pos)        	
          
          ATpos <- AT[AT %in% pos]
          oCGpos <- oCG[oCG %in% pos]
          dCGpos <- dCG[dCG %in% pos]
          
          totalmat[ ATpos , ]=cbind( totalmat[ATpos,1]*p[1] ,totalmat[ATpos,2]*p[2] ,    totalmat[ATpos,3]*p[1] ,totalmat[ATpos,4]*p[2] )*s[n]*epsilon[h]
          totalmat[oCGpos , ]=cbind( totalmat[oCGpos,1]*p[3],totalmat[oCGpos,2]*p[4] ,    totalmat[oCGpos,3]*p[3] ,totalmat[oCGpos,4]*p[4])*s[n]*epsilon[h]
          totalmat[dCGpos , ]=cbind( totalmat[dCGpos,1]*p[5] ,totalmat[dCGpos,2]*p[6] ,    totalmat[dCGpos,3]*p[5] ,totalmat[dCGpos,4]*p[6])*s[n]*epsilon[h]
          
          # not missing any factors
          for (d in 1:3){
            bps <- unlist(lapply(gene.chr, function(x) if( sum(c(is.na(x[[4]]), is.na(x[[5]]), is.na(x[[6]])))==0){if(x[[4]]==n & x[[5]]==h & x[[6]]==d){x[[3]]}} )) 
            pos <- match(bps, res[,1])
            allsites <- c(allsites, pos)        	
            
            ATpos <- AT[AT %in% pos]
            oCGpos <- oCG[oCG %in% pos]
            dCGpos <- dCG[dCG %in% pos]
            
            totalmat[ ATpos , ]=cbind( totalmat[ATpos,1]*p[1] ,totalmat[ATpos,2]*p[2] ,    totalmat[ATpos,3]*p[1] ,totalmat[ATpos,4]*p[2] )*s[n]*epsilon[h]*delta[d]
            totalmat[oCGpos , ]=cbind( totalmat[oCGpos,1]*p[3],totalmat[oCGpos,2]*p[4] ,    totalmat[oCGpos,3]*p[3] ,totalmat[oCGpos,4]*p[4])*s[n]*epsilon[h]*delta[d]
            totalmat[dCGpos , ]=cbind( totalmat[dCGpos,1]*p[5] ,totalmat[dCGpos,2]*p[6] ,    totalmat[dCGpos,3]*p[5] ,totalmat[dCGpos,4]*p[6])*s[n]*epsilon[h]*delta[d]
          }
        }
      }
      
      # Rep timing and Expr missing
      for (d in 1:3){
        me  <- unlist(lapply(gene.chr, function(x) if( is.na(x[[4]]) & is.na(x[[5]]) & !is.na(x[[6]]) ) {if(x[[6]]==d){x[[3]]}} ))  # missing expression
        pos.me <- match(me, res[,1])
        allsites <- c(allsites,pos.me)
        
        ATpos.me <- AT[AT %in% pos.me];
        oCGpos.me <- oCG[oCG %in% pos.me]
        dCGpos.me <- dCG[dCG %in% pos.me]  # ignore expression since it is missing
        
        totalmat[ ATpos.me , ]=cbind( totalmat[ATpos.me,1]*p[1] ,totalmat[ATpos.me,2]*p[2] ,    totalmat[ATpos.me,3]*p[1] ,totalmat[ATpos.me,4]*p[2] )*delta[d]
        totalmat[oCGpos.me, ]=cbind( totalmat[oCGpos.me,1]*p[3],totalmat[oCGpos.me,2]*p[4] ,    totalmat[oCGpos.me,3]*p[3] ,totalmat[oCGpos.me,4]*p[4])*delta[d]
        totalmat[dCGpos.me , ]=cbind( totalmat[dCGpos.me,1]*p[5] ,totalmat[dCGpos.me,2]*p[6] ,    totalmat[dCGpos.me,3]*p[5] ,totalmat[dCGpos.me,4]*p[6])*delta[d]
      }
      
      #where ALL missing, ignore s and epsilon and delta
      ATn <- AT[!(AT %in% allsites)]
      oCGn <- oCG[!(oCG %in% allsites)]
      dCGn <- dCG[!(dCG %in% allsites)]	  
      
      totalmat[ ATn , ]=cbind( totalmat[ATn,1]*p[1] ,totalmat[ATn,2]*p[2] ,    totalmat[ATn,3]*p[1] ,totalmat[ATn,4]*p[2] ) 
      totalmat[oCGn , ]=cbind( totalmat[oCGn,1]*p[3],totalmat[oCGn,2]*p[4] ,    totalmat[oCGn,3]*p[3] ,totalmat[oCGn,4]*p[4]) 
      totalmat[dCGn , ]=cbind( totalmat[dCGn,1]*p[5] ,totalmat[dCGn,2]*p[6] ,    totalmat[dCGn,3]*p[5] ,totalmat[dCGn,4]*p[6]) 
      
      res[,3:6]=totalmat
      X[[i]]=res[,-7]
    }
  }
  
  return(X)
}


#' @title Pull out sequences, CpG dinucleotide positions, and base pairs at risk
#'   for mutation subsetted by categories in the background model.
#' @description A function to gather information about a given gene list that 
#'   will be needed to fit the background mutation model.  It pulls out the
#'   sequence of the genes in the list \code{X}, as well as indicates which of
#'   the positions resides in a CpG dinucleotide pair, and counts how many base
#'   pairs are at risk for mutation in the 108 combinations of 6 mutation types
#'   x 2 silent/nonsilent status x 3 replication timing categories x 3
#'   expression level categories.
#' @inheritParams multiply.p.s.epsilon
#' @param X a list with one entry for each chromosome, where each entry is a 
#'   matrix containing a row for each coding base pair and the following 
#'   columns: 1. base pair position, 2. nucleotide number (see 
#'   \code{\link{convert.seq.to.num}}), 3. number of possible nonsilent 
#'   transitions, 4. number of possible nonsilent transversions, 5. number of 
#'   possible silent transitions, 6. number of possible silent transversions, 
#'   and 7. whether the position is in a CpG dinucleotide. May be subsetted by a
#'   particular gene list (see \code{\link{generate.sel.exome}})
#' @return a list with three items: \item{seq.in.chrom}{a list with an item for 
#'   each chromosome that contains a matrix whose first column is the position 
#'   and the second column is the nucleotide of a base pair within that 
#'   chromosomes} \item{dCG.in.chrom}{position of the CpG dinucleotide coding 
#'   sequences within chromosomes} \item{type.const}{a 3 by 12 matrix containing
#'   E_{1,n,h},F_{2,n,h},E_{3,n,h},F_{4,n,h},E_{5,n,h},F_{6,n,h}, 
#'   C_{1,n,h},D_{2,n,h},C_{3,n,h},D_{4,n,h},C_{5,n,h},D_{6,n,h} for n=1,2,3, 
#'   and h=1,2,3}
#' @note This internal function is not intended to be called by the user.
preprocess.BM<-function(X, gene)
{
  type.const = rbind(rep(0,12), rep(0,12), rep(0,12))    
  type.const <- abind(type.const, type.const, type.const, along=3) ###  E_{1,n,h},F_{2,n,h},E_{3,n,h},F_{4,n,h},E_{5,n,h},F_{6,n,h}, C_{1,n,h},D_{2,n,h},C_{3,n,h},D_{4,n,h},C_{5,n,h},D_{6,n,h} for n=1,2,3, h=1,2,3
  type.const <- abind(type.const, type.const, along=4) # or = 1 or 2
  seq.in.chrom = res<-vector("list",24)     ###  matrix whose first column is the position and the second column is the nucleotide of a base pair within chromosomes
  dCG.in.chrom =  res<-vector("list",24)    ###  position of the dCG of coding sequences within chromosomes
  
  for(i in 1:24)
  {
    if(!is.null(X[[i]]))
    {
      res=  X[[i]]
      on.chr <- unlist(lapply(gene, function(x) x[[2]]==i))  # pull out all genes on chrom i
      gene.chr <- gene[on.chr]
      
      totalmat=matrix(res[,3:6] ,ncol=4)
      dCG=which(res[,7]==1)             ### position of the nucleotide C or G within dCG
      
      
      AT = which(res[,2]<=2)             ### position of the nucleotide A or T
      CG = which(res[,2]>2)         ### position of the nucleotide C or G
      x= CG %in% dCG
      oCG= CG[!x]                        ### position of the nucleotide C or G within non dCG
      
      for (s in 1:3){  # loop over replication regions
        for (h in 1:3){  # loop over expression categories
          for (d in 1:2){ # loop over or categories
            bps <- unlist(lapply(gene.chr, function(x) if( sum(c(is.na(x[[4]]), is.na(x[[5]]), is.na(x[[6]])))==0){if(x[[4]]==s & x[[5]]==h & x[[6]]==d){x[[3]]}} )) 
            pos <- match(bps, res[,1])
            
            a <- b <- c <- rep(0, 4)
            if ((length(pos)-sum(is.na(pos)))>0){ 
              if (sum(AT %in% pos)>0){
                a= colSums(matrix( totalmat[AT[AT %in% pos],],nrow=length(AT[AT %in% pos])) )  ### A or T to all other nucleotides
              }
              if (sum(oCG %in% pos)>0){
                b= colSums(matrix( totalmat[oCG[oCG %in% pos],],nrow=length(oCG[oCG %in% pos]))) ### G or C to all other nucleotides, at nonCpG
              }
              if (sum(dCG %in% pos)>0){
                c= colSums(matrix(totalmat[dCG[dCG %in% pos],],nrow=length(dCG[dCG %in% pos])) ) ### G or C to all other nucleotides, at CpG
              }}
            
            type.const[s,,h,d] =  type.const[s,,h,d] + c( a[1:2],b[1:2],c[1:2],a[3:4],b[3:4],c[3:4] )
          }
        }
      }
      seq.in.chrom[[i]]=res[,1:2]
      dCG.in.chrom[[i]]=res[dCG,1]
    }
  }
  return(list(seq.in.chrom, dCG.in.chrom, type.const))
  ###  return a list of
  ###  a matrix whose first column is the position and the second column is the nucleotide per chromosome
  ###  a vector of position of the dCG in the sequence per chromosome
  ###  a matrix consiting of per chromosome E_1nh,F_2nh,E_3nh,F_4nh,E_5nh,F_6nh, per chromosome C_1nh,D_2nh,C_3nh,D_4nh,C_5nh,D_6nh for row n=1,2,3
 }


#' @title Multiply the nonsilent constants in a subsetted \code{exome.constants} 
#'   object by the relative rate parameters of the background mutation model
#' @description A function to multiply the constants e and f in a subsetted 
#'   \code{exome.constants} object by the relative rate parameter for selection bias
#'   of the background mutation model.  This parameter represents the ratio of 
#'   nonsilent to silent mutations
#' @param res a list with one entry for each chromosome, where each entry is a 
#'   matrix containing a row for each coding base pair and the following 
#'   columns: 1. base pair position, 2. nucleotide number (see 
#'   \code{\link{convert.seq.to.num}}), 3. number of possible nonsilent 
#'   transitions, 4. number of possible nonsilent transversions, 5. number of 
#'   possible silent transitionsget, 6. number of possible silent transversions,
#'   and 7. whether the position is in a CpG dinucleotide. Is subsetted by a 
#'   particular gene list to include only genes used for nonsilent rate 
#'   estimation (see \code{\link{generate.sel.exome}})
#' @param r numeric value representing the relative rate parameter estimate for 
#'   the ratio of mutations in genes with nonsilent vs only silent mutations 
#'   (selection bias)
#' @return an object of the same structure as \code{res}, but columns 3 and 4
#'   (e, and f) have been multiplied by the nonsilent relative rate parameter
#'   \code{r}.
#' @note This internal function is not intended to be called by the user.
### multiply selection bias r
multiplyr<-function(res,r)
{
  for(i in 1:length(res))
    if(!is.null(res[[i]]))
      res[[i]][,3:4]= matrix(res[[i]][,3:4],ncol=2)*r
  return(res)
}

#' @title Convert nucleotide sequence to column numbers in
#'   \code{exome.SIFT}
#' @description This function converts nucleotide sequence to column numbers in
#'   the \code{exome.SIFT} object that they correspond to
#' @param x a character vector containing any number of "A", "T", "G", and "C".
#' @return a vector of integers where 4 corresponds to "A", 5 corresponds to 
#'   "T", 6 corresponds to "G", and 7 corresponds to "C".
#' @note This internal function is not intended to be called by the user.
mut.base<-function(x)
{
  if(x=="A") {return(4)
  }else if(x=="C") {return(5)
  }else if(x=="G") {return(6)
  }else if(x=="T") {return(7)
  }else {return(NA)}
}

#' @title Calculate the background mutation probability for every gene/sample 
#'   combination
#' @description This function calcuates the empirical Bayes estimate of a 
#'   mutation occurring in every gene and sample according to the background 
#'   mutation model
#' @param gid a character vector containing the Ensembl gene ids of all genes
#' @inheritParams multiply.p.s.epsilon
#' @param exome.constants.mult an object returned by \code{\link{multiply.p.s.epsilon}}
#' @param sample.name a character vector containing the names of all samples
#' @param muttable a matrix containing the likelihood due to existing background
#'   mutations, see \code{\link{mut.lik.change}}
#' @param nonsil.mut.type a matrix with one row for every observed mutation, 
#'   with 10 columns in this order: Ensemble gene id, chromosome, position, 
#'   mutation type (SNP or In_frame or Frame_shift), reference allele, tumor 
#'   allele 1, tumor allele 2, sample id, mutation type (1=transition or 
#'   2=transversion), and SIFT score
#' @param a numeric value for the maximum likelihood estimate of the 
#'   hyperparameter a representing the prior for q_j (sample-specific mutation 
#'   rate, q_j~Unif(a,b))
#' @param b numeric value for the maximum likelihood estimate of the 
#'   hyperparameter b representing the prior for q_j (sample-specific mutation 
#'   rate, q_j~Unif(a,b))
#' @param uniqueA a numeric vector containing all unique values of A (see 
#'   \code{\link{getA}})
#' @param tableA a numeric vector of the same length of \code{uniqueA} that 
#'   contains the number of instances of each value in \code{uniqueA}
#' @return a list with one entry for each gene where each entry contains a 
#'   vector with the probability of mutation for each sample
#' @details the return value is only calculated for genes with two or more 
#'   mutations to save on computation time.
#' @note This internal function is not intended to be called by the user.
### calculate bij of all genes and tumors
calculate.bij<-function( gid, gene, p, s, epsilon, delta, exome.constants.mult, sample.name,muttable,nonsil.mut.type,a,b,uniqueA,tableA)
{#exome.constants.mult has gone through multiply.p.s.epsilon() function so s and epsilon are incorporated
  bij <- vector("list", length(gid))
  
  # get posterior mean of q for each sample
  q=rep(NA,length(sample.name))  ### pnom=sij= Pr( no nonsilent mutation in gene ij and sample i)
  names(q)=sample.name
  mutationexist=TRUE
  for(sampleid in unique(muttable[,1])){
    C=matrix(as.numeric(muttable[muttable[,1]==sampleid,-1]),ncol=2)  ### likelihood change due to background mutations for sample sampleid
    D=sum(log(C[,1]))
    
    base <-optim((a+b)/2,lupost3.vec,method="L-BFGS-B",lower=a,upper=b,control=list(fnscale= -1),mutationexist=mutationexist,C=C,D=D,uniqueA=uniqueA,tableA=tableA)$value
    # loglik value given maximum lik est of q (maximizing over prior)
    
    q[match(sampleid, names(q))]= exp(log(integrate(lupost4.vec,a,b,mutationexist,C,D,uniqueA,tableA,base)$value) - log(integrate(lupost2.vec,a,b,mutationexist,C,D,uniqueA,tableA,base)$value))
    
  }
  mutationexist=FALSE
  C=matrix(as.numeric(muttable[muttable[,1]==sample.name[length(sample.name)],-1]),ncol=2)  ### likelihood change due to background mutations for sample sampleid
  D=sum(log(C[,1]))
  base=optim((a+b)/2,lupost3.vec,method="L-BFGS-B",lower=a,upper=b,control=list(fnscale= -1),mutationexist=mutationexist,C=C,D=D,uniqueA=uniqueA,tableA=tableA)$value
  q[is.na(q)]= exp(log(integrate(lupost4.vec,a,b,mutationexist,C,D,uniqueA,tableA,base)$value) - log(integrate(lupost2.vec,a,b,mutationexist,C,D,uniqueA,tableA,base)$value))
  
  for( ij in (1:length(gid)))
  {
    pnom=rep(NA,length(sample.name))  ### pnom=sij= Pr( no nonsilent mutation in gene ij and sample i)
    names(pnom)=sample.name
    
    if(sum( nonsil.mut.type[,1] == gid[ij] ,na.rm=T )>1)  {       ### If the number of nonsilent mutations less than or equal to THREE!!, skip the gene
      x=match(gene[[ij]][[3]], exome.constants.mult[[ gene[[ij]][[2]] ]][,1] )
      rep <- gene[[ij]][[4]]; if(is.na(rep)) rep<-2
      exp <- gene[[ij]][[5]]; if(is.na(exp)) exp<-2
      or <- gene[[ij]][[6]]; if(is.na(or)) or<-1
      if (sum(is.na(x)) == length(x) ){sij[[ij]] <- pnom }else{  
        B=matrix(exome.constants.mult[[ gene[[ij]][[2]] ]][x,3:4],ncol=2)
        B=cbind(B,p[7]*s[rep]*epsilon[exp]*delta[or])
        B=rowSums(B)
        B=sort(B)
        uniqueB=unique(B)
        tableB=as.vector(table(B))
        pnom=rep(0,length(sample.name))  ### pnom=sij= Pr( no nonsilent mutation in gene ij and sample i)
        names(pnom)=sample.name
        
        ## calculate sij 
        pnom <- exp(rowSums(log(1-as.matrix(q)%*%uniqueB)%*%tableB))
      }
    }
    bij[[ij]] <- pnom     
  }
  return(bij) 
}


#' @title Calculate posterior probability of being a driver
#' @description This function calculates the posterior probability for every 
#'   gene being a driver
#' @inheritParams calculate.bij
#' @param bij list object with one entry per gene, where each entry is a numeric
#'   vector containing 1-the probability of a mutation in each sample under the 
#'   background mutation model
#' @param nonsil.mut.type table of mutations, object obtained from 
#'   \code{\link{mut.type.converter}}
#' @param f0 numeric vector containing the estimated null density of FI scores 
#'   obtained from \code{\link{locfdr}}
#' @param f1 numeric vector containing the estimated non-null density of FI 
#'   scores obtained from \code{\link{locfdr}}
#' @param alpha numeric value of first shape parameter of the prior Beta 
#'   distribution on the probability of mutation for driver genes. Default value
#'   of 0.2 is chosen as a compromise between a cancer type with a relatively low 
#'   mutation rate (Ovarian cancer, fitted value from COSMIC of 0.15) and one with 
#'   a comparatively high mutation rate (Squamous cell lung, fitted value from 
#'   COSMIC of 0.27), but results are robust to changes in this parameter. Note
#'   that intuitively (and empirically), a higher mutation rate overall leads to 
#'   a higher driver mutation rate overall - and thus less mass is concentrated in 
#'   the left tail of the distribution. 
#' @param beta numeric value of second shape parameter of the prior Beta 
#'   distribution on the probability of mutation for driver genes. Default value
#'   of 6 is chosen as a compromise between a cancer type with a relatively low 
#'   mutation rate (Ovarian cancer, fitted value from COSMIC of 6.6) and one with 
#'   a comparatively high mutation rate (Squamous cell lung, fitted value from 
#'   COSMIC of 5.83), but results are robust to changes in this parameter.  Note
#'   that intuitively (and empirically), a higher mutation rate overall leads to 
#'   a higher driver mutation rate overall - and thus less mass is concentrated in 
#'   the left tail of the distribution. 
#' @param exome.SIFT list object with one item per chromosome where each item
#'   contains matrix with one row per coding base pair and 7 columns: position,
#'   nucleotide, CpG context, FI score for mutation to "A", FI score for
#'   mutation to "C", FI score for mutation to "G", and FI score for mutation to
#'   "T".
#' @param p0 vector of prior probabilities for each gene being a driver. This is
#'   precomputed from COSMIC and loaded into package.  See paper for details.
#' @return named vector of posterior probabilities that each gene is a driver.
#' @note This internal function is not intended to be called by the user.
#### calculate posterior probabilities of gene being a driver according to mixture model framework using COSMIC for prior of driver gene mut prob
calculate.post.probs <- function(bij, sample.name, nonsil.mut.type, gid, exome.SIFT, f0, f1, alpha=0.2, beta=6, p0){
  #alpha and beta are the fixed hyperparams of the additional gain in prob of mutation for a driver gene
  post=rep(NA,length(gid))
  names(post)=gid
  all.samples.genes <- vector("list", length(gid))
  if (length(p0)==1) {p0 <- rep(p0,length(gid))
  } else if (length(p0) != length(gid)) { print("Error - length of prior prob vector different than # of genes"); break;}
  
  for( ij in (1:length(gid))){
    res <- data.frame(patientid=sample.name, nonsil=0, SIFT=-1)
    res$patientid <- as.character(res$patientid)
    res$pjg <- 1-unlist(bij[ij])
    genemuts <- nonsil.mut.type[nonsil.mut.type[,1]==gid[ij] & !is.na(nonsil.mut.type[,1]),]
    if (length(genemuts)==10) {genemuts <- t(as.matrix(genemuts)) }
    
    if (nrow(genemuts) > 0) {
      if (genemuts[1,2]=="X") { genemuts[,2] <- 23 }
      if (genemuts[1,2]=="Y") { genemuts[,2] <- 24 }
      dupids <- genemuts[duplicated(genemuts[,8]),8]
      res$nonsil[res$patientid %in% genemuts[,8]] <- 1
      genemuts <- cbind(genemuts, NA)
      chrs <- unique(genemuts[,2])
      chrs <- chrs[!is.na(chrs)]
      siftchr <- vector("list", length(chrs))
      for (l in 1:length(chrs)){
        siftchr[[l]] <- exome.SIFT[[as.numeric(chrs[l])]]
      }
      for ( k in 1:nrow(genemuts)) {
        chrom <- which(chrs==genemuts[k,2])
        # add case for indels
        if (genemuts[k, 4]=="Frame_shift") { genemuts[k,11] <- 1 
        } else if (genemuts[k, 4]=="In_frame") { genemuts[k,11] <- 0.95 
        } else {  genemuts[k,11] <- siftchr[[chrom]][siftchr[[chrom]][,1]==as.numeric(genemuts[k,3]), mut.base(genemuts[k,7])] }
      }
      
      if(length(dupids)>0) { if( sum(is.na(dupids)) != length(dupids)){  # take maximum sift score when more than one mut per gene per sample
        for( l in 1:length(dupids)) { 
          if(!sum(is.na(genemuts[genemuts[,8]==dupids[l],11]))==nrow(genemuts[genemuts[,8]==dupids[l],]) ) {
            res$SIFT[res$patientid==dupids[l]] <- max(as.numeric(genemuts[genemuts[,8]==dupids[l],11]), na.rm=T)
          }}
      }}
      
      genemuts <- genemuts[!(genemuts[,8] %in% dupids),] #remove duplicates
      if (length(genemuts)==11) {genemuts <- t(as.matrix(genemuts)) }
      if (nrow(genemuts) > 0) {
        for ( k in 1:nrow(genemuts)) {
          res$SIFT[res$patientid == genemuts[k,8]] <- as.numeric(genemuts[k,11])
        }
      }
    }
    all.samples.genes[[ij]] <- res
    # data.frame for gene ij all set up.  Now calculate postprob that gene ij is driver
    # for( ij in (1:length(gid))){
    x <- all.samples.genes[[ij]][,2]
    p <- all.samples.genes[[ij]][,4]
    s <- all.samples.genes[[ij]][,3]
    fds <- rep(NA, nrow(all.samples.genes[[ij]])); fps <- fds
    fds <- pmax(f1[pmax(ceiling(s*length(f1)),1)],min(f1[f1>0]/2))
    fps <- pmax(f0[pmax(ceiling(s*length(f0)),1)],min(f0[f0>0]/2))
    s[is.na(s)] <- -1
    fds[s==-1] <- 1; fps[s==-1] <- 1; 
    pbar <- mean(p)
    post.1.num <- log(1-p0[ij]) + lbeta(sum(x)+alpha, length(x)-sum(x)+beta) + 
      log(1 - pbeta(pbar,sum(x)+alpha, length(x)-sum(x)+beta)) + 
      sum(x*log(fds)) - lbeta(alpha, beta) - log(1-pbeta(pbar,alpha,beta))
    post.1.num <- min(post.1.num, 709)
    post.0.num <- log(p0[ij]) +  sum(x*(log(fps)+log(p)) +(1-x)*log(1-p)) 
    post.1 <- exp(post.1.num) / (exp(post.1.num) + exp(post.0.num))
    post.0 <- exp(post.0.num) / (exp(post.1.num) + exp(post.0.num))
    post[ij] <- post.1
  } 
  return(post)
}

#' @title Fit background mutation model
#' @description This function calculates the relative rate parameters of the
#'   background mutation model, estimated by method of moments
#' @inheritParams generate.sel.exome
#' @param mutab a matrix containing one row per mutation and 8 columns (Ensembl
#'   gene name, chromosome, position, variant type (SNP, In_frame, Frame_shift),
#'   reference allele, tumor allele 1, tumor allele 2, and sample id.
#' @param nonsil.mut.type.sampl.sum a 3 (expression category) by 3(replication
#'   timing category) by 6 (mutation type) matrix containing the total number of
#'   base pairs eligible for a nonsilent mutation in each category (2nd item
#'   obtained from \code{\link{mut.type.converter}})
#' @param sil.mut.type.sampl.sum a 3 (expression category) by 3(replication
#'   timing category) by 6 (mutation type) matrix containing the total number of
#'   base pairs eligible for a silent mutation in each category (2nd item
#'   obtained from \code{\link{mut.type.converter}})
#' @param nonsil.type.const list of 3 objects with information about nonsilent
#'   coding sequences (see \code{\link{preprocess.BM}})
#' @param sil.type.const list of 3 objects with information about silent coding
#'   sequences (see \code{\link{preprocess.BM}})
#' @return a list object with four elements: 
#'   \item{p}{a
#'   vector of length 7 containing the mutation type relative rate parameters in
#'   the following order: A/T transition, A/T transversion, non-CpG transition,
#'   non-CpG transversion, CpG transition, CpG transversion, and Indel.} 
#'   \item{r}{numeric value representing the relative rate parameter estimate
#'   for the ratio of mutations in genes with nonsilent vs only silent mutations
#'   (selection bias)} 
#'   \item{s}{a vector of length 3 containing the relative
#'   rate parameters for the three replication timing regions (1=Early,
#'   2=Middle, 3=Late)} 
#'   \item{epsilon}{a vector of length  containing the
#'   relative rate parameters for the three expression levels (1=Low, 2=Medium,
#'   3=High)}
#'   \item{delta}{a vector of length 2 where the second element represents the relative rate of mutation
#'   in olfactory receptor (OR) genes compared to all others within a similar 
#'   replication timing and expression level category.  First element set to 1 (reference category).}
#' @note This internal function is not intended to be called by the user.
### calculate p_{i} for i=1,...8, and s, and epsilon
fit.background.model<-function(mutab, nonsil.mut.type.sampl.sum, sil.mut.type.sampl.sum, nonsil.type.const, 
                               sil.type.const, gene) #plug in nonsil.mutab for mutab
{ #sil.mut.type.sampl.sum[sil.mut.type.sampl.sum==0]=1
  r <- vector()
  for (n in 1:3){
    for (h in 1:3){  # only include in calculation if not all zeroes in denominator
      if (sum(c(sil.type.const[[3]][n,7:12,h,1]+sil.type.const[[3]][n,7:12,h,2], nonsil.type.const[[3]][n,1:6,h,1] + nonsil.type.const[[3]][n,1:6,h,2]) == 0) == 0 &
            sum(c(sil.mut.type.sampl.sum[n,,h,1]+ sil.mut.type.sampl.sum[n,,h,2] == 0)) == 0) { 
        r <-  c(r,mean( ((nonsil.mut.type.sampl.sum[n,,h,1]+ nonsil.mut.type.sampl.sum[n,,h,2])/ (nonsil.type.const[[3]][n,1:6,h,1] + nonsil.type.const[[3]][n,1:6,h,2])) *
                          ((sil.type.const[[3]][n,7:12,h,1] + sil.type.const[[3]][n,7:12,h,2] ) / (sil.mut.type.sampl.sum[n,,h,1] +sil.mut.type.sampl.sum[n,,h,2])) ))     
      }   
    }
  }
  r <- mean(r)
  
  p.all <- rbind(rep(0,6),rep(0,6),rep(0,6))
  p.all <- abind(p.all, p.all, p.all, along=3)
  for (n in 1:3){
    for (h in 1:3){
      p.all[n,,h] <- ( nonsil.mut.type.sampl.sum[n,,h,1] + sil.mut.type.sampl.sum[n,,h,1] + nonsil.mut.type.sampl.sum[n,,h,2] + sil.mut.type.sampl.sum[n,,h,2]) / 
        ( sil.type.const[[3]][n,7:12,h,1] + r * nonsil.type.const[[3]][n,1:6,h,1] + sil.type.const[[3]][n,7:12,h,2] + r * nonsil.type.const[[3]][n,1:6,h,2] )  # part of phat
      if (sum(sil.type.const[[3]][n,7:12,h,],nonsil.type.const[[3]][n,1:6,h,]) == 0){ p.all[n,,h] <- NA;  }
    }
  }
  ref <- p.all[,1,]  # reference cat is type 1
  
  p <- rep(0,6)
  for (m in 1:6) {
    p.m <- p.all[,m,]/ref
    p[m] <- mean(p.m[p.m != 0 & !is.na(p.m) & !(p.m==Inf)])    ## p_{i}, i=1,2...,6
  }
  
  # calculate s
  s <- rep(0,3)
  stemp <- s
  for (n in 1:3) {
    for (h in 1:3) {
      stemp[h] <- sum(nonsil.mut.type.sampl.sum[n,,h,1] + sil.mut.type.sampl.sum[n,,h,1] + nonsil.mut.type.sampl.sum[n,,h,2] + sil.mut.type.sampl.sum[n,,h,2]) / 
        sum( p*(sil.type.const[[3]][n,7:12,h,1] + r * nonsil.type.const[[3]][n,1:6,h,1] + sil.type.const[[3]][n,7:12,h,2] + r * nonsil.type.const[[3]][n,1:6,h,2] )) 
    }
    s[n] <- mean(stemp, na.rm=T)
  }
  s <- s/s[2]  # reference region is 2 (middle replicating)
  
  
  # calculate epsilon
  epsilon <- rep(0,3) 
  epsilontemp <- NA
  for (h in 1:3) {
    sp.mult <- as.matrix(s)%*%t(as.matrix(p))
    epsilontemp <- sum(nonsil.mut.type.sampl.sum[,,h,1] + sil.mut.type.sampl.sum[,,h,1] + nonsil.mut.type.sampl.sum[,,h,2] + sil.mut.type.sampl.sum[,,h,2]) / 
      sum(sp.mult*(sil.type.const[[3]][,7:12,h,1] + r*nonsil.type.const[[3]][,1:6,h,1] + sil.type.const[[3]][,7:12,h,2] + r*nonsil.type.const[[3]][,1:6,h,2])) 
    epsilon[h] <- mean(epsilontemp, na.rm=T)
  }
  epsilon <- epsilon/epsilon[2]
  
  
  # calculate delta
  delta <- rep(0,2)
  for (o in 1:2){
    spe.mult <- as.matrix(s)%*%t(as.matrix(p))
    spe.mult <- abind(epsilon[1]*spe.mult, epsilon[2]*spe.mult, epsilon[3]*spe.mult, along=3)
    delta[o] <- sum(nonsil.mut.type.sampl.sum[,,,o] + sil.mut.type.sampl.sum[,,,o]) / 
      sum(spe.mult*(sil.type.const[[3]][,7:12,,o] + r*nonsil.type.const[[3]][,1:6,,o] ))
  }
  delta <- delta/delta[1]
  
  
  
  ## calculate p_{indel}, which will be used later for calculation of p_{frameshift} and p_{inframe}
  
  #add in rep timing and expression levels to mutab to sum rep timing / expr category indels
  mutabRE <- cbind(mutab, rep(NA, nrow(mutab)), rep(NA,nrow(mutab)) , rep(NA,nrow(mutab)))
  for ( j in 1:24){
    on.chr <- unlist(lapply(gene, function(x) x[[2]]==j))  # pull out all genes on chrom j
    gene.chr <- gene[on.chr]
    tmp <- which(mutab[,2] == j) # pull out muts on chrom j
    if (j == 23) { tmp <- which(mutab[,2] == "X" | mutab[,2] == 23) }
    if (j == 24) { tmp <- which(mutab[,2] == "Y" | mutab[,2] == 24) }
    
    if (length(tmp) > 0) {
      names <- unlist(lapply(gene.chr, function(x) x[[1]] ))
      x <- match(mutab[tmp,1], names)
      mutabRE[tmp,9:11] <- cbind(unlist(lapply(gene.chr[x], function(x) if(is.null(x)){NA}else{x[[4]]})), unlist(lapply(gene.chr[x], function(x) if(is.null(x)){NA}else{x[[5]]}) ),
                                 unlist(lapply(gene.chr[x], function(x) if(is.null(x)){NA}else{x[[6]]}) ))
    }
  }
  
  L<-cbind(rep(0,3),rep(0,3), rep(0,3))
  L<-abind(L,L,along=3)
  for(i in 1:24){
    on.chr <- unlist(lapply(gene, function(x) x[[2]]==i))  # pull out all genes on chrom j
    gene.chr <- gene[on.chr]
    for( n in 1:3) {
      for (h in 1:3) {
        for (d in 1:2){
          if( is.matrix(nonsil.type.const[[1]][[i]]) ) {
            mat <- nonsil.type.const[[1]][[i]]
            bp <- unlist(lapply(gene.chr, function(x) if( sum(c(is.na(x[[4]]), is.na(x[[5]]), is.na(x[[6]])))==0){if(x[[4]]==n & x[[5]]==h & x[[6]]==d){x[[3]]}} )) 
            L[n,h,d] <- L[n,h,d] + nrow(mat[mat[,1] %in% bp,])  # length of sequence with reptiming cat n and expression region h in chrom i
          }     
        }   
      }
    }
  }
  
  if(sum(  mutab[,4]=="In_frame" | mutab[,4]=="Frame_shift"  )>0)
  {
    mutab.indel=   mutabRE[ mutabRE[,4]=="In_frame" | mutabRE[,4]=="Frame_shift",]
    exist=rep(FALSE,nrow(mutab.indel) )
    for( i in 1:nrow(mutab.indel) ) {
      if (i %% 100 == 0 ) {print(i)}
      if(   sum(  nonsil.type.const[[1]][[number(mutab.indel[i,2])]][,1] ==  mutab.indel[i,3] , na.rm=T )  == 1)   exist[i]= T }
    mutab.indel <- mutab.indel[exist,]
    ind <- vector()
    for (n in 1:3){
      for (h in 1:3){
        #for (d in 1:2){
        ind <-  c(ind, nrow(matrix(mutab.indel[mutab.indel[,9]==paste(n) & !is.na(mutab.indel[,9]) & mutab.indel[,10]==paste(h) & !is.na(mutab.indel[,10]),],
                                   ncol=ncol(mutab.indel)))/(L[n,h,1]+L[n,h,2])/r/ref[n,h] )  #### p_{indel}
        #}
      }
    }
  } else ind <- 0
  p=c(p,mean(ind[ind!=Inf],na.rm=T))
  
  return(list(p,r,s,epsilon,delta))
  
}


#' @title Get total counts of mutations for each replication timing, expression,
#'   and mutation type category and reformatted mutation table
#' @description This function reads in a mutation table and returns the total 
#'   counts of mutations in each of the replication timing regions, expression 
#'   level categories, and mutation types. It also returns a reformatted 
#'   mutation table.
#' @inheritParams fit.background.model
#' @inheritParams calculate.post.probs
#' @param seq.in.chrom a list with an item for each chromosome that contains a 
#'   matrix whose first column is the position and the second column is the 
#'   nucleotide of a base pair within that chromosomes (first item returned from
#'   \code{\link{preprocess.BM}})
#' @param dCG.in.chrom a list with an item for each chromosome that contains a
#'   vector of the position of the CpG dinucleotide coding sequences (second
#'   item returned from \code{\link{preprocess.BM}})
#' @return a list object with two elements: 
#'   \item{mut.per.type.sum}{a 3 by 3 by
#'   6 matrix with the total counts of mutations in each of the 3 replication
#'   timing regions, 3 expression level categories, and 6 mutation types (indels
#'   counted separately since every base pair is at risk for this type of
#'   mutation).} 
#'   \item{mutab}{a reformatted mutation table that contains an extra
#'   two columns: 1. a mutation type indicator (1= transition, 2=transversion,
#'   and 3=indel), 2. SIFT score for the mutation.}
#' @note This internal function is not intended to be called by the user.
mut.type.converter<- function(mutab, exome.SIFT, seq.in.chrom, dCG.in.chrom, gene)   ### convert mutation type to id (1,2,..6)
{
  mutab <- as.matrix(mutab)
  mutab.snp= mutab[ mutab[,4]=="SNP" ,]
  
  if(sum(  mutab[,4]=="In_frame" | mutab[,4]=="Frame_shift"  )>0 )
    mutab.indel=   mutab[ mutab[,4]=="In_frame" | mutab[,4]=="Frame_shift",]   else mutab.indel=NULL
  
  mutab.dnp= mutab.tnp=mutab.onp=NULL
  if(sum(mutab[,4]=="DNP")>0)
  {
    mutab.dnp=  (as.matrix(mutab[ mutab[,4]=="DNP" ,]))
    if (sum(mutab[,4]=="DNP")==1) {mutab.dnp=  t(as.matrix(mutab[ mutab[,4]=="DNP" ,])) }
    #### convert DNP to SNP ##############
    a=     matrix(0, nrow= nrow(mutab.dnp)*2,ncol=ncol(mutab.dnp)   )
    colnames(a)=colnames(mutab)
    a[,1]=  rep(mutab.dnp[,1] ,each=2)
    a[,2]=  rep(mutab.dnp[,2] ,each=2)
    a[,8]=  rep(mutab.dnp[,8] ,each=2)
    a[2*(1:nrow(mutab.dnp))-1,3]=  mutab.dnp[,3]
    a[2*(1:nrow(mutab.dnp)),3]= as.numeric(mutab.dnp[,3]) + 1
    a[,5]= unlist(  strsplit( mutab.dnp[,5]  ,""))
    a[,6]= unlist(  strsplit( mutab.dnp[,6] ,""))
    a[,7]= unlist(  strsplit( mutab.dnp[,7] ,""))
    mutab.dnp=a
  }
  
  
  if(sum(mutab[,4]=="TNP")>0)
  {
    mutab.tnp=  mutab[ mutab[,4]=="TNP" ,]
    if (sum(mutab[,4]=="TNP")==1) {mutab.tnp=  t(as.matrix(mutab[ mutab[,4]=="TNP" ,])) }
    #### convert TNP to SNP ##############
    a=     matrix(0, nrow= nrow(mutab.tnp)*3,ncol=ncol(mutab.tnp)   )
    colnames(a)=colnames(mutab)
    a[,1]=  rep(mutab.tnp[,1] ,each=3)
    a[,2]=  rep(mutab.tnp[,2] ,each=3)
    a[,8]=  rep(mutab.tnp[,8] ,each=3)
    a[3*(1:nrow(mutab.tnp))-2,3]=  mutab.tnp[,3]
    a[3*(1:nrow(mutab.tnp))-1,3]= as.numeric(mutab.tnp[,3]) + 1
    a[3*(1:nrow(mutab.tnp)),3]= as.numeric(mutab.tnp[,3]) + 2
    a[,5]= unlist(  strsplit( mutab.tnp[,5]  ,""))
    a[,6]= unlist(  strsplit( mutab.tnp[,6] ,""))
    a[,7]= unlist(  strsplit( mutab.tnp[,7] ,""))
    mutab.tnp=a
  }
  
  if(sum(mutab[,4]=="ONP")>0)
  {
    mutab.onp.all=  mutab[ mutab[,4]=="ONP" ,]
    if (sum(mutab[,4]=="ONP")==1) {mutab.onp.all=  t(as.matrix(mutab[ mutab[,4]=="ONP" ,])) }
    #### convert ONP to SNP ##############
    maxchar <- max(nchar(mutab.onp[,5],mutab.onp[,6],mutab.onp[,7]))
    umaxchar <- unique(maxchar)
    for (k in 1:length(umaxchar)){
      mutab.onp <- mutab.onp.all[maxchar==umaxchar[k],]
      a=     matrix(0, nrow= nrow(mutab.onp)*umaxchar[k],ncol=ncol(mutab.onp)   )
      colnames(a)=colnames(mutab)
      a[,1]=  rep(mutab.onp[,1] ,each=umaxchar[k])
      a[,2]=  rep(mutab.onp[,2] ,each=umaxchar[k])
      a[,8]=  rep(mutab.onp[,8] ,each=umaxchar[k])
      a[umaxchar[k]*(1:nrow(mutab.onp))-2,3]=  mutab.onp[,3]
      a[umaxchar[k]*(1:nrow(mutab.onp))-1,3]= as.numeric(mutab.onp[,3]) + 1
      a[umaxchar[k]*(1:nrow(mutab.onp)),3]= as.numeric(mutab.onp[,3]) + 2
      a[,5]= unlist(  strsplit( mutab.onp[,5]  ,""))
      a[,6]= unlist(  strsplit( mutab.onp[,6] ,""))
      a[,7]= unlist(  strsplit( mutab.onp[,7] ,""))
      b <- rbind(b,a)
    }
    mutab.onp <- b
  }
  
  mutab=rbind(mutab.snp,mutab.dnp,mutab.tnp,mutab.onp)
  
  
  ref=mutab[,5]      ### reference nucleotide
  mut=ref
  temp= (mutab[,6]!=ref)
  mut[temp]=mutab[temp,6]
  
  temp= (mutab[,7]!=ref)
  mut[temp]=mutab[temp,7]   ### mutated nucleotide
  
  mutab = cbind( mutab, paste(ref,mut,sep="")  )  ### mutab[,9]=mutation type (A->T,...)
  
  muttype=rep(0,nrow(mutab))
  
  exist=dCG=rep(FALSE,nrow(mutab) )
  for( i in 1:nrow(mutab) )
  {
    if(   sum(  seq.in.chrom[[number(mutab[i,2])]][,1] ==  as.numeric(mutab[i,3]), na.rm=T  )  > 0)   exist[i]= T   ### exist[i]=T if the observed mutation exists within the coding sequences of biomart file (bg genes)
    if(   sum(   dCG.in.chrom[[number(mutab[i,2])]] ==  as.numeric(mutab[i,3]) , na.rm=T )  > 0)   dCG[i]= T    ### dCG[i]=T if the observed mutation exists within dCG
    
  }
  muttype[exist & !dCG] = no.dCG.type( mutab[exist & !dCG,9] ) ### convert mutation type(not within dCG) to id
  if(sum(dCG)>0) muttype[dCG] = dCG.type( mutab[dCG,9] )       ### convert mutation type(within dCG) to id
  
  # bring in replication timing and expression level information
  mutabRE <- cbind(mutab, rep(NA, nrow(mutab)), rep(NA,nrow(mutab)), rep(NA,nrow(mutab)) )
  for ( j in 1:24){
    on.chr <- unlist(lapply(gene, function(x) x[[2]]==j))  # pull out all genes on chrom j
    gene.chr <- gene[on.chr]
    tmp <- which(mutab[,2] == j) # pull out muts on chrom j
    if (j == 23) { tmp <- which(mutab[,2] == "X" | mutab[,2] == 23) }
    if (j == 24) { tmp <- which(mutab[,2] == "Y" | mutab[,2] == 24) }
    
    if (length(tmp) > 0) {
      names <- unlist(lapply(gene.chr, function(x) x[[1]] ))
      x <- match(mutab[tmp,1], names)
      mutabRE[tmp,10:12] <- cbind(unlist(lapply(gene.chr[x], function(x) if(is.null(x)){NA}else{x[[4]]})), unlist(lapply(gene.chr[x], function(x) if(is.null(x)){NA}else{x[[5]]})),
                                  unlist(lapply(gene.chr[x], function(x) if(is.null(x)){NA}else{x[[6]]})) )
    }
  }
  
  
  repl <- as.numeric(mutabRE[,10])
  expr <- as.numeric(mutabRE[,11])
  or <- as.numeric(mutabRE[,12])
  mut.per.type.sum = rbind(c(1:6), c(1:6), c(1:6))
  mut.per.type.sum = abind(mut.per.type.sum, mut.per.type.sum, mut.per.type.sum, along=3)
  mut.per.type.sum = abind(mut.per.type.sum, mut.per.type.sum, along=4)
  
  for(h in 1:3){
    for(i in 1:6){ for(c in 1:2){
      mut.per.type.sum[1,i,h,c] = sum(muttype[repl==1 & expr==h & or==c]==paste(i), na.rm=T)
      mut.per.type.sum[2,i,h,c] = sum(muttype[repl==2 & expr==h & or==c]==paste(i), na.rm=T)
      mut.per.type.sum[3,i,h,c] = sum(muttype[repl==3 & expr==h & or==c]==paste(i), na.rm=T)
    }}
  }
  
  mutab[,9] = mut.type( mutab[,9] )  #mutation type (transition or transversion)
  mutab=cbind(mutab,0)
  
  remove <- NULL
  for(i in 1:24)
  {
    which.tmp <- sapply(mutab[,2],number) == i
    which.tmp <- which(!is.na(which.tmp) & which.tmp==T)
    mutab.tmp <- mutab[which.tmp,]
    mut.tmp <- mut[which.tmp]
    exist <- rep(NA,nrow(mutab.tmp))  ### removing mutations which do not exist in exome
    x <- match( as.numeric(mutab.tmp[,3]) , exome.SIFT[[i]][,1]  )
    exist <- which(!is.na(x))
    remove <- c(remove, which.tmp[which(is.na(x))])
    if (length(exist)>0){
      mutab.tmp[exist,10]= exome.SIFT[[i]][ cbind(x[exist] , sapply(mut.tmp[exist], mut.base)) ]
      mutab[which.tmp, ] <- mutab.tmp
    }
  }
  if (length(remove)>0)
    mutab <- mutab[-remove,]
  
  colnames(mutab)=1:ncol(mutab)
  
  if(!is.null(mutab.indel))
  {
    mutab.indel=cbind(mutab.indel,matrix(3,nrow=nrow(mutab.indel),ncol=1))
    last=rep(0,nrow(mutab.indel))
    last[  mutab.indel[,4]=="In_frame"  ]=0.95
    last[  mutab.indel[,4]=="Frame_shift" ]=1
    mutab.indel=cbind(mutab.indel,last)
    
    exist <- rep(NA,nrow(mutab.indel))      ### removing mutations which do not exist in exome
    for(i in 1:nrow(mutab.indel) )
    {
      x <- match( as.numeric(mutab.indel[i,3]) , exome.SIFT[[number(unique(mutab.indel[i,2])) ]][,1]  )
      exist[i]=is.na(x)
    }
    mutab.indel <- matrix(mutab.indel[!exist,],ncol=ncol(mutab.indel))
    
    colnames(mutab.indel)=1:ncol(mutab)
    mutab=as.matrix(rbind(mutab,mutab.indel ))
  } else mutab= as.matrix(mutab)
  
  return(list(mut.per.type.sum,mutab))
  ## mut.per.type.sum=c(sum_{i}sum_{t_{l}=1}N_{il}, sum_{i}sum_{k,t_{l}=2}M_{il}, sum_{i}sum_{t_{l}=3}N_{il}, sum_{i}sum_{k,t_{l}=4}M_{il}, sum_{i}sum_{t_{l}=5}N_{il}, sum_{i}sum_{k,t_{l}=6}M_{il}
  ## when the mutab is from the nonsilent mutation table, otherwise
  ## mut.per.type.sum=c(sum_{i}sum_{t_{l}=1}S_{il}, sum_{i}sum_{k,t_{l}=2}T_{il}, sum_{i}sum_{t_{l}=3}S_{il}, sum_{i}sum_{k,t_{l}=4}T_{il}, sum_{i}sum_{t_{l}=5}S_{il}, sum_{i}sum_{k,t_{l}=6}T_{il}
  ## when the mutab is from the silent mutation table
  ## mutab is the mutation table converted to the format(nonsil.mut.type or sil.mut.type) from which I can calculte the likelihood
  
}


#' @title Get mutation type (transition or transversion)
#' @description Given a sequence of two characters, the function returns whether
#'   the mutation is a transition (1) or a transversion (2)
#' @param x a character of length two where each character is either
#'   "A","T","G", or "C".  For example, x could be "AG". 12 possible two-letter
#'   codes.
#' @return an integer indicator of mutation type, where 1=transition and
#'   2=transversion.  For example x="AG" would return 1 (for transition).
#' @details see \code{\link{mut.type.converter}}
#' @note This internal function is not intended to be called by the user.
### convert mutation type(not within dCG) to id (1=transition, 2=transversion)
mut.type<-function(x)
{
  y=rep(1,length(x))
  y[x=="AG"]= 1
  y[x=="TC"]=1
  y[x=="AC"]=2
  y[x=="TG"]=2
  y[x=="AT"]=2
  y[x=="TA"]=2
  y[x=="CT"]=1
  y[x=="GA"]=1
  y[x=="CA"]=2
  y[x=="GT"]=2
  y[x=="CG"]=2
  y[x=="GC"]=2
  return(y)
}


#' @title Get mutation type (1-4) of non-CpG mutations
#' @description Given a sequence of two characters, the function returns the
#'   type of mutation: transition from A/T (1), transversion from A/T (2),
#'   transition from non-CpG G/C (3), or transversion from non-CpG G/C (4).
#' @param x a character of length two where each character is either
#'   "A","T","G", or "C".  For example, x could be "AG". 12 possible two-letter
#'   codes.
#' @return an integer indicator of mutation type, where 1=transition from A/T,
#'   2=transversion from A/T, 3=transition from non-CpG C/G and 4=transversion
#'   from non-CpG C/G.  For example x="AG" would return 1 (for transition).
#' @details used internally in \code{\link{mut.type.converter}}
#' @note This internal function is not intended to be called by the user.
### convert mutation type(not within dCG) to id
no.dCG.type<-function(x)
{
  y=rep(0,length(x))
  y[x=="AG"]= 1
  y[x=="TC"]=1
  y[x=="AC"]=2
  y[x=="TG"]=2
  y[x=="AT"]=2
  y[x=="TA"]=2
  y[x=="CT"]=3
  y[x=="GA"]=3
  y[x=="CA"]=4
  y[x=="GT"]=4
  y[x=="CG"]=4
  y[x=="GC"]=4
  return(y)
}

#' @title Get mutation type (5-6) of CpG mutations
#' @description Given a sequence of two characters, the function returns the
#'   type of mutation: transition from CpG G/C (5), or transversion from CpG G/C
#'   (6).
#' @param x a character of length two where each character is either
#'   "A","T","G", or "C".  Only the 6 two letter codes that begin with "C" or
#'   "G" are allowed. For example, x could be "CT".
#' @return an integer indicator of mutation type, where 1=transition from CpG
#'   C/G and 2=transversion from CpG C/G.  For example x="AG" would return 1
#'   (for transition).
#' @details used internally in \code{\link{mut.type.converter}}
#' @note This internal function is not intended to be called by the user.
## convert mutation type(within dCG) to id
dCG.type<-function(x)
{
  y=rep(0,length(x))
  y[x=="CT"]=5
  y[x=="GA"]=5
  y[x=="CA"]=6
  y[x=="GT"]=6
  y[x=="CG"]=6
  y[x=="GC"]=6
  return(y)
}

#' @title Calculate change in likelihood due to background mutations
#' @description This function calculates the change in likelihood for each
#'   existing mutation in the reformatted tables obtained from
#'   \code{\link{mut.type.converter}} given estimates of the relative rate
#'   parameters from \code{\link{fit.background.model}}.
#' @param nonsil.mut.type a reformatted mutation table that contains an extra
#'   two columns: 1. a mutation type indicator (1= transition, 2=transversion,
#'   and 3=indel), 2. SIFT score for the mutation.  Second item returned from
#'   \code{\link{mut.type.converter}}.
#' @param res a gene list obtained from \code{\link{generate.sel.exome}} and
#'   run through \code{\link{multiplyr}} for genes used for nonsilent rate
#'   estimation
#' @param nonsilent logical value indicating whether genes are used for
#'   nonsilent rate estimation
#' @param both_log logical value indicating whether genes are used for both
#'   silent and nonsilent rate estimation
#' @param p_inframe numerical value representing the rate if in-frame indel
#'   mutations to A/T transitions
#' @param p_frameshift numerical value representing the rate if frameshift indel
#'   mutations to A/T transitions
#' @inheritParams multiply.p.s.epsilon
#' @inheritParams multiplyr
#' @return a matrix containing the likelihood due to existing background 
#'   mutations, to be utilized in \code{\link{calculate.bij}}
#' @note This internal function is not intended to be called by the user.
mut.lik.change <-function(nonsil.mut.type,res, nonsilent, both_log ,p_inframe,p_frameshift,p,r,s,epsilon,delta, gene)
{
  B<-NULL
  for(chr in  unique(nonsil.mut.type[,2]) )
  {
    genei <- nonsil.mut.type[ nonsil.mut.type[,2] == chr , ] # pull out muts on chrom chr
    genei <- matrix(genei,ncol=10)
    on.chr <- unlist(lapply(gene, function(x) x[[2]]== number(chr) ))  # pull out all genes on chrom j
    gene.chr <- gene[on.chr]
    
    genei <- cbind(genei, rep(NA, nrow(genei)), rep(NA,nrow(genei)), rep(NA,nrow(genei)))
    
    if (nrow(genei) > 0) { # retrieve rep timing and expr cats and chromatin status and put them into the mat of muts on chromosome chr
      names <- unlist(lapply(gene.chr, function(x) x[[1]] ))
      x <- match(genei[,1], names)
      genei[,11:13] <- cbind(unlist(lapply(gene.chr[x], function(y) if(is.null(y)){NA}else{y[[4]]})), 
                             unlist(lapply(gene.chr[x], function(y) if(is.null(y)){NA}else{y[[5]]})),
                             unlist(lapply(gene.chr[x], function(y) if(is.null(y)){NA}else{y[[6]]})))
    }
    
    z <- match( genei[,3] , res[[number(chr) ]][,1]  )
    isna=!is.na(z)
    z <- z[isna]
    if(length(z)>0)
    {
      genei[genei[,11]==1,11] <- s[1]
      genei[genei[,11]==2,11] <- s[2]
      genei[genei[,11]==3,11] <- s[3]
      genei[genei[,12]==1,12] <- epsilon[1]
      genei[genei[,12]==2,12] <- epsilon[2]
      genei[genei[,12]==3,12] <- epsilon[3]
      genei[genei[,13]==1,13] <- delta[1]
      genei[genei[,13]==2,13] <- delta[2]
      genei[is.na(genei[,11]),11] <- s[2]
      genei[is.na(genei[,12]),12] <- epsilon[2]
      genei[is.na(genei[,13]),13] <- delta[1]
      
      if(nonsilent)
      {
        A <- matrix(res[[ number(chr) ]][z,3:4],ncol=2)  # e and f (already multiplied by p and s and epsilon and delta)
        A <- cbind(A,r*p[7]*as.numeric(genei[isna,11])*as.numeric(genei[isna,12])*as.numeric(genei[isna,13])) # indels
      } 
      else  A <- matrix(res[[ number(chr) ]][z,5:6],ncol=2) # c and d (already multiplied by p and s and epsilon and delta)
      
      if(both_log){
        
        A<-cbind(A, rowSums(matrix(res[[ number(chr) ]][z,3:6],ncol=4)) +r*p[7]*as.numeric(genei[isna,11])*as.numeric(genei[isna,12])*as.numeric(genei[isna,13]))
      }else    {A <- cbind(A, rowSums(A))}
      
      
      A<-cbind( A[ cbind( 1:nrow(A), as.numeric( genei[isna,9] ) ) ] ,  A[,ncol(A)] )  # 9 is transition or transversion or indel id
      A<-cbind(genei[isna,8],A)
      
      B<- rbind(B,A)
    }
  }
  
  return(  B  )
}


#' @title Compute A - the likelihood of a mutation at every position
#' @description This function computes the likelihood of a mutation occurring at
#'   each position in the exome according to the background mutation model
#' @param nonsil.exclus oject obtained from \code{\link{generate.sel.exome}} 
#'   representing the exclusively nonsilent genes
#' @param sil.exclus oject obtained from \code{\link{generate.sel.exome}} 
#'   representing the exclusively silent genes
#' @param both oject obtained from \code{\link{generate.sel.exome}} 
#'   representing the genes with nonsilent mutations also used for silent 
#'   mutation detection
#' @param r numeric value representing the relative rate parameter estimate for 
#'   the ratio of mutations in genes with nonsilent vs only silent mutations 
#'   (selection bias)
#' @inheritParams multiply.p.s.epsilon
#' @return a numeric vector containting the likelihood of a mutation at every
#'   position.
#' @note This internal function is not intended to be called by the user.
# get A object to compute uniqueA and tableA for the computation of likelihood for all positions
getA <- function(nonsil.exclus, sil.exclus, both, p, r, s, epsilon, delta, gene){
  A=NULL
  for(i in 1:24){
    if(is.matrix(nonsil.exclus[[i]])){
      genei <- nonsil.exclus[[i]] # pull out posns on chrom i
      on.chr <- unlist(lapply(gene, function(x) x[[2]]== i ))  # pull out all genes on chrom j
      gene.chr <- gene[on.chr]
      genei <- cbind(genei, rep(NA, nrow(genei)), rep(NA,nrow(genei)), rep(NA,nrow(genei)))
      
      if (nrow(genei) > 0) { # retrieve rep timing and expr cats and put them into the mat of muts on chromosome chr
        pos <- unlist(lapply(gene.chr, function(x) x[[3]] ))
        rep <- unlist(lapply(gene.chr, function(x) rep(x[[4]], length(x[[3]])) ))
        exp <- unlist(lapply(gene.chr, function(x) rep(x[[5]], length(x[[3]])) ))
        hic <- unlist(lapply(gene.chr, function(x) rep(x[[6]], length(x[[3]])) ))
        pos <- cbind(pos,rep,exp,hic)
        x <- match(genei[,1], pos[,1])
        genei[,7:9] <-  pos[x,2:4]
      }
      
      genei[genei[,7]==1,7] <- s[1]
      genei[genei[,7]==2,7] <- s[2]
      genei[genei[,7]==3,7] <- s[3]
      genei[genei[,8]==1,8] <- epsilon[1]
      genei[genei[,8]==2,8] <- epsilon[2]
      genei[genei[,8]==3,8] <- epsilon[3]
      genei[genei[,9]==1,9] <- delta[1]
      genei[genei[,9]==2,9] <- delta[2]
      genei[is.na(genei[,7]),7] <- s[2]
      genei[is.na(genei[,8]),8] <- epsilon[2]
      genei[is.na(genei[,9]),9] <- delta[1]
      A=c(A,rowSums( matrix(genei[,3:4],ncol=2)) +r*p[7]*genei[,7]*genei[,8]*genei[,9])  
    }
  }
  rm(nonsil.exclus)
  
  for(i in 1:24){
    if(is.matrix(both[[i]])){
      genei <- both[[i]] # pull out posns on chrom i
      on.chr <- unlist(lapply(gene, function(x) x[[2]]== i ))  # pull out all genes on chrom j
      gene.chr <- gene[on.chr]
      genei <- cbind(genei, rep(NA, nrow(genei)), rep(NA,nrow(genei)), rep(NA,nrow(genei)))
      
      if (nrow(genei) > 0) { # retrieve rep timing and expr cats and put them into the mat of muts on chromosome chr
        pos <- unlist(lapply(gene.chr, function(x) x[[3]] ))
        rep <- unlist(lapply(gene.chr, function(x) rep(x[[4]], length(x[[3]])) ))
        exp <- unlist(lapply(gene.chr, function(x) rep(x[[5]], length(x[[3]])) ))
        hic <- unlist(lapply(gene.chr, function(x) rep(x[[6]], length(x[[3]])) ))
        pos <- cbind(pos,rep,exp,hic)
        x <- match(genei[,1], pos[,1])
        genei[,7:9] <-  pos[x,2:4]
      }
      
      genei[genei[,7]==1,7] <- s[1]
      genei[genei[,7]==2,7] <- s[2]
      genei[genei[,7]==3,7] <- s[3]
      genei[genei[,8]==1,8] <- epsilon[1]
      genei[genei[,8]==2,8] <- epsilon[2]
      genei[genei[,8]==3,8] <- epsilon[3]
      genei[genei[,9]==1,9] <- delta[1]
      genei[genei[,9]==2,9] <- delta[2]
      genei[is.na(genei[,7]),7] <- s[2]
      genei[is.na(genei[,8]),8] <- epsilon[2]
      genei[is.na(genei[,9]),9] <- delta[1]
      
      A=c(A,rowSums( matrix( genei[,3:6],ncol=4))+r*p[7]*genei[,7]*genei[,8]*genei[,9])
    }
  }
  rm(both)
  
  for(i in 1:24){
    if(is.matrix(sil.exclus[[i]])){
      A=c(A,rowSums( matrix( sil.exclus[[i]][,5:6],ncol=2))  )
    }
  }
  rm(sil.exclus)
  A=sort(A)
  return(A)
}

#' @title Find the maximum likelihood values for the hyperparameters \code{a}
#'   and \code{b}
#' @description Calculates the value of (\code{a},\code{b}) that maximizes the
#'   likelihood of q_j (sample-specific background mutation rate) given the
#'   relative rate parameters.
#' @param x a vector of length two with the initial guess for \code{a} and
#'   \code{b}.  Note that these values are on the log scale, i.e. a lower bound
#'   of 5E-8 would correspond to a=-16.8.
#' @inheritParams calculate.bij
#' @param S an integer corresponding to the number of samples in the dataset.
#' @return a list containing two items: \item{a}{numeric value for the maximum
#'   likelihood estimate of the hyperparameter a representing the prior for q_j
#'   (sample-specific mutation rate, q_j~Unif(a,b))} \item{b}{numeric value for
#'   the maximum likelihood estimate of the hyperparameter a representing the
#'   prior for q_j (sample-specific mutation rate, q_j~Unif(a,b))}
#' @note This internal function is not intended to be called by the user.
#### find the parameter a,b of the prior of q_i
find.prior.param<-function(x,muttable,uniqueA,tableA,S)
{
  a=min(x,-3)
  b=min(max(x),-3)
  if(a==b) return(Inf)
  else{
    loglik=0
    mutationexist=T
    sample.with.mutation=unique(muttable[,1])
    for(sampleid in sample.with.mutation)
    {
      C=matrix(as.numeric(muttable[muttable[,1]==sampleid,-1]),ncol=2)  ### likelihood change for sample sampleid
      D=sum(log(C[,1]))
      base=optim((a+b)/2,lupost3.vec, method="L-BFGS-B",lower=a,upper=b,control=list(fnscale= -1),mutationexist=mutationexist,C=C,D=D,uniqueA=uniqueA,tableA=tableA)$value
      loglik=loglik+log(integrate(lupost2.vec,a,b,mutationexist,C,D,uniqueA,tableA,base)$value)+base
    }
    mutationexist=FALSE
    
    base=optim((a+b)/2,lupost3.vec,method="L-BFGS-B",lower=a,upper=b,control=list(fnscale= -1),mutationexist=mutationexist,C=C,D=D,uniqueA=uniqueA,tableA=tableA)$value
    
    
    loglik=loglik+(log(integrate(lupost2.vec,a,b,mutationexist,C,D,uniqueA,tableA,base)$value)+base)*(S-length(sample.with.mutation))
    loglik=loglik-S*log(exp(b)-exp(a))
    
    return(-loglik)
  }
}


#' @title Likelihood of mutations in a single gene and sample given the 
#'   background model
#' @description Calculates, for a given gene and sample, the likelihood of 
#'   mutations in a given gene under the background mutation model and current 
#'   value of the sample-specific mutation rate
#' @param t numeric value of sample-specific mutation rate (log-scale)
#' @param mutationexist logical value indicating whether to include observed 
#'   mutations in the current gene
#' @param C subset of matrix \code{muttable} (see \code{\link{calculate.bij}}) 
#'   containing only those rows corresponding to the current sample
#' @param D numeric value corresponding to the sum of the logarithms of the 
#'   first column of \code{C}
#' @param uniqueB similar to \code{uniqueA} except restricted to the current 
#'   gene
#' @param tableB similar to \code{tableA} except restricted to the current gene
#' @inheritParams calculate.bij
#' @param base minimum value of the log likelihood of the sample-specific 
#'   mutation rate q_j given the background model
#' @return likelihood of mutations in a single gene and sample given the 
#'   background model and sample-specific mutation rate \code{t}
#' @note This internal function is not intended to be called by the user.
lupost.vec<-function(t,mutationexist,C,D,uniqueB,tableB,uniqueA,tableA,base)
{
  if (length(t)==1){
    lik=sum(log(1-exp(t)*uniqueA)*tableA) + sum(log(1-exp(t)*uniqueB)*tableB)  ### log likelihood when no background mutations
    
    if(mutationexist){
      lik=lik- sum(log(1-exp(t)*C[,2])) + t*nrow(C)+D ### add change of log likelihood due to background mutations
    }
  }else{
    lik <- rowSums(log(1-as.matrix(exp(t))%*%uniqueA)%*%tableA) + rowSums(log(1-as.matrix(exp(t))%*%uniqueB)%*%tableB)
    
    if(mutationexist){
      lik=lik- rowSums(log(1-as.matrix(exp(t))%*%C[,2])) + t*nrow(C)+D ### add change of log likelihood due to background mutations
    }
  }
  
  return( exp( lik +t-base ))     
}



#' @title Likelihood of sample specific mutation rate given the background model
#' @description Calculates the likelihood of the sample specific mutation rate 
#'   under the background mutation model.
#' @inheritParams calculate.bij
#' @inheritParams lupost.vec
#' @return likelihood of the sample-specific mutation rate q_j under the 
#'   background mutation model given the observed mutations.
#' @note This internal function is not intended to be called by the user.
lupost2.vec <-function(t,mutationexist,C,D,uniqueA,tableA,base)
{
  if (length(t)==1){
    lik=sum(log(1-exp(t)*uniqueA)*tableA)  ### log likelihood when no background mutations
    
    if(mutationexist){
      lik=lik- sum(log(1-exp(t)*C[,2])) + t*nrow(C)+D ### add change of log likelihood due to background mutations
    }
  }else{
    lik <- rowSums(log(1-as.matrix(exp(t))%*%uniqueA)%*%tableA)
    
    if(mutationexist){
      lik=lik- rowSums(log(1-as.matrix(exp(t))%*%C[,2])) + t*nrow(C)+D ### add change of log likelihood due to background mutations
    }
  }
  
  return( exp( lik+t-base  ))         
}

#' @title Likelihood of sample specific mutation rate given the background model
#' @description Calculates the log likelihood of the sample specific mutation
#'   rate under the background mutation model. Similar to
#'   \code{\link{lupost2.vec}} except that it returns the raw value of the
#'   likelihood value instead of the logarithm and it is not normalized with
#'   \code{base}.
#' @inheritParams lupost.vec
#' @return log likelihood of the sample-specific mutation rate q_j under the 
#'   background mutation model given the observed mutations.
#' @note This internal function is not intended to be called by the user.
lupost3.vec<-function(t,mutationexist,C,D,uniqueA,tableA)
{
  if (length(t)==1){
    lik <- sum(log(1-exp(t)*uniqueA)*tableA)      
    
    if(mutationexist){
      lik=lik- sum(log(1-exp(t)*C[,2])) + t*nrow(C)+D ### add change of log likelihood due to background mutations
    }
  }else {
    lik <- rowSums(log(1-as.matrix(exp(t))%*%uniqueA)%*%tableA)
    
    if(mutationexist){
      lik=lik- rowSums(log(1-as.matrix(exp(t))%*%C[,2])) + t*nrow(C)+D ### add change of log likelihood due to background mutations
    }
  }
  
  return(  lik+t  )         
}

#' @title Posterior mean of sample-specific mutation rate given the background model
#' @description Calculates the posterior mean of the sample specific mutation
#'   rate under the background mutation model. Similar to
#'   \code{\link{lupost2.vec}} except that it returns the un-normalized 
#'   value for the posterior mean of the sample-specific rate.
#' @inheritParams lupost.vec
#' @return unormalized posterior mean of the sample-specific mutation rate q_j under the 
#'   background mutation model given the observed mutations.
#' @note This internal function is not intended to be called by the user.
lupost4.vec <-function(t,mutationexist,C,D,uniqueA,tableA,base)
{
  if (length(t)==1){
    lik=sum(log(1-exp(t)*uniqueA)*tableA)  ### log likelihood when no background mutations
    
    if(mutationexist){
      lik=lik- sum(log(1-exp(t)*C[,2])) + t*nrow(C)+D ### add change of log likelihood due to background mutations
    }
  }else{
    lik <- rowSums(log(1-as.matrix(exp(t))%*%uniqueA)%*%tableA)
    
    if(mutationexist){
      lik=lik- rowSums(log(1-as.matrix(exp(t))%*%C[,2])) + t*nrow(C)+D ### add change of log likelihood due to background mutations
    }
  }
  
  return( exp( lik+2*t-base  ))         ### the prior distribution of t=log(q) when q~Unif(a,b) is f(t)=exp(t)/(b-a)
}



#' @title Convert chromosome names (character) to numeric
#' @description Function that converts character chromosome names (including
#'   those using "X" and "Y") to numeric values 1-24
#' @param x a character, one of "1", "2", ..., "24", "X", "Y"
#' @return an integer between 1 and 24.  "X" is converted to 23 and "Y" is
#'   converted to 24.  All other values just change classes from character to
#'   numeric ("1" -> 1).
#' @note This internal function is not intended to be called by the user.
number<-function(x)
{
  if( x == "X" )       i=23
  else if(  x == "Y" )      i=24
  else if( x %in% c(as.character(1:24),1:24)) i=  as.numeric( x )
  else i=NA
  return(i)
}


#' @title Retrieve the column from SIFT oject correspoinding to mutated base number
#' @description function to match the mutated base to the appropriate column of
#'   \code{exome.SIFT} (1:4, 2:7, 3:6, 4:5)
#' @details see \code{\link{convert.seq.to.num}} for correspondence of base
#'   letters to numbers and \code{\link{mut.type.converter}} for details of the
#'   structure of \code{exome.SIFT}.
#' @param mutbase an integer 1, 2, 3 or 4
#' @return an integer 4, 5, 6 or 7
#' @note This internal function is not intended to be called by the user.
sift.col <- function(mutbase){
  col <- NA
  if ( mutbase == 1 ) 
    col <- 4
  if ( mutbase == 2 )
    col <- 7
  if ( mutbase == 3 )
    col <- 6
  if ( mutbase == 4 )
    col <- 5
  return(col)
}

#' @title Retrieve the column from SIFT oject correspoinding to mutated base letter
#' @description function to match the mutated base to the appropriate column of
#'   \code{exome.SIFT} ("A":4, "C":7, "G":6, "T":5)
#' @details Similar to \code{\link{sift.col}} except uses the character of bases 
#'   instead of numerical indicator.  See \code{\link{mut.type.converter}}
#'   for details of the structure of \code{exome.SIFT}.
#' @param mutbase a character "A", "C", "G", or "T"
#' @return an integer 4, 5, 6 or 7
#' @note This internal function is not intended to be called by the user.
sift.colA <- function(mutbase){
  col <- NA
  if ( mutbase == "A" ) 
    col <- 4
  if ( mutbase == "C" )
    col <- 5
  if ( mutbase == "G" )
    col <- 6
  if ( mutbase == "T" )
    col <- 7
  return(col)
}

#' @title Simulate new dataset
#' @description Shuffle the observed mutations restricted to same mutation type,
#'   replication region and expression level
#' @param N integer number of simulated datasets to create
#' @param sil.mutab a matrix containing one row per silent mutation and 8 
#'   columns (Ensembl gene name, chromosome, position, variant type (SNP, 
#'   In_frame, Frame_shift), reference allele, tumor allele 1, tumor allele 2, 
#'   and sample id.
#' @param nonsil.mutab a matrix containing one row per nonsilent mutation and 8 
#'   columns (Ensembl gene name, chromosome, position, variant type (SNP, 
#'   In_frame, Frame_shift), reference allele, tumor allele 1, tumor allele 2, 
#'   and sample id.
#' @inheritParams generate.sel.exome
#' @inheritParams calculate.post.probs
#' @param exome.nonsil list object with one item per chromosome where each
#'   item contains matrix with one row per coding base pair and 7 columns: 
#'   position, nucleotide, CpG context, nonsilent indicator (1=nonsilent, 
#'   0=silent) for mutation to "A", nonsilent indicator for mutation to "C", 
#'   nonsilent indicator for mutation to "G", and nonsilent indicator for 
#'   mutation to "T".
#' @param SEED random seed for reproducible results
#' @param dir directory path where to save the simulated datasets for use in 
#'   \code{\link{locfdr}}
#' @param allF logical value indicating whether or not the sample consists of
#'   all females whether or not to shuffle the observed mutations over the Y 
#'   chromosome
#' @return NULL
#' @note This internal function is not intended to be called by the user.
shuffle.muts <- function(N, sil.mutab, nonsil.mutab, exome.constants, gene, 
                         exome.nonsil, exome.SIFT, SEED=NULL, dir=".", allF=TRUE){
  # allF is a logical for whether or not Y-chromosome should be included in the shuffling
  if(!require("data.table")){
    print("trying to install data.table package")
    install.packages("data.table")
    if(require("data.table")){
      print("data.table package is installed and loaded")
    } else {
      stop("could not install data.table package")
    }
  } else {print("data.table package is loaded")}
  
  if ( length(SEED) > 0 ) { set.seed(SEED) }
  
  # set up mutation tables 
  maxchr <- 24
  if (allF){maxchr <- 23}
  mutab <- rbind(sil.mutab, nonsil.mutab)
  mutab <- mutab[sapply(mutab[,2],number) %in% 1:maxchr,]
  mutab.new <- mutab
  mutab.new[,c(1:3)] <- NA
  
  BP <- data.table()
  mutab.tmp <- NULL
  
  d0 <- default.stringsAsFactors()
  options(stringsAsFactors = FALSE)
  
  for(chr in 1:maxchr ){ 
    exome.constants[[chr]] <- cbind(chr, exome.constants[[chr]], NA, NA, NA, NA)
    on.chr <- unlist(lapply(gene, function(x) x[[2]]== number(chr) ))  # pull out all genes on chrom j
    gene.chr <- gene[on.chr]
    pos <- unlist(lapply(gene.chr, function(x) x[[3]] ))
    rep <- unlist(lapply(gene.chr, function(x) rep(x[[4]], length(x[[3]])) ))
    exp <- unlist(lapply(gene.chr, function(x) rep(x[[5]], length(x[[3]])) ))
    or  <- unlist(lapply(gene.chr, function(x) rep(x[[6]], length(x[[3]])) ))
    gn <-  unlist(lapply(gene.chr, function(x) rep(x[[1]], length(x[[3]])) ))
    x <- match(exome.constants[[chr]][,2], pos)
    nores <- is.na(x)
    exome.constants[[chr]][!nores,9:12] <-  cbind(rep[x[!nores]],exp[x[!nores]],or[x[!nores]],gn[x[!nores]])
    BP <- rbindlist(list(BP, data.table(data.frame(exome.constants[[chr]])))) 
    
    mutab.chrom <- cbind(mutab[sapply(mutab[,2],number)==chr,], NA, NA, NA, NA)
    x <- match(as.numeric(mutab.chrom[,3]), pos)
    nores <- is.na(x)
    mutab.chrom[!nores,9:11] <-  cbind(rep[x[!nores]],exp[x[!nores]],or[x[!nores]])
    x <- match(as.numeric(mutab.chrom[,3]), exome.constants[[chr]][,2])
    nores <- is.na(x)
    mutab.chrom[!nores,12] <- exome.constants[[chr]][x[!nores],8]
    mutab.tmp <- rbind(mutab.tmp, mutab.chrom)
  }
  mutab <- mutab.tmp; rm(mutab.tmp)
  BP$V9[is.na(BP$V9)] <- 4
  BP$V10[is.na(BP$V10)] <- 4
  BP$V11[is.na(BP$V11)] <- 1
  BP$V3 <- as.numeric(BP$V3)
  BP$V8 <- as.numeric(BP$V8) 
  BP$V9 <- as.numeric(BP$V9) 
  BP$V10 <- as.numeric(BP$V10)
  BP$V11 <- as.numeric(BP$V11)
  
  for (u in 1:N){
    setkey(BP, V3)
    mut.new <- NULL
    mut <- NULL
    bp <- NULL
    
    for(allele in c("A","T","G","C")) {
      mut <- data.table(data.frame(mutab[mutab[,5]==allele,]))
      mut$Start_Position <- as.numeric(mut$Start_Position)
      mut$V9 <- as.numeric(mut$V9)
      mut$V10 <- as.numeric(mut$V10)
      mut$V11 <- as.numeric(mut$V11)
      mut$V12 <- as.numeric(mut$V12)
      mut$V9[is.na(mut$V9)] <- 4
      mut$V10[is.na(mut$V10)] <- 4
      mut$V11[is.na(mut$V11)] <- 1
      mut$V12[is.na(mut$V12)] <- 4
      setkey(mut, V9, V10, V11)
      
      bp <- BP[J(convert.seq.to.num(allele))]
      setkey(bp, V9, V10, V11)
      
      for (delta in 1:2){
        if (allele %in% c("A","T")) {
          for (s in 1:3){ 
            mutA <- mut[J(s,4,delta)]  # expr missing (4=missing)
            if (nrow(mutA)>0 & sum(!is.na(mutA$Reference_Allele))!=0){	
              bpa <- bp[J(s,1:4,delta)]
              newrows <- sample(1:nrow(bpa), size=nrow(mutA), replace=T)
              mutA$Chrom <- bpa$chr[newrows]
              mutA$Start_Position <- bpa$V2[newrows]
              mutA$Ensembl_gene_id <- bpa$V12[newrows]
              mut.new <- rbind(mut.new, mutA)
            }
            for (h in 1:3){
              if (s==1){
                mutA <- mut[J(4,h,delta)]  # rep missing (4=missing)
                if (nrow(mutA)>0 & sum(!is.na(mutA$Reference_Allele))!=0){
                  bpa <- bp[J(1:4,h,delta)]
                  newrows <- sample(1:nrow(bpa), size=nrow(mutA), replace=T)
                  mutA$Chrom <- bpa$chr[newrows]
                  mutA$Start_Position <- bpa$V2[newrows]
                  mutA$Ensembl_gene_id <- bpa$V12[newrows]
                  mut.new <- rbind(mut.new, mutA, use.names=T)
                }
              }
              
              mutA <- mut[J(s,h,delta)] # both present
              if (nrow(mutA)>0& sum(!is.na(mutA$Reference_Allele))!=0){
                bpa <- bp[J(s,h,delta)]
                newrows <- sample(1:nrow(bpa), size=nrow(mutA), replace=T)
                mutA$Chrom <- bpa$chr[newrows]
                mutA$Start_Position <- bpa$V2[newrows]
                mutA$Ensembl_gene_id <- bpa$V12[newrows]
                mut.new <- rbind(mut.new, mutA, use.names=T)
              }
            }
          }
          mutA <- mut[J(4,4,delta)]  # both missing
          if (nrow(mutA)>0& sum(!is.na(mutA$Reference_Allele))!=0){ 
            bpa <- bp[J(1:4,1:4,delta)]
            newrows <- sample(1:nrow(bpa), size=nrow(mutA), replace=T)
            mutA$Chrom <- bpa$chr[newrows]
            mutA$Start_Position <- bpa$V2[newrows]
            mutA$Ensembl_gene_id <- bpa$V12[newrows]
            mut.new <- rbind(mut.new, mutA, use.names=T)
          }  
        }else if (allele %in% c("G","C")) {	
          setkey(mut, V9, V10, V11, V12)
          setkey(bp, V9, V10, V11, V8)
          for(dinuc in c(1,0)){
            for (s in 1:3){ 
              mutA <- mut[J(s,4,delta,dinuc)]  # expr missing (4=missing)
              if (nrow(mutA)>0 & sum(!is.na(mutA$Reference_Allele))!=0){	
                bpa <- bp[J(s,1:4,delta,dinuc)]
                newrows <- sample(1:nrow(bpa), size=nrow(mutA), replace=T)
                mutA$Chrom <- bpa$chr[newrows]
                mutA$Start_Position <- bpa$V2[newrows]
                mutA$Ensembl_gene_id <- bpa$V12[newrows]
                mut.new <- rbind(mut.new, mutA, use.names=T)   
              }
              for (h in 1:3){
                if (s==1){
                  mutA <- mut[J(4,h,delta,dinuc)]  # rep missing (4=missing)
                  if (nrow(mutA)>0 & sum(!is.na(mutA$Reference_Allele))!=0){ 
                    bpa <- bp[J(1:4,h,delta,dinuc)]
                    newrows <- sample(1:nrow(bpa), size=nrow(mutA), replace=T)
                    mutA$Chrom <- bpa$chr[newrows]
                    mutA$Start_Position <- bpa$V2[newrows]
                    mutA$Ensembl_gene_id <- bpa$V12[newrows]
                    mut.new <- rbind(mut.new, mutA, use.names=T) 
                  }
                }
                
                mutA <- mut[J(s,h,delta,dinuc)] # both present
                if (nrow(mutA)>0& sum(!is.na(mutA$Reference_Allele))!=0){ 
                  bpa <- bp[J(s,h,delta,dinuc)]
                  newrows <- sample(1:nrow(bpa), size=nrow(mutA), replace=T)
                  mutA$Chrom <- bpa$chr[newrows]
                  mutA$Start_Position <- bpa$V2[newrows]
                  mutA$Ensembl_gene_id <- bpa$V12[newrows]
                  mut.new <- rbind(mut.new, mutA, use.names=T) 
                }
              }
            }
            mutA <- mut[J(4,4,delta,dinuc)]  # both missing
            if (nrow(mutA)>0& sum(!is.na(mutA$Reference_Allele))!=0){ 
              bpa <- bp[J(1:4,1:4,delta,dinuc)]
              newrows <- sample(1:nrow(bpa), size=nrow(mutA), replace=T)
              mutA$Chrom <- bpa$chr[newrows]
              mutA$Start_Position <- bpa$V2[newrows]
              mutA$Ensembl_gene_id <- bpa$V12[newrows]
              mut.new <- rbind(mut.new, mutA, use.names=T) 
            }  
          }
          # dinuc missing 
          for (s in 1:3){ 
            mutA <- mut[J(s,4,delta,4)]  # expr missing (4=missing)
            if (nrow(mutA)>0 & sum(!is.na(mutA$Reference_Allele))!=0){	
              bpa <- bp[J(s,1:4,delta,0:1)]
              newrows <- sample(1:nrow(bpa), size=nrow(mutA), replace=T)
              mutA$Chrom <- bpa$chr[newrows]
              mutA$Start_Position <- bpa$V2[newrows]
              mutA$Ensembl_gene_id <- bpa$V12[newrows]
              mut.new <- rbind(mut.new, mutA, use.names=T) 
            }
            for (h in 1:3){
              if (s==1){
                mutA <- mut[J(4,h,delta,4)]  # rep missing (4=missing)
                if (nrow(mutA)>0 & sum(!is.na(mutA$Reference_Allele))!=0){
                  bpa <- bp[J(1:4,h,delta,0:1)]
                  newrows <- sample(1:nrow(bpa), size=nrow(mutA), replace=T)
                  mutA$Chrom <- bpa$chr[newrows]
                  mutA$Start_Position <- bpa$V2[newrows]
                  mutA$Ensembl_gene_id <- bpa$V12[newrows]
                  mut.new <- rbind(mut.new, mutA, use.names=T) 
                }
              }
              
              mutA <- mut[J(s,h,delta,4)] # both present
              if (nrow(mutA)>0& sum(!is.na(mutA$Reference_Allele))!=0){
                bpa <- bp[J(s,h,delta,0:1)]
                newrows <- sample(1:nrow(bpa), size=nrow(mutA), replace=T)
                mutA$Chrom <- bpa$chr[newrows]
                mutA$Start_Position <- bpa$V2[newrows]
                mutA$Ensembl_gene_id <- bpa$V12[newrows]
                mut.new <- rbind(mut.new, mutA, use.names=T) 
              }
            }
          }
          mutA <- mut[J(4,4,delta,4)]  # both missing
          if (nrow(mutA)>0& sum(!is.na(mutA$Reference_Allele))!=0){ 
            bpa <- bp[J(1:4,1:4,delta,0:1)]
            newrows <- sample(1:nrow(bpa), size=nrow(mutA), replace=T)
            mutA$Chrom <- bpa$chr[newrows]
            mutA$Start_Position <- bpa$V2[newrows]
            mutA$Ensembl_gene_id <- bpa$V12[newrows]
            mut.new <- rbind(mut.new, mutA, use.names=T)
          }  
        } 
      }}
    # deal with insertions and deletions - can go anywhere
    mut <- data.table(data.frame(mutab[!(mutab[,5] %in% c("A","G","C","T")),]))
    mut$Start_Position <- as.numeric(mut$Start_Position)
    mut$V9 <- as.numeric(mut$V9)
    mut$V10 <- as.numeric(mut$V10)
    mut$V11 <- as.numeric(mut$V11)
    mut$V12 <- as.numeric(mut$V12)
    mut$V9[is.na(mut$V9)] <- 4
    mut$V10[is.na(mut$V10)] <- 4
    mut$V10[is.na(mut$V11)] <- 1
    mut$V12[is.na(mut$V12)] <- 4
    setkey(mut, V9, V10, V11)
    
    bp <- BP
    setkey(bp, V9, V10, V11)
    for (s in 1:3){ 
      mutA <- mut[J(s,4,delta)]  # expr missing (4=missing)
      if (nrow(mutA)>0 & sum(!is.na(mutA$Reference_Allele))!=0){	
        bpa <- bp[J(s,1:4,delta)]
        newrows <- sample(1:nrow(bpa), size=nrow(mutA), replace=T)
        mutA$Chrom <- bpa$chr[newrows]
        mutA$Start_Position <- bpa$V2[newrows]
        mutA$Ensembl_gene_id <- bpa$V12[newrows]
        mut.new <- rbind(mut.new, mutA)
      }
      for (h in 1:3){
        if (s==1){
          mutA <- mut[J(4,h,delta)]  # rep missing (4=missing)
          if (nrow(mutA)>0 & sum(!is.na(mutA$Reference_Allele))!=0){
            bpa <- bp[J(1:4,h,delta)]
            newrows <- sample(1:nrow(bpa), size=nrow(mutA), replace=T)
            mutA$Chrom <- bpa$chr[newrows]
            mutA$Start_Position <- bpa$V2[newrows]
            mutA$Ensembl_gene_id <- bpa$V12[newrows]
            mut.new <- rbind(mut.new, mutA, use.names=T)
          }
        }
        
        mutA <- mut[J(s,h,delta)] # both present
        if (nrow(mutA)>0& sum(!is.na(mutA$Reference_Allele))!=0){
          bpa <- bp[J(s,h,delta)]
          newrows <- sample(1:nrow(bpa), size=nrow(mutA), replace=T)
          mutA$Chrom <- bpa$chr[newrows]
          mutA$Start_Position <- bpa$V2[newrows]
          mutA$Ensembl_gene_id <- bpa$V12[newrows]
          mut.new <- rbind(mut.new, mutA, use.names=T)
        }
      }
    }
    mutA <- mut[J(4,4,delta)]  # both missing
    if (nrow(mutA)>0& sum(!is.na(mutA$Reference_Allele))!=0){ 
      bpa <- bp[J(1:4,1:4,delta)]
      newrows <- sample(1:nrow(bpa), size=nrow(mutA), replace=T)
      mutA$Chrom <- bpa$chr[newrows]
      mutA$Start_Position <- bpa$V2[newrows]
      mutA$Ensembl_gene_id <- bpa$V12[newrows]
      mut.new <- rbind(mut.new, mutA, use.names=T)
    }
    
    # reformat mut.new for return() -> split into sil and nonsil    
    mutallele <- mut.new$Tumor_Seq_Allele2
    mutallele[mut.new$Tumor_Seq_Allele2 == mut.new$Reference_Allele] <- mut.new$Tumor_Seq_Allele1[mut.new$Tumor_Seq_Allele2 == mut.new$Reference_Allele]
    mut.new$SIFT <-NA
    mut.new$nonsil <-NA
    for (chr in 1:maxchr){
      nonsil.chr <- exome.nonsil[[chr]]
      siftchr <- exome.SIFT[[chr]]
      which.onchr <- which(mut.new$Chrom == chr)
      x <- match(mut.new$Start_Position[which.onchr], siftchr[,1])
      mut.new$SIFT[which.onchr] <- diag(siftchr[x, sapply(mutallele[which.onchr], sift.colA)])
      x <- match(mut.new$Start_Position[which.onchr], nonsil.chr[,1])
      mut.new$nonsil[which.onchr] <- diag(nonsil.chr[x, sapply(mutallele[which.onchr], sift.colA)])
    }
    which.indel <- which(mut.new$Variant_Type %in% c("Frame_shift", "In_frame"))
    mut.new$SIFT[which.indel] <- 1
    mut.new$nonsil[which.indel] <- 1
    which.inframe <- which(mut.new$Variant_Type %in% c("In_frame"))
    mut.new$SIFT[which.inframe] <- 0.95
    sil.mut.new <- data.frame(mut.new[mut.new$nonsil==0,])
    nonsil.mut.new <- data.frame(mut.new[mut.new$nonsil==1,])
    
    write.table(sil.mut.new[,c(4:11,13)], file=paste(dir,"/sil.",u,".txt",sep=""),row.names=FALSE, quote=FALSE )
    write.table(nonsil.mut.new[,c(4:11,13)], file=paste(dir, "/nonsil.",u,".txt",sep=""),row.names=FALSE, quote=FALSE )
  }
  options(stringsAsFactors=d0)
  
}



#' @title Convert HGNC symbols to Ensembl identifiers using biomaRt
#' @description This function takes an MAF table and returns a vector of Ensembl
#'   identifiers corresponding to the HGNC names in the "Hugo_Symbol" column.
#' @param table a matrix of MAF data that contains a column named "Hugo_Symbol"
#'   with the HGNC names
#' @param ensembl an object created by \code{useMart} in the \code{biomaRt}
#'   package which tells the function which version of Ensembl to use
#' @return a vector of Ensembl identifiers corresponding to the HGNC symbols,
#'   obtained from \code{biomaRt}.
#' @note This internal function is not intended to be called by the user.
convert.hgnc.to.ensembl <- function(table, ensembl){
  whichcol <- which(colnames(table) == "Hugo_Symbol")
  hgnc <- table[,whichcol]
  b <- getBM(attributes= c("ensembl_gene_id", "hgnc_symbol"), filters="hgnc_symbol", values= hgnc,  mart=ensembl)
  x <- match(hgnc, b$hgnc_symbol)
  newnames <- b[x,1]
  
  # deal with missing ensembl ids - try to map from Entrez gene ids, then from newer Ens versions
  if (sum(is.na(newnames)) > 0){
    which.missing <- which(is.na(newnames))
    is.ensg <- substr(table[which.missing,whichcol],1,4) == "ENSG"
    newnames[which.missing[is.ensg]] <- table[which.missing[is.ensg],whichcol]
    
    if (sum(is.na(newnames)) > 0){
      which.missing <- which(is.na(newnames))
      whichcol <- which(colnames(table) == "Entrez_Gene_Id")
      entrez <- table[which.missing,whichcol]
      b <- getBM(attributes= c("ensembl_gene_id", "entrezgene"), filters="entrezgene", values=entrez,  mart=ensembl)
      x <- match(entrez, b$entrezgene)
      missnames <- b[x,1]
      newnames[which.missing] <- missnames
      
      if (sum(is.na(newnames)) > 0){
        current <- useMart("ensembl",dataset = "hsapiens_gene_ensembl") 
        which.missing <- which(is.na(newnames))
        whichcol <- which(colnames(table) == "Hugo_Symbol")
        hgnc <- table[which.missing,whichcol]
        b <- getBM(attributes= c("ensembl_gene_id", "hgnc_symbol"), filters="hgnc_symbol", values=hgnc,  mart=current)
        x <- match(hgnc, b$hgnc_symbol)
        missnames <- b[x,1]
        newnames[which.missing] <- missnames
      }
    }
  }
  return(newnames)
}

#' @title Cubic spline logistic regression
#' @description Performs the cubic spline logistic regression for use in the
#'   \code{\link{locfdr}} function
#' @param center numeric vector of the midpoints of the bins
#' @param succ numeric vector of the same length of \code{center} that
#'   corresponds to the number of 'successes' (fulls) in each bin
#' @param fail umeric vector of the same length of \code{center} that
#'   corresponds to the number of 'failures' (nulls) in each bin
#' @param df the number of degrees of freedom for the spline regression
#'   (defaults to 5)
#' @return list object with four elements: \item{z}{numeric vector of midpoints}
#'   \item{probs}{numeric vector of fitted probabilities of success} 
#'   \item{ratio}{numeric vector of the ratio of successes to failures,
#'   accounting for total numbers of successes and failures} \item{df}{the
#'   number of degrees of freedom used for the spline regression}
#' @note This internal function is not intended to be called by the user.
compRatio <- function(center,succ,fail,df=5){ 
  require(splines)
  n<-succ+fail
  ids<-which(n>0)
  z<-center
  tmp<-ns.out<-ns(center[ids],df)
  class(tmp)<-"matrix"
  mat<-data.frame(s=succ[ids],f=fail[ids],tmp)
  glm.out<-glm(cbind(s,f)~.,data=mat,family=binomial)
  newz<-predict(ns.out,z)
  class(newz)<-"matrix"
  probs<-predict(glm.out,data.frame(newz),type="response")
  B<-sum(fail)/sum(succ)
  r<-(1-probs)/(B*probs)
  return(list(z=z,probs=probs,ratio=r))
}


#' @title Estimation of non-null density
#' @description This function utilizes the algorithm for local false discovery
#'   rate (locfdr) estimation from Efron (2001) to estimate the non-null density
#'   of SIFT scores.  Null scores are obtained from the simulated datasets
#'   created using \code{\link{shuffle.muts}}
#' @inheritParams shuffle.muts
#' @param dir a character string that contains the directory path to the
#'   simulated datasets
#' @param N a numeric value that corresponds to how many simulated datasets are
#'   contained in the directory \code{dir}
#' @return a list object with three elements: \item{f0}{numeric vector
#'   containing the estimated null density of FI scores over \code{nbins} bins} 
#'   \item{f1}{numeric vector containing the estimated non-null density of FI
#'   scores over \code{nbins} bins} \item{nbins}{numeric value that represents
#'   how many bins were used for the spline regression}
#' @note This internal function is not intended to be called by the user.
locfdr <- function(nonsil.mutab, exome.SIFT, dir="./simulated", N=100){
  # comparing simulated null to observed full distribution 
  require(splines)
  
  scores.null <- NULL
  for (i in 1:N){
    tab <-read.table(paste(dir,"/nonsil.", i, ".txt", sep=""), header=T)
    scores.null <- c(scores.null, tab$SIFT)
    rm(tab)
  }
  nonsilent.mutation.table <- data.frame(nonsil.mutab, stringsAsFactors = FALSE)
  
  # check that all mutations are nonsilent & pull SIFT scores
  nonsilent.mutation.table$SIFT <- NA
  nonsilent.mutation.table$Chrom <- unlist(sapply(nonsilent.mutation.table$Chrom, number))
  nonsilent.mutation.table <- nonsilent.mutation.table[!is.na(nonsilent.mutation.table$Chrom),]
  for (i in 1:24){
    nonsil.chrom <- nonsilent.mutation.table[nonsilent.mutation.table$Chrom==i, ]
    sift <- exome.SIFT[[i]]
    
    if (nrow(nonsil.chrom)>0){
      pos <- as.numeric(nonsil.chrom$Start_Position)
      if (length(pos)==0){    pos <- as.numeric(nonsil.chrom$Start_position)  }
      ref <- nonsil.chrom$Reference_Allele
      tum1 <- nonsil.chrom$Tumor_Seq_Allele1
      tum2 <- nonsil.chrom$Tumor_Seq_Allele2
      tum2 <- ifelse(ref==tum2, tum1, tum2) 
      
      snps <- which(nonsil.chrom$Variant_Type=="SNP")
      frmshft <- which(nonsil.chrom$Variant_Type=="Frame_shift")
      inframe <- which(nonsil.chrom$Variant_Type=="In_frame")
      
      snp.pos <- match(pos[snps],sift[,1])
      if (length(snp.pos)>0 & sum(is.na(snp.pos)) != length(snp.pos) ) {
        nonsil.chrom$SIFT[snps] <- diag(sift[snp.pos,unlist(sapply(tum2[snps], function(x) mut.base(x))) ])
      }
      if (length(frmshft)>0) {
        nonsil.chrom$SIFT[frmshft] <- 1
      }
      if (length(inframe)>0) {
        nonsil.chrom$SIFT[inframe] <- 0.95
      }
      nonsilent.mutation.table[nonsilent.mutation.table$Chrom==i, ] <- nonsil.chrom
    }
  }
  
  scores.full <- nonsilent.mutation.table$SIFT
  
  
  # remove NAs
  scores.null <- scores.null[!is.na(scores.null)]
  scores.full <- scores.full[!is.na(scores.full)]
  
  # binned 'logistic' regression spline
  B <- length(scores.null)/length(scores.full)
  nbins <- 50
  mid <- seq(1:nbins)-0.5 #mid-points of the nbins intervals
  scores.null.bins <- hist(scores.null, breaks=seq(0,1,length=(nbins+1)), plot=FALSE)$counts #z_i (failures)
  scores.full.bins <- hist(scores.full, breaks=seq(0,1,length=(nbins+1)), plot=FALSE)$counts #Z_i (successes)
  pi <- compRatio(mid, scores.full.bins, scores.null.bins, df=5)$probs
  pi[pi>1] <- 1; pi[pi<0] <- 0
  p0 <- min(1/((1-pi)/(B*pi)))
  post1 <- 1- p0*(1-pi)/(B*pi)
  
  # estimate of f to get f1
  fit.full <- glm(scores.full.bins ~ ns(mid, 5), poisson)
  f <- fitted(fit.full)
  f[f<0] <- 0
  area.f <- sum(f*(1/nbins))
  f <- f/area.f # normalize
  f1 <- post1*f / (1-p0)
  f1[f1<0] <- 0
  area.f1 <- sum(f1*(1/nbins))
  f1 <- f1/area.f1
  f0 <- (1-post1)*f/p0
  f0[f0<0] <- 0
  area.f0 <- sum(f0*(1/nbins))
  f0 <- f0/area.f0
  
  return(list(f0,f1,nbins))
}
