#### Ordered Multinomial Response Models ####
#
#
#
#
#
#
library("MASS") # install.packages("MASS")
#
#
### Example 1: Asset allocation in Pension Plans
#              .. amended from Wooldridge, J: (2002)
#              .. Econometric Analysis of Cross Section and Panel Data
#              .. Example 15.5
#
# Data
rm(list=ls())
pension <- read.csv("data/pension.csv")
#
# Variables
# 
# Ordered dependent variable: 
# pctstck = {0, 50, 100}
# codes the response "mostly bonds", "mixed", "mostly stock"
#
# Explanatory variables:
# age, educ female, black, married .. standard interpretation
# choice = 1  if a person has a choice in how pension fund is invested
# wealth89    net worth, 1989, $1000
# prftshr =1  if profit sharing plan
# income is described by a set of dummy variables:
#
# finc25=1  ....   $15,000  < faminc92  <= $25,000
# finc35=1  ....   $25,000  < faminc92  <= $35,000
# finc50=1  ....   $35,000  < faminc92  <= $50,000
# finc75=1  ....   $50,000  < faminc92  <= $75,000
# finc100=1 ....   $50,000  < faminc92  <= $75,000
# finc101=1 ....   $100,000 < faminc92
#
#
#
# Model estimation
#
# OLS (dependent variable is NOT treated as ordinary)
summary(lm(pctstck~age+educ+female+black+choice+wealth89+prftshr
           +finc35+finc50+finc75+finc100+finc101, data=pension))
# "choice" = 12.76 ... if a person has a choice over his/her
#                      pension plan, on average there are 
#                      about 12.8 percent more assets in stocks
#
#
# Ordered response 
?polr
head(pension)
summary(pension)
pension$choice <- as.factor(pension$choice)
pension$pctsk <- as.factor(pension$pctstck) # dep. var must be a factor
Ordered.probit <- polr(pctsk~age+educ+female+black+choice+wealth89
                       +prftshr+finc35+finc50+finc75+finc100+finc101, 
                       data=pension, Hess = T, method="probit")
#
Ordered.logit <- polr(pctsk~age+educ+female+black+choice+wealth89
                      +prftshr+finc35+finc50+finc75+finc100+finc101, 
                      data=pension, Hess = T, method="logistic")
#
summary(Ordered.probit)
summary(Ordered.logit)
#
require("lmtest") # instal.packages("lmtest")
require("AER") # install.packages("AER")
coeftest(Ordered.probit)
coeftest(Ordered.logit)
#
str(Ordered.probit)
#
#
#
#
# Simple predictions
head(predict(Ordered.probit)) # type="class", the default 
head(predict(Ordered.probit, type="p")) # type="probs".
#
head(predict(Ordered.logit))
head(predict(Ordered.logit, type="p"))
#
#
#
#
# Model evaluation - probit
logLik(Ordered.probit)
lrtest(Ordered.probit)
#  Pseudo-R-squared = 1 - (logLik(UR)/logLik(null.model))
null.m <- polr(pctsk~1, data=pension, Hess = T, method="probit")
summary(null.m)
cat("Pseudo-R-squared =", 1- (logLik(Ordered.probit)/logLik(null.m)) )
#
# Model evaluation - logit
logLik(Ordered.logit)
lrtest(Ordered.logit)
#  Pseudo-R-squared = 1 - (logLik(UR)/logLik(null.model))
null.m2 <- polr(pctsk~1, data=pension, Hess = T, method="logistic")
summary(null.m2)
cat("Pseudo-R-squared =", 1- (logLik(Ordered.logit)/logLik(null.m2)) )
#
#
#
#
# Confusion matrices: logit & probit
#
probit.fitted <- predict(Ordered.probit)
logit.fitted <- predict(Ordered.logit)
# install.packages("caret")
library(caret)
#
confusionMatrix(data = probit.fitted, reference = pension$pctsk)
#
confusionMatrix(data = logit.fitted, reference = pension$pctsk)
#
#
#
#
# 
## The estimated effect of change in the explanatory variable "choice" 
#  on the expected probabilities of dependent variable outcomes.
#
#  .. Beta coefficient for "choice" > 0 (both for probit and logit)
#  .. therefore: P(y="0", i.e. mostly bonds) decreases as "choice" changes from 0 to 1
#                P(y="100", i.e. mostly stocks) increases as "choice" changes from 0 to 1
#                effect on P(y="50") is not determined by sign of the beta coefficient!
#
#  .. To calculate expected probabilities, we need to choose values
#  .. for the other regressors:
#     Illustrative, approx. average person: 
#         age=60, educ=13.5, married=0,
#         black=0, female=0, wealth89 = 200 {$200.000}
#         finc75=1 {income between $50.000 and $75.000}
# new data
pens2 <- rbind(c(NA, 60, 13.5, 0, 0, 0, 200, 1, 0, 0, 1, 0, 0), 
               c(NA, 60, 13.5, 0, 0, 1, 200, 1, 0, 0, 1, 0, 0))
pens2 <- data.frame(pens2)
colnames(pens2) <- c("pctsk","age","educ","female","black","choice","wealth89","prftshr",
                    "finc35","finc50","finc75","finc100","finc101")
pens2$choice <- as.factor(pens2$choice)
pens2
# prediction of dependent variable probability outcomes
y.P.probit <- predict(Ordered.probit, type='p', newdata=pens2)
y.P.logit <- predict(Ordered.logit, type='p', newdata=pens2)
#
y.P.probit # see rows 125 - 128
y.P.logit
#
# As the outcomes are ordered, it makes sense to calculate
# cumulative probabilities: e.g.: P(y <= 50 | x) = P(y = 0 | x) + P(y = 50 | x)
# and the changes in estimated cumulative probabilities given a change in regressor.
#
# P(y <= 50), choice=0, probit
1-y.P.probit[1,3]
# P(y <= 50), choice=1, cet. par., probit
1-y.P.probit[2,3]
# Change in P(y <= 50) as choice moves from 0 to 1:
(1-y.P.probit[2,3]) - (1-y.P.probit[1,3])
#
#
#
#
#
library(effects)
# recast the model without expersq (as separate regressor)
plot(allEffects(Ordered.logit), type="probability",
     style = "stacked",colors = c("blue", "red", "orange"),
     rug=F)
plot(effect("age*choice", Ordered.logit), style = "stacked", 
     colors = c("darkgreen", "grey", "red"), type="probability")
plot(effect("age*educ", Ordered.logit), style = "stacked", 
     colors = c("darkgreen", "grey", "red"), type="probability")
plot(effect("age", Ordered.logit), style = "stacked", 
     colors = c("darkgreen", "grey", "red"), type="probability")
plot(effect("educ", Ordered.logit), style = "stacked", 
     colors = c("darkgreen", "grey", "red"), type="probability")
#
#
#
#
#
#
#### Additional outputs and amendments to the Ordered multinomial model ####
#
#
# {ordinal} package
# install.packages("ordinal")
library(ordinal)
help(package=ordinal)
?clm # see "link" and "threshold" description
#
#
# Model estimation
#
clm.logit <- clm(pctsk~age+educ+female+black+choice+wealth89
                      +prftshr+finc35+finc50+finc75+finc100+finc101, 
                      data=pension, link="logit", threshold="flexible")

#
#
# Comparison of "polr" and "clm" estimates
#
summary(clm.logit)
summary(Ordered.logit)
#
# Beta coefficients
Ordered.logit$coefficients # using polr
clm.logit$beta             # using clm
# 
# Thresholds
Ordered.logit$zeta # using polr
clm.logit$alpha # using clm
#
#
#
#
### Predicted probabilities 
?predict.clm # read the "Details" for argument explanation...
#
#
# Individual outcome probabilities - matrices of predictions
#
# type: P(y = j|x) ;  j = 0, 1, ... , J
#
pension2 <-pension
pension2$pctsk <- NULL
pred1 <- predict(clm.logit, newdata=pension2) # returns a list object...
pred1
pred1 <- matrix(unlist(pred1), nrow=194, ncol=3)
colnames(pred1) <- c("0", "50", "100")
#
head(predict(Ordered.logit, newdata=pension2, type="p")) # polr predictions
pred1[1:6,] # clm predictions
#
#
#
# Cumulative predictions - matrix of predictions
#
# type: P(y <= j|x) ;  j = 0, 1, ... , J
#
pred2 <- predict(clm.logit, newdata=pension2, type="cum.prob") # returns a list object...
pred2$cprob1  # read ?predict.clm "Details" 
pred2 <- matrix(unlist(pred2$cprob1), nrow=194, ncol=3)
colnames(pred2) <- c("0", "50", "100")
#
#
pred1[1:6,] # Individual probabilities
pred2[1:6,] # Cumulative probabilities
#
#
#
#
### Nominal effects - illustrative example
#
# Default polr and clm objects specify a structure where regression parameters, 
# (betas) are not allowed to vary with j.
#
# Nominal effects relax this assumption by allowing one or more regression
# parameters to vary with j. For details, see 
# http://cran.r-project.org/web/packages/ordinal/vignettes/clm_tutorial.pdf
#
#
# Say, we want to allow "choice" and "female" coeffs to vary across j:
# .. we do so by removing both variables from the list of standard regressors
# .. and including them as "nominal".
# 
clm.logit.2 <- clm(pctsk~age+educ+wealth89+black
                 +prftshr+finc35+finc50+finc75+finc100+finc101, 
                 nominal=~choice+female,
                 data=pension, link="logit", threshold="flexible")
summary(clm.logit.2) 
#
#
# Confusion matrix, illustrative comparison: default vs. nominal coeffs
#
clm.nominal.fitted <- predict(clm.logit.2, newdata=pension2, type="class")
# 
confusionMatrix(data = logit.fitted, reference = pension$pctsk) # polr
confusionMatrix(data = unlist(clm.nominal.fitted), reference = pension$pctsk) # clm.nominal
#
# From this illustration we see no model prediction-improvement 
# induced by the introduction of "nominal" variables
#
#
#
#
#
### Structured thresholds - example
#
# Here, we impose additional restrictions on the thresholds. 
# The following model requires that the thresholds, alpha(j) 
# are equidistant, i.e. equally spaced.
#
# This restriction only makes sense for three or more thresholds,
# hence we show it using a new dataset.
#
#
rm(list=ls())
wine <- wine
?wine # {ordinal} package
# Dependent variable
# rating: ordered factor with 5 levels
#         1 = “least bitter” and 5 = “most bitter”
# Regressors
# "temperature' and "contact" between juice and skins can be controlled
# when crushing grapes during wine production.
#
#
#
# Ordered logistic regression, no threshold restrictions
fm1 <- clm(rating ~ temp + contact, data = wine,
           link="logit", threshold="flexible")
summary(fm1)
lrtest(fm1)
#
# Threshold restrictions imposed
fm2 <- clm(rating ~ temp + contact, data = wine,
           link="logit", threshold="equidistant")
summary(fm2) # we "save" two degrees of freedom
lrtest(fm2)
#
#
# Thresholds
fm1$alpha # using clm - flexible
fm2$alpha # using clm - equidistant
#
#
# Structured thresholds
# .. equidistance reduces the number of estimated parameters
# .. whether the restrictions are warranted by the data can be 
# .. tested using a likelihood ratio test:
#
anova(fm1, fm2) # Do not reject H0
#
#
## Ukol 1
## Sestavte matici zamen (confusion matrix) pro model fm1
## .. pouzijte knihovu {caret}
##
#
#
#
#
#