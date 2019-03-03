#### Missing data & Multiple Imputation (MI) ####
#
#
#
#
#
rm(list=ls())
wageData <- read.csv("_dataW03/wage1.csv")
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
# 2) In our n=50 sample, we simulate 6 and 4 MCAR observations in 2 regressors 
#    (10 missing values total).
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
set.seed(99)
sample2 <- sample(nrow(full), size = 5, replace = F)
sample3 <- sample(nrow(full), size = 6, replace = F)
mcar <- full # step 1, copy all data
mcar[sample2, "educ"] <-  NA  # step 2, generate NAs
mcar[sample3, "tenure"] <-  NA 
sum(complete.cases(mcar)) # complete cases in the mcar dataset
cat("Due to missing data, we have lost a total of n = ", 50-(sum(complete.cases(mcar))), "observations.")
fix(mcar)
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
# Compare the three models: coefficients and VIFs
require(lmtest)
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
# In our illustrative example, missing data are artificially generated
# .. and we know their nature.
# 
# However, in empirical applications, we often start by describing 
# and visualizing missing data occurences
require("mice")
require("VIM")
#
md.pattern(mcar.mice)
# each row corresponds to a missing data pattern (1=observed, 0=missing). 
# Rows and columns are sorted in increasing amounts of missing information. 
# The last column and row contain row and column counts, respectively.
#
md.pairs(mcar.mice) # Number of observations per variable pair.
# rr - response-response, both variables are observed
# rm - response-missing, row observed, column missing
# rm - missing-response, row missing, column observed
# mm - missing-missing, both variables are missing
#
marginplot(mcar.mice[, c("educ", "tenure")], col = mdc(1:2, trans=F), 
           cex = 1.2, cex.lab = 1.2, cex.numbers = 1.3, pch = 19,
           xlab = "educ", ylab = "tenure")
# x-axis:
# .. minimum educ (blue dot corresponds to educ=5 (x-axis) and tenure = 0 (y-axis)
#
# .. Purple dots on the "x-axis"
# .... "corner" purple dot: educ and tenure are both missing (2 instances) 
# .... educ = 12 and tenure is missing (2 instances)
# .... educ = 13 and tenure is missing (3 instances)
#
# y-axis
# .. Purple dots on the y-axis correspond to instances
# .. with observed tenure and missing (not-determined) values of educ.
#
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
imputed.data <- mice(mcar.mice, m=5, seed=200) # m=5 is the default setting
# Imputation summary
imputed.data # see page 16 & 18 of the {mice} PDF file for "pmm" and other methods
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
# .. Note that the imputed points follow the blue points reasonably well,
#    including the gaps in the distribution
#
# Estimation of a model using MI:
?with
LRM.mice <- with(imputed.data, lm(lwage~educ+tenure+female+south))
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
?pool.compare
# Say, we want to compare the following two models:
# a]  lwage~educ+tenure+female+south  ... our "original model"
# b]  lwage~educ       +female        ... a restricted model
#
original <- with(imputed.data, lm(lwage~educ+tenure+female+south)) #repeated for convenience
restricted <- with(imputed.data, lm(lwage~educ+female)) 
stat <- pool.compare(original, restricted, method = "wald") # for lm() models
stat
stat$p
#
#######################################
#
# Finally, we can compare coefficients from different estimation methods:
# .. note that s.e. and siginficance information is missing here:
#
Coeffs <- cbind(coef(LRM.bench), coef(LRM.cc), coef(LRM.ms), LRM.MI[,1])
colnames(Coeffs) <- (c("Benchmark","CompleteCases","MeanSubstitution","MultImputation"))
Coeffs
#
#
#
#
rm(list=ls())
## Assignment 1
## 
## 1) Open the "_dataW03/hp2_mi.csv" dataset. 
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
##
## 4) Perform MI, estimation and evaluation of the model based on MI
##    ..hint: replicate the steps on lines 91-107
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