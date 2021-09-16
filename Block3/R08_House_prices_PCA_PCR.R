### Modelling Prices of Census Tracts in Boston
#
# Apply PCA and PCR
#
#
rm(list=ls())
library(Ecdat)
mydataset <- Hedonic
?Hedonic
# mv is the dependent variable
str(mydataset)
#
#
# Pre-processing, step 1:
x <- model.matrix(mv~.,mydataset)[,-1]
# y <- mydataset$mv
#
#########################
######### PCA ###########
#########################
library(psych)
#
# Step 1 - perform the KMO test



# Step 2 - perform PCA using the {stats} function prcomp()
#          use the summary() function



# Step 3 - show the loading vectors 


# Step 4 - display the PCA plot


# Step 5 - display principal components (Z vectors)


#
#
#########################
######### PCR ###########
#########################
library(pls)
#
#
# Step 1 - use pcr() from the {pls} package. to calculate PCR: mv ~ .
set.seed(10)


# Step 2 - perform the CV-based selection of components to be used in PCR
#          display the plot



# Step 3 - plot PCR-fitted vs observed "mv" values.








