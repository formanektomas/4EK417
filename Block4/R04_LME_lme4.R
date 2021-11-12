#### Mixed effects models ####
#
#
#
#
#
rm(list=ls())
library(lme4) # install.packages("lme4")
library(lattice) # install.packages("lattice")
help(package=lme4)
#
# Example dataset
?sleepstudy
slst <- sleepstudy
summary(slst)
str(slst)
#
#
# 1 Simple lm() model
# .. We ignore individual heterogeneity
summary(lm(Reaction ~ Days, data=slst))
#
#
# 2 We use the LSDV approach 
# .. Individual intercepts 
summary(lm(Reaction ~ Days+Subject-1, data=slst))
#
# 3 We may use the lmer() and estimate individual random effect
# .. Again, individual intercepts are estimated
?lmer
lme.1 <- lmer(Reaction ~ 1 + Days + (1|Subject), data=slst)
summary(lme.1)
# Using the coef() command, we can verify that subjects have
# different Intercepts, but the slopes for "Days" are identical.
coef(lme.1)
confint(lme.1)
dotplot(ranef(lme.1, which = "Subject", condVar=T))
#
# 4 Using lmer(), we may use random (individual) effects
#   on both intercepts and slopes:
lme.2 <- lmer(Reaction ~ 1 + Days + (1+Days | Subject), 
              slst)
# Note that the lme.2 model allows for correlation between random effects
summary(lme.2)
coef(lme.2)
confint(lme.2)
dotplot(ranef(lme.2, which = "Subject", condVar=T))
#
# 5 Random Intercepts & slopes
# .. this time, we want uncorrelated random effects
lme.3 <- lmer(Reaction ~ 1 + Days + (1|Subject) + (0+Days|Subject),
              slst)
summary(lme.3)
coef(lme.3)
confint(lme.3)
#
#
# A simple plot, describing individual slopes and intercepts:
xyplot(Reaction ~ Days | Subject, sleepstudy, type = c("g","p","r"),
       index = function(x,y) coef(lm(y ~ x))[1],
       xlab = "Days of sleep deprivation",
       ylab = "Average reaction time (ms)", aspect = "xy")
#
#
#
#
#
#
#
########################################
##### Example 2 - Grunfeld dataset #####
########################################
#
rm(list=ls())
data("Grunfeld", package = "plm")
str(Grunfeld)
plot(Grunfeld[,-1])
#
## LM (OLS)
summary(lm(inv~value+capital, data=Grunfeld))
#
## LME - random intercept (firm)
#
G1.me <- lmer(inv~value+capital + (1|firm), Grunfeld)
# note the warning...
head(Grunfeld)
Grunfeld[,3:5] <- log(Grunfeld[,3:5]) # log-transform observations
G1.me <- lmer(inv~value+capital + (1|firm), Grunfeld)
summary(G1.me)
dotplot(ranef(G1.me, which = "firm", condVar=T))
coef(G1.me)
#
## LME - crossed random intercept (firm and year)
#
G2.me <- lmer(inv~value+capital + (1|firm) + (1|year), Grunfeld)
summary(G2.me)
dotplot(ranef(G2.me, which = "firm", condVar=T))
dotplot(ranef(G2.me, which = "year", condVar=T))
coef(G2.me)
#
#
## Accounting for serial correlation in error terms:
#
# We use the {nlme} package
#
# corAR1()     ..for ar(1) processes and fixed intervals
# corARMA()    ..incorporates both ar() and ma() processes
# corCAR1()    ..used with varying intervals
#
library(nlme)
#
#
Gr.lme <- lme(inv~value+capital, random=~1|firm, Grunfeld)
summary(Gr.lme)
#
Gr.lme.ar <- lme(inv~value+capital, random= ~1|firm, cor=corAR1(form = ~year), Grunfeld)
summary(Gr.lme.ar)
#
# Do we need to account for temporal autocorrelation?
#
anova(Gr.lme.ar,Gr.lme)
#
# We can control for both heteroscedasticity and serial correlation:
#
Gr.lme.general <- lme(inv~value+capital, random= ~1|firm, 
                 weights = varIdent(form = ~ 1|firm),
                 cor=corAR1(form = ~year), Grunfeld)
summary(Gr.lme.general)
#
#
#
#