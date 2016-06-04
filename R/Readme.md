## Differential expression analysis of published microarrays datasets from  the NCBI Gene Expression Omnibus (GEO)


### analyze_geo_microarrays.R
     Rscript analyze_geo_microarrays.R --gse GSE8597 --gse_samples GSE8597.txt --gpl GPL570 --gpl_info gpl_info.txt --contrast CHX_E2-CHX_EtOH

**gpl_info file format**

GPL      | Gene        | GeneID  | Transcript        | platform
-------- | ----------- | ------- | ----------------- | ----------
GPL570   | Gene.symbol | Gene.ID | GenBank.Accession | Affymetrix Human Genome U133 Plus 2.0 Array
GPL10558 | Gene.symbol | Gene.ID | GenBank.Accession | Illumina HumanHT-12 V4.0 expression beadchip

**gse_samples file format**

ID            | sample                          | condition
------------- | ------------------------------- | --------- 
GSM213318     | MCF7_CHX_E2_24h_rep1            | CHX_E2
GSM213322     | MCF7_CHX_EtOH_24h_rep1          | CHX_EtOH
GSM213326     | MCF7_E2_24h_rep1                | E2
GSM213330     | MCF7_EtOH_24h_rep1              | EtOH

### Methods


Differential expression analysis using the limma R/Bioconductor package. P-values are adjusted for multiple comparisons with the Benjamini & Hochberg method.


**References**

 1. W. Huber, V.J. Carey, R. Gentleman, ..., M. Morgan
 Orchestrating high-throughput genomic analysis with Bioconductor. 
 Nature Methods, 2015:12, 115.
  
 2. Smyth, GK (2005). 
 Limma: linear models for microarray data. In:  'Bioinformatics and Computational Biology Solutions using R and  Bioconductor'. R. Gentleman, V. Carey, S. Dudoit, R. Irizarry, W.
  Huber (eds), Springer, New York, pages 397-420.
  
 3. Benjamini, Y., and Hochberg, Y. (1995). 
 Controlling the false discovery rate: a practical and powerful approach to multiple testing. 
  Journal of the Royal Statistical Society Series B 57, 289-300.
  
  
### Installation
 
 - Bioconductor packages : GEOquery, limma
 - CRAN packages : corrgram, getopt, gplots

        #run install_packages.R
 
### Version

  R  3.2.2

### Copyright

David Laperriere dlaperriere@outlook.com
