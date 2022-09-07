#### Multinomial Logit ####
#
#
# see: http://en.wikipedia.org/wiki/Multinomial_logistic_regression
# see: http://data.princeton.edu/wws509/notes/c6s2.html
#
# Multinomial Logit
# A method that is used to predict the probabilities of different 
# possible outcomes of a categorically distributed dependent variable, 
# given a set of independent variables (which may be real, binary,
# categorical-valued, etc.)
#
# Multinomial logit regression provides a particular solution to the 
# classification problem that assumes that a linear combination 
# of the observed features and some problem-specific parameters 
# can be used to determine the probability of each particular outcome 
# of the dependent variable. 
#
# Note that we need only J-1 equations to describe a variable with 
# J response categories and that it really makes no difference which 
# category we pick as reference, because we can always convert 
# from one formulation to another.
#
#
#
#
#
# Data
rm(list=ls())
occ <- read.csv("data/occupation.csv")
occ$status <- as.factor(occ$status)
occ$black <- as.factor(occ$black)
# sample of young men & their occupation/status
# "at home", "in school", "working", where "at home" means not in school and not working.
# Occupation/status is modelled using: age, exper, exper^2, black
# .. usuall interpretation of explanatory variables.
#
#
#
# Model estimation
# install.packages("nnet")
library(nnet)
help(package=nnet)
?multinom
#
summary(multinom(status~educ+exper+expersq+black, data=occ))
# Say, we want "school" to be the base outcome
occ$status <- relevel(occ$status, ref="school")
multi.FIT <- multinom(status~educ+exper+expersq+black, data=occ)
summary(multi.FIT)
library("lmtest") # instal.packages("lmtest")
library("AER") # install.packages("AER")
coeftest(multi.FIT) # interpret coefficients on educ and black...
#
#
#
#
# Predictions from the model I.
#
class.fit <- predict(multi.FIT, type='class')
prob.fit <- predict(multi.FIT, type='probs')
#
head(class.fit)
head(prob.fit)
# The outcome with the highest estimated probability is the predicted outcome.
head(cbind(prob.fit, as.character(class.fit)), 15)
sum.prob <- apply(prob.fit, MARGIN=1, sum)
head(cbind(prob.fit, sum.prob), 15)
#
#
#
#
## Predictions from the model I - differences in estimated probabilities.
#
# a) Lets consider two black men, each with 5 years of experience
#    one has 12 years of education, the other 13 years.
#    What change in expected outcome probabilities is associated
#    with 1 year difference in education?
#
occ2 <- rbind(c(12, 5, 25, 1, NA), c(13, 5, 25, 1, NA))
occ2 <- data.frame(occ2)
colnames(occ2) <- c("educ", "exper", "expersq", "black", "status")
occ2$black <- as.factor(occ2$black)
occ2
exp.status.prob <- predict(multi.FIT, type='probs', newdata=occ2)
exp.status.prob
#
# Changes in fitted probabilities
exp.status.prob[2,] - exp.status.prob[1,]
#
# Probabilities on all three statuses must add up to 1
# for any individual....
round(sum(exp.status.prob[2,] - exp.status.prob[1,]), 4)
#
#
#
#
## Interpretation of the individual beta-coefficients on "educ" 
# 
coeftest(multi.FIT)
# home:educ        -0.673546
# work:educ        -0.314554
#
# relative change in [p(home)/p(school)] from a one unit increase in educ, cet. par.
exp(-0.673546)-1
# relative change in [p(work)/p(school)] given a one unit increase in educ, cet. par.
(exp(-0.314554)-1)
#
exp.status.prob
x1 <- (exp.status.prob[1,2]/exp.status.prob[1,1]) #[p(home)/p(school)], educ=12
x2 <- (exp.status.prob[2,2]/exp.status.prob[2,1]) #[p(home)/p(school)], educ=13, cet.par.
# odds ratios
x1
x2
# relative change in odds ratio  
(x2-x1)/x1 # relative change in [p(home)/p(school)] from a one unit increase in educ, cet. par.
#
x3 <- (exp.status.prob[1,3]/exp.status.prob[1,1]) #[p(work)/p(school)], educ=12
x4 <- (exp.status.prob[2,3]/exp.status.prob[2,1]) #[p(work)/p(school)], educ=13, cet.par.
(x4-x3)/x3 # relative change in [p(work)/p(school)] from a one unit increase in educ, cet. par.
#
# 
## Interpretation excercise
## - On row 80, change education levels of the two men to 10 and 11 (delta educ=1),
##   cet. par. experience and black variables.
## - Repeat rows 80 - 112.
## - Compare expected probabilities "exp.stat.prob" matrix as educ goes 
##   from 12 to 13 with the same matrix as educ changes from 10 to 11 (cet. par.)
## - Also, compare changes in fitted probabilities (row 87)
## - Comment on interpretation of the individual beta-coeffs as calculated 
##   in rows 96 - 114... 
##   "When educ: 10->11 instead of 12->13 (cet. par.).... interpretation of home:educ and work:educ"
#
#
#
#
#
#
# b) Lets consider two  men, each with 6 years of experience
#    and 16 years of education. First one is black, the other is not.
#    What change in expected outcome probabilities is associated
#    with "black"?
#
# 
occ3 <- rbind(c(16, 6, 36, 1, NA), c(16, 6, 36, 0, NA))
occ3 <- data.frame(occ3)
colnames(occ3) <- c("educ", "exper", "expersq", "black", "status")
occ3$black <- as.factor(occ3$black)
exp.status.prob.b <- predict(multi.FIT, type='probs', newdata=occ3)
exp.status.prob.b
#
# Changes in fitted probabilities
exp.status.prob.b[2,] - exp.status.prob.b[1,]
#
# Probabilities on all three statuses must add up to 1
# for any individual....
round(sum(exp.status.prob.b[2,] - exp.status.prob.b[1,]), 4)
#
## Interpretation of the individual beta-coefficients on "black" 
# 
coeftest(multi.FIT)
# home:black        0.812182
# work:black        0.310526
#
# relative change in [p(home)/p(school)] between black=1 and black=0, cet. par.
exp(0.812182)-1
# relative change in [p(work)/p(school)] between black=1 and black=0, cet. par.
(exp(0.310526)-1)
#
exp.status.prob.b
x5 <- (exp.status.prob.b[1,2]/exp.status.prob.b[1,1]) #[p(home)/p(school)], black=1 
x6 <- (exp.status.prob.b[2,2]/exp.status.prob.b[2,1]) #[p(home)/p(school)], black=0 , cet.par.
(x5-x6)/x6 # relative change in [p(home)/p(school)]
#
x7 <- (exp.status.prob.b[1,3]/exp.status.prob.b[1,1]) #[p(work)/p(school)], black=1 
x8 <- (exp.status.prob.b[2,3]/exp.status.prob.b[2,1]) #[p(work)/p(school)], black=0 , cet.par.
(x7-x8)/x8 # relative change in [p(work)/p(school)] 
# 
# 
#
#
# 
#
#
#
#
## Model evaluation: 
coeftest(multi.FIT)
logLik(multi.FIT)
library("lmtest") # instal.packages("lmtest")
lrtest(multi.FIT)
#  McFadden's pseudo-R-squared = 1 - (deviance(UR)/deviance(null.model))
null.m <- multinom(status~1, data=occ)
summary(null.m)
cat("McFadden's pseudo-R-squared =", 1- (deviance(multi.FIT)/deviance(null.m)) )
#
#
#
#
### Confusion matrix
#
# install.packages("caret")
library(caret)
#
confusionMatrix(data = class.fit, reference = occ$status)
#
#
### Effects plot
#
library(effects)
# recast the model without expersq (as separate regressor)
multi.FIT2 <- multinom(status~educ+exper+black, data=occ)
plot(allEffects(multi.FIT2), type="probability" )
plot(allEffects(multi.FIT2), type="probability",
     style = "stacked",colors = c("blue", "red", "orange"),
     rug=F)
plot(effect("educ*black", multi.FIT2), type="probability")
plot(effect("exper*black", multi.FIT2), type="probability")
#
#
#
#
#
#
#
#