#
#################################
#### k-fold Cross Validation #### 
#################################
#
# 
## Resampling 
#  Can be computationally expensive, because it involves fitting 
#  the same statistical method multiple times, using different
#  subsets of the (training) data.
#
## k-Fold Cross-validation 
#  Can be efficiently used to estimate the test
#  error associated with a given estimation method and/or 
#  model specification - in order to evaluate its performance, 
#  or to select the appropriate level of flexibility.
#  (Bias vs. Variance tradeoff)
#
#  Involves randomly dividing the set of observations into k groups, 
#  or folds, of approximately equal size. The first fold is treated as 
#  a validation set, and the method is fit on the remaining k - 1 folds. 
#  The mean squared error is then computed on the observations in the held-out fold. 
#  This procedure is repeated k times; each time, a different group of 
#  observations is treated as a validation set.
#
#  Very general approach, can be applied to almost 
#  any statistical learning method 
#  (OLS, logit, Ridge, Lasso, KNN, PC regression, etc.)
#
#
#
# 
# Data - Swiss Labor example continued
rm(list=ls())
library(AER) # install.packages("AER")
data("SwissLabor")
?SwissLabor
# We transform the dependent variable into a binary (dummy) variable
SwissLabor$parti <- ifelse(SwissLabor$participation == "yes",1,0)
attach(SwissLabor)
#
#
# Model estimation: OLS, Logit, Probit
OLS.FIT <- glm(parti ~ age + I(age^2) + income, family=gaussian(link = "identity"))
summary(OLS.FIT)     
LOG.FIT <- glm(parti ~ age+ I(age^2)+income, family=binomial(link="logit"))
summary(LOG.FIT)
PROB.FIT <- glm(parti ~ age+ I(age^2)+income, family=binomial(link="probit"))
summary(PROB.FIT)
#
# Additional model specification, include "education" and income^2 as regressors
OLS.FITa <- glm(parti ~ age + I(age^2) + income + education + I(income^2))
summary(OLS.FITa)     
LOG.FITa <- glm(parti ~ age+ I(age^2)+income+education + I(income^2), 
               family=binomial(link="logit"))
summary(LOG.FITa)
PROB.FITa <- glm(parti ~ age+ I(age^2)+income+education + I(income^2), 
                family=binomial(link="probit"))
summary(PROB.FITa)
#
#
# Compare IC for the models:
AIC(OLS.FIT)
AIC(LOG.FIT)
AIC(PROB.FIT)
AIC(OLS.FITa)
AIC(LOG.FITa)
AIC(PROB.FITa)
#
#
library(cvTools) # install.packages("cvTools")
#
# CV using "MAPE"
cv.OLS <- cvFit(OLS.FIT, data = SwissLabor, y = SwissLabor$parti, cost = mape, 
                K = 10, R = 100, predictArgs = list(type="response"), seed = 1234)
cv.LOG <- cvFit(LOG.FIT, data = SwissLabor, y = SwissLabor$parti, cost = mape, 
                K = 10, R = 100, predictArgs = list(type="response"), seed = 1234)
cv.PROB <- cvFit(PROB.FIT, data = SwissLabor, y = SwissLabor$parti, cost = mape, 
                 K = 10, R = 100, predictArgs = list(type="response"), seed = 1234)
cv.OLSa <- cvFit(OLS.FITa, data = SwissLabor, y = SwissLabor$parti, cost = mape, 
                 K = 10, R = 100, predictArgs = list(type="response"), seed = 1234)
cv.LOGa <- cvFit(LOG.FITa, data = SwissLabor, y = SwissLabor$parti, cost = mape, 
                 K = 10, R = 100, predictArgs = list(type="response"), seed = 1234)
cv.PROBa <- cvFit(PROB.FITa, data = SwissLabor, y = SwissLabor$parti, cost = mape, 
                  K = 10, R = 100, predictArgs = list(type="response"), seed = 1234)
#
# Evaluation table and evaluation plot for k-fold CV output
cvFits <- cvSelect(OLS=cv.OLS,LOG=cv.LOG, PROB=cv.PROB, 
                   OLS.A=cv.OLSa, LOG.A=cv.LOGa, PROB.A=cv.PROBa)
cvFits
summary(cvFits)
plot(cvFits, method = "density")



help(package=cvTools) 
#
?cvFit 
# mind the default predict() output for glm() objects, use predictArgs() !! 
#
# Since the response is a binary variable, an appropriate cost function is
Cost <- function(r, pi) mean(abs(r-pi) > 0.5)
# where r is the observed response and pi is the predicted probability of success
# cost function returns the error rate for cutoff 0.5
# .. function syntax is not a very intuitive. You may want to check:
# https://stackoverflow.com/questions/16781551/cost-function-in-cv-glm-of-boot-library-in-r 
#
# Here, Cost returns the ratio of classified cases 
#
cv.OLS <- cvFit(OLS.FIT, data = SwissLabor, y = SwissLabor$parti, cost = Cost, 
                K = 10, R = 100, predictArgs = list(type="response"), seed = 1234)
cv.LOG <- cvFit(LOG.FIT, data = SwissLabor, y = SwissLabor$parti, cost = Cost, 
                K = 10, R = 100, predictArgs = list(type="response"), seed = 1234)
cv.PROB <- cvFit(PROB.FIT, data = SwissLabor, y = SwissLabor$parti, cost = Cost, 
                 K = 10, R = 100, predictArgs = list(type="response"), seed = 1234)
cv.OLSa <- cvFit(OLS.FITa, data = SwissLabor, y = SwissLabor$parti, cost = Cost, 
                K = 10, R = 100, predictArgs = list(type="response"), seed = 1234)
cv.LOGa <- cvFit(LOG.FITa, data = SwissLabor, y = SwissLabor$parti, cost = Cost, 
                K = 10, R = 100, predictArgs = list(type="response"), seed = 1234)
cv.PROBa <- cvFit(PROB.FITa, data = SwissLabor, y = SwissLabor$parti, cost = Cost, 
                 K = 10, R = 100, predictArgs = list(type="response"), seed = 1234)
#
# Evaluation table and evaluation plot for k-fold CV output
cvFits <- cvSelect(OLS=cv.OLS,LOG=cv.LOG, PROB=cv.PROB, 
                   OLS.A=cv.OLSa, LOG.A=cv.LOGa, PROB.A=cv.PROBa)
cvFits
summary(cvFits)
plot(cvFits, method = "density")
#
#
#
#
## Example repeated with same results, using the {boot} package
#
library(boot)
?cv.glm 
#
# Since the response is a binary variable, an appropriate cost function is
Cost <- function(r, pi = 0) mean(abs(r-pi) > 0.5)
# .. cost function repeated - it is the same for cvFit() and cv.glm() 
# .. see Help section, Examples, of ?cv.glm()
#
# See "Value" section in help for cv.glm:
#
# "delta": A vector of length two. The first component is the raw cross-validation 
# estimate of prediction error. The second component is the adjusted cross-validation 
# estimate. The adjustment is designed to compensate for the bias introduced by 
# not using leave-one-out cross-validation.
#
set.seed(200)
cv.glm(SwissLabor, OLS.FIT, cost=Cost, K=10)$delta
cv.glm(SwissLabor, LOG.FIT, cost=Cost, K=10)$delta
cv.glm(SwissLabor, PROB.FIT, cost=Cost, K=10)$delta
cv.glm(SwissLabor, OLS.FITa, cost=Cost, K=10)$delta
cv.glm(SwissLabor, LOG.FITa, cost=Cost, K=10)$delta
cv.glm(SwissLabor, PROB.FITa, cost=Cost, K=10)$delta
#
# compare the first delta components to:
summary(cvFits)
#
#
## Titanic survival: Complex data analysis example continued
#
# VARIABLE DESCRIPTIONS:
#
# survival        Survival   (0 = No; 1 = Yes)
# pclass          Passenger Class  (1 = 1st; 2 = 2nd; 3 = 3rd)
# name            Name
# sex             Sex
# age             Age
# sibsp           Number of Siblings/Spouses Aboard
# parch           Number of Parents/Children Aboard
# ticket          Ticket Number
# fare            Passenger Fare
# cabin           Cabin
# embarked        Port of Embarkation (C = Cherbourg; Q = Queenstown; S = Southampton)
# title           5 levels (factors)
# Child           dummy variable, passenger is a child
# Family          Family size (min = 1)
# Mother          dummy variable, passenger is a mother
#
rm(list=ls())
Titanic <- read.csv("data/titanic_cleaned.csv")
#
head(Titanic)
summary(Titanic)
attach(Titanic)
#Survival visualization by Passenger Class
#
## Three logistic regressions, confusion matrices and ROC curves
#
# Logistic regressions
LR1 <- glm(Survived~Pclass, family=binomial)
LR2 <- glm(Survived~Pclass+Female, family=binomial)
LR3 <- glm(Survived~Pclass+Female+Age, family=binomial)
#
#
# Cross validation of the prediction methods
Cost <- function(r, pi = 0) mean(abs(r-pi) > 0.5)
# !! mind the default predict() output for glm() objects, use predictArgs() !!
cv.LR1 <- cvFit(LR1, data = Titanic, y = Titanic$Survived, cost = Cost, 
                K = 5, R = 50, predictArgs = list(type="response"), seed = 150)
cv.LR2 <- cvFit(LR2, data = Titanic, y = Titanic$Survived, cost = Cost, 
                K = 5, R = 50, predictArgs = list(type="response"), seed = 150)
cv.LR3 <- cvFit(LR3, data = Titanic, y = Titanic$Survived, cost = Cost, 
                K = 5, R = 50, predictArgs = list(type="response"), seed = 150)
#
cvFits <- cvSelect(LR1 = cv.LR1, LR2 = cv.LR2, LR3 = cv.LR3)
cvFits
summary(cvFits)
#
plot(cvFits, method = "density")
#
#
#
#