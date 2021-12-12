#### Censored regression models #### 
#
# 
# 
# Model data:
# Data on months until an inmate in a North Carolina prison is arrested after
# being released from prison
#
# main interest of the research: evaluate the efficiency of "work program"
#
# durat     - months before arrest
#             893/1445 individuals were not arrested again during the time
#             they were followed in the study (censoring ranges from 70 to 81 months)
# ldurat    - dependent variable, log of max(time until return, time followed)
# workprg   - 1 if participated in prison work programm
# priors    - # of prior convictions
# tserved   - time served (months)
# felon     - 1 if felony sentence
# alcohol   - 1 if alcohol problems
# drugs     - 1 if drug history
# black, married, educ, age: self explanatory, (educ, age in years)
#
#
#
#
# Data & basic plots
library(survival) #install.packages("survival")
rm(list=ls())
recid <- read.csv("data/recid.csv")
head(recid)
tail(recid)
hist(recid$durat, main="max(time until return, or time followed)")
boxplot(recid$durat ~ recid$cens, xlab="Censoring:   No/Yes")
# 
#
# 
#
#
### Example 17.4: Based on Wooldridge: Introductory econometrics, 
#    
#   Evaluation of prison work group programme impact on recidivism
#   
# Data censoring 
# 1 Total observations
nrow(recid)
#
# Censored observations of the "durat" variable
sum(recid$cens) # Innmates not re-arrested during the time for which they were followed.
# Therefore, their "months before next arrest" observations,
# i.e "durat" data are CENSORED. Due to study setup, censoring times among
# innmates are different, range: 70 months to 81 months.
#
# Observations not cenosered
sum(recid$cens==0) # Innmates re-arrested during the study/survey time.
# Corresponding "durat" data are not censored but represent the actual time
# before next arrest.
#
#
#
#
#
?survreg
?Surv
# Given the Surv: event argument (0 = right censored, 1 = event at time),
# we need to "reverse" the cens dummy variable:
recid$ev <- 1- recid$cens
#
Cens.Fit<-survreg(Surv(ldurat,event=ev,type='right') ~ 
                    workprg + priors + tserved + felon + alcohol + drugs +
                    black + married + educ + age, dist='gaussian', robust=T,data=recid)
summary(Cens.Fit)
#
#
head(cbind(predict(Cens.Fit, type="response"), recid$ldurat)) # "response" - scale of the dep. variable
pred1 <- predict(Cens.Fit, type="response",se.fit = T) # prediction & s.e. of prediction shown
head(cbind(pred1$fit,pred1$se.fit))
#
#
### Coefficient interpretation:
#
#
Cens.Fit$coefficients[6] # Alc. decreases the expected time before next arrest.
100*(exp(Cens.Fit$coefficients[6])-1)
# With alcohol problems, the expected duration (time before arrest) is
# approx 47% shorter.
#
Cens.Fit$coefficients[5] # Felony increases duration!
100*(exp(Cens.Fit$coefficients[5])-1)
# Peple serving time for felony crimes have almost 56% longer duration.
#
#
#
#
## Assignment 1
## Use OLS regression to estimate the general model specification on
## lines 61-62. (i.e. ignore the censoring information avalable)
## Compare such OLS-estimated coefficients to the "Cens.Fit" model.
#
#