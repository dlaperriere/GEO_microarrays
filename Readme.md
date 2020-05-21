## Differential expression analysis of published microarrays datasets from  the NCBI Gene Expression Omnibus (GEO)


### analyze_geo_microarrays.py
     python analyze_geo_microarrays.py  -g MCF7_E2_CHX.GSE8597.analysis.txt

**geo dataset file format (-g filename, tsv)**

parameter | value
--------- | ----------- 
gse       | GSE#      e.g. GSE8597  
gpl       | GPL#      e.g. GPL570
samples   | filename   
contrast  | treatment-control    e.g. E2-EtOH
contrast  | treatment2-control2
contrast  | ...

**samples file format (tsv)**

ID            | sample                          | condition
------------- | ------------------------------- | --------- 
GSM213318     | MCF7_CHX_E2_24h_rep1            | CHX_E2
GSM213322     | MCF7_CHX_EtOH_24h_rep1          | CHX_EtOH
GSM213326     | MCF7_E2_24h_rep1                | E2
GSM213330     | MCF7_EtOH_24h_rep1              | EtOH

  
### Output

- text version of the differential expression analysis results for each contrast in the DiffExpression folder
- QC figures in the Figure folder
- RData file with the ExpressionSet object
- Excel file with all the differential expression analysis results

![results](/images/result_files.png?raw=true)
![excel](/images/result_excel.png?raw=true)

### Installation
 

**Python modules**

      pip install openpyxl
      pip install pillow
    
 **R packages**
 
 - Bioconductor : GEOquery, limma
 - CRAN  : corrgram, getopt, gplots


      # run R/install_packages.R


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
  
  
### Version

  Python 3.8.2
  
  R 3.6.3
  
### Copyright

David Laperriere dlaperriere@outlook.com
