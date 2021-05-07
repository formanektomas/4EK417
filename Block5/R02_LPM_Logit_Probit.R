#### Binary dependent variables: LPM, logit, probit ####
#
#
#
# Repetition excercise
# Based on Wooldridge - Introductory econometrics, Example 8.8
# Labor force participation for married women
# 
#
#
#
### OLS
#
rm(list=ls())
mroz<-read.csv('data/mroz.csv')
ols.fit<-lm(inlf ~ nwifeinc + educ + exper + expersq + age + kidslt6 + kidsge6,
           data=mroz)
summary(ols.fit)
pred.lf.partic <- predict(ols.fit, type="response") 
summary(pred.lf.partic) # all predictions within (-0.35, +1.13) interval (rounding)
# 
# Confusion matrix
# for p-hat => 0.5, we predict "success" (labor force participation)
OLS.T <- table(Predicted = round(pred.lf.partic), Actual = mroz$inlf)
OLS.T # Contingency table (Confusion matrix-like)
OLS.T <- OLS.T[order(rownames(OLS.T), decreasing=T),]
OLS.T <- OLS.T[, order(colnames(OLS.T), decreasing=T)]
OLS.T # Confusion matrix
#
#
# Selected classification accuracy measures (evaluated for 0.5 prediction threshold)
#
# Overall accuracy
# (TP+TN)/(Number of observations in sample)
cat("Overall Correct Classification Ratio:", round((OLS.T[1,1]+OLS.T[2,2])/nrow(mroz), 3))
#
# Correct Classification Ratio By Outcome:
#
# Sensitivity
# TP / (Actual condition positive)
cat("Correct Classification ratio for Actual = 1 (in labor force):", 
          round(OLS.T[1,1]/(sum(OLS.T[,1])),3) )
#
# Specificity
# TN / (Actual condition negative)
cat("Correct Classification ratio for Actual = 0 (not in labor force):", 
          round(OLS.T[2,2]/(sum(OLS.T[,2])),3) )
#
#
#
#
#
### WLS
#
library(lmtest)
library(sandwich)
summary(ols.fit)
bptest(ols.fit)
# Heteroskedasticity corrected standard errors:
coeftest(ols.fit, vcov=vcovHC(ols.fit,type='HC0'))
#
# WLS estimation
# .. using the prior knowledge of var(y|x) = yhat * 1-yhat
# .. - where yhat is the predicted (fitted) value of dependent variable
# .. we weight the SQUARED RESIDUALS (not the observed variables) by "hhat", 
# .. i.e. mutiply by 1/hhat, i.e. use "weights=1/hhat" in the lm() function,
# .. - where hhat = yhat * 1-yhat
hist(ols.fit$fitted.values) 
# Some fitted values are negative or above unity... for those,
# we set the hhat to arbitrary values ensuring high weight-penalization 
yhat <- ols.fit$fitted.values
yhat[yhat < 0] <- 0.01
yhat[yhat > 1] <- 0.99
hist(yhat)
hhat <- yhat*(1-yhat)
#
wls.fit<-lm(inlf ~ nwifeinc + educ + exper + expersq + age + kidslt6 + kidsge6,
            weights=I(1/hhat), data=mroz)
summary(wls.fit, vcov=vcovHC(ols.fit,type='HC0'))
#
# Confusion matrix
pred.wls <- predict(wls.fit, type="response") 
summary(pred.wls)
# for p-hat => 0.5, we predict "success" (labor force participation)
WLS.T <- table( Predicted = round(pred.wls), Actual = mroz$inlf)
WLS.T <- WLS.T[order(rownames(WLS.T), decreasing=T),]
WLS.T <- WLS.T[, order(colnames(WLS.T), decreasing=T)]
WLS.T # Confusion Matrix
#
cat("Overall Correct Classification Ratio:", round((WLS.T[1,1]+WLS.T[2,2])/nrow(mroz), 3) )
cat("Correct Classification ratio for Actual = 1 (in labor force):", 
          round(WLS.T[1,1]/(sum(WLS.T[,1])),3) )
cat("Correct Classification ratio for Actual = 0 (not in labor force):", 
          round(WLS.T[2,2]/(sum(WLS.T[,2])),3) )
#
#
#
#
### FGLS
#
summary(ols.fit)
bptest(ols.fit)
#
# FGLS estimation
# For feasible GLS we obtain the logarithm of squared residuals from 
# the basic model. Then we regress it on the model’s independent variables 
# and calculate the exponential of fitted values from that regression which 
# give hhat. Then we estimate the basic model again, but with the weights 1/hhat.
lres.u <- log(ols.fit$residuals^2)
aux.fit <- lm(lres.u ~ nwifeinc + educ + exper + expersq + age + kidslt6 + kidsge6, data=mroz)
hhat2 <- exp(aux.fit$fitted.values)
#
fgls.fit<-lm(inlf ~ nwifeinc + educ + exper + expersq + age + kidslt6 + kidsge6,
            weights=I(1/hhat2), data=mroz)
summary(fgls.fit, vcov=vcovHC(ols.fit,type='HC0'))
#
# Confusion matrix
pred.fgls <- predict(fgls.fit, type="response") 
summary(pred.fgls)
# for p-hat => 0.5, we predict "success" (labor force participation)
FGLS.T <- table(Predicted = round(pred.fgls), Actual = mroz$inlf)
FGLS.T <- FGLS.T[order(rownames(FGLS.T), decreasing=T),]
FGLS.T <- FGLS.T[, order(colnames(FGLS.T), decreasing=T)]
FGLS.T # Confusion Matrix
#
cat("Overall Correct Classification Ratio:", round((FGLS.T[1,1]+FGLS.T[2,2])/nrow(mroz), 3) )
cat("Correct Classification ratio for Actual = 1 (in labor force):", 
          round(FGLS.T[1,1]/(sum(FGLS.T[,1])),3) )
cat("Correct Classification ratio for Actual = 0 (not in labor force):", 
          round(FGLS.T[2,2]/(sum(FGLS.T[,2])),3) )
#
#
#
#
### Logistic regression
#
?glm
#
logit.fit<-glm(inlf ~ nwifeinc + educ + exper + expersq + age + kidslt6 + kidsge6,
               family=binomial, data=mroz)
summary(logit.fit)
#
# Evaluation of the estimated model
logLik(logit.fit) # The maximized log-likelihood 
#
# Mc Fadden R^2 - manual calculation... 
# Mc Fadden R^2 = 1 - (logLik(Unrestricted model)/logLik(Trivial model))
logit.zero <- glm(inlf ~ 1, family=binomial, data=mroz) # Trivial model
LL.UR <- as.numeric(logLik(logit.fit))
LL.zero <- as.numeric(logLik(logit.zero))
cat("Mc Fadden R^2 = ", 1 - LL.UR/LL.zero)
#
# LR: Likelihood ratio statistics
# LR = 2*(LL(UR)-LL(zero)) ~ Chisq(k) 
# .. under H0: model(UR) is not statistically significant 
# .. where k is the number of variable regressors in UR model
library(lmtest)
lrtest(logit.fit, logit.zero) # Reject H0
lrtest(logit.fit)
#
#
#
## Confusion matrix
pred.logit <- predict(logit.fit, type="response") 
summary(pred.logit) # All predicted probabilities of "success" lie within the (0, 1) interval
# for p-hat => 0.5, we predict "success" (labor force participation)
LOGI.T <- table(Predicted = round(pred.logit), Actual = mroz$inlf)
LOGI.T <- LOGI.T[order(rownames(LOGI.T), decreasing=T),]
LOGI.T <- LOGI.T[, order(colnames(LOGI.T), decreasing=T)]
LOGI.T # Confusion Matrix
#
cat("Overall Correct Classification Ratio:", round((LOGI.T[1,1]+LOGI.T[2,2])/nrow(mroz), 3) )
cat("Correct Classification ratio for Actual = 1 (in labor force):", 
          round(LOGI.T[1,1]/(sum(LOGI.T[,1])),3) )
cat("Correct Classification ratio for Actual = 0 (not in labor force):", 
          round(LOGI.T[2,2]/(sum(LOGI.T[,2])),3) )
#
#
#
#
## Predictions from a model estimated using logistic regression
#
?predict.glm
# Predict on the scale of the linear predictors:
# .. predict the log-odds for observations 100 and 120
p.l.odds <- predict(logit.fit, newdata=mroz[c(100,120), ])
p.l.odds
# 'Manually', we can predict odds (odds ratio):
p.odds <- exp(p.l.odds)
p.odds
# 'Manual' prediction of the success probability:
# p(y) = odds/(1+odds)
p.prob <- p.odds/(1+p.odds)
p.prob
# Success probability, using the "response" argument in predict()
p.prob.R <- predict(logit.fit, type="response", newdata=mroz[c(100,120), ])
p.prob.R
# The predictions may be summarized as follows: 
p.l.odds # log-odds
p.odds # odds ratio
p.prob # predicted probability
p.prob.R # predicted probability using the "response" argument
#
#
#
#
### Probit
#
?glm
#
probit.fit<-glm(inlf ~ nwifeinc + educ + exper + expersq + age + kidslt6 + kidsge6,
               family=binomial(link = "probit"), data=mroz)
summary(probit.fit)
# Prediction from the probit-estimated model
predict(probit.fit, type="response", newdata=mroz[c(100,120), ])
#
#
#
#
#
#
## Marginal effects - Partial effects
# Wooldridge: APEs & PEAs
#
#  Coefficients from a probit and logit model are not directly comparable 
#  and easily interpretable. 
#  However, their marginal effects are.
library(mfx) # install.packages("mfx")
?logitmfx
?probitmfx
# Please note the "atmean" argument - APE vs. PEA
#
# APEs
logit.APEs <- logitmfx(inlf ~ nwifeinc + educ + exper + age 
                       + kidslt6 + kidsge6, data=mroz, atmean = F)
logit.APEs
#
probit.APEs <- probitmfx(inlf ~ nwifeinc + educ + exper + age 
                       + kidslt6 + kidsge6, data=mroz, atmean = F)
probit.APEs
#
#
#
# PAEs
logit.PEAs <- logitmfx(inlf ~ nwifeinc + educ + exper + age 
                       + kidslt6 + kidsge6, data=mroz, atmean = T)
logit.PEAs
#
probit.PEAs <- probitmfx(inlf ~ nwifeinc + educ + exper + age 
                         + kidslt6 + kidsge6, data=mroz, atmean = T)
probit.PEAs
#
#
#
#
#
## Quick exerice: 
## 1) Estimate logistic model for "Poor quality of healthcare for diabetes-patiens'
##
## PoorCare <- OfficeVisits + MedicalClaims + ERVisits + StartedOnCombination
##
## PoorCare == 1 if care is poor
## OfficeVisits is the number of times the patient visited any doctor's office.
## MedicalClaims is the number of days on which the patient had a medical claim
## ERVisits is the number of times the patient visited the emergency room.
## StartedOnCombination is a binary variable: patient started treatment with multiple medication
##
##
## 2) Generate fitted values of the dependent variable (on the response-scale, probabilitites)
## 3) Estimate APEs and PEAs
##
##
rm(list=ls())
Quality <- read.csv("data/quality.csv")
 

# 
#
#
#