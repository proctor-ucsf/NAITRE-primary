# NAITRE-primary

Public repository for the primary mortality analysis of the NAITRE trial: Neonates and Azithromycin: An Innovation in the Treatment of Children

## Description

This repo includes the R code to complete all analyses for the article:

_Neonatal Azithromycin Administration for Prevention of Infant Mortality_, Oldenburg et al. _NEJM Evidence_ 2022. https://doi.org/10.1056/EVIDoa2100054

https://evidence.nejm.org/doi/full/10.1056/EVIDoa2100054 

This repo is mirrored on the Open Science Framework (OSF), where we have additionally archived the study's datasets and computational notebook output files: https://osf.io/ujeyb/

## To run the analyses

1. Clone this repository
2. Download the two analysis datasets from https://osf.io/ujeyb/. Save the datasets in a subdirectory named: `NAITRE-primary/data/final` 
3. Create a subdirectory to save the analysis output: `NAITRE-primary/output/`
4. Run the `.Rmd` files in the  `NAITRE-primary/code/analysis` directory.  They will generate `.html` files in the output directory with the results.

We have archived the `.html` output files from the final analysis as associated files for release 1 of this repository and also on OSF.

## System Requirements

All analyses were run using R software version 4.1.1 on Mac OSX Catalina using the RStudio IDE (https://www.rstudio.com).

```> sessionInfo()```   
```R version 4.1.1 (2021-08-10)```   
```Platform: x86_64-apple-darwin17.0 (64-bit)```   
```Running under: macOS Catalina 10.15.7```   

## Installation Guide

You can download and install R from CRAN: https://cran.r-project.org

You can download and install RStudio from their website: https://www.rstudio.com

All R packages required to run the analyses are sourced in the file NAITRE-primary-Config.R.

The installation time should be < 10 minutes total on a typical desktop computer.
