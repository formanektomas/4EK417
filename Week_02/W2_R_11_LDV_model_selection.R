### Model selection methods and binary dependent variables (logistic regression)
#
require(Ecdat) # install.packages("Ecdat")
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
require(MASS) # install.packages("MASS")
# Full glm() logistic model
glm1 <- glm(ui ~ ., family = binomial, data = dataUI)
summary(glm1)
#
?stepAIC
# Selection based on AIC, "backwards" selection is the default
glm1.step <- stepAIC(glm1)
glm1.step$anova
glm1.step
#
#
#
#
#
# 2] Lasso regularization using {glmpath}
#
#
require(glmpath) # install.packages("glmpath")
?glmpath
#
X.mat <-  model.matrix(ui~., dataUI)
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
fit.lasso$b.predictor[select,] # minimum AIC & corresponding model
#
# Alternatively, we can use CV
?cv.glmpath
cv.lasso <- cv.glmpath(X.mat, y, family=binomial, type="response")
min.cv <- which(cv.lasso$cv.error == min(cv.lasso$cv.error))
abline(v=min.cv/100, col="red")
# fraction: the fraction of L1 norm or log(\lambda) with respect to their maximum values 
# at which the CV errors are computed. Default is seq(0,1,length=100).
#
# Predictions
?predict.glmpath
pred <- predict.glmpath(fit.lasso, newx = X.mat, type="response",s=select)
head(pred,10)
#
#
#
#
#