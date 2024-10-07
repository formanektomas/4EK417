---
layout: default
---
# Zadání domácích úkolů

--- 

**Domácí úkoly zpracujte v `Rmd` (Markdown), nebo `qmd` (quarto) formátu,**   

**odevzdejte ve ZKOMPILOVANÉ verzi, tj. výstup do `html/pdf/docx` souboru.**  

- U zkompilovaných výstupů musejí být viditelné použité příkazy, tj. nastavení `echo=T` (je defaultní).  
- Podle potřeby přiložte dataset a zdrojový Rmd nebo qmd soubor.  
- Pokud odevzdáváte úkol v komprimovaném souboru, používejte výhradně **.zip** formát.  


Obecná doporučení pro práci s R (domácí úkoly)

1. Používejte nejnovější verzi [R](https://www.r-project.org/)
2. Používejte nejnovější verzi [RStudio](https://rstudio.com/products/rstudio/)
3. Aktualizujte balíčky
4. Je-li to nutné, nainstalujte si poslední verzi Pandoc (`Rmd` compiler)
  
      install.packages("installr",dependencies = T)  
      installr::install.pandoc() # may require admin access rights  
     

---

## Týden 1 (odevzdání do 22.9.)

Vypracujte zadání ve skriptu `R03_data_handling_exercise.Rmd`.  
Zkompilovaný html/pdf/docx soubor odevzdejte prostřednictvím odevzdávárny v insisu.  
Bonusový úkol (2b): Quick exercise: 3 ze skriptu `R06_dplyr.Rmd` (poslední příklad ze skriptu) 


--- 

## Týden 2 (odevzdání do 29.9.) - úkol má dvě části

* Stažení zajímavého datasetu z databáze Eurostat/WDI/OECD, (u Eurostatu použijte data na úrovni NUTS2/NUTS3), prostřednictvím balíčku R.  
    - Orientace v datasetu: Popis ukazatelů, obsažených v datasetu (typově: jaké věkové skupiny jsou sledovány, ...).  
    - Úprava dat pomocí balíčku `dplyr` a pipe operátoru: filtrování "vhodných" ukazatelů podle Vašeho uvážení. Popište, jaká data jste vybrali (případně proč).  
    - Jednoduchá vizualizace dat pomocí balíčku `ggplot2`. Před vizualizací dat ověřte rozměr výsledného datasetu pomocí příkazu `dim()`. Při správném filtrování musí počet řádků datasetu odpovídat zobrazovaným datům. (Např: zobrazuji řady s HDP pro 10 regionů a 5 let -> data frame má 50 řádků v tzv. dlouhém formátu.)
    - Převod do formátu časových řad (využijte balíček `zoo`).  
    - Úkol může být založen na postupech ze skriptu `R07_Eurostat.Rmd` (ale nepoužívejte přímo datasety z tohoto skriptu).  
    - Doprovoďte Váš výstup stručným slovním komentářem (popište zvolené proměnné).  

* Vypracujte Assignment 1 (na ř. 275 skriptu `R11_Missing_data.R`)  

* Úkol odevzdejte ve zkompilovaném formátu (html, docx nebo pdf soubor vytvořený/zkompilovaný z markdown či quarto souboru)  

---

## Týden 3 (odevzdání do 6. 10.)

Vizualizace prostorových dat v R - kartogram (infomapa)

* K vizualizaci použijte dva různé datasety: jeden může vycházet z úkolu pro minulý týden, druhý dataset si opět zvolte/vyhledejte na Eurostatu (nebo použijte jiný vhodný zdroj dat).

* Pro Vámi vybrané proměnné zobrazte infomapu, např. podle vzoru ze skriptu `R02_ggplot_choropleths.R`   
    + Zobrazte alespoň čtyři různé infomapy: použijte různé projekce, různá časová období (použijte fazety), odlišné NUTS úrovně, zobrazte proměnné pro různé sledované skupiny (věkové skupiny, skupiny podle vzdělání, pohlaví, atd.).  
    + Pokud pracujete se státy jako Francie nebo Španělsko, je vhodné z datasetu odstranit zámořská území (nebo ohraničit oblast zobrazovanou na mapě). 
    + Před vizualizací dat v `ggplot()` zkontrolujte rozměr datasetu.
    + Použití dat z Eurostatu není podmínkou, lze využít WDI nebo jinou databázi


---  

## Týden 4 (odevzdání do 13. 10.)

Interpolace prostorových dat

* Vyřešte úlohu ze skriptu `R06b_Complex_spatial_interpolation_example.Rmd` a odevzdejte ve zkompilovaném formátu (html/docx/pdf).  
* Před zpracováním dat je vhodné podrobně si přečíst doprovodné informace a návod ze skriptu.
`

---  


[Homepage](https://formanektomas.github.io/4EK417/)
