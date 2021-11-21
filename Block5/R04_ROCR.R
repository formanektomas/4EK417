#### Confusion matrix and {ROCR} package ####
#
## Predictor (classifier) evaluation methods
#
#
# Default example - continued
# Data
rm(list=ls())
library(ggplot2) # install.packages("ggplot2")
library(ISLR) # install.packages("ISLR")
data <- Default
attach(data)
def <- rep(0, 10000) # We need to construct dependent dummy variable
def[data$default=="Yes"] <- 1
data$def <- def
head(data)
#
#
# Logistic regression
LOG.FIT <- glm(def~balance+student, family=binomial)
summary(LOG.FIT)
data$log.fit <- fitted(LOG.FIT) # same as predict(... , type="response")
ggplot(data, aes(x=log.fit)) + 
  geom_histogram(bins = 100)
#
#
#
# Confusion matrix 1, cutoff at yhat=0.5
#
Log.T <- table(Predicted = round(data$log.fit), Actual = data$def)
Log.T <- Log.T[order(rownames(Log.T), decreasing=T),]
Log.T <- Log.T[, order(colnames(Log.T), decreasing=T)]
Log.T
# for p-hat => 0.5, we predict "success" (default)
cat("Overall Correct Classification Ratio:", round((Log.T[1,1]+Log.T[2,2])/nrow(data), 3)) 
cat("Correct Classification ratio for Actual = 1 (in labor force):", 
           round(Log.T[1,1]/(sum(Log.T[,1])),3) )
cat("Correct Classification ratio for Actual = 0 (not in labor force):", 
           round(Log.T[2,2]/(sum(Log.T[,2])),3) )
#
#
#
# Confusion matrix 2, cutoff at yhat=0.3
#
# First, we need to create predictions from a new threshold:
pred2 <- ifelse(data$log.fit > 0.3,1,0)
#
Table.2 <- table(Predicted = pred2, Actual = data$def)
Table.2 <- Table.2[order(rownames(Table.2), decreasing=T),]
Table.2 <- Table.2[, order(colnames(Table.2), decreasing=T)]
Table.2
cat("Overall Correct Classification Ratio:", round((Table.2[1,1]+Table.2[2,2])/nrow(data), 3)) 
cat("Correct Classification ratio for Actual = 1 (in labor force):", 
    round(Table.2[1,1]/(sum(Table.2[,1])),3) )
cat("Correct Classification ratio for Actual = 0 (not in labor force):", 
    round(Table.2[2,2]/(sum(Table.2[,2])),3) )
#
#
## Assignment 1
## a) How does the True positive rate P(Yhat = + | Y = +)"
##    change if we lower the "cutoff" to 0.25
##
## b) What is the cutoff" that would lead to a , 
##    True Positive Rate of 80% or more?
#
#
#
#
#
#
# Illustration: {caret} package for confusion matrix-associated statistics 
library(caret) # install.packages("caret")
# help(package=caret)
library(e1071) # install.packages("e1071")
?caret::confusionMatrix
# Success ratio / prevalence needs to be specified for the confusionMatrix()
preval <- sum(def)/nrow(data)
pred2 <- factor(pred2)
observed.def <- factor(data$def)
confusionMatrix(pred2, observed.def, positive="1", prevalence=preval)
# "no information rate," refers to predictions based on largest class 
# in the table...
# Mcnemar's Test
# https://en.wikipedia.org/wiki/McNemar%27s_test
# ..  to determine whether the row and column marginal frequencies are equal
#
# See also details in:
# https://topepo.github.io/caret/measuring-performance.html
#
# Cohen's kappa
# It is generally thought to be a more robust measure than simple percent 
# agreement calculation, as ?? takes into account the possibility of the 
# agreement occurring by chance.
# 
#
#
# {ROCR} Visualizing the Performance of Scoring Classifiers
library(ROCR) # install.packages("ROCR")
help(package=ROCR)
fp <- glm(def~balance+student, family=binomial, data=data)$fitted
summary(fp) #find median of fitted values
#
# Accuracy plot: (TP+TN)/(P+N)
?prediction # step 1 in every ROCR evaluation
pred <- prediction(fp, labels=data$def) # step 1 in every ROCR evaluation
?performance
perf <- performance(pred,measure="acc") # Actual performance evaluation 
plot(perf)
#
# Sensitivity
# True positive rate plot: P(Yhat = + | Y = +). Estimated as: TP/P.
plot(performance(pred,measure="tpr"))
#
# False positive rate plot: P(Yhat = + | Y = -). Estimated as: FP/N
plot(performance(pred,measure="fpr"))
#
# Specificity
# True negative rate. P(Yhat = - | Y = -)
plot(performance(pred,measure="tnr"))
#
# False negative rate plot: P(Yhat = - | Y = +). Estimated as: FN/P.
plot(performance(pred,measure="fnr"))
#
# Sensitivity/specificity curve (x-axis: specificity, y-axis: sensitivity)
plot(performance(pred, "sens", "spec"))
#
# ROC curve (receiver operating characteristics)
plot(performance(pred,"tpr","fpr"), main="ROC Curve")
arrows(0,0,1,1,lty=2, code=0)
#
#
# ROC explained
plot(performance(pred,"tpr","fpr"), main="ROC Curve", 
     colorize=TRUE, print.cutoffs.at=seq(0,1,by=0.1))
arrows(0,0,1,1,lty=2, code=0)
#
# a)
# The ROC curve always starts at the point (0, 0) 
# i.e threshold of value 1.This means at this threshold we 
# will not catch any defaults (sensitivity of 0) 
# but will correctly label of all the non-defaulting clients (FP = 0)
#
# b)
# The ROC curve always ends at the point (1,1) 
# i.e threshold of value 0. This means at this threshold we will 
# catch all the default cases (sensitivity of 1) but will 
# incorrectly label of all the non-defaults as defaulting clients (FP = 1)
#
# c)
# The ROC curve captures all thresholds simultaneously.
# The higher the threshold, or closer to (0, 0), 
# the higher the specificity and the lower the sensitivity. 
# The lower the threshold, or closer to (1,1),the higher the sensitivity 
# and lower the specificity.
#
# d)
# So which threshold value one should pick?
# No general answer... select the best threshold for the trade-off you want to make.
# A threshold around 0.1 - i.e point approx (0.1, 0.7) on this ROC curve - looks like a good choice.
# .. On the other hand, if one is more concerned with having 
# .. a high sensitivity (TPR), one should pick a lower threshold.
# .. at the expense of higher false positive rate (FPR).
#
# Some "automatic" selection methods are available:
# https://www.r-bloggers.com/2019/02/some-r-packages-for-roc-curves/
#
#
#
#
# Alternatively, {ROCR} built-in ROC convex hull - a ROC (=tpr vs fpr) curve 
# with concavities removed  (those represent sub-optimal choices of cutoff) 
plot(performance(pred,"rch"))
arrows(0,0,1,1,lty=2, code=0)
#
# Area under the ROC curve
performance(pred,"auc")@y.values # Ideally, very close to unity.
#
#
#
#
#
# Say, we want to find the cutoff that maximizes accuracy (ACC)
# .. of the classification based on the model estimated by logistic regression.
# .. This example and approach is relevant for the train sample only,
# .. Cross validation (evaluation) may be performed.
#
#
plot(performance(pred,measure="acc")) # which cutoff maximizes accuracy?
str(performance(pred,measure="acc"))
acc.rate <- performance(pred,measure="acc")@y.values # "@" is used with S4 objects
cutoff <- performance(pred,measure="acc")@x.values
acc.rate <- unlist(acc.rate)
cutoff <- unlist(cutoff)
plot(acc.rate~cutoff, type="l")
#
max(acc.rate)
which(acc.rate == max(acc.rate))
best.acc.cutoff <- cutoff[which(acc.rate == max(acc.rate))]
abline(v=best.acc.cutoff, col="red",lty=2)
best.acc.cutoff
#
# Confusion matrix 3, cutoff for maximum train data accuracy
#
# First, we need to create the predictions:
pred3 <- ifelse(data$log.fit > best.acc.cutoff,1,0)
#
Table.3 = table(Predicted = pred3, Actual = data$def)
Table.3 <- Table.3[order(rownames(Table.3), decreasing=T),]
Table.3 <- Table.3[, order(colnames(Table.3), decreasing=T)]
Table.3
cat("Overall Correct Classification Ratio:", round((Table.3[1,1]+Table.3[2,2])/nrow(data), 3))
cat("Correct Classification ratio for Actual = 1 (in labor force):", 
    round(Table.3[1,1]/(sum(Table.3[,1])),3) )
cat("Correct Classification ratio for Actual = 0 (not in labor force):", 
    round(Table.3[2,2]/(sum(Table.3[,2])),3) )
# Comparison of confusion matrices:
Table.3 # cutoff at yhat = 0.4288332
Log.T # cutoff at yhat = 0.5
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
## Titanic survival: Complex data analysis example
#
# VARIABLE DESCRIPTIONS:
#
# survival        Survival   (0 = No; 1 = Yes)
# pclass          Passenger Class  (1 = 1st; 2 = 2nd; 3 = 3rd)
# name            Name
# sex             Sex
# age             Age
# sibsp           Number of Siblings/Spouses Aboard
# parch           Number of Parents/Children Aboard
# ticket          Ticket Number
# fare            Passenger Fare
# cabin           Cabin
# embarked        Port of Embarkation (C = Cherbourg; Q = Queenstown; S = Southampton)
# title           5 levels (factors)
# Child           dummy variable, passenger is a child
# Family          Family size (min = 1)
# Mother          dummy variable, passenger is a mother
#
rm(list=ls())
Titanic <- read.csv("data/titanic_cleaned.csv")
#
head(Titanic)
summary(Titanic)
#Survival visualization 
#
# by Passenger Class
Surv <- table(Titanic$Survived, Titanic$Pclass)
Surv
barplot(Surv, xlab="Passenger Class" ,ylab = "Number of People", beside=T, main = "survived and deceased by Passenger Class", las=1, legend.text=c("deceased","survived"))
#
# by Gender
counts1 <- table(Titanic$Survived, Titanic$Female)
barplot(counts1, xlab = "Female ", ylab = "Number of People", 
        beside=T, main = "survived and deceased between male and female", 
        las=1, legend.text=c("deceased","survived"))
# by Port of Embarkation
# C = Cherbourg; Q = Queenstown; S = Southampton
counts3 <- table(Titanic$Survived, Titanic$Embarked)
barplot(counts3, xlab="Port of Embarkation" ,ylab = "Number of People", beside=T, main = "survived and deceased by Port of Embarkation", las=1, legend.text=c("deceased","survived"))
#
# Mosaicplot reflects accurate relative proportions (by tile-area)
mosaicplot(Titanic$Pclass ~ Titanic$Survived, 
           main="Passenger Fate by Traveling Class", shade=FALSE, 
           color=TRUE, xlab="Pclass", ylab="Survived")
#
#
#
#
## To model survival probabilities, we evaluate three logistic regressions, 
## .. with confusion matrices and ROC curves provided
#
Titanic$Pclass <- as.factor(Titanic$Pclass)
# Logistic regressions
LR1 <- glm(Survived~Pclass, family=binomial, data=Titanic)
LR2 <- glm(Survived~Pclass+Female, family=binomial, data=Titanic)
LR3 <- glm(Survived~Pclass+Female+Age, family=binomial, data=Titanic)
LR4 <- 
#
# Regression outputs
summary(LR1)
summary(LR2)
summary(LR3)
#
# Predictions
y.f.1 <- round(fitted(LR1))
y.f.2 <- round(fitted(LR2))
y.f.3 <- round(fitted(LR3))
#
# Basic confusion matrices
T1 <- table(Predicted = y.f.1, Actual = Titanic$Survived)
T1 <- T1[order(rownames(T1), decreasing=T),]
T1 <- T1[, order(colnames(T1), decreasing=T)]
#
T2 <- table(Predicted = y.f.2, Actual = Titanic$Survived)
T2 <- T2[order(rownames(T2), decreasing=T),]
T2 <- T2[, order(colnames(T2), decreasing=T)]
#
T3 <- table(Predicted = y.f.3, Actual = Titanic$Survived)
T3 <- T3[order(rownames(T3), decreasing=T),]
T3 <- T3[, order(colnames(T3), decreasing=T)]
#
T1
T2
T3
#
# Confusion matrix output from the {caret} library
library(caret) 
prev=sum(Titanic$Survived)/nrow(Titanic)
# predicted and observed variables need to be factors...
y.f.1 <- factor(y.f.1)
y.f.2 <- factor(y.f.2)
y.f.3 <- factor(y.f.3)
Obs.Surv <- factor(Titanic$Survived)

confusionMatrix(y.f.1, Obs.Surv, positive="1", prevalence=prev)
confusionMatrix(y.f.2, Obs.Surv, positive="1", prevalence=prev)
confusionMatrix(y.f.2, Obs.Surv, positive="1", prevalence=prev)
#
#
## ROC curvess
#
# Add fitted values to the data frame
Titanic$Fit1 <- fitted(LR1)
Titanic$Fit2 <- fitted(LR2)
Titanic$Fit3 <- fitted(LR3)
#
# Make {caret} "prediction" objects
P1 <- prediction(Titanic$Fit1, labels=Titanic$Survived) # step 1 in every ROCR evaluation
P2 <- prediction(Titanic$Fit2, labels=Titanic$Survived) 
P3 <- prediction(Titanic$Fit3, labels=Titanic$Survived) 
#
# Save ROC curve data
ROC1 <- performance(P1,"tpr","fpr")
ROC2 <- performance(P2,"tpr","fpr")
ROC3 <- performance(P3,"tpr","fpr")
#
# Plot ROC curves (add multiple ROCs to one plot)
plot(ROC1, lwd=2, main="ROC curve")
plot(ROC2, add = T, lwd=2, col = "blue")
plot(ROC3, add = T, lwd=2, col = "green")
#
#
#
#
## Assignment 2
## BIC values for the logistic regressions LR1, LR2 and LR3 are as follows:
BIC(LR1)
BIC(LR2)
BIC(LR3)
## Using "Titanic" variables, specifiy a model "LR4" of your choice
## that would be better at predicting Titanic survival.
## 
##
##
## Assignment 3
## Produce the combine ROC-plot for models LR1 to LR4
##
##
## Assignment 4
## What is the AUC (area under ROC curve) for LR3 and LR4 models?
##
##
## Assignment 5
## Use the {ROCR} package to produce the "Accuracy" (acc) plot
## (with "cutoff" on the x-axis) for the LR4 model, 
#
#
#