rm(list=ls())
#-----------------
# Packages
#-----------------
# install.package("neuralnet")
require(neuralnet)
require(ggplot2)
require(dplyr)
#-----------------
# Data - Bank Marketing Data Set
#-----------------
# Moro, Cortez Rita
# Source:https://archive.ics.uci.edu/ml/datasets/Bank+Marketing#
# Descritption: The data is related with direct marketing campaigns (phone calls) of a Portuguese banking institution. 
# The classification goal is to predict if the client will subscribe a term deposit (variable y).
dta<-read.csv("bank.csv", sep=";")
colnames(dta) <- gsub("-","",colnames(dta))
dta <- dta %>% 
  filter(balance <30000, duration < 2200)
dta_orig <-dta
dta <- dta %>% select(y, age, job, balance, loan, housing, day, duration, campaign, previous) 
#check for NAs
apply(dta,2,function(x) sum(is.na(x)))
# hot-wire factors to binary
dta$y <- as.character(dta$y)
dta$y[dta$y == "yes"] <- 1
dta$y[dta$y == "no"] <- 0
dta$y <- as.numeric(dta$y)
ncol(dta)
dta <- cbind(y=dta$y, model.matrix(y~.-1,dta))
colnames(dta) <- gsub("-","",colnames(dta))
ncol(dta)
#-----------------
# Explonatory analysis
#-----------------
ggplot(dta_orig) + geom_point(aes(duration, balance, color=y))
ggplot(dta_orig) + geom_point(aes(duration, balance, color=y))
#-----------------
# Normalization
#-----------------
mu <- apply(dta[,2:ncol(dta)], 2, mean)
sd <- apply(dta[,2:ncol(dta)], 2, sd)
normalize <- function(x) {
  return ((x - mean(x)) / (sd(x)))
}
dta[,2:ncol(dta)] <- apply(dta[,2:ncol(dta)],2, normalize)
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
nrow(dta) == nrow(dta_train)+nrow(dta_test1)+nrow(dta_test2)
#-----------------
# Building NN
#-----------------
# act.fct - "logistic" is default value 
# linear.output = F - we want to applie act function to output, because output should be (0,1)
# err.fct - "ce" cross entropy
# hidden - length = hidden layers, values = hidden neurons 
formul <- formula(paste0("y~", paste0(colnames(dta)[!colnames(dta) %in% c("y","jobadmin.")], collapse = "+")))
hn <- 15
hl <- 1 
hidden_settings <- rep(hn,hl)
nn <- neuralnet(formul,
                data=dta_train,
                err.fct = "ce", 
                hidden=hidden_settings,
                stepmax = 1e+05,
                rep=1,
                linear.output=FALSE,
                threshold=0.01, 
                lifesign="full")
#-----------------
ynn1 <- as.numeric(predict(nn, newdata=dta_test1)>0.5)
sum((ynn1==dta_test1$y)[dta_test1$y==1])/sum(dta_test1$y==1)
#-----------------
plot(nn)
#-----------------
ynn2 <- as.numeric(predict(nn, newdata=dta_test2)>0.5)
sum((ynn2==dta_test2$y)[dta_test2$y==1])/sum(dta_test2$y==1)
table(ynn2,dta_test2$y) #rows are actual values, rows are predicted
#-----------------
ln <- glm(y~.-jobunknown, data=dta_train, family = "binomial")
yhat <- as.numeric(predict(ln, dta_test2, type="response") > 0.5)
sum((yhat==dta_test2$y)[dta_test2$y==1])/sum(dta_test2$y==1)
table(yhat,dta_test2$y) #rows are actual values, rows are predicted
#-----------------
mse_nn2 < mse_ln
#-----------------
# Assigment 
#-----------------
# You have recived new data for 20 clients with model 
# estimated in previsou sections try to asses whether these clients 
# are goint to subscribe (clients with propability higher than 60%)
# and return their names. 
# (data are already normalized with mu, sd)
#-----------------
new <- readRDS("new_clients.rds")
#-----------------
?predict
