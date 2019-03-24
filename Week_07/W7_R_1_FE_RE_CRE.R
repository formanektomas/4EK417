#### Fixed effects & Random effects & Correlated random effects ####
#
#
#
#
rm(list=ls())
W.panel <- read.csv("_dataW07/wagepan.csv")
#
# We wil estimate a wage model. The model will be used 
# to assess the return to education. We take into account 
# individual heterogeneity and control for other aspects:
# 
#
# LRM: lwage ~ educ, black, hisp, exper, exper^2,
#              married, union, (ability)
# 
# Where
# "ability" - the unobserved heterogeneity, 
# individual ability does not change over time
# other variables have the usual interpretation 
# .. see Wooldridge (Introductory econometrics)
#
head(W.panel)
tail(W.panel)
summary(W.panel)
unique(as.factor(W.panel$nr))
library(ggplot2) # install.packages("ggplot2")
ggplot(W.panel, aes(x=as.factor(year), y=lwage, fill=as.factor(year))) + 
  geom_boxplot()
# "time effects" need to be taken into account 
#
#
#
## Pooled regression (no unobserved individual nor time effects)
#
OLS1 <- lm(lwage~educ+black+hisp+exper+I(exper^2)
           +married+union, data=W.panel)
summary(OLS1)
# Repeat the Pooled model using {plm}
require(plm) # install.packages("plm", "SparseM")
pooled.m <- plm(lwage~educ+black+hisp+exper+I(exper^2)
                +married+union, data=W.panel, model="pooling")
summary(pooled.m)
#
?pdwtest
pdwtest(pooled.m)
#
#
#######################
#### Fixed effects ####
#######################
#
# All time invariant regressors get dropped from
# the regression, however, interactions between
# time-variant and time-invariant regressors may be used
#
#
# FE - Individual effects
# .. we estimate the model using FE method ("within"), individual effects
# .. alternatively, "twoways" effects
FE.m <- plm(lwage~educ+black+hisp+exper+I(exper^2)
            +married+union, data=W.panel,
            effect="individual", model="within")
summary(FE.m)
# Individual effects are usually of lesser importance, 
# but may be extracted using fixef()
?fixef.plm
Fixed.effects.1 <- fixef(FE.m, type="level")
head(summary(Fixed.effects.1))
head(Fixed.effects.1) # individual intercepts, NOT deviations from a baseline
tail(Fixed.effects.1)
#
# Tests: Autocorrelation, heteroscedasticity, Poolability
pdwtest(FE.m) # DW for panels
# Wooldridge Test for AR(1) in FE - not asymptotic,
# good performance on "short"panels
?pwartest
pwartest(FE.m) # We reject H0
# HAC errors
?vcovHC
#
require(car) # install.packages("car")
require(lmtest) # install.packages("lmtest")
# .. cluster="group"  to account for timewise heteroskedasticity and serial correlation 
coeftest(FE.m, vcov = vcovHC(FE.m, method = "arellano"))
#
coeftest(FE.m) # ordinary FE s.errors for comparison
#
# Poolability - fixed effects redundancy test
?pFtest()
pFtest(FE.m, pooled.m) # We reject poolability null hypothesis
#
#
#
#
# FE - Individual & time effects
# .. we estimate the model using FE method ("within"), individual+time effects
FE.m2 <- plm(lwage~exper+I(exper^2)
            +married+union, data=W.panel,
            effect="twoways", model="within")
coeftest(FE.m2)
# Individual & time effects 
Fixed.effects.2 <- fixef(FE.m2, effect="individual")
Time.effects.2 <- fixef(FE.m2, effect="time")
head(Fixed.effects.2) # individual intercepts, NOT deviations from a baseline
head(summary(Fixed.effects.2))
#
Time.effects.2
summary(Time.effects.2)
#
# Tests: Autocorrelation, heteroscedasticity, Poolability
pwartest(FE.m2) # We reject H0
coeftest(FE.m2, vcov = vcovHC(FE.m2, method = "arellano"))
# Poolability test
?pFtest()
pFtest(FE.m2, pooled.m) # We reject poolability null hypothesis
#
#
#
#
#
########################
#### Random effects ####
########################
#
# .. we estimate the model using RE approach
RE.m <- plm(lwage~educ+black+hisp+exper+I(exper^2)
             +married+union, data=W.panel,
             effect="individual", model="random")
summary(RE.m)
pdwtest(RE.m)
#
# Hausman specification test (compare RE with a base (FE) model)
?phtest
phtest(FE.m, RE.m) 
# for illustration purposes only.... we cannot actually use 
# this test, as regressors in RE and FE models are different
# (time invariant regressors..)
#
#
#
#
#
#
###################################
#### Correlated Random effects ####
###################################
#
library(dplyr)
CRE.dat <- W.panel %>%
             group_by(nr) %>% 
             mutate(educBar = mean(educ), 
                    experBar = mean(exper)) %>%
            ungroup()
#
# Individual education does not change in our dataset...
sum(CRE.dat$educ-CRE.dat$educBar)
#
CRE.m <- plm(lwage~educ+black+hisp+exper+I(exper^2)
            +married+union+experBar, data=CRE.dat,
            effect="individual", model="random")
summary(CRE.m)
pdwtest(CRE.m)
#
#
#
#
#### FGLS estimation of panel data models using {plm}
#### Estimation of linear panel models by general feasible generalized least squares
#
#  Two-step estimation process:
#  1) The model is estimated by Pooling, FE or FD
#  2) Residuals are used to estimate an error covariance matrix 
#     for use in a feasible-GLS analysis.
#
#  .. Robust against any type of intragroup heteroskedasticity and serial correlation.
#  .. Inefficient under groupwise heteroskedasticity.
#  .. Efficiency requires N >> T
#
#
## Example based on the "Wagepan" data
#
#
# FGLS estimation: FE
?pggls
FGLS.m <- pggls(lwage~educ+black+hisp+exper+I(exper^2)
            +married+union, data=W.panel,
            effect="individual", model="within")
summary(FGLS.m)
# Compare estimated coefficients
coeftest(FE.m)
coeftest(FGLS.m)
# FGLS is a "WLS" type estimator, 
# observations are weighted, estimated coefficients are different
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
## Assignment 1
##
rm(list=ls())
data("Grunfeld", package="plm")
?Grunfeld # variable description
head(Grunfeld)
tail(Grunfeld)
plot(Grunfeld[,-1])
##
## 1) Estimate a model specification    inv ~ value + capital
##    .. use Pooled, FE, RE & CRE estimators 





## 2) Use Poolability and Hausman tests 










