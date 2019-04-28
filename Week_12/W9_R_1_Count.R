#### Selected methods for estimating models with count data dependent variable ####
#
#
#
#
rm(list=ls())
#
# Install and require specific packages
#
# help(package = MASS)

# help(package = pscl) # hurdle and zeroinfl functions
#
#
#
## Example 1: based on Wooldridge: Introductory econometrics, Example 17.3
#  .. Determinants of Number of Arrests for Young Men
#
crime1 <- read.csv("_dataW09/crime1.csv")
#
summary(crime1$narr86)
boxplot(crime1$narr86~crime1$born60)
boxplot(crime1$narr86~crime1$black)
#
# Model: Number of arrests in 1986 <- (Intercept)
#                                     + pcnv "proportion of prior convictions to arrests"
#                                     + avgsen "average sentence length, months"
#                                     + tottime "time in prison since age 18 (in months)"
#                                     + ptime86 "months in prison during 1986"
#                                     + qemp86 "number of quarters employed, 1986"
#                                     + inc86 "legal income, 1986, $100s"
#                                     + black + hispan "0-1 dummies"
#                                     + born60 "=1 if born in 1960"
#
#
#
## We start by estimating the model by OLS:
#
OLS.FIT<-lm(narr86 ~ pcnv + avgsen + tottime + ptime86 + qemp86 + inc86 
            + black + hispan + born60, data = crime1)
summary(OLS.FIT)
logLik(OLS.FIT)
require(lmtest) # install.packages("lmtest")
bptest(OLS.FIT)
#
#
## Poisson regression
#
Poiss.FIT<-glm(narr86 ~ pcnv + avgsen + tottime + ptime86 + qemp86 + inc86 
               + black + hispan + born60, data=crime1, family=poisson)
summary(Poiss.FIT)
logLik(Poiss.FIT)
cor(Poiss.FIT$fitted.values, crime1$narr86)^2
lrtest(Poiss.FIT)
#
#
#
## Interpretation of coefficients: Approximate effects
# %delta(E(y|x)) =approx (100*beta(j))*delta(x(j))
coeftest(Poiss.FIT)
summary(crime1$pcnv) # "proportion of prior convictions to arrests"
Poiss.FIT$coefficients[2] # pcnv coefficient
# Say, we want to know the expected effect of a 0.1 (10%) improvement in pcnv
100*Poiss.FIT$coefficients[2]*0.1
# By improving (increasing) pcnv by 0.1, we expect to reduce narr86 by 
# approx. 4%
#
#
## Interpretation of coefficients: Exact calculation
# %delta(E(y|x)) = (100*(exp(beta(j))-1))*delta(x(j))
# pcnv variable
(100*(exp(Poiss.FIT$coefficients[2])-1))*0.1
# dummy variable black
coefficients(Poiss.FIT)[8]
#
## IRR (Incidence rate ratio) interpretation:
exp(coefficients(Poiss.FIT)[8]) 
# 1.936 "times the expected arrests of white young males (cet. par.) in 1986"
#
##
100*(exp(coefficients(Poiss.FIT)[8])-1)
# 93.6 % more arrests for black young men as compared to whites (cet. par.), 1986
#
#
#
# APEs & PEAs
# the resuling APEs and PEAs are on the scale of the dependent variable, i.e. 
# the expected occurence or arrests (given our example)
require(mfx) # install.packages("mfx")
?poissonmfx
#
# APEs
poissonmfx(narr86 ~ pcnv + avgsen + tottime + ptime86 + qemp86 
           + inc86 + black + hispan + born60, data=crime1, 
           atmean = F, robust = T)
#PEAs
poissonmfx(narr86 ~ pcnv + avgsen + tottime + ptime86 + qemp86 
           + inc86 + black + hispan + born60, data=crime1, 
           atmean = T, robust = T)
# 
#
# IRR
# we can interpret the parameter estimate 
# as the log of the ratio of expected counts...
# .. We obtain the incidence rate ratio 
#    by exponentiating the Poisson regression coefficient
# 
#
?poissonirr
poissonirr(narr86 ~ pcnv + avgsen + tottime + ptime86 + qemp86 
           + inc86 + black + hispan + born60, data=crime1, 
           robust = T)
# if "ptime86" increases by a unit, "narr86" decreases by a factor of 0.906
# if "black" = 1, "narr86" increases by a factor of 1.936
# ....
#
#
#
## Assignment 1
## Describe the effect of a unit change in the qemp86 regressor
## qemp86 "number of quarters employed, 1986"
## .. Use Poiss and LPM coefficients and partial effects.
##
#
#
#
#
## Predictions (fitted values) from an estimated Poisson model:
predPoiss <- predict(Poiss.FIT, type="response") 
# for prediction on the scale of "y" - dependent variable
head(cbind(crime1$narr86, predPoiss), 10)
cor(Poiss.FIT$fitted.values, crime1$narr86)^2
#
#
#
## Dispersion test
require(AER) # install.packages("AER") 
?dispersiontest
dispersiontest(Poiss.FIT)
#
summary(Poiss.FIT)
summary(Poiss.FIT,dispersion = 1.5)
#
#
#
#
#
#
## Negative Binomial glm: from the {MASS} library; MASS = 'Modern Applied Statistics with S' 
require(MASS) # install.packages("MASS") 
?glm.nb
#
NB.FIT<-glm.nb(narr86 ~ pcnv + avgsen + tottime + ptime86 + qemp86 + inc86 
               + black + hispan + born60, data=crime1)
summary(NB.FIT)
logLik(NB.FIT)
head(predict(NB.FIT, type="response")) # scale of dep. variable
head(cbind(NB.FIT$fitted.values, crime1$narr86), 20)
cor(NB.FIT$fitted.values, crime1$narr86)^2
lrtest(NB.FIT)
#
negbinmfx(narr86 ~ pcnv + avgsen + tottime + ptime86 + qemp86 + inc86 
          + black + hispan + born60, data=crime1, atmean = F, robust = T)
#
negbinirr(narr86 ~ pcnv + avgsen + tottime + ptime86 + qemp86 + inc86 
          + black + hispan + born60, data=crime1, robust = T)
#
#
#
#
#
#
#
## Zero inflated models from the {pscl} package
require(pscl) # install.packages("pscl")
# Political Science Computational Laboratory
?zeroinfl
#
# y ~ x1 + x2 | z1 + z2 + z3 
# .. is the count data model y ~ x1 + x2  /Poisson, NB/,
# .. conditional on (|) the zero-inflation model y ~ z1 + z2 + z3 /logit/
#
#
# Say, we keep the ZI count part of the model unchanged:
# narr86 <- pcnv+avgsen+tottime+ptime86+qemp86+inc86+black+hispan+born60
#
# We construct an additional, "link", model (to be estimated by logit), describing 
# the participation / non-participation in activities that are
# of criminal nature or with significant arrest potential
# .. we may be over-simplifying here by ignoring accidental & unprovoked arrests.
# "link":
# narr86 <- qemp86+born60+hispan+black+inc86
#
#
#
## Zero-inflated Poisson model  
ZI.Poiss.FIT <- zeroinfl(narr86 ~ pcnv + avgsen + tottime + ptime86 
                         + qemp86 + inc86 + black + hispan 
                         + born60 | qemp86 + born60 + hispan + black + inc86,
                         link = "logit", dist = "poisson", data = crime1)
summary(ZI.Poiss.FIT)
head(predict(ZI.Poiss.FIT)) 
head(predict(ZI.Poiss.FIT, type="response")) 
cor(ZI.Poiss.FIT$fitted.values, crime1$narr86)^2
lrtest(ZI.Poiss.FIT)
#
#
#
# Zero-inflated negative binomial model  
ZI.NB.FIT <- zeroinfl(narr86 ~ pcnv + avgsen + tottime + ptime86 
                      + qemp86 + inc86 + black + hispan 
                      + born60 | qemp86 + born60 + hispan + black + inc86,
                      link = "logit", dist = "negbin", data = crime1)
summary(ZI.NB.FIT)
head(predict(ZI.NB.FIT)) 
head(predict(ZI.NB.FIT, type="response")) 
cor(ZI.NB.FIT$fitted.values, crime1$narr86)^2
lrtest(ZI.NB.FIT)
#
#
#
#
#
#
## Assignment 2 
## We have estimated 5 models describing the expected
## number of arrests for young males in the USA (1986)
OLS.FIT
Poiss.FIT
NB.FIT
ZI.Poiss.FIT
ZI.NB.FIT
## 1)
## Use k-Fold CV with k=5 and "repetitions" = 10
## to choose the "best" model for predictions
## .. k-Fold CV provides information on the "test sample" performance
##
## 2)
## Use the "density" plot to compare the methods
# 
#
## Your solution starts as follows:
library(cvTools) # install.packages("cvTools")
## k-Fold Cross Validation for the OLS-estimated model:
cv.OLS <- cvFit(OLS.FIT, data = crime1, y = crime1$narr86, cost = rtmspe, 
                K = 5, R = 10, seed = 500)
## k-Fold CV for the Poiss-estimate:
cv.Poiss <- cvFit(Poiss.FIT, data = crime1, y = crime1$narr86, cost = rtmspe, 
                K = 5, R = 10, predictArgs = list(type="response"), seed = 500)
##
## Continue with the comparison by creating the remaining cvFit objects:
cv.NB <- cvFit() # for Negative Binomial 
cv.Z.P <- cvFit() # for Zero-inflated + Poisson
cv.Z.NB <- cvFit() # for Zero-inflated + NB
## Next, produce a "list" of cv.objects for sub sequent comparison
cvFits <- cvSelect(OLS = cv.OLS, Poisson = cv.Poiss, Neg.Bin. = cv.NB,
                   ZI.Poisson = cv.Z.P, ZI.Neg.Bin. = cv.Z.NB)
## 
## Based on"rtmspe", what is the best prediction model?
#
## Plot the "CV results" comparison.
#  
#
#
#
#
#
#
#
#
#
## Example 2: Number of doctor visits, 
#  .. data from the U.S. Medical Expenditure Panel Survey for 2003
#
# Variables:
# docvisits: Number of doctor visits, 2003 - dependent variable
# private:   Has private insurance
# medicaid:  Has Medicaid insurance
# age:       Age
# age2:      Age^2
# educyr:    Education in years
# female:    dummy variable
# ssiratio:  health-related quality of life
# 
#
#
rm(list=ls())
visits <- read.csv("_dataW09/medical.csv")
#
summary(visits$docvis)
hist(visits$docvis)
hist(visits$docvis, xlim=c(0,50))
boxplot(visits$docvis~visits$female)
plot(visits$docvis~visits$age)
plot(visits$docvis~visits$age, pch=16, col=rgb(0, 0, 1, alpha=0.1))
#
#
#
#
### Poisson regression
#
summary(glm(docvis ~ private+medicaid+age+age2+female+educyr, data=visits, family=poisson))
# No significant difference between visits for males and females
Poiss.FIT<-glm(docvis ~ private+medicaid+age+age2+educyr, data=visits, family=poisson)
summary(Poiss.FIT)
#
head(cbind(Poiss.FIT$fitted.values, visits$docvis), 10)
cor(Poiss.FIT$fitted.values, visits$docvis)^2
dispersiontest(Poiss.FIT)
#
#
### Negative Binomial regression
#
NB.FIT<-glm.nb(docvis ~ private+medicaid+age+age2+educyr, data=visits)
summary(NB.FIT)
logLik(NB.FIT)
head(cbind(NB.FIT$fitted.values, visits$docvis), 10)
cor(NB.FIT$fitted.values, visits$docvis)^2
#
#
### Zero-inflated Poisson model 
ZI.Poiss.FIT <- zeroinfl(docvis ~ private+medicaid+age+age2+educyr | private+medicaid,
                         link = "logit", dist = "poisson", data = visits)
summary(ZI.Poiss.FIT)
head(cbind(ZI.Poiss.FIT$fitted.values, visits$docvis), 10)
cor(ZI.Poiss.FIT$fitted.values, visits$docvis)^2
lrtest(ZI.Poiss.FIT)
#
#
### Zero-inflated negative binomial model coefficients
ZI.NB.FIT <- zeroinfl(docvis ~ private+medicaid+age+age2+educyr | private+medicaid,
                      link = "logit", dist = "negbin", data = visits)
summary(ZI.NB.FIT)
head(cbind(ZI.NB.FIT$fitted.values, visits$docvis), 10)
cor(ZI.NB.FIT$fitted.values, visits$docvis)^2
lrtest(ZI.NB.FIT)
#  
#
#
### Hurdle: Negbin | Logit
?hurdle
Hurdle.FIT <- hurdle(docvis ~ private+medicaid+age+educyr | private+medicaid+age+educyr,
                     dist="negbin", zero.dist="binomial", data = visits)
summary(Hurdle.FIT)
head(cbind(Hurdle.FIT$fitted.values, visits$docvis), 10)
cor(Hurdle.FIT$fitted.values, visits$docvis)^2
#