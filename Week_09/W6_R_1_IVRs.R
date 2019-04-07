#### Instrumental Variable Regressions (IVRs) ####
#
#
require("AER") # install.packages("AER") 
#
#
### BWGHT example, based on Wooldridge, Introductory Econometrics
#   .. Example 15.3
rm(list=ls())
bwght <- read.csv("_dataW06/bwght.csv")
head(bwght)
# 
# require("progress") # install.packages("progress")
require("GGally") # install.packages("GGally")
?ggpairs
ggpairs(bwght)
warnings()
#
# OLS estimation of a regression with a presumably non-exogenous regressor
OLS.1 <- lm(log(bwght) ~ packs, data=bwght)
summary(OLS.1)
#
#
# Regression of the reduced form with "cigprice" as IV
iv.cigs <- summary(lm(packs ~ cigprice, data=bwght))
iv.cigs
#
#
## Regression of the reduced form with  fatheduc + motheduc 
iv.fm <- summary(lm(packs ~ faminc+motheduc, data=bwght))
iv.fm
#
#
#
#
## IV estimation of the model, using cigprice as IV
#
?ivreg
IV.1 <- ivreg(log(bwght) ~ packs | cigprice, data=bwght)
summary(IV.1, vcov = sandwich, diagnostics=T)
#
#
#
## IV estimation of the model, using  fatheduc + motheduc as IVs
IV.2 <- ivreg(log(bwght) ~ packs | faminc+motheduc, data=bwght)
summary(IV.2, vcov = sandwich, diagnostics=T)
#
#
#
#
#
## Exogenous regressors always serve as IVs
#  .. y1 ~ (Intercept) + x1 + y | (Intercept) + x1 + Z1 + z2 +...
IV.3 <- ivreg(log(bwght) ~ packs + male | faminc+motheduc+male, data=bwght)
summary(IV.3, vcov = sandwich, diagnostics=T)
#
#
#
#
#
## Rule-of-Thumb Weak Instruments test in auxiliary regression
#  of the type  endog_regressor ~ instrument(s)
#  "F statistics > 10" may be used as a weak instruments test
#       H0: Instruments are weak, 
#       H1: non(H0), 
#       Rule: Reject H0 if F>10
#
iv.cigs # We do not reject H0
iv.fm   # We reject H0
#
#
#
#
#
#
#
#### {AER} IV estimation - another "cigarette" example
#
rm(list=ls())
?CigarettesSW
# data
data("CigarettesSW", package = "AER")
CigarettesSW$rprice <- with(CigarettesSW, price/cpi) # real cig. prices
CigarettesSW$rincome <- with(CigarettesSW, income/population/cpi) # real income p.c.
CigarettesSW$tdiff <- with(CigarettesSW, (taxs - tax)/cpi) # real tax change
#
## model for cigarettes consumption dynamics
#  .. packs - # of packs per capita per year
fm <- ivreg(log(packs) ~ log(rprice) + log(rincome) | log(rincome) + tdiff + I(tax/cpi),
            data = CigarettesSW, subset = year == "1995")
summary(fm, vcov = sandwich, diagnostics = TRUE)
#
# Based on the results, we drop log(rincome) from the equation and 
# from the list of IVs.
# Then, we compare the simplified (restricted) model to the 
# original (unrestricted) IV model.
# 
## ANOVA
fm2 <- ivreg(log(packs) ~ log(rprice) | tdiff+ I(tax/cpi), 
             data = CigarettesSW, subset = year == "1995")
summary(fm2, vcov = sandwich, diagnostics = TRUE)
#
anova(fm, fm2)
#
# We can simplify the model even further, drop IVR and do OLS:
fm3 <- ivreg(log(packs) ~ log(rprice) | log(rprice), data = CigarettesSW, subset = year == "1995")
lm3 <- lm(log(packs) ~ log(rprice), data = CigarettesSW, subset = year == "1995")
coeftest(fm3)
coeftest(lm3)
#
#
#
#
#
## Assignment 1
## 
rm(list=ls())
WAGE <- read.csv("_dataW06/wage2.csv")
## Using the data file wage2.csv (a Wooldridge textbook datafile),
## estimate the model 
##
##       log(wage) ~ (Intercept) + educ + exper   
##                   (assume educ is endogenous, exper is exogenous)
##
## .. (a) Use OLS
## .. (b) Estimate the reduced form regression model for educ.
#         and use "sibs" as an instrument.
##        - is  "sibs" an adequate instrument?
##         
##    (c) Estimate the main/structural equation using ivreg()
##        Interpret the Diagnostic tests output from the ivreg() estimation
##
##    (d) Use the wage2.csv dataset and find 2 or more suitable instruments for educ
##        .. estimate the model using ivreg() and do Diagnostic tests.
##
##
##
#
#
#
