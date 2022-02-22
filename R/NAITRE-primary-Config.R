#-----------------------------
# NAITRE_interim_Config.R
#
# configuration file for
# the NAITRE interim analyses
#-----------------------------

#-----------------------------
# load packages
#-----------------------------
library(tidyverse)
library(table1)
library(data.table)
library(epitools)
library(kableExtra)
library(scales)
library(labelled)
library(foreach)
library(doParallel)
library(magrittr)
library(lubridate)
library(epiR)
library(ggmap)
library(sf)
library(cowplot) # for ggdraw
library(ggsn) # for scale bars and north symbols
library(rnaturalearth) # for africa country outlines
library(codebook) # for codebook generation
library(labelled) # for adding labels to datasets

#-----------------------------
# unmasked
# treatment assignments
#-----------------------------
Az <- c("RR", "SS", "TT", "WW")
Pl <- c("UU", "XX", "YY", "ZZ")

#-----------------------------
# load functions
#-----------------------------
source(here("NAITRE-primary/R/functions","calc_ratio.R"))
source(here("NAITRE-primary/R/functions","calc_ratio_pval.R"))
source(here("NAITRE-primary/R/functions","get_p_int.R"))
source(here("NAITRE-primary/R/functions","get_subgroup_ratio.R"))