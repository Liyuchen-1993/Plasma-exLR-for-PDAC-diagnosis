# Plasma-exLR-for-PDAC-diagnosis

## ***Summary***

This repository summarized the source R Codes of statistical analysis for the article gutjnl-2019-318860,  it also contains the detail description of data manipulating process so that others can replicate the results or use the d-signature in clinical practice or validation studies.

## ***Download and Install***

System requirements: R >= 3.4.2. Linux system is officially supported, but Mac/Windows should work, too.

To download the new version of the R packages, type the following at the R command line:

`install.packages("glmnet")`

`install.packages("caret")`

`install.packages("pROC")`

`install.packages("varSelRF")`

`install.packages("e1071")`

`install.packages("Rtsne")`

After installing, you have to load to use the package, with: library("glmnet").

For more detailed usage instructions, see the manuscript : gutjnl-2019-318860

## ***Available main process and detail description***

| **Main processes**                                           | **Detailed description**                                     |
| ------------------------------------------------------------ | :----------------------------------------------------------- |
| The specimen collection and exLR-seq bioinformatics analyses. | Five hundred and one participants, PDAC (n=284), CP (n=100), and healthy controls (n = 117) were enrolled. The RNA-seq reads filter perform by **FastQC** software, the reads mapping evaluated by **RnaSeqMap/Hisat2** software. |
| Expression profile normalization,     dimensionality reduction and visualization. | The quantification and normalization (TPM) of exLR-seq profiles were manipulated by **SanRPKM/FeatureCount** software. The dimensional reduction and visualization of variates was conducted by t-SNE algorithm through R package "**Rtsne**". |
| Different expression analysis and pathway enrichment analysis | The different expression analysis for total samples were performed by Mann-Whitney U test (FDR<0.05, fold change>2). The DEGs were used to perform enrichment annotation of KEGG pathway. |
| Grouping of total samples, potential diagnostic power estimation | Training cohort (Healthy=51; CP=16;   PDAC=121), internal validation cohort (Healthy=23; CP=44;   PDAC=68), external validation cohort (Healthy=43; CP=40; PDAC=95). The **PASS** software was used to estimate the potential diagnostic power based on studied samples. |
| Training cohort    different expression analysis and Feature selection | The different expressed exLRs were selected by Mann-Whitney U test integrated pancreatic tissue and plasma samples (FDR<0.05, fold change>1.4), and LASSO and Random forest algorithm performed by R package "**glmnet**" and "**varSelRF**" were used to process feature selection. |
| Diagnostic model construction, parameter tuning and d-signature developing | The eight candidate markers were used to establish classifier by SVM algorithm through "**e1071**" R package. Five-fold internal cross-validation method was implemented by 'caret' package for SVM parameters tuning. The d-signature was quantitated by predict strength of SVM model output. |
| D-signature validated in internal and external validation cohort. | The training diagnostic model was used to estimate d-signature tested across two validation cohorts and the diagnostic efficacy (**Sn, Sp, AUC and accuracy**) were estimated by **SPSS** and R package “**pROC**”. |


