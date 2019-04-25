#-----------------
# Packages
#-----------------
# install.package("neuralnet")
require(neuralnet)
require(ggplot2)
require(dplyr)
#-----------------
# Data -  Ames Housing 
#-----------------
# Author: De Cock
# Source: http://jse.amstat.org/v19n3/decock.pdf
# Descritption: 80 variables
dta<-readRDS("AmesHousing.rds")
colnames(dta) <- gsub("[.]","",colnames(dta))
dta <- dta %>% filter(SaleCondition == "Normal",
                      GrLivArea < 1500, 
                      LotArea < 20000,
                      BldgType == "1Fam",
                      SaleType == "WD "
                      ) %>% 
        mutate(TotLivArea = TotalBsmtSF+GrLivArea) %>%
  select(SalePrice, LotArea, TotLivArea, GarageCars, Fireplaces, OverallCond, TotRmsAbvGrd)
dta <- dta[1:380,]
apply(dta,2,function(x) sum(is.na(x)))
#-----------------
# Explonatory analysis
#-----------------
ggplot(dta) + geom_point(aes(LotArea, SalePrice, color=as.factor(OverallCond)))
#-----------------
# Normalization
#-----------------
normalize <- function(x) {
  return ((x - mean(x)) / (sd(x)))
}
# other approaches can be used
#normalize <- function(x) {
#  return ((x - min(x)) / (max(x)-min(x)))
#}
# from base function scale
# see ?scale
dta <- apply(dta,2, normalize)
dta <- as.data.frame(dta)
round(apply(dta, 2, mean),3)
apply(dta, 2, sd)
#-----------------
# Train/Test/Test
#-----------------
train <- sample(nrow(dta),nrow(dta)*0.7)
dta_train <- dta[train,] 
dta_test <- dta[-train,] 
dta_test1 <- dta[1:(nrow(dta_test)*.5),] 
dta_test2 <- dta[(nrow(dta_test)*.5):nrow(dta_test),] 
#-----------------
# Building NN
#-----------------
# act.fct - "logistic"
# linear.output = T - act.fct is not applied to output neuron
# err.fct - "sse" some of squares
# hidden - length = hidden layers, values = hidden neurons 
hn <- 7
hl <- 2 
hidden_settings <- rep(hn,hl)
nn <- neuralnet(SalePrice~LotArea+TotLivArea+GarageCars+Fireplaces+OverallCond+TotRmsAbvGrd,
                data=dta_train,
                err.fct = "sse", 
                hidden=hidden_settings,
                stepmax = 1e+05,
                rep=1,
                linear.output=TRUE,
                threshold=0.02, 
                lifesign="full")
#-----------------
ynn1 <- predict(nn, newdata=dta_test1)
mse_nn1 <- mean((dta_test1$SalePrice-ynn1)^2)
#-----------------
head(nn$result.matrix)
# Steps to until absolute partial derivates of the error/cost function are smaller then treshold
# Weight for intercept Intercept.to.1layhid1
plot(nn)
#-----------------
ynn2 <- predict(nn, newdata=dta_test2)
mse_nn2 <- mean((dta_test2$SalePrice-ynn2)^2)
#-----------------
ln <- lm(SalePrice~., data=dta_train)
yhat <- predict(ln, dta_test2)
mse_ln <- mean((dta_test2$SalePrice-yhat)^2)
#-----------------
mse_nn2 < mse_ln
#-----------------
#source("neural_net_regression_bench.r")
dta_result <- readRDS("nn_plot1.rds")
#-----------------
ggplot(dta_result) + geom_density(aes(mse, group=model, fill=model))
#-----------------
# Assigment
#----------------
# 1) Use previous code and try to find best possible neural network.
# 2) Evaluate how long it might take to estimate neural networks 
#    with 1,2,3 hidden layers and 5, 7, 10, 15 hidden neurons.
#    (use package microbenchmark)
install.packages("microbenchmark")
#----------------
(bench <- microbenchmark::microbenchmark({
#
#  code to bench 
#
#
})
)
mean(bench$time)/1e9 #nanoseconds

