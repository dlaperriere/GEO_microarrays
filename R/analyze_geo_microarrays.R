#!/usr/bin/env Rscript

# Differential expression analysis of published microarrays datasets from the NCBI Gene Expression Omnibus (GEO) 
#
# Usage: 
#  Rscript analyze_geo_microarrays.R --gse GSE8597 --gse_samples GSE8597.txt --gpl GPL570 --gpl_info gpl_info.txt --contrast CHX_E2-CHX_EtOH 
#
# Note: 
#  based on GEO2R http://www.ncbi.nlm.nih.gov/geo/geo2r/
#
# Copyright
# David Laperriere dlaperriere@outlook.com

# QC figures parameters
n_mostvargenes = 150
figwidth = 512
figheight = 512

###############################################################
# R libs

write("* Load utlity methods ", stdout())

initial.options <- commandArgs(trailingOnly = FALSE)
file.arg.name <- "--file="
script.name <- sub(file.arg.name, "", initial.options[grep(file.arg.name, initial.options)])
script.basename <- dirname(script.name)

source(paste(sep = "/", script.basename, "utils.R"))


write("* Load R packages", stdout())

Rpkg = c("corrgram", "getopt", "gplots","limma","GEOquery")
for(pkg in Rpkg){
  suppressPackageStartupMessages(require(pkg, character.only=TRUE))
} 

# set GEOquery download file method
if(capabilities("libcurl")){
     options('download.file.method.GEOquery' = 'libcurl')
}

###############################################################
# Parameters

write("* Check parameters", stdout())

opts = matrix(c(
     "help"       , "h", 0, "logical", 
     "verbose"    , "v", 0, "logical", 
     "contrast"   , "c", 1, "character", 
     "gse"        , "g", 1, "character", 
     "gse_samples", "s", 1, "character", 
     "gpl"        , "p", 1, "character", 
     "gpl_info"   , "i", 1, "character"
    ), ncol = 4, byrow = TRUE)

parameters = getopt(spec = opts, debug = F)

if (!is.null(parameters$help) || 
    is.null(parameters$gse)  || is.null(parameters$gse_samples) || 
    is.null(parameters$gpl) || is.null(parameters$gpl_info) || 
    is.null(parameters$contrast)  ) {
    parameters$help = TRUE
}


# Display help message
if (!is.null(parameters$help)) {
    
    self = commandArgs()[1]  #only works when invoked with Rscript
    if (is.null(self)) {
        self = "Rscript analyze_geo_microarrays.R"
    }
    
    cat("---------------------------------------\n")
    cat(paste("Usage: ", self, " --contrast|-c treat-ctrl --gse|-g GSE8597 --gse_samples|-s samples.txt --gpl|-p GPL570 --gpl_info|-i gpl_info.txt \n", sep = ""))
    q(status = 0)
}


gse <- parameters$gse
if (length(gse) == 0) {
  stop("cannot use empty GSE (--gse/-g) ...")
}
gpl <- parameters$gpl
if (length(gpl) == 0) {
  stop("cannot use empty GPL (--gpl/-p) ...")
}
contrast <- parameters$contrast

# read sample info 
# ID        | sample                           | condition 
# GSM692735 | siControl treated with DMSO rep1 | siControlDMSO 
# GSM692736 | siControl treated with E2 rep1   | siControlE2
gse_samples <- read.csv(file = parameters$gse_samples, sep = "\t")

# read platform info 
# GPL    | Gene        | GeneID  | Transcript        | platform 
# GPL570 | Gene.symbol | Gene.ID | GenBank.Accession | Affymetrix Human Genome U133 Plus 2.0 Array
gpl_info <- read.csv(file = parameters$gpl_info, sep = "\t", stringsAsFactors = F)


###############################################################
# Differential expression analysis with limma

sml <- gsub(" ", "", gse_samples$condition)
rdata <- paste(gse, "RData", sep = ".")

geodata_dir = paste(sep = "/", script.basename, "../GeoData")
makedir(geodata_dir)
makedir("DiffExpression")
makedir("Figures")

write("* Download GSE data from NCBI/GEO", stdout())
if (file.exists(rdata)) {
    load(rdata)
} else {
    
    
    Sys.sleep(3)
    gset <- getGEO(gse, GSEMatrix = TRUE, destdir = geodata_dir)
    
    
    if (length(gset) > 1) 
        idx <- grep(gpl, attr(gset, "names")) else idx <- 1
    gset <- gset[[idx]]
    
    # make proper column names to match toptable
    fvarLabels(gset) <- make.names(fvarLabels(gset))
    
    # log2 transform
    ex <- exprs(gset)
    qx <- as.numeric(quantile(ex, c(0, 0.25, 0.5, 0.75, 0.99, 1), na.rm = T))
    LogC <- (qx[5] > 100) || (qx[6] - qx[1] > 50 && qx[2] > 0) || (qx[2] > 0 && qx[2] < 1 && qx[4] > 1 && qx[4] < 2)
    if (LogC) {
        ex[which(ex <= 0)] <- NaN
        exprs(gset) <- log2(ex)
    }
    
    save(gset, file = rdata)
}


cat(as.character(gset@phenoData@data$description[1]), file = paste(gse, "description.txt", sep = "."))

write("* Setup the design and proceed with analysis", stdout())
fl <- as.factor(sml)
if (!is.null(parameters$verbose)) {
   #gset
    fl
    contrast
}

if (!all(length(gse_samples$ID) == length(colnames(gset)))) {
  print( paste("ID:", length(gse_samples$ID)) )
  print( paste("GEO ExpressionSet:",length(colnames(gset))) )
  stop( "sample ID and expression set must be the same length...")
}

if (!all(gse_samples$ID == colnames(gset))) {
  print(gse_samples$ID == colnames(gset))
  stop( "sample ID and expression set must be the in the same order...")
}

# set design and contrast
gset$description <- fl
design <- model.matrix(~description + 0, gset)
colnames(design) <- levels(fl)
fit <- lmFit(gset, design)
if (!is.null(parameters$verbose)) {
    design
}

cont.matrix <- makeContrasts(contrast, levels = design)
cont.matrix


# calculate moderated t-statistics, moderated F-statistic, and log-odds of differential expression by 
# empirical Bayes moderation of the standard errors towards a common value
fit2 <- contrasts.fit(fit, cont.matrix)
fit2 <- eBayes(fit2, 0.01)

# adjust P-values & add Fold Change
num_genes = length(featureNames(gset))
tT <- topTable(fit2, adjust = "fdr", sort.by = "B", number = num_genes, coef = 1)
tT$FC = (abs(tT$logFC)/tT$logFC) * 2^abs(tT$logFC)


write("* Download GPL annotation from NCBI/GEO", stdout())

gpl_annot = paste(geodata_dir, "/", gpl, ".annot.gz", sep = "")
if (file.exists(gpl_annot)) {
    
    if (file.info(gpl_annot)$size <= 0) {
        rm_status = file.remove(gpl_annot)
    }
}

platf <- getGEO(gpl, AnnotGPL = TRUE, destdir = geodata_dir)
ncbifd <- data.frame(attr(dataTable(platf), "table"))


# replace original platform annotation & save results
write("* Save results", stdout())

tT <- tT[setdiff(colnames(tT), setdiff(fvarLabels(gset), "ID"))]
tT <- merge(tT, ncbifd, by = "ID")
tT <- tT[order(tT$P.Value), ]  # restore correct order

colnames(tT) = tolower(colnames(tT))
write(" gpl columns:", stdout())
colnames(tT)

gpl_gene <- gsub(" ", "\\.", gpl_info[gpl_info$GPL == gpl, ]$Gene)
gpl_geneid <- gsub(" ", "\\.", gpl_info[gpl_info$GPL == gpl, ]$GeneID)
gpl_transcript <- gsub(" ", "\\.", gpl_info[gpl_info$GPL == gpl, ]$Transcript)
subcols = tolower(c("ID", gpl_gene, gpl_geneid, gpl_transcript, "FC", "logFC", "AveExpr", "t", "P.Value", "adj.P.Val"))
tT <- subset(tT, select = subcols)

write(" gpl_info columns:", stdout())
# subcols
gpl_gene
gpl_geneid
gpl_transcript

contrast = gsub('[^[:alnum:]_ ()+-]', '_', contrast)
write.table(tT, file = paste("DiffExpression/diffexp", gse, contrast, "txt", sep = "."), row.names = F, sep = "\t")


###############################################################
# QC figures

write("* Generate QC figures", stdout())

ex <- exprs(gset)
colnames(ex) = sml
ex <- ex[, order(sml)]

topvar = order(RowVar(ex), decreasing = TRUE)[1:n_mostvargenes]

boxplot_figname = paste("Figures/boxplot", gse, "png", sep = ".")

if(!file.exists(boxplot_figname)){

# Expression boxplot
 png(filename = boxplot_figname, width = figwidth, height = figheight) 
 # par(mar=c(2+round(max(nchar(colnames(ex)))/2),4,2,1))
 title <- paste(gse, sep = "")
 boxplot(ex, boxwex = 0.6, notch = F, main = title, outline = FALSE, las = 2, col = as.factor(colnames(ex)))
 dev.off()

# N most variable genes correlogram/heatmap
 png(filename = paste("Figures/correlogram", gse, "topvar.png", sep = "."), width = figwidth, height = figheight)
 title <- paste(" ", gse, " (", n_mostvargenes, " most variable genes)", sep = "")
 corrgram(ex[topvar, ], order = FALSE, lower.panel = panel.shade, upper.panel = panel.pie, text.panel = panel.txt, main = title)
 dev.off()

 png(filename = paste("Figures/heatmap", gse, "topvar.png", sep = "."), width = figwidth, height = figheight)
 title <- gse
 ytitle <- paste(n_mostvargenes, " most variable genes", sep = "")
 heatmap.2(ex[topvar, ], trace = "none", density.info = "none", col = greenred(10), dendrogram = "column", ylab = ytitle, margins = c(7, 7), main = gse)
 dev.off()
}

## -30-
write("* Done", stdout())
if (!is.null(parameters$verbose)) {
    sessionInfo()
}
q(status = 0) 
