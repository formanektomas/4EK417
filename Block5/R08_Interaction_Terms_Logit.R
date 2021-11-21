#### Effect displays 
#
# Usage of the {effects} package:
#
# Calculating & plotting effects of interaction elements
# on probability of success in logistic models
# .. application to multilevel dependent variables will be discussed next week
#
#
# Example 1: Titanic data
Titanic <- read.csv("data/Titanic_cleaned.csv")
Titanic$Pclass <- factor(Titanic$Pclass)
Titanic$Female <- factor(Titanic$Female)
#
#
# Logistic model, no interactions
t.0 <- glm(Survived ~ Pclass + Female + Age, data=Titanic, family = binomial)
summary(t.0)
logLik(t.0)
#
#
# Logistic model, with interactions
t.1 <- glm(Survived ~ Pclass + Female + Age
           + Pclass:Female + Pclass:Age + Female:Age, 
           data=Titanic, family = binomial)
summary(t.1)
logLik(t.1)
library(lmtest)
lrtest(t.0,t.1)
#
#
# As we use interaction elements in Logistic models, 
# APEs become "hard" to calculate.
# Package {effects} can be used to provide similar information/output:
#
library(effects)
allEffects(t.1) # type="response" is the default setting
# note that "Age" is split into 5 intervals, with representative 
# "rounded" values as labels.
#
## 1
# By default, all covariates -not included in a term- are set to their means
# .. Example: in "Pclass*Female effect", age = mean(age)
# .. i.e. success probs are calculated for the mean value of age
#
## 2 
# Factors not included in a term are set to their proportional distribution
# by averaging over contrasts
# .. Example: in "Pclass*Age effect", Female/male sample proportions are
# .. used to calculate success probabilities.
#
## 3
# This default setting can be "overriden" by arguments to allEffects
?allEffects
allEffects(t.1, typical = median) # applies only to age, median instead of mean
#
# proportions of the Factors can be set arbitrarily:
# .. Note how the Pclass*Age effect changes (men vs women)
allEffects(t.1, given.values = c(Female1=0)) # Note the Female1 syntax
allEffects(t.1, given.values = c(Female1=1)) # Note the Female1 syntax
#
# Arguments can be combined:
allEffects(t.1, typical = median, given.values = c(Female1=1)) 
#
#
#
## Plotting the effects
#
plot(allEffects(t.1) ) # type="response" is NOT the default here
plot(allEffects(t.1), type="response" ) # type="response"
#
#
#
## Plotting the effects - "individually"
#
?plot.eff
# 
plot(effect("Pclass*Female", t.1), type="response")
plot(effect("Pclass*Age", t.1), type="response")
plot(effect("Female*Age", t.1), type="response")
# Multiline
plot(effect("Pclass*Female", t.1), type="response", 
     lines=list(multiline=TRUE), confint=list(style="bars"))
plot(effect("Pclass*Age", t.1), type="response", 
     lines=list(multiline=TRUE), confint=list(style="bands"))
plot(effect("Female*Age", t.1), type="response", 
     lines=list(multiline=TRUE), confint=list(style="bands"))
#
# Finally, we can plot a "higher order interaction", 
# even if not included in the original model:
plot(effect("Pclass*Female*Age", t.1), type="response")
#
#
#
#
####
## Assignment 1
#
# Data
# Data on police treatment of individuals arrested in Toronto 
# for simple possession of small quantities of marijuana.
rm(list=ls())
library("carData")
Arrests <- Arrests
Arrests$year <- factor(Arrests$year)
?Arrests
str(Arrests)
head(Arrests,10)
#
#
# Basic Logistic model
Arr.0 <- glm(released ~ employed+citizen+checks+colour+year+age,
             family = binomial, data=Arrests)
summary(Arr.0)
#
# Preliminary analysis suggest following two interactions:
# colour and year
# colour and age
#
## 1 Amend the model to include both interactions
#
#
## 2 Produce effects tables for the amended model, use default settings,
##   Plot all effects at once.
#
#
## 3 Produce effects tables, use medians instead of means for covariates
#
#
## 4 Plot the "individual" effects plots
#
#
#
#
#