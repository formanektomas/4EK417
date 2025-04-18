#### Missing data & Multiple Imputation (MI) ####
#
#
#### Brief introduction to NA data in R:
#
#
rm(list=ls())
#
#
# 
#
#### Dealing with missing data - 'NA' values
#
#
#
v1 <- c(-10, 5, 3, 0, NA, 1, -1, NA, 4)
class(v1)
length(v1)
summary(v1) # No. of NA values is displayed
# 
# Some specific features of NA handling by R:
#
v1 >= 0 # (NA >= 0) is evaluated as NA
mean(v1)    
range(v1)   
# mean(), var(), sd()
# and other basic data analyses may not be performed
# unless NA's are dealt with properly.
#
mean(v1, na.rm=TRUE) # NA values are ignored during the calculation
#
#
is.na(v1) # Tests the objects, returns TRUE if object (vector element) is NA.
which(is.na(v1)) # returns the indices of TRUE values within a vector (object)
#
v2 <- v1[!is.na(v1)] # All non-NA values from v1 are saved to v2,
v3 <- c(na.omit(v1)) # same result as from the line above.
#
#
# 
#
# Missing values: Loading external data files with missing values (NAs)
#
# By default, only "NA" values and empty data fields get interpreted as NA's.
# (in logical, numeric, integer and complex fields)
# Other NA's (na.strings), such as "..." or "Missing value" must be
# explicitly passed to the read.table / read.csv function
#
#
USA <- read.csv("datasets/USA_states.csv")
# Amended from the state.x77 dataset from the Datasets package
fix(USA) # Are there missing values? How are they encoded?
str(USA) 
# Note the class of variable with missinterpreted NA values...
#
## Assignment 3
?read.csv
## Amend the following "read.csv" command on line 161 to import the "USA_states.csv" file
## properly. 
USA <- read.csv("datasets/USA_states.csv", na.strings = c("...", ))
#
#
#### Missing data & regression analysis
#
rm(list=ls())
wageData <- read.csv("datasets/wage1.csv")
#
#
## Example description ## 
#
# LRM:    lwage ~ (Intercept) + educ + tenure + female + south
#
# A) Data:
#
# 1) From "wage1.csv", we only retrieve a small data sample, n=50
#    for further estimation
# 
# 2) In our n=50 sample, we simulate 6 and 5 MCAR observations in 2 regressors. 
#
# B) Estimation & model comparison
#
# 1) We estimate the benchmark LRM using "full" dataset of n=50
# 2) We estimate the LRM using complete cases only (listwise deletion)
# 3) We estimate the LRM using mean substitution
# 4) Example of multiple imputation in R is provided
#
#
# A.1
set.seed(300)
sample1 <- sample(nrow(wageData), size = 50, replace = F)
full <- wageData[sample1, ] # This is the n=50 sample for benchmark estimation
# rownames in "full" dataframe correspond to randomly selected rows from "wageData"...
row.names(full) <- c(1:50) # fixes row names.
#
#
# A.2 Simulate MCAR missing data for two variables: educ and tenure
set.seed(19)
sample2 <- sample(nrow(full), size = 5, replace = F)
set.seed(111)
sample3 <- sample(nrow(full), size = 6, replace = F)
mcar <- full # step 1, copy all data
mcar[sample2, "educ"] <-  NA  # step 2, generate NAs
mcar[sample3, "tenure"] <-  NA 
sum(complete.cases(mcar)) # complete cases in the mcar dataset
cat("Due to missing data, we have lost a total of n = ", 50-(sum(complete.cases(mcar))), "observations.")
head(mcar[,1:10],20)
#
#
# B.1 Our benchmark model - with no missing data simulated (all n=50 observations used)
LRM.bench <- lm(lwage~educ+tenure+female+south, data = full)
summary(LRM.bench)
#
#
# B.2 LRM on observations with missing data - estimated on complete.cases only
#     .. rows with NA entries are excluded automatically 
LRM.cc <- lm(lwage~educ+tenure+female+south, data = mcar)
summary(LRM.cc) # compare coeffs and significances with "LRM.bench"
#
#
# B.3 LRM on observations with missing data - mean substitution used
# .. Mean substitution split to two steps for clarity,
# .. the following mean substitution routine can be performed more efficiently....
mcar.ms <- mcar # We shall use a new data.frame to make the mean substitution
educ.mean <- mean(mcar.ms$educ, na.rm=T )     # Calculate the means
tenure.mean <- mean(mcar.ms$tenure, na.rm=T ) #
mcar.ms[sample2, "educ"] <- educ.mean         # Mean substitutions
mcar.ms[sample3, "tenure"] <- tenure.mean     # 
#
LRM.ms <- lm(lwage~educ+tenure+female+south, data = mcar.ms)
summary(LRM.ms)
# Compare the coefficients 
library(lmtest)
coeftest(LRM.bench) # benchmark
coeftest(LRM.cc)    # missing data -> negative impact on statistical significance 
coeftest(LRM.ms)    # Mean subistitution -> falsely "improved" results as compared to benchmark
#
#
#
#
#
# B.4 Multiple imputation example - using the {mice} package
# ... tested on version 3.30 of {mice}
#
mcar.mice <- mcar[ , c(22,2,3,4,6,11)] # only select variables/columns of interest
head(mcar.mice,15)
# We shall use a new data.frame for multiple imputation
# .. MI uses ML estimation and does NOT work if dataframe contains
# .. linearly dependent variables and/or combinations such as var1 & log(var1)..
#
# In our illustrative example, missing observations are artificially generated
# .. and we know their nature.
# 
# However, in empirical applications, we often start by describing 
# and visualizing missing data occurences
library("mitml")
library("mice")
library("VIM")
#
md.pattern(mcar.mice)
# each row corresponds to a missing data pattern (1=observed, 0=missing). 
# Rows and columns are sorted in increasing amounts of observations. 
# Top (blue) row represents "full" observations
# Numbers on the left are "row counts", numbers on the right are "variable counts".
#
md.pairs(mcar.mice) # Number of observations per variable pair.
# rr - response-response, both variables are observed
# rm - response-missing, row observed, column missing
# rm - missing-response, row missing, column observed
# mm - missing-missing, both variables are missing
#
# ?marginplot
marginplot(mcar.mice[, c("educ", "tenure")], col = mdc(1:2, trans=F), 
           cex = 1.2, cex.lab = 1.2, cex.numbers = 1.3, pch = 19,
           xlab = "educ", ylab = "tenure")
# Alternatively:
marginplot(mcar.mice[, c("educ", "tenure")])
# .. Blue dots
# .... scatter-plot of observed educ-tenure pairs
#
# .. Purple dots on the "x-axis"
# .... educ is observed (at different levels), yet we have no data on tenure
#
# .. Purple dots on the "y-axis"
# .... tenure is observed (at different levels), yet we have no data on educ
#
# .. "Corner" purple dot 
# .... both educ and tenure are  missing at the same time
#
help(package=mice)
# Create the imputation object
?mice # "pmm" predictive mean matching is the default method for numerical data
# "pmm"
# semi-parametric imputation method. Its main virtues are that imputations are
# restricted to the observed values and that it can preserve non-linear relations
# even if the structural part of the imputation model is wrong.
#
#
imputed.data <- mice(mcar.mice[,-1], m=5, seed=200) # m=5 is the default setting
# mcar.mice[,-1] - depvar "lwage" is removed from the series used for MI.
# .. hence, depvar is not in the imputed datasets and has to be provided
# .. separately for subsequent estimation
#
#
# Imputation summary
str(imputed.data) # see page 16 & 18 of the {mice} PDF file for "pmm" and other methods
# .. pmm - Predictive mean matching
# Actual imputed values for each of the 5 imputations
imputed.data$imp$educ
imputed.data$imp$tenure # note that lines 25 and 33 are present in both imputation sets....
#
# Visualize imputed data
stripplot(imputed.data, pch = 20, cex = 1.2)
# .. y-axes: range of each given variable
# .. x-axes: 0 is the original data, 1 is the first imputation, .... 
# .. Blue dots: observed data (no missing data --> blue dots only)
# .. Purple dots: imputed data
# .. Note how the pmm-based imputed points follow the blue points,
#
# Estimation of a model using MI:
?base::with
LRM.mice <- base::with(imputed.data, lm(mcar.mice$lwage~educ+tenure+female+south))
# .. ~educ+tenure+female+south come from the "imputed.data"
# .. note how depvar is taken from the original data frame
#
#
# Estimation output
LRM.mice
?pool
pool(LRM.mice)
# estimate	 Pooled complete data estimate
# ubar	     Within-imputation variance of estimate
# b	         Between-imputation variance of estimate
# t	         Total variance, of estimate (used for st. error and t-values)
# dfcom	     Degrees of freedom in complete data
# df	       Degrees of freedom of $t$-statistic
# riv	       Relative increase in variance
# lambda	   Proportion of the total variance attributable to the missingness
# fmi	       Fraction of missing information, defined in Rubin (1987)
# ?mipo      #..for additional information on the output
LRM.MI <- summary(pool(LRM.mice)) 
LRM.MI
# 
#
#
#
# Testing two nested models - estimated using {mice} imputation
#
?D1 # linear restrictions on parameters, see References section for discussion:
# https://stefvanbuuren.name/fimd/sec-multiparameter.html#sec:wald
#
# Say, we want to compare the following two models:
# a]  lwage~educ+tenure+female+south  ... our "original model"
# b]  lwage~educ       +female        ... a restricted model
#
original <- with(imputed.data, lm(mcar.mice$lwage~educ+tenure+female+south)) #repeated for convenience
restricted <- with(imputed.data, lm(mcar.mice$lwage~educ+female)) 
stat <- D1(original, restricted) 
summary(stat) # riv = relative increase (in) variance, 
#                     see eq. (2.29) in the link above
#
#######################################
#
# Finally, we can compare coefficients from different estimation methods:
# .. note that s.e. and siginficance information is missing here:
#
Coeffs <- cbind(coef(LRM.bench), coef(LRM.cc), coef(LRM.ms), LRM.MI[,"estimate"])
colnames(Coeffs) <- (c("Benchmark","CompleteCases","MeanSubstitution","MultImputation"))
Coeffs
#
#
#
#
rm(list=ls())
## Assignment 1
## 
## 1) Open the "datasets/hp2_mi.csv" dataset. 
##    This dataset contains an amended HPRICE2 dataset (as used in Wooldridge)
##    .. dataset is shorter and contains missing data (MCAR)
##    
## 2) Use OLS to estimate the equation (complete cases only):
##
##    log(price) <- (Intercept) + log(nox) + dist + rooms + stratio
##
##    .. where:  
##            price       housing price, $
##            nox         nitrox. concentr. in parts per 100m
##            rooms       number of rooms
##            dist        wght dist to 5 employ centers
##            stratio     average student-teacher ratio
##    .. all observations are provided as average values for different districts/areas
##
## 3) Using nrow() and sum(complete.cases()) functions, find out the 
##    proportion of rows with missing data in the dataset.
##    Use the plots shown above to visualize the structure of missing data.
##
## 4) Perform MI, estimation and evaluation of the model based on MI
##    .. Use "seed=200" argument for the mice() function
##
##
#
#
#
#
#
#
#
#