#### Lasso-penalized QREG: a quick example.
#
rm(list = ls())
require(Ecdat) # install.packages("Ecdat")
require(quantreg) # install.packages("quantreg")
require(rqPen) # install.packages("rqPen")
#
## Example is based on Return to schooling" data and model
?RetSchool
school <- RetSchool
school <- school[complete.cases(school),]
school$region <- as.factor(school$region)
#
#
#
# Standard QREG:
QR.1 <- rq(wage76 ~ grade76+black+age76+nodaded, data=school, tau = 1:9/10)
summary(QR.1, se="boot")
# summary plot
plot(summary(QR.1, se="boot"), ols=T)
#
# Lasso-penalized QREG as in {quantreg}
QR.lasso <- rq(wage76 ~ grade76+black+age76+nodaded, method="lasso", 
               lambda=100,data=school, tau = 1:9/10)
QR.lasso # no statistical inference available for lasso-QREG
#
#
#######################################
#
# Lasso-penalized QREG as in {rqPen}
#
X.mat <-  model.matrix(wage76~., school)
X.mat <- X.mat[,-1] # constant does not have to be included in X.mat for cv.rq.pen()
y <- school$wage76
#
# {rqPen} does not do X.matrix regularization (assumes regularity)... 
# manually regularize regressors including dummies...
# https://stats.stackexchange.com/questions/69568/whether-to-rescale-indicator-binary-dummy-predictors-for-lasso
# ... see web page for discussion on regularizing dummies in penalized regressions
#
X.mat <- scale(X.mat,center=F,scale=apply(X.mat, 2, sd, na.rm = TRUE))
var(X.mat[,"grade76"])
var(X.mat[,"black"])
#
#
#
## CV-based lambda selection, QREG for tau = 0.5
#
?cv.rq.pen
CV.QREG.lasso <- cv.rq.pen(X.mat,y, tau=0.5) # we use default lasso settings
print(CV.QREG.lasso)
#
CV.QREG.lasso$lambda.min
coefficients(CV.QREG.lasso)
#
cv_plots(CV.QREG.lasso, logLambda = F,main="lambda (tau=0.5)")
abline(v=CV.QREG.lasso$lambda.min, col="red")
#
#
#
## QREG for tau = 0.3 & 0.8
#
CV.QREG.lasso3 <- cv.rq.pen(X.mat,y, tau=0.3)
CV.QREG.lasso8 <- cv.rq.pen(X.mat,y, tau=0.8)
#
# tau=0.3
cv_plots(CV.QREG.lasso3, logLambda = F,main="lambda (tau=0.3)")
abline(v=CV.QREG.lasso3$lambda.min, col="red")
#
# tau=0.8
cv_plots(CV.QREG.lasso8, logLambda = F,main="lambda (tau=0.8)")
abline(v=CV.QREG.lasso8$lambda.min, col="red")
#
# Comparison
Comp <- data.frame(tau0.3=coefficients(CV.QREG.lasso3),
         tau0.5=coefficients(CV.QREG.lasso), 
         tau0.8=coefficients(CV.QREG.lasso8))
Comp 
# Note how CV-based model setup (QREG based on lasso penalty) 
# differs for varying tau values.
# .. coefficients vary, some regressors are switched off.