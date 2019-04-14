#### Interpretation example: Binary dependent variable,
#    logistic regression, coefficient sign ####
#
#
## Coefficient interpretation excercise (LPM & logistic regression)
#
# Default sample data - package {ISLR}
#
rm(list=ls())
require(ISLR) #install.packages("ISLR")
data <- Default
attach(data) # We may access variables directly
head(data)
?Default # see data description
summary(data)
#
# Basic data plotting:
# Balance plots
boxplot(balance~default, ylab="Balance", xlab="Default",
        main="Balances for defaulting and non-defaulting customers")
boxplot(balance~student, ylab="Balance",  xlab="Student",
        main="Balances for student and non-student customers")
# Income plots
boxplot(income~default, ylab="Income",  xlab="Default",
        main="Income distribution for defaulting and non-defaulting customers")
boxplot(income~student, ylab="Income",  xlab="Student",
        main="Income distribution for student and non-student customers")
# Combined information on a balance-income scatterplot
plot(income~balance, col=student, pch=19, cex=1,
     main="Balance and Income for students and non-students")
# Students tend to have lower income
plot(income~balance, col=default, pch=19, cex=1,
     main="Defaults determination by Balance and Income")
# Customers with higher balances tend to default more frequently
#
# 
## Coefficient interpretation ##
#
# Linear regression
#
# SLRM
# Default <- Balance
def <- rep(0, 10000) # We need to construct dependent dummy variable
def[default=="Yes"] <- 1
data$def <- def
summary(lm(def~balance)) # SLRM: POSSITIVE coefficent for balance
plot(def~balance, pch=21, cex=0.5, main="Defaults by Balances")
abline(lm(def~balance), col="red") 
# We may observe negative expected "probabilities" of default
#
# SLRM
# Default <- Student
summary(lm(def~student)) # POSSITIVE coefficent for student:Yes
#
#
# MLRM
# Default <- Balance+Student
summary(lm(def~balance+student)) # NEGATIVE coefficent for student:Yes
#
# We replicate the student:Yes sign "problem" using logistic regression:
#
# Default <- Balance
summary(glm(def~balance, family=binomial)) # POSSITIVE coefficent for Balance
plot(def~balance, pch=1, cex=0.8, main="Defaults by Balances")
points(glm(def~balance, family=binomial)$fitted ~ balance, pch=16, col="red", cex=0.2)
# All expected probabilities of default are within the (0, 1) interval
# Default <- Student
summary(glm(def~student, family=binomial)) # POSSITIVE coefficent for student:Yes
# Default <- Balance+Student
summary(glm(def~balance+student, family=binomial)) # NEGATIVE coefficent for student:Yes
#
# 
# Visualization / explanation
# Fitted values calculated for a model that is estimated on the whole dataset
data$def.fit <- glm(def~balance+student, family=binomial)$fitted # add fitted values to d.f.
# Next, we plot fitted values separately for students and non-students
# Expected default probabilities for students, at different balance levels
plot(def.fit~balance, data=data[student=="Yes", ], pch=19, cex=0.6, col="orange", 
     las=1, ylab="default probability", 
     main="Default probabilities for students and non-students") 
# .. Enlarge the plot window
# Expected default probabilities for non-students, at different balance levels
points(def.fit~balance, data=data[student=="No", ], pch=19, cex=0.6, col="darkgreen") 
# Overall default rate for students (Blue horizontal line)
avg.def.st.Y <- mean(data$def[data$student=="Yes"])
abline(h=avg.def.st.Y, col="orange", lwd=2)
# Overall default rate for non-students (Green horizontal plot)
avg.def.st.N <- mean(data$def[data$student=="No"])
abline(h=avg.def.st.N, col="darkgreen", lwd=2)
mtext("Students                    ", col="orange")
mtext("                             Non-students", col="darkgreen")
legend(86,0.95, "Expected default probabilities for students", pch=19, col="orange", cex=0.8, box.col="white")
legend(86,0.90, "Expected default probabilities for NON-students", pch=19, col="darkgreen", cex=0.8, box.col="white")                 
legend(86,0.85, "Average default rate for students", lty=1, col="orange", cex=0.8, box.col="white")                  
legend(86,0.8, "Average default rate for NON-students", lty=1, col="darkgreen", cex=0.8, box.col="white")
abline(h=c(0,1))
#
#
#
#
## Assignment 1
## Compare the positive slopes in the SLRMs:
## .. default <- balance
## .. default <- student
## with the signs of a MLRM: default <- balance+student.
## Explain the change in sign of the student variable
#
#
#
#
## Assignment 2
## For the Logit-estimated model default <- balance+student, calculate the following:
##    (a) Confusion matrix 
##    (b) Default probability of a student with Balance = 1500
##    (c) Default probability of a non-student with Balance = 1500
##    (d) APEs
#
#
#