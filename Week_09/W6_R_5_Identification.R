#### SEMs - specification, identification and estimation ####
#
# 
# 
# 
#
#
### Example 16.3 & 16.5: Based on Wooldridge: Introductory econometrics, 
#    
#   Labor supply of married, working women
#   
#
# Data
rm(list=ls())
mroz <- read.csv('_dataW06/mroz.csv')
# We limit our data to working women only
mroz <- mroz[mroz$inlf == 1, ]
#
# Model data:
#
# hours      - hours worked, 1975
# wage       - hourly wage
# educ       - years of schooling
# age        - woman's age in years
# kidslt6    - number of kids < 6 years old
# nwifeinc   - faminy income with "wage" variable excluded
# exper      - actual labor market experience
# expersq    - exper^2
#
# Basic data plots
# Scatterplot matrix of the data used in our model
plot(mroz[, c(2,3,4,5,6,7,19,20,22)])
#
# Specify a system of equations and instruments:
eqHours <- hours ~ log(wage) + educ + age + kidslt6 + nwifeinc
eqWage  <- log(wage) ~ hours + educ + exper + unem
instr <- ~ educ + age + kidslt6 + nwifeinc + exper + unem
# If no labels are provided, equations are named automatically
Wage.model <- list(Hours = eqHours, Wages = eqWage)
#
#
# We start by estimating the model using OLS (interdependencies ignored)
fitOls <- systemfit(Wage.model, data = mroz)
summary(fitOls)
round(coef(summary(fitOls)), digits = 4)
#
#
#
#
# Before we try 2SLS estimation of the SEM, we want to make sure that both equations
# are identified:
#
# Step 1:
# Estimate the reduced forms for both dependent variables:
#
# Reduced form for hours:
red.hours <- lm(hours ~ educ + age + kidslt6 + nwifeinc + exper + unem, data=mroz)
# Reduced form for log(wage)
red.wage <- lm(log(wage) ~ educ + age + kidslt6 + nwifeinc + exper + unem, data=mroz)
#
# Step 2: Verify identification of equation 1 (eqHours):
summary(red.hours)
# eqHours is identified if either exper or unem coefficients are not zero
summary(red.wage)
#
## Assignment 1
## What is the identification condition for equation eqWage?
## Is the equation eqWage identified?
#
#
#
# Next, we estimate the model using 2SLS method
fit2sls <- systemfit(Wage.model, method = "2SLS", inst = instr, data = mroz)
summary(fit2sls)
round(coef(summary(fit2sls)), digits = 4)
#
#
# We can also estimate the model using the 3SLS method
fit3sls <- systemfit(Wage.model, method = "3SLS", inst = instr, data = mroz)
summary(fit3sls)
round(coef(summary(fit3sls)), digits = 4)
#
# The estimated models may be compared using BIC
BIC(fitOls)
BIC(fit2sls)
BIC(fit3sls)
#
#
#
#
# To assess the quality of instruments and endogeneity of regressors, we need to
# use the ivreg command (2SLS method) from the {AER} package:
#
# equation eqHours
eqHours.iv <- ivreg(hours ~ log(wage) + educ + age + kidslt6 + nwifeinc
                    | educ + age + kidslt6 + nwifeinc + exper + unem, 
                    data = mroz)
summary(eqHours.iv, vcov = sandwich, diagnostics = T)
#
#
## Assignment 2
## Comment on the results of Weak instruments test,
## Wu-Hausmann test and Sargan test
#
#
## Assignment 3
## By analogy to lines 223 - 226, evaluate the instruments for equation eqWage.
#
#
#
#
### Computer exercise C16.2: Based on Wooldridge: Introductory econometrics, 
#
# (ii) We allow educ to be endogenous because of omitted ability.
#      We use motheduc and fatheduc as IVs for educ.
#
eqHours3 <- log(hours) ~ log(wage) + educ + age + kidslt6 + nwifeinc
eqWage3  <- log(wage) ~ log(hours) + educ + exper + unem
instr3 <- ~ age + kidslt6 + nwifeinc + exper + unem + motheduc + fatheduc
# If no labels are provided, equations are named automatically
Wage.model3 <- list(Hours = eqHours3, Wages = eqWage3)
#
ModEst3 <- systemfit(Wage.model3, method = "2SLS", inst = instr3, data = mroz)
#
summary(ModEst3)
round(coef(summary(ModEst3)), digits = 4)
#
#
# (iii) We use the ivreg command (2SLS method) from the {AER} package
#       to test the IVs-setup introduced in (ii):
# 
eqHours.iv3 <- ivreg(log(hours) ~ log(wage) + educ + age + kidslt6 + nwifeinc
                     | age + kidslt6 + nwifeinc + exper + unem + motheduc + fatheduc, 
                     data = mroz)
summary(eqHours.iv3, vcov = sandwich, diagnostics = T)
#
eqWages.iv3 <- ivreg(log(wage) ~ log(hours) + educ + exper + expersq
                     | age + kidslt6 + nwifeinc + exper + unem + motheduc + fatheduc, 
                     data = mroz)
summary(eqWages.iv3, vcov = sandwich, diagnostics = T)
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
#### Identification in IVRs and SEMs: Gas prices example from Greene, Econometric analysis
#
# 
library("AER") # install.packages("AER") 
library("systemfit") # install.packages("systemfit")
?systemfit
#
#
rm(list=ls())
gas <- read.csv("_dataW06/greene7_8.csv")
gas <- gas[complete.cases(gas) == T, ] # complete cases analysis
#
plot(gas$Pg ~ gas$obs, type="l") # price index of gasoline
plot(gas$d_Pg ~ gas$obs, type="l") # 1st differences of Pg
#
plot(gas$G ~ gas$obs, type="l") # gasoline consumption
plot(gas$d_G ~ gas$obs, type="l") # first difference of G
#
#
### Unidentified equations - illustration 1
#
Consump <- d_G ~ d_Pg # define equation 1
Price <- d_Pg ~ d_G # define equation 2
system <- list(GasCons = Consump, GasPrice = Price) # make a SEM
#
# First, the model is estimated using OLS 
# (interdependencies are ignored)
#
model1 <- systemfit(system, method="OLS", data = gas)
summary(model1)
round(coef(summary(model1)), digits = 3)
#
# Now, lets try 2SLS
model1 <- systemfit(system, method="2SLS", data = gas)
# 
#
#
#
### ### Unidentified equations - illustration 2
#
Consump2 <- d_G ~ d_Pg + d_G_1 # define equation 1
Price2 <- d_Pg ~ d_G # define equation 2
instr <- ~ d_G_1 # list of instruments
system2 <- list(GasCons = Consump2, GasPrice = Price2) # make a SEM
#
# OLS 
model2 <- systemfit(system2, method="OLS", data = gas)
round(coef(summary(model2)), digits = 3)
#
# 2SLS
model2 <- systemfit(system2, method="2SLS",  inst = instr, data = gas)
round(coef(summary(model2)), digits = 3)
# The first equation is not identified.
# This may be illustrated using the ivreg function from {AER}:
#
IVR.e1 <- ivreg( d_G ~ d_Pg + d_G_1 | d_G_1, data=gas)
# whereas, the second equation is identified:
IVR.e2 <- ivreg( d_Pg ~ d_G | d_G_1, data=gas)
summary(IVR.e2, vcov = sandwich, diagnostics=T)
# compare with
round(coef(summary(model2)), digits = 4)
# 
#
#
#
### ### Just identified equations - illustration 3
#
Consump3 <- d_G ~ d_Pg + d_G_1 # define equation 1
Price3 <- d_Pg ~ d_G + d_Y # define equation 2
instr3 <- ~ d_G_1 + d_Y # list of instruments
system3 <- list(GasCons = Consump3, GasPrice = Price3) # make a SEM
#
# OLS 
model3 <- systemfit(system3, method="OLS", data = gas)
round(coef(summary(model3)), digits = 3)
#
# 2SLS
model3 <- systemfit(system3, method="2SLS",  inst = instr3, data = gas)
summary(model3)
round(coef(summary(model3)), digits = 3)
# Results may be replicated using the ivreg function from {AER}:
#
IVR2.e1 <- ivreg( d_G ~ d_Pg + d_G_1 | d_G_1 + d_Y, data=gas)
coef(summary(IVR2.e1, vcov = sandwich, diagnostics=T))
# and
IVR2.e2 <- ivreg( d_Pg ~ d_G + d_Y | d_G_1 + d_Y, data=gas)
coef(summary(IVR2.e2, vcov = sandwich, diagnostics=T))
# compare with
round(coef(summary(model3)), digits = 6)
# 
#
#
#
### ### Over-identified equations - illustration 4
#
Consump4 <- d_G ~ d_Pg + d_G_1 + d_Pop # define equation 1
Price4 <- d_Pg ~ d_G + d_Y # define equation 2
instr4 <- ~ d_G_1 + d_Y + d_Pop # list of instruments
system4 <- list(GasCons = Consump4, GasPrice = Price4) # make a SEM
#
# OLS 
model4 <- systemfit(system4, method="OLS", data = gas)
round(coef(summary(model4)), digits = 6)
#
# 2SLS
model4 <- systemfit(system4, method="2SLS",  inst = instr4, data = gas)
summary(model4)
round(coef(summary(model4)), digits = 6)
# Results may be replicated using the ivreg function from {AER}:
#
IVR4.e1 <- ivreg( d_G ~ d_Pg + d_G_1 + d_Pop | d_G_1 + d_Y + d_Pop, 
                  data=gas)
coef(summary(IVR4.e1, vcov = sandwich, diagnostics=T))
# and
IVR4.e2 <- ivreg( d_Pg ~ d_G + d_Y | d_G_1 + d_Y + d_Pop, data=gas)
coef(summary(IVR4.e2, vcov = sandwich, diagnostics=T))
# compare with
round(coef(summary(model4)), digits = 6)
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
#
