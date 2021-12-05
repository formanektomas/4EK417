#### Tobit model ####
#
#
#
# Corner solution response 
# .. significant portion of zero outcomes + roughly continuous positive outcomes
#
#
#
### Example 1: Based on Wooldridge: Introductory econometrics, Example 17.2
#  .. Dependen variable: Hours per year, worked by married women
#  .... significant proportion of zero hours/year, 
#  .... positive observations roughly continuous
#
# Data
rm(list=ls())
mroz <- read.csv("data/mroz.csv")
hist(mroz$hours)
sum(mroz$hours > 0) # Number of non-zero observations
sum(mroz$hours == 0) 
#
#
# Estimation by OLS:
OLS.Fit<-lm(hours ~ nwifeinc + educ + exper + expersq + age +
                    kidslt6 + kidsge6,
                  data=mroz)
summary(OLS.Fit)
summary(OLS.Fit$fitted.values)
hist(OLS.Fit$fitted.values)
#
#
# Estimation by Tobit
library(AER) #install.packages('AER')
?tobit # convenient interface to "survreg", may be used for
       # censored and survival analysis
       # default left censoring: left = 0 /may be changed/
#
Tobit.Fit <- tobit(hours ~ nwifeinc + educ + exper + expersq + age +
                    kidslt6 + kidsge6, data=mroz)
summary(Tobit.Fit)
lrtest(Tobit.Fit)
#
# Scale factor
# The "scale" is the residual standard deviation, or estimate of 
# "sigma" in the usual linear models terminology. 
# For linear regression with uncensored data, the estimate of scale is 
# independent of the estimate of the other coefficients, and can be 
# computed at the end.  For censored data this is not so, the scale and 
# the coefficients must be estimated together; as a consequence, the full 
# variance/covariance matrix includes both beta and log(scale). 
Tobit.Fit$var
#
#
#
#
# Predictions from a Tobit model
fitted <- predict(Tobit.Fit, type="response")
cor(mroz$hours,fitted)^2
head(cbind(mroz$hours,fitted), 10)
#
#
# PEA output may be calculated through the {censReg} package
#
# install.packages("censReg")
library("censReg")
?censReg
Tobit.Fit2 <- censReg(hours ~ nwifeinc + educ + exper + age + kidslt6 + kidsge6, data=mroz) 
summary(Tobit.Fit2) 
# compare to
summary(Tobit.Fit)
#
#
# PEA (at mean values and for y > 0)
?margEff.censReg 
# effect on the expected value of the dependent variable 
# evaluated at the mean values of the explanatory variables.
margEff(Tobit.Fit2)
summary(margEff(Tobit.Fit2))

# Can be interpreted as: 
# - for the average individual (unless "xValues" argument is specified), 
# - an addition year of study increases the expected hours worked by 47.8 hours
#
#
#
#
## This can be verified "manually", using the same model and data
## .. note the "x=TRUE" command so the model saves the x values
#
fm.tobit <- tobit(hours ~ nwifeinc + educ + exper  
                  + age + kidslt6 + kidsge6, data=mroz, x=TRUE)
fm.tobit$coef
fm.tobit$scale
#
## the vector of marginal effects (at mean values and for y > 0) should be as follows.
## .. note the [-1] used to remove the intercept term from the final vector, 
## .. but not from within the adjustment term. 
#
pnorm(sum(apply(fm.tobit$x,2,FUN=mean) * fm.tobit$coef)/fm.tobit$scale) * fm.tobit$coef[-1]
#
#
#
#
#
#
### Example 2: FRINGE.csv
#
# Model explaining employee pension given a number of explanatory variables
# 
# Variables
# pension  - $ value of employee pension
# depends  - number of dependents
# ...other variables are defined as in "mroz" / names self-explanatory
#
rm(list=ls())
fringe <- read.csv("data/fringe.csv")
head(fringe)
hist(fringe$pension)
sum(fringe$pension > 0) # Number of non-zero employee pensions
sum(fringe$pension == 0) # Number of zero-value employee pensions
sum(fringe$pension == 0) / nrow(fringe) # zero-value dependent variable ratio
#
#
Tobit2.Fit <- tobit(pension ~ exper+age+tenure+educ+depends
                   +married+white+male, data=fringe)
summary(Tobit2.Fit)
lrtest(Tobit2.Fit)
#
#
# Add 'union' as explanatory variable
Tobit3.Fit <- tobit(pension ~ exper+age+tenure+educ+depends
                    +married+white+male+union, data=fringe)
summary(Tobit3.Fit)
lrtest(Tobit2.Fit, Tobit3.Fit)
#
## Assignment 1
## Instead of 'pension', use 'peratio' as model's dependent variable:
## .. peratio:
## .. pension to earnings ratio = pension/earnings
## 1) 
## Set and estimate a 'Tobit4' model, use the same regressors
## as in 'Tobit3.Fit'.
## 2)
## For 'peratio', are gender and race  suitable regressors?
## 3) 
## Use {censReg} package to calculate PEA output.
#
#