# Praktikum z ekonometrie (4EK417)

--- 

**Seminar held by:**  
[Tomas Formanek](https://insis.vse.cz/auth/lide/clovek.pl?id=46723)     
Department of Econometrics   
Faculty of Informatics and Statistics  
University of Economics, Prague  

--- 

### Requirements and classification

+ [Detailed information provided here (CZE)](./CourseClassification.html)
+ [Literature and other supporting materials for the course](./LiteratureSupport.html)

---

# Náhradní výuka po dobu mimořádných opatření

---

### Program nahrazující běžnou výuku ve dnech 16. 3. 2020 a 23. 3. 2020

Blok 2 - polynomial and step regression, regression splines, smoothing splines, local regression, Generalized Additive Models (GAM)

**Samostudium**  

+ Podívejte se na videa zařazená do kapitoly 7 (Chapter 7: Moving Beyond Linearity)  
    + [https://www.r-bloggers.com/in-depth-introduction-to-machine-learning-in-15-hours-of-expert-videos/](https://www.r-bloggers.com/in-depth-introduction-to-machine-learning-in-15-hours-of-expert-videos/)  U videí lze zapnout AJ titulky pro lepší porozumění mluvenému slovu.
    + základní literatura: slidy 74-108 z prezentace [Block 2](https://github.com/formanektomas/4EK417/raw/master/Block2/Block_2.pdf)
    + doplňková literatura: kapitola 7 knihy [An Introduction to Statistical Learning](http://faculty.marshall.usc.edu/gareth-james/ISL/)  

+ R-lab (skripty a on-line kurzy):  
    + skripty R12 až R15 z [Bloku 2](https://github.com/formanektomas/4EK417/raw/master/Block2/Block2.zip)
    + on-line interaktivní kurz [Interactive Course using mgcv (ch. 1,2,4)](https://noamross.github.io/gams-in-r-course/)

**Domácí úkol (získání bodů pro průběžnou klasifikaci)**  
+ Do 29.3. do insisu odevzdejte rozšířený domácí úkol vycházející z tématu:  
    + ekonometrický model postavte na datech, která jste použili v úkolu odevzdávaném k 15.3.2020,  
    + v analýze použijte (a) polynomiální regresi, (b) kubické a natural spline křivky, (c) lokální regresi, (d) GAM,  
    + interpretujte a vyhodnoťte jednotlivé postupy/odhadové metody a srovnejte je navzájem.  
    
+ Úkol je za 10 bodů.

--- 

### Block 1: Data handling in R

+ Importing data from major databases (Eurostat, IMF, Yahoo finance, etc.)
+ [Markdown](https://rstudio.com/wp-content/uploads/2015/02/rmarkdown-cheatsheet.pdf) for data/output presentation & visualization using `ggplot2`
+ Tidyverse packages `tidyr`, `dplyr`, pipe operator `%>%`
+ Missing data, multiple imputation 

#### Materials for Block 1  

+ [Download presentation slides for Block 1](https://github.com/formanektomas/4EK417/raw/master/Block1/Block_1.pdf)
+ [Download R scripts (zip)](https://github.com/formanektomas/4EK417/raw/master/Block1/Block1.zip)
  
#### Supporting materials for Block 1  

- [R](https://www.r-project.org/) / [RStudio](https://www.rstudio.com/products/RStudio/)  
- [stackoverflow](https://stackoverflow.com/tags/r/info)  

---

### Block 2: Model specification choice methods & extensions to linear models

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
 

#### Materials for Block 2

+ [Download presentation slides for Block 2](https://github.com/formanektomas/4EK417/raw/master/Block2/Block_2.pdf)  
+ [Download R scripts (zip)](https://github.com/formanektomas/4EK417/raw/master/Block2/Block2.zip)
  
#### Supporting materials for Block 2  
  
- [Interactive Course using mgcv (ch. 1,2,4)](https://noamross.github.io/gams-in-r-course/)  

---

### Block 3: Spatial analysis and spatial econometrics

+ Spatial data: basic descriptive analysis  
+ Spatial data: advanced visualization (choropleths, [sf](https://r-spatial.github.io/sf/) package)  
+ Spatial econometrics  
    + Cross-sectional data  
    + Panel data  
    + Advanced topics (spatial filtering)  

#### Materials for Block 3

+ [Download presentation slides for Block 3](https://github.com/formanektomas/4EK417/raw/master/Block3/Block_3.pdf)  


#### Supporting materials for Block 3

- [Simple Features for R](https://r-spatial.github.io/sf/)  
- [GADM maps and data](https://gadm.org/)  
- [Interactive Course using mgcv (ch. 3)](https://noamross.github.io/gams-in-r-course/)  
- R Package **RCzechia** : run `install.packages("RCzechia")`  

---

### Block 4: Limited dependent variables (LDVs): advanced methods and models

--- 

### Block 5: Treatment effects

--- 

### Block 6: Panel data methods

+ Panel data models  
    + Fixed effects & Random effects models  
    + Panel data tests and advanced topics  
    
+ Linear mixed effects models
    + Longitudinal data  
    + Hierarchical models  

#### Materials for Block 6
- [Scripts and datasets for Block 6](./Block6/README.html)  

---

### Seminar paper

+ [Detailed information provided here (CZE)](./SeminarPaper.html)

---

### Home assignments

+ [Detailed information provided here (CZE)](./Homeworks.html)

---

[Homepage](https://formanektomas.github.io/4EK417/)
