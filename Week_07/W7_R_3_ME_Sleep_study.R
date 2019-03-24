#### Sleep study example ####
#
#
# use     lme() from the {nlme} package
#
#
#
rm(list=ls())
library("lme4")
?sleepstudy
slst <- sleepstudy
summary(slst)
str(slst)
detach("package:lme4", unload=TRUE)
#
library(nlme) # install.packages("nlme")
#
#
# Data description
# A data frame with 180 observations on the following 3 variables.
#
# Reaction    Average reaction time (ms)
#
# Days        Number of days of sleep deprivation
#
# Subject     Subject number on which the observation was made.
#
#
#
#
#
#
#
#
## 1 
#  Estimate SLRM lm() model  Reaction <- Days
#  .. ignore individual heterogeneity



#
#
## 2 
#  Use the LSDV approach & lm() model to account for individual intercepts 


#
#
## 3 
#  Use the lme() function and estimate individual random effects
#  .. Individual intercepts with fixed and random effects are estimated
#  .. coefficient for Days is fixed
#
?lme
lme.1 <- 
summary(lme.1)
# fitted vs. observed values by Subject
plot(lme.1, fitted(.) ~ Reaction | Subject)
# standardized residuals versus fitted values
plot(lme.1, resid(., type = "p") ~ fitted(.) | Subject)
#
#
## 4 
#  Using lme(), add random (individual) effects
#  on both intercept and slope
#  .. allow for correlation between random effects - do not use pdDiag()
# .. plot fitted vs. observed values by Subject

lme.2 <- 

#
#
## 5 
#  Use pdDiag() to make the two random effects independent
#  .. plot fitted vs. observed values by Subject
lme.3 <- 


#
#
## 6
#  Test the H_0 of uncorrelated random effects (lme.3 vs lme.2)



#
#
## 7 
#  Evaluate whether we "need" random slopes 
#  .. use the LR test
#  .. compare with the anova() approach to testing




#
#
#
#