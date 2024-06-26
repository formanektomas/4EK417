# One-dimensional panel (data with hierarchical structure)
rm(list=ls())
library(foreign) # install.packages("foreign")
Panel <- read.dta("data/cpsmar2004.dta") 
Panel$a_hga <- NULL
Panel$a_sex <- NULL
Panel$a_maritl <- NULL
Panel$a_unmem <- NULL
Panel$cellid <- NULL
Panel <- Panel[complete.cases(Panel) == T, ] # Complete cases analysis
#
library(nlme)
#
## 1 
#  Start by estimating an OLS model:
summary(lm(lnwage~ed+age+asian+union, data = Panel))
summary(lm(lnwage~ed+age+asian+union+gmstcen, data = Panel)) 
#
#
## 2
#  Using the lme() / lmer() function, allow for random effects in the intercept
#  -> use the "gmstcen" federal state ID 
#  .. the remaining regressors have "fixed effects" only
#  
lme.w.1 <-
  
#
#
## 3
#  Generalize the previous model by allowing for random effects
#  for education (ed) variable.
#  
lme.w.2 <-

#
#
## 4
#  Test for redundancy of the generalization of lme.w.1 into lme.w.2
#  .. interpret the results
#  ..

  

#
#
## 5
#  Restrict the random effects from equation lme.w.2 to have cov=0.
#  Test the "validity" of this restriction 
lme.w.3 <- 

#
#
## 6
#  Enhance previous model by including "union" as fixed effect at level 2 (state), 
#  .. by expanding the lme.w.2 / lme.w.3 model
lme.w.4 <- 


