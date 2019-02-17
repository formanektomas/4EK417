#### Model selection methods & topics ####
#
#
#
rm(list=ls())
wages <- read.csv("_dataW02/wage1.csv")
wages$lwage <- NULL
# Is the dataset complete?
all(complete.cases(wages))
#
#
## We start by estimating our "benchmark", "theoretically defined"
## LRM for wages. See Wooldridge, Introductory Econometrics, 5th ed.,
## equation 7.4, page 231.
#
W.7.4 <- lm(wage~female+educ+exper+tenure, data=wages)
summary(W.7.4)
#
# AIC
AIC(W.7.4)
# BIC
BIC(W.7.4)
# Adjusted R^2
summary(W.7.4)$adj.r.squared
#
#
#
#### Model selection: Best subset selection method ####
#
#
require("leaps") #install.packages("leaps")
?regsubsets() # note the "method" and "force.in" arguments....
#
# By default, all combinations of up to 8 regressors are evaluated
bestSubset.8 <- regsubsets(wage~., wages)
summary(bestSubset.8)
#
# Let's evaluate "all" 2^22 combinations
# .. dataset has 23 columns, with 22 potential explanatory variables
bestSubset.all <- regsubsets(wage~., wages, nvmax=22)
#
2^22 # FYI
#
summary(bestSubset.all)
#
# Accessing the information from regsubsets() function
# 
# Buil-in plots of the {leaps}
# Shows variables's inclusions at different k (no of regressors)
?plot.regsubsets
plot(bestSubset.all, scale="r2") # the top model maximizes R^2
plot(bestSubset.all, scale="adjr2") # top model maximizes ad.R^2
plot(bestSubset.all, scale="Cp") # top model minimizes Cp and AIC (LRM)
plot(bestSubset.all, scale="bic") # top model minimizes BIC
#
#
#
#
## Alternatively, the plots may be arranged as follows:
best.info <- summary(bestSubset.all) # store the summary as an object
#
# Minimum RSS
plot(best.info$rss, xlab="Number of Explanatory Variables", ylab="RSS")
ii <- which.min(best.info$rss)
points(ii,best.info$rss[ii],pch=20,col="red")
#
# Maximum R^2
plot(best.info$rsq, xlab="Number of Explanatory Variables",ylab="R^2")
ii <- which.max(best.info$rsq)
points(ii,best.info$rsq[ii],pch=20,col="red")
#
# Maximum adj.R^2
plot(best.info$adjr2, xlab="Number of Explanatory Variables",ylab="adj.R^2")
ii <- which.max(best.info$adjr2)
points(ii,best.info$adjr2[ii],pch=20,col="red")
#
# Minimum Cp and AIC identified from a plot
plot(best.info$cp, xlab="Number of Variables",ylab="Cp")
ii <- which.min(best.info$cp)
points(ii,best.info$cp[ii],pch=20,col="red")
#
# Minimum BIC
plot(best.info$bic, xlab="Number of Explanatory Variables",ylab="BIC")
ii <- which.min(best.info$bic)
points(ii,best.info$bic[ii],pch=20,col="red")
#
#
# The above graphs may be summarized as follows:
which.min(best.info$rss)
which.max(best.info$rsq)
which.max(best.info$adjr2)
which.min(best.info$cp)
which.min(best.info$bic)
#
#
# Finally, let's have a look at the "best" model:
# What are the 10 varibles that minimize BIC?
ii <- which.min(best.info$bic)
coef(bestSubset.all, ii)
best.info$rsq[ii]
best.info$adjr2[ii]
# 
#
# A functional method for obtaining regressors & estimating selected LRM:
ii <- which.min(best.info$bic)
name.info <- (best.info$which[ii, ]==TRUE)
VariableSet <- names(name.info[name.info==TRUE])
VariableSet <- VariableSet[-1]
cat(VariableSet, sep="+")
# and copy-paste into a new LRM
best.LRM <- (lm(wage~educ+exper+tenure+female+smsa
                +west+trade+services+profocc+expersq, 
                data = wages))
summary(best.LRM)
# Compare with the "original" model from Wooldridge
summary(W.7.4)
#
#
#
#
#### Model selection: Forward stepwise selection method ####
#
forward.select <- regsubsets(wage~., wages, 
                             nvmax=22, method = "forward")
22^2 # approx. number of models evaluated
summary(forward.select)
#
#
# Default plots
plot(forward.select, scale="r2") # the top model maximizes R^2
plot(forward.select, scale="adjr2") # top model maximizes ad.R^2
plot(forward.select, scale="Cp") # top model minimizes Cp and AIC (LRM)
plot(forward.select, scale="bic") # top model minimizes BIC
#
# 
# Minimum BIC
fwd.info <- summary(forward.select)
plot(fwd.info$bic, xlab="Number of Explanatory Variables",ylab="BIC")
iifwd <- which.min(fwd.info$bic)
points(iifwd,fwd.info$bic[iifwd],pch=20,col="red")
#
coef(forward.select, iifwd)
fwd.info$rsq[iifwd]
fwd.info$adjr2[iifwd]
#
# Compare to Best subset selection results:
coef(bestSubset.all, ii)
best.info$rsq[ii]
best.info$adjr2[ii]
#
#
#### Model selection: Backward stepwise selection method ####
#
#
back.select <- regsubsets(wage~., wages,
                          nvmax=22, method = "forward")
summary(back.select)
#
#
# Default plots
plot(back.select, scale="r2") # the top model maximizes R^2
plot(back.select, scale="adjr2") # top model maximizes ad.R^2
plot(back.select, scale="Cp") # top model minimizes Cp and AIC (LRM)
plot(back.select, scale="bic") # top model minimizes BIC
# Minimum BIC
back.info <- summary(back.select)
plot(back.info$bic, xlab="Number of Explanatory Variables",ylab="BIC")
iib <- which.min(back.info$bic)
points(iib,back.info$bic[iib],pch=20,col="red")
#
coef(back.select, iib)
back.info$rsq[iib]
back.info$adjr2[iib]
# In this particular case, both forward and backward stepwise selection methods lead
# to the same specification (does NOT apply in general)
#
#
# 
#
### Final comparison of the models: ### 
#
#
summary(W.7.4) # Our "benchmark", theoretically defined model
summary(best.LRM) # Model chosen using the "Best subset" method
# .. Generally, FSS and BSS may generate different subsets
# .. Global minimum for BIC is NOT guaranteed
# Here, Forward stepwise and Backward stepwise methods 
# select the same subset 
# (inferior to the best subset selection method
# all results are VALID FOR A GIVEN DATASET ONLY ! )
FSS <- lm(wage~educ+tenure+female+smsa+west+trade+services+profocc, data=wages)
summary(FSS)
#
BIC(W.7.4) # BIC for the benchmark model
BIC(best.LRM) # The global minimum for BIC among all possible subsets
BIC(FSS) # BIC for the Forward stepwise and Backward stepwise methods
#
#
#
#
## Assignment 1
rm(list=ls())
htv.data <- read.csv("_dataW02/htv.csv")
head(htv.data)
## 
## Data description: 
##
##      educ  highest grade completed by 1991
##        ne         =1 if in northeast, 1991
##        nc         =1 if in nrthcntrl, 1991
##      west              =1 if in west, 1991
##     south             =1 if in south, 1991
##     exper             potential experience
##  motheduc            highest grade, mother
##  fatheduc            highest grade, father
##  brkhme14        =1 if broken home, age 14
##      sibs               number of siblings
##     urban        =1 if in urban area, 1991
##      ne18              =1 if in NE, age 18
##      nc18              =1 if in NC, age 18
##   south18           =1 if in south, age 18
##    west18            =1 if in west, age 18
##   urban18      =1 if in urban area, age 18
##    tuit17          college tuition, age 17
##    tuit18          college tuition, age 18
##     lwage                        log(wage)    is the dependent variable
##   expersq                          exper^2
##
##
## A) BEST SUBSET SELECTION
##
## 1) Use best subset selection method to choose best regressors for lwage
##    .. hint: set nvmax to 17.
##
## 2) Using the plot.regsubsets(), find out which specification leads to
##    minimum BIC.
##
## 3) Get beta coefficients of the LRM found at step 2 and store the BIC statistics
##    Bonus: estimate the LRM found at step 2 using lm()
##
##
## B) FORWARD STEPWISE SELECTION
##
## 4) Use forward stepwise selection to find "best" regressor sets
##
## 5) Using the plot.regsubsets(), find out, which specification minimizes the BIC statistics
##
## 6) Estimate the LRM found at step 5 and compare with the BIC obtained 
##    through best subset selection.
##
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
#