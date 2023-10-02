---
layout: default
---
# Zadání domácích úkolů

--- 

**Domácí úkoly zpracujte v `Rmd` (Markdown), nebo `qmd` (quarto) formátu, odevzdávejte i ve ZKOMPILOVANÉ verzi, tj. výstup do `html/pdf/docx` souboru.**  
- U zkompilovaných výstupů musejí být viditelné použité příkazy, tj. nastavení `echo=T` (je defaultní).
- Podle potřeby přiložte dataset.  


Obecná doporučení pro práci s R (domácí úkoly)

1. Používejte nejnovější verzi [R](https://www.r-project.org/)
2. Používejte nejnovější verzi [RStudio](https://rstudio.com/products/rstudio/)
3. Aktualizujte balíčky
4. Je-li to nutné, nainstalujte si poslední verzi Pandoc (`Rmd` compiler)
  
      install.packages("installr",dependencies = T)  
      installr::install.pandoc() # may require admin access rights  
     

---


## Týden 1 (odevzdání do 24.9.)

Vypracujte zadání ve skriptu `R03_data_handling_exercise.Rmd`.
Zkompilovaný html/pdf/docx soubor odevzdejte prostřednictvím odevzdávárny v insisu. 

(filtrování údajů typu Date: např. `date >= "1980-01-01"` )


--- 


## Týden 2 (odevzdání do 1.10.)   

* Stažení zajímavého datasetu z databáze Eurostat/WDI, na úrovni NUTS2/NUTS3 (Eurostat), prostřednictvím balíčku R.  
    - Úprava dat pomocí `dplyr` a pipe operátoru: filtrování "vhodných" ukazatelů podle Vašeho uvážení, popište, jaká data jste vybrali (případně proč), proveďte jednoduchou vizualizaci dat pomocí `ggplot2`.  
    - Úkol může být založen na postupech ze skriptu `R07_Eurostat.Rmd` (ale nepoužívejte přímo datasety z tohoto skriptu).  
    - **Pozor:** před vizualizací dat zkontrolujte rozměr použité tabulky - pomocí příkazu `dim()`. Při správném filtrování musí počet řádků datasetu odpovídat zobrazovaným datům. (Např: zobrazuji řady s HDP pro 10 regionů a 5 let = 50 řádků.) Tato kontrola musí být součástí odevzdaného úkolu.  
    - Doprovoďte Váš výstup stručným slovním komentářem (popište zvolené proměnné).  

---

## Týden 3 (odevzdání do 8. 10.)

Vizualizace prostorových dat v R - kartogram (infomapa)

* Pro vhodnou proměnnou zobrazte infomapu, např. podle vzoru ze skriptu `R02_ggplot_choropleths.R`   
    + Zobrazte alespoň tří různé infomapy (různé projekce, různé státy, časová období, NUTS úrovně, atd.).  
    + Pokud pracujete se státy jako Francie nebo Španělsko, je vhodné z datasetu odstranit zámořská území. 
    + Před vizualizací dat v `ggplot()` zkontrolujte rozměr datasetu.
    + Použití dat z Eurostatu není podmínkou, lze využít WDI nebo jinou databázi se státy celého světa (mapy z `giscoR`)
    
* u zkompilovaných Rmd výstupů musejí být viditelné všechny použité příkazy, tj. nastavení `echo=T` (je defaultní).   



---   


[Homepage](https://formanektomas.github.io/4EK417/)
