#### LPM, Logit, Probit - comparison ####
#
#
rm(list=ls())
require(AER) # install.packages("AER")
data("SwissLabor")
?SwissLabor
attach(SwissLabor)
#
#
#
# spineplots need "factors" as dependent variables.
?spineplot
spineplot(participation~age, ylevel=c("yes","no"))
spineplot(participation~income, ylevel=c("yes","no"))
spineplot(participation~education, ylevel=c("yes","no"))
#
#
plot(income~age, col=participation, pch=21, cex=0.7, bg = "grey",
     main="Participation by Balance and Income")
#
#
#
# We transform the dependent variable into a binary (dummy) variable
parti <- as.character(participation)
n <- length(parti)
for (i in 1:n){
  if(parti[i]=="yes") parti[i]=1
  if(parti[i]=="no") parti[i]=0
}
parti <- as.numeric(parti)
#
#
#
####  Model:   parti ~ age+ I(age^2)+income
#
#### Estimation by different methods
#
## OLS
#
OLS.FIT <- lm(parti ~ age + I(age^2) + income + education)
summary(OLS.FIT)     # education is insignificant
OLS.FIT <- lm(parti ~ age + I(age^2) + income )
summary(OLS.FIT)     # education is insignificant
#
## Logit
#
LOG.FIT <- glm(parti ~ age+ I(age^2)+income, family=binomial(link="logit"))
summary(LOG.FIT)
#
## Probit
#
PROB.FIT <- glm(parti ~ age+ I(age^2)+income, family=binomial(link="probit"))
summary(PROB.FIT)
#
#
## Estimated coefficients
cfs <- cbind(coefficients(OLS.FIT), coefficients(LOG.FIT), coefficients(PROB.FIT))
colnames(cfs) <- c("OLS","Logit", "Probit")
cfs # Only signs of the coefficients may be reasonably compared
#
#
## Predictions from different models
preds <- cbind(fitted(OLS.FIT), fitted(LOG.FIT), fitted(PROB.FIT), parti)
colnames(preds) <- c("OLS","Logit", "Probit", "Actual/Condition")
head(preds, 20)
cor(preds)
#
#
#
### Comparison of estimation methods & their efficiency (by illustration)
#
#
# Log Likelihoods:
logLik(OLS.FIT)
logLik(LOG.FIT)
logLik(PROB.FIT)
#
#
# Confusion matrices construction
OLS.T <- table(Predicted = round(fitted(OLS.FIT)), Actual = parti)
OLS.T <- OLS.T[order(rownames(OLS.T), decreasing=T),]
OLS.T <- OLS.T[, order(colnames(OLS.T), decreasing=T)]
#
LOG.T <- table(Predicted = round(fitted(LOG.FIT)), Actual = parti)
LOG.T <- LOG.T[order(rownames(LOG.T), decreasing=T),]
LOG.T <- LOG.T[, order(colnames(LOG.T), decreasing=T)]
#
PROB.T <- table(Predicted = round(fitted(PROB.FIT)), Actual = parti)
PROB.T <- PROB.T[order(rownames(PROB.T), decreasing=T),]
PROB.T <- PROB.T[, order(colnames(PROB.T), decreasing=T)]
#
# Confusion matrices
OLS.T
LOG.T
PROB.T
#
#
### ROC plot & AUC
#
# ROC plot construction
require(ROCR)
# Add fitted values to the data frame
SwissLabor$parti <- parti
SwissLabor$Fit1 <- fitted(OLS.FIT)
SwissLabor$Fit2 <- fitted(LOG.FIT)
SwissLabor$Fit3 <- fitted(PROB.FIT)
#
# Make {caret} "prediction" objects
P1 <- prediction(SwissLabor$Fit1, labels=SwissLabor$parti) # step 1 in every ROCR evaluation
P2 <- prediction(SwissLabor$Fit2, labels=SwissLabor$parti) 
P3 <- prediction(SwissLabor$Fit3, labels=SwissLabor$parti) 
#
# Save ROC curve data
ROC1 <- performance(P1,"tpr","fpr")
ROC2 <- performance(P2,"tpr","fpr")
ROC3 <- performance(P3,"tpr","fpr")
#
# Plot ROC curves (add multiple ROCs to one plot)
plot(ROC1, lwd=2, main="ROC curve")
plot(ROC2, add = T, lwd=2, col = "red")
plot(ROC3, add = T, lwd=2, col = "green")
arrows(0,0,1,1,lty=2, code=0)
#
#
# AUC statistics
performance(P1,"auc")@y.values
performance(P2,"auc")@y.values
performance(P3,"auc")@y.values
#
#
#
#
#### Performance evaluation using the test sample (prediction sample)
#
## Ad-hoc illustration
#
# Leave out observations (rows) 601-872 from the estimation and evaluate models' 
# & test sample performance evaluation
#
#
# Step 1: Re-estimation of the models (train sample only)
#
# OLS
OLS.FIT2 <- lm(parti ~ age + I(age^2) + income, data=SwissLabor[1:600, ])
summary(OLS.FIT2)     
AIC(OLS.FIT2) # for comparison with Logit and Probit
#
# Logit
LOG.FIT2 <- glm(parti ~ age+ I(age^2)+income, family=binomial, 
               data=SwissLabor[1:600, ])
summary(LOG.FIT2)
#
# Probit
PROB.FIT2 <- glm(parti ~ age+ I(age^2)+income, family=binomial(link="probit"), 
                data=SwissLabor[1:600, ])
summary(PROB.FIT2)
#
#
# Step 2: Predictions (test sample)
OLS.pred <- round(predict(OLS.FIT2, newdata = SwissLabor[601:872, ]))
LOG.pred <- round(predict(LOG.FIT2, newdata = SwissLabor[601:872, ], type="response"))
PROB.pred <- round(predict(PROB.FIT2, newdata = SwissLabor[601:872, ], type="response"))
#
# Test sample confusion matrix
#
OLS.T2 <- table(Predicted = OLS.pred, Actual = SwissLabor[601:872,"parti" ])
OLS.T2 <- OLS.T2[order(rownames(OLS.T2), decreasing=T),]
OLS.T2 <- OLS.T2[, order(colnames(OLS.T2), decreasing=T)]
#
LOG.T2 <- table(Predicted = LOG.pred, Actual = SwissLabor[601:872,"parti" ])
LOG.T2 <- LOG.T2[order(rownames(LOG.T2), decreasing=T),]
LOG.T2 <- LOG.T2[, order(colnames(LOG.T2), decreasing=T)]
#
PROB.T2 <- table(Predicted = PROB.pred, Actual = SwissLabor[601:872,"parti" ])
PROB.T2 <- PROB.T2[order(rownames(PROB.T2), decreasing=T),]
PROB.T2 <- PROB.T2[, order(colnames(PROB.T2), decreasing=T)]
#
OLS.T2
LOG.T2
PROB.T2
#
#
#
#
#
#
#