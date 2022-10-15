---
layout: default
---
# Zadání domácích úkolů

--- 

**Domácí úkoly odevzdávejte v `Rmd` (Markdown) formátu nebo Rmd zkompilované do `html/pdf/docx` výstupu.**  
- U zkompilovaných výstupů musejí být viditelné použité příkazy, tj. nastavení `echo=T` (je defaultní).
- **U nezkompilovaných úkolů (.Rmd) dbejte na to, aby skript seběhl - přiložte data nebo zadejte kód, který data stáhne (eurostat), případně který otevře dataset z Vámi zvoleného balíčku.**  


Obecná doporučení pro práci s R (domácí úkoly)

1. Používejte nejnovější verzi [R](https://www.r-project.org/)
2. Používejte nejnovější verzi [RStudio](https://rstudio.com/products/rstudio/)
3. Aktualizujte balíčky
4. Je-li to nutné, nainstalujte si poslední verzi Pandoc (`Rmd` compiler)
  
      install.packages("installr",dependencies = T)  
      installr::install.pandoc() # may require admin access rights  
     

---


## Týden 1 (odevzdání do 25.9.)

*  Vyberte si vhodný dataset, například ze seznamu zde  
    + [https://vincentarelbundock.github.io/Rdatasets/datasets.html](https://vincentarelbundock.github.io/Rdatasets/datasets.html) 
    + (ideálně makro-data)
    + vyberete-li jiný dataset, srozumitelně popište svá data (např. v úvodu Rmd souboru)
    
* Pomocí jedné proměnné (typu GDP, INF, Imports, ....) sledované v čase pro různé průřezové jednotky, ukažte převod tabulky s daty mezi "dlouhým" a "krátkým" formátem.
    + předpokládám použití funkcí z balíčku `tidyr`, ale lze i jiné (`data.table`, `reshape2`, atd.)  

* Vhodným způsobem data zobrazte pomocí balíčku `ggplot2`  
    + alespoň 2 grafy, použijte různá nastavení (např. přidejte fazety, resp. vhodně ukažte práci s vrstvami/layers)  

* Vhodným způsobem ukažte práci s balíčkem `dplyr` a použití pipe operátoru 
    + například: použijte funkci summary v rámci pipeline

* Každý bude pracovat s vlastním datasetem (viz Google sheet, odkaz bude zaslán e-mailem)

---


## Týden 2 (odevzdání do 2.10.)  


* Vyřešte úkol, který se nachází na konci skriptu `R11_Missing_data.R`  **2b**   

* Stažení zajímavého datasetu z databáze Eurostat, na úrovni NUTS2/NUTS3, prostřednictvím balíčku R.   **3b**   
    - Úprava dat pomocí `dplyr` a pipe operátoru (filtrování "vhodných" dat podle Vašeho uvážení), jednoduchá vizualizace dat pomocí `ggplot2`.  
    - Úkol může být založen na postupech ze skriptu `R07_Eurostat.Rmd` (ale nepoužívejte přímo datasety z tohoto skriptu).  
    - **Pozor:** před vizualizací dat zkontrolujte rozměr použité tabulky - pomocí příkazu `dim()`. Při správném filtrování musí počet řádků odpovídat zobrazovaným datům. (Např: zobrazuji řady s HDP pro 10 regionů a 5 let = 50 řádků.) Tato kontrola musí být součástí odevzdaného úkolu.  
    - Doprovoďte Váš výstup stručným slovním komentářem (popište zvolené proměnné).  
    - Abychom zamezili duplicitám, uveďte Vámi zvolený dataset (kod datasetu + slovni popis) na Google docs (stejný sešit jako u prvního úkolu, nový list).  


--- 

## Týden 3 (odevzdání do 9. 10. 2022)

Vizualizace prostorových dat v R - kartogram (infomapa)

* Pro tento úkol použijte data z Eurostatu, která jste stáhli v rámci úkolu z minulého týdne (ideálně data na úrovni NUTS2 nebo NUTS3). 
    + Pro vhodnou proměnnou zobrazte infomapu, např. podle vzoru ze skriptu `R02_ggplot_choropleths.R`  
    + Použijte alespoň dva různé způsoby zobrazení dat (různé projekce, různé státy, časová období, NUTS úrovně, atd.).  
    + Pokud pracujete se státy jako Francie nebo Španělsko, je vhodné z datasetu odstranit zámořská území. 
    + Před vizualizací dat v `ggplot()` zkontrolujte rozměr datasetu.  
    
* Odevzdejte ve formátu Rmd, ideálně již zkompilovaného do `html/pdf/docx` výstupu
    + u zkompilovaných výstupů musejí být viditelné použité příkazy, tj. nastavení `echo=T` (je defaultní).   
    + u nezkompilovaných skriptů musí být přiložen dataset nebo skript musí data stáhnout (z Eurostatu).  


--- 

## Týden 4 (odevzdání do 16. 10. 2022)
## Pozor: vzhledem k chybnému/pozdnímu  otevření odevzdávárny je termín odevzdání posunut o týden, tj. do 23.10. 

Prostorová struktura: stanovení matice sousednosti v `R`

* Pro tento úkol použijte data (tj. regiony), která jste stáhli v rámci úkolu z minulého týdne (ideálně data na úrovni NUTS2 nebo NUTS3). 
    + Použijte alespoň dva různé způsoby stanovení prostorové struktury (vzdálenost mezi centroidy, kNN, společná hranice.).  
    + Vizualizujte prostorovou strukturu na mapě.  
    
* Odevzdejte ve formátu Rmd, ideálně již zkompilovaného do `html/pdf/docx` výstupu
    + u zkompilovaných výstupů musejí být viditelné použité příkazy, tj. nastavení `echo=T` (je defaultní).   
    + u nezkompilovaných skriptů musí být přiložen dataset nebo skript musí data stáhnout (z Eurostatu).  
    + Pozor: odevzdání úkolu v jiném formátu bude penalizováno ztrátou bodů. 



---

[Homepage](https://formanektomas.github.io/4EK417/)
