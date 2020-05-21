################################################################
## CRAN packages
# corrgram: Plot a Correlogram                            URL: https://cran.r-project.org/web/packages/corrgram/index.html
# getopt  : C-like getopt behavior                                                              
# gplots  : Various R Programming Tools for Plotting Data 

r <- getOption("repos")             # hard code the US repo for CRAN
r["CRAN"] <- "http://cran.us.r-project.org"
options(repos = r)

cran_pkg = c("corrgram", "getopt", "gplots")

for(pkg in cran_pkg){
 print(pkg)
  if (!require(pkg, character.only=TRUE)) install.packages(pkg)

}

################################################################
## Bioconductor packages

if (!require("Biobase")) {
 source("http://bioconductor.org/biocLite.R") #biocLite("BiocUpgrade")
 biocLite()
} 

# limma   : Linear Models for Microarray Data                URL: http://bioconductor.org/packages/release/bioc/html/limma.html
# GEOquery: Get data from NCBI Gene Expression Omnibus (GEO)
bioc_pkg = c("limma","GEOquery")

for(pkg in bioc_pkg){
  print(pkg)
  if (!require(pkg, character.only=TRUE)) {
    source("http://bioconductor.org/biocLite.R")
    biocLite(pkg)
  } 
} 

# Lists all the packages installed locally
#library()
