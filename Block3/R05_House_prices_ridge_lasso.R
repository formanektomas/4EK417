### Modelling Prices of Census Tracts in Boston
#
# Apply ridge, lasso and elastic net regression
#
#
rm(list=ls())
library(Ecdat)
mydataset <- Hedonic
?Hedonic
# mv (median value of owner–occupied homes) is our dependent variable
x <-  model.matrix(mv~., mydataset)[1:500 , -1]
y <- mydataset$mv[1:500]
x.test <- model.matrix(mv~., mydataset)[501:506 , -1]
y.test <- mydataset$mv[501:506]
#
# prepare a range of lambda values for ridge, lasso and elastic net
grid <- 10^seq(-3, 5, length=100)
#
#
#########################
### Ridge regression ####
#########################
#
# Step 1 - use glmnet() to estimate a series of regressions for different lambdas



# Step 2 - Model selection by cross-validation
#          use CV.glmnet() to perform, store & plot the CV



# Step 3 - Coefficient extraction


# Step 4 - Predictions: use the "best" ridge model to predict mv values for the test sample



#
#
#########################
### Lasso regression ####
#########################
#
# Step 1 - use glmnet() to estimate a series of regressions for different lambdas



# Step 2 - Model selection by cross-validation
#          use CV.glmnet() to perform, store & plot the CV



# Step 3 - Coefficient extraction


# Step 4 - Predictions: use the "best" lasso model to predict mv values for the test sample




#
#
##########################
# Elastic net regression #
##########################
#
# Step 1 - set alpha = 0.5 and use glmnet() to estimate a series of regressions for different lambdas



# Step 2 - Model selection by cross-validation
#          use CV.glmnet() to perform, store & plot the CV



# Step 3 - Coefficient extraction



# Step 4 - Predictions: use the "best" elastic net model to predict mv values for the test sample





