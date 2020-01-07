### Modelling Prices of Census Tracts in Boston
#
# Apply PCA and PCR
#
#
rm(list=ls())
require(Ecdat)
mydataset <- Hedonic[1:200,]
testsample <- Hedonic[201:506,]
?Hedonic
# mv is the dependent variable
str(mydataset)
#
#
# Pre-processing, step 1:
# convert "chas" to 0-1 dummy variable 

mydataset$chas <- 
testsample$chas <- 

# Pre-processing, step 2:
# store all variables except for the dependent variable in "mat" matrix

mat <- 

#
#########################
######### PCA ###########
#########################
require(psych)
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
require(pls)
#
#
# Step 1 - use pcr() from the {pls} package. to calculate PCR: mv ~ .
set.seed(10)


# Step 2 - perform the CV-based selection of components to be used in PCR
#          display the plot



# Step 3 - plot PCR-fitted vs observed "mv" values.


# Step 4 - calculate test sample MSE
#          OLS-based test sample is: 0.145   
#          .. (verify OLS-based MSE as a bonus assignment)





