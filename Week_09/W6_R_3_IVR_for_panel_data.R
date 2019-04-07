###### IVR with panel data
#
# One or all of the models may be estimated using instrumental variables by
# indicating the list of the instrumental variables. 
#
#
rm(list=ls()) # install.packages("plm")
require(plm) # install.packages("plm")
data("Crime", package = "plm")
?Crime
plot(Crime[,c("crmrte","density","pctymle","prbconv","polpc","taxpc")])
#
plm.formula = log(crmrte) ~ log(prbarr) + log(polpc) + log(prbconv) +
  + log(prbpris) + log(avgsen) + log(density) + log(wcon) +
  + log(wtuc) + log(wtrd) + log(wfir) + log(wser) + log(wmfg) +
  + log(wfed) + log(wsta) + log(wloc) + log(pctymle) + log(pctmin) +
  + region + smsa + factor(year) | . - log(prbarr) -log(polpc) +
  + log(taxpc) + log(mix)
#
# Note the instrument syntax:
# Instead of specifying the full list of exogenous variables and instruments,
# we specify the external instruments and the variables of the model that are
# assumed to be endogenous (using the minus sign)
#
# Pooled regression
cr.pool <- plm(plm.formula, data = Crime,
          model = "pooling")
summary(cr.pool)
#
# Fixed effects
cr.FE <- plm(plm.formula, data = Crime,
               model = "fd")
summary(cr.FE)
pFtest(cr.FE,cr.pool)
#
# Random effects
cr.RE <- plm(plm.formula, data = Crime,
             model = "random")
summary(cr.RE)
phtest(cr.RE, cr.FE)
#
# Standard errors
library(lmtest)
library(car)
library(sandwich)
# 
pbgtest(cr.RE)
coeftest(cr.RE)
summary(cr.RE, vcovHC(cr.RE, method="arellano"))
#
# 
#
#################
#
#
## "cigarette" example
#
rm(list=ls())
library(AER)
?CigarettesSW
# data
data("CigarettesSW", package = "AER")
CigarettesSW$rprice <- with(CigarettesSW, price/cpi) # real cig. prices
CigarettesSW$rincome <- with(CigarettesSW, income/population/cpi) # real income p.c.
CigarettesSW$tdiff <- with(CigarettesSW, (taxs - tax)/cpi) # real tax change
#
## model for cigarettes consumption dynamics
#  .. packs - # of packs per capita per year in a given state
#  .. log(rprice) is an endogenous regressor
#  .. tdiff and tax/cpi are IVs.
#
plm1 <- plm(log(packs) ~ log(rprice) + log(rincome) | log(rincome) + tdiff + I(tax/cpi),
            data = CigarettesSW, index = c("state","year"), model="fd")
summary(plm1)
summary(plm1, vcovHC(plm1, method="arellano"))
#
#
#
## Quick exercise:
## Comment on the estimated intercept of the "FD"-estimated model.
## (use ?plm)
#
#
#
# As log(rincome) is not significant, re-estimate model:
plm1 <- plm(log(packs) ~ log(rprice) | log(rincome) + tdiff + I(tax/cpi),
            data = CigarettesSW, index = c("state","year"), model="fd")
summary(plm1)
summary(plm1, vcovHC(plm1, method="arellano"))
#
#