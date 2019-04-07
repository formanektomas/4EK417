#### IVR with time series data ####
#
#
#
## Wooldridge, Introductory econometrics, Example 11.5; Ch15, comp. ex. C7
#
rm(list=ls())
library("AER") # install.packages("AER") 
#
phillips <- read.csv('_dataW06/phillips.csv') # Read the data
#
# Model data:
# Annual TS, 1948 - 2003
#
# inf      - percentage change in CPI
# unem     - civilian unemployment rate, %
# 
# Basic data manipulation and plots
phillips$time <- 1:56 # time trend
phillips.ts <- ts(phillips, start = 1948, frequency = 1)
phillips.zoo <- zoo(phillips.ts)
phillips.zoo$d.inf <- phillips.zoo$inf - phillips.zoo$inf_1
phillips.zoo$unem_2 <- stats::lag(phillips.zoo$unem, k=-2)
head(phillips.zoo,10)
#
plot(phillips$inf ~ phillips$obs, type = "l" )
plot(phillips$inf ~ phillips$unem)
#
# We use data up to 1996 only fo the estimation:
lm.11.19 <-lm( d.inf ~ unem, data = phillips.zoo, subset=1:49 )
summary(lm.11.19, vcov = vcovHAC(lm.11.19 ))
#
# The natural rate of unemployment may be calculated as
# mju = beta0 / (- beta1)
lm.11.19$coefficients[1]/(-1*lm.11.19$coefficients[2])
#
# In "lm.11.19", we assume unem is exogenous regressor.
# If we relax this assumption, we may use unem_1 as and/or infl_1 as IVs
#
# Aux. regression of unem on unem_1
summary(lm(unem~unem_1+unem_2, data = phillips.zoo))
#
# IV regression 
# .. with TS, we use HAC estimate of standard errors
vignette("sandwich")
?vcovHAC
?NeweyWest
#
C7 <- ivreg(d.inf ~ unem | unem_1+unem_2, data = phillips.zoo, subset=1:49 )
summary(C7, vcov = vcovHAC(C7), diagnostics=T)
summary(C7, vcov = NeweyWest(C7), diagnostics=T)
# 
#
summary(lm.11.19, vcov = vcovHAC(lm.11.19 ))
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