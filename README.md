# Praktikum z ekonometrie (4EK417)

--- 

**Seminar held by:**  
[Tomas Formanek](https://insis.vse.cz/auth/lide/clovek.pl?id=46723)     
Department of Econometrics   
Faculty of Informatics and Statistics  
University of Economics, Prague  

--- 

### Requirements and classification

+ [Detailed information provided here (CZE)](https://formanektomas.github.io/4EK417/CourseClassification.html)
+ [Literature and other supporting materials for the course](https://formanektomas.github.io/4EK417/LiteratureSupport.html)


--- 

### Seminar paper

+ [Detailed information provided here (CZE)](https://formanektomas.github.io/4EK417/SeminarPaper.html)

---

### Home assignments

+ [Detailed information provided here (CZE)](https://formanektomas.github.io/4EK417/Homeworks.html)

---
---  

## Block 1: Data handling in R

+ Data manipulation and visualization basics
+ [Markdown](https://rstudio.com/wp-content/uploads/2015/02/rmarkdown-cheatsheet.pdf) and [Quarto](https://rstudio.github.io/cheatsheets/quarto.pdf) for data & output presentation  
+ Introduction to [Tidyverse](https://www.tidyverse.org/) packages `tidyr`, `dplyr`, `ggplot2`, pipe operator `%>%`  
+ Importing data from major databases (Eurostat, IMF, Yahoo finance, etc.)  
+ Missing data, multiple imputation  

#### Materials for Block 1  

+ [Download presentation slides for Block 1](https://github.com/formanektomas/4EK417/raw/master/Block1/Block_1.pdf)
+ [Download R scripts (zip)](https://github.com/formanektomas/4EK417/raw/master/Block1/Block1.zip)
  
#### Supporting materials for Block 1  

- [R](https://www.r-project.org/) / [RStudio](https://www.rstudio.com/products/RStudio/)  
- [stackoverflow](https://stackoverflow.com/tags/r/info)  

- [Enders, C.K., Applied Missing Data Analysis (2022)](https://www.appliedmissingdata.com/)


---

## Block 2: Spatial analysis and spatial econometrics

+ Spatial data: basic descriptive analysis  
+ Spatial data: advanced visualization (choropleths, [sf](https://r-spatial.github.io/sf/) package)  
+ Spatial econometrics  
    + Cross-sectional data  
    + Panel data  
    + Advanced topics (spatial filtering)  

#### Materials for Block 2

+ [Download presentation slides for Block 2](https://github.com/formanektomas/4EK417/raw/master/Block2/Block_2.pdf)  
+ [Download R scripts (zip)](https://github.com/formanektomas/4EK417/raw/master/Block2/Block2.zip)  



#### Supporting materials for Block 2

- [Rowe and Arribas-Bel, Spatial Modelling for Data Scientists - a textbook](https://gdsl-ul.github.io/san/)  
- [Simple Features for R](https://r-spatial.github.io/sf/)  
- [GADM maps and data](https://gadm.org/)  
- [uber hexagons in R](https://cran.r-project.org/web/packages/h3jsr/vignettes/intro-to-h3jsr.html)  
- [Interactive Course using mgcv (ch. 3)](https://noamross.github.io/gams-in-r-course/)  
- R Package **RCzechia** : run `install.packages("RCzechia")`  
- [Spatial autocorrelation - RPubs tutorial](https://rpubs.com/quarcs-lab/spatial-autocorrelation)  
- [Introduction to CS spatial regression models](https://www.researchgate.net/publication/373759152_Introduction_to_Cross-Section_Spatial_Econometric_Models_with_Applications_in_R)  

- [ARSET - Fundamentals of Remote Sensing (NASA on-line course)](https://appliedsciences.nasa.gov/get-involved/training/english/arset-fundamentals-remote-sensing)  
- [ARSET - Applied Remote Sensing (NASA on-line courses)](https://appliedsciences.nasa.gov/what-we-do/capacity-building/arset)  

---

## Block 3: Model specification choice methods & extensions to linear models

Model selection  
+ Theoretical approach: specific-to-general, general-to-specific
+ Stepwise model selection

Model selection & regularization  
+ Penalized regression
+ Dimension reduction: PCR & PLS


Moving beyond linearity  
+ Quantile regression (quick repetition)  
+ Polynomial and step regression  
+ Regression splines, smoothing splines    
+ Local regression  
+ Generalized Additive Models (GAM)  
 

#### Materials for Block 3

+ [Download presentation slides for Block 3](https://github.com/formanektomas/4EK417/raw/master/Block3/Block_3.pdf)  
+ [Download R scripts (zip)](https://github.com/formanektomas/4EK417/raw/master/Block3/Block3.zip)
  
#### Supporting materials for Block 3  
  
- [Interactive Course using mgcv (ch. 1,2,4)](https://noamross.github.io/gams-in-r-course/)  
- [Quantitude podcast S3E03 Principal Components Analysis is your PAL](https://quantitudepod.org/s3e03-principal-components-analysis-is-your-pal/)  


---

## Block 4: Linear Mixed Effect models

+ Introduction to linear mixed effects models
    + Longitudinal data  
    + Hierarchical models  

#### Materials for Block 4

+ [Download presentation slides for Block 4](https://github.com/formanektomas/4EK417/raw/master/Block4/Block_4.pdf)  
+ [Download R scripts (zip)](https://github.com/formanektomas/4EK417/raw/master/Block4/Block4.zip)


#### Supporting materials for Block 4

- [Introduction to LMEs in R](https://ourcodingclub.github.io/tutorials/mixed-models/)  
- [Mixed models in R](https://m-clark.github.io/mixed-models-with-R/)  
- [Vignettes for lme4 package](https://cran.r-project.org/web/packages/lme4/vignettes/)  


--- 

## Block 5: Models for binary & limited dependent variables

#### Materials for Block 5

+ [Presentation slides based on Block 6 of 4EK416/4EK608](https://github.com/formanektomas/4EK608_4EK416/raw/master/Block6/Block6.pdf)  
+ [Download R scripts (zip)](https://github.com/formanektomas/4EK417/raw/master/Block5/Block5.zip)  

#### Supporting materials for Block 5

- [R package `effects`](https://www.jstatsoft.org/article/view/v087i09)  
- [R package `effects` for multinomial and proportional-odds logit models](https://www.jstatsoft.org/article/view/v032i01)  

--- 

## Block 6: Treatment effects analysis


#### Materials for Block 6  

+ [Download presentation slides for Block 6](https://github.com/formanektomas/4EK417/raw/master/Block6/Block6.pdf)  


#### Supporting materials for Block 6

- [Ben Lambert: A graduate course in econometrics, videos 54 to 74](https://www.youtube.com/watch?v=Sqy_b5OSiXw&list=PLwJRxp3blEvaxmHgI2iOzNP6KGLSyd4dz&index=55)  

---

[Homepage](https://formanektomas.github.io/4EK417/)
