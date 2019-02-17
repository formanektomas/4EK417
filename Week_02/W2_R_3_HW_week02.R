rm(list=ls())
require("eurostat") # install.packages("eurostat")
#
# unemployment - annual data
Unem <- get_eurostat("lfst_r_lfu3rt", time_format = "num")
Unem.labels <- label_eurostat(Unem, fix_duplicated = T)
#
#
# CPI - annual data
CPI <- get_eurostat("prc_hicp_aind", time_format = "num")
CPI.labels <- label_eurostat(CPI, fix_duplicated = T)
#
#
## 1 Filter the data
## - 2000 and newer only (both datasets)
## - filter for NUTS0 level (in Unemployment data, "geo" has 2-digit id)
## - choose 4 - 6 states
##
##
## 2 Choose "reasonable" (general) Unemployment and Inflation variables for Phillips curve estimation.
##   (applies to both datasets)
##
##
## 3 Join the two datasets for estimation
##
##
## 4 Treat Inflation as the dependent variable and estimate a plm() panel model
##   Inf_(it) = \beta_0 + \beta_1 Unem_(it) + a_(i) + u_(it)
##
##
## 5 Interpret your results 
##   .. simplification: assume exogeneity in Unemployment variable
##   .. IVR for panel models will be discussed separately
##
##