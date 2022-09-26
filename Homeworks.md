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





---

[Homepage](https://formanektomas.github.io/4EK417/)
