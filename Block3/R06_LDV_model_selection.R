### Model selection methods and binary dependent variables (logistic regression)
#
library(Ecdat) # install.packages("Ecdat")
#
# Unemployment insurance - Blue Collar Workers
rm(list=ls())
dataUI <- Benefits
?Benefits
dataUI$bluecol <- NULL # "yes" for all rows in the dataset
dataUI$ui <- as.character(dataUI$ui)
dataUI$ui <- ifelse(dataUI$ui == "yes",1,0)
# ui is our dependent variable
# .. applied for (and received) UI benefits ?
#
#
#
#
#
# 1] Stepwise regression
#
library(MASS) # install.packages("MASS")
# Full glm() logistic model
glm1 <- glm(ui ~ ., family = binomial, data = dataUI)
summary(glm1)
#
?stepAIC
# Selection based on AIC, "backwards" selection is the default
glm1.step <- stepAIC(glm1) # note how the algorithm stops after removing "nwhite"
glm1.step$anova # summary of the eliminated regressors
# The usual operations may be performed:
summary(glm1.step)
head(predict(glm1.step,type="response"),10)
#
#
#
#
#
# 2] Lasso regularization using {glmpath}
#
#
library(glmpath) # install.packages("glmpath")
?glmpath
#
X.mat <-  model.matrix(ui~., dataUI)[,-1] # remove intercept column of ones
y <- dataUI$ui
fit.lasso <- glmpath(X.mat, y, family=binomial)
#
# Coefficient "selection" by lasso penalty
plot(fit.lasso, xvar="step", mar = c(5,4,4,7)) # for each step, a regressor is excluded
plot(fit.lasso, xvar="step", xlimit=6, mar = c(5,4,4,7)) # `last few` regressors
#
# Coefficient penalization (restriction) at different lambda values
plot(fit.lasso, xvar="lambda", mar = c(5,4,4,7))
#
# BIC for different "lambda" restrictions
plot(fit.lasso, type="bic", xvar="lambda")
#
# Model selection based on the "BIC"
#
summary(fit.lasso)
select <- which(fit.lasso$bic==min(fit.lasso$bic))
fit.lasso$b.predictor[select,] # minimum BIC & corresponding model
fit.lasso$lambda[select]
#
#
# Alternatively, we can use CV
#
# ?cv.glmpath
# cv.lasso <- cv.glmpath(X.mat, y, family=binomial, type="response", mode="lambda")
# min.cv <- which(cv.lasso$cv.error == min(cv.lasso$cv.error))
# abline(v=min.cv/100, col="red")
# fraction: the fraction of L1 norm or log(\lambda) with respect to their maximum values 
# at which the CV errors are computed. Default is seq(0,1,length=100).
#
#
#
# Predictions
?predict.glmpath
# predictions made at different "steps" 
pred <- predict.glmpath(fit.lasso, newx = X.mat, type="response")
head(pred,10)
# predictions at min BIC
pred <- predict.glmpath(fit.lasso, newx = X.mat, type="response",s=select)
head(pred,10)
# predictions at min BIC - Alternative syntax using lambda value at BIC minimal.
pred <- predict.glmpath(fit.lasso, newx = X.mat, 
                        type="response",
                        mode="lambda",
                        s=fit.lasso$lambda[select])
head(pred,10)
#
#
#
##########################################################################
# Detecting separation and infinite estimates in binomial response GLMs  #
##########################################################################
#
#
#
library("brglm2")
data("endometrial", package = "brglm2")
modML <- glm(HG ~ NV + PI + EH, family = binomial, data = endometrial)
summary(modML)
# Syntax for separation detection
library("detectseparation")
?detectseparation::detect_separation
endometrial_sep <- glm(HG ~ NV + PI + EH, data = endometrial,
                       family = binomial("logit"),
                       method = "detect_separation")
endometrial_sep 
#
# 
#
library(glmpath) # install.packages("glmpath")
X.mat <-  model.matrix(HG ~ NV + PI + EH, endometrial)[,-1]
y <- endometrial$HG
fit.lasso <- glmpath(X.mat, y, family=binomial)
#
# Coefficient "selection" by lasso penalty
plot(fit.lasso, xvar="step", mar = c(5,4,4,7))
summary(fit.lasso)
# Coefficients at different steps
fit.lasso$b.predictor
# Coefficients and lambda at minimum BIC
select <- which(fit.lasso$bic==min(fit.lasso$bic))
fit.lasso$b.predictor[select,] # minimum BIC & corresponding model
fit.lasso$lambda[select]

# Predictions at lambda minizing the bic statistic.
predict(fit.lasso,newx=X.mat[1:10,],s=select,type="response")
#
#
#
