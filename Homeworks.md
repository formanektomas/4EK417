---
layout: default
---
# Zadání domácích úkolů

--- 


## Obecná doporučení pro práci s R

1. Používejte nejnovější verzi [R](https://www.r-project.org/)
2. Používejte nejnovější verzi [RStudio](https://rstudio.com/products/rstudio/)
3. Aktualizujte balíčky
4. Je-li to nutné, nainstalujte si poslední verzi Pandoc (`Rmd` compiler)
  
      install.packages("installr",dependencies = T)  
      installr::install.pandoc() # may require admin access rights  
     

---


## Týden 1 (odevzdání do 20.2.)

*  Vyberte si vhodný dataset, například ze seznamu zde  
    + https://vincentarelbundock.github.io/Rdatasets/datasets.html 
    + (ideálně makro-data)
    + vyberete-li jiný dataset, srozumitelně popište svá data (např. v úvodu Rmd souboru)
    
* Pomocí jedné proměnné (typu GDP, INF, Imports, ....) sledované v čase pro různé průřezové jednotky, ukažte převod tabulky s daty mezi "dlouhým" a "krátkým" formátem.
    + předpokládám použití funkcí z balíčku `tidyr`, ale lze i jiné (`data.table`, `reshape2`, atd.)  

* Vhodným způsobem data zobrazte pomocí balíčku `ggplot2`  
    + alespoň 2 grafy, použijte různá nastavení (např. přidejte fazety, resp. vhodně ukažte práci s vrstvami/layers)
    
* Odevzdejte ve formátu `.Rmd` nebo Rmd zkompilované do `html/pdf/docx` výstupu   
    + u zkompilovaných výstupů musejí být viditelné použité příkazy, tj. nastavení `echo=T` (je defaultní).

* Každý bude pracovat s vlastním datasetem (viz Google sheet, odkaz bude zaslán e-mailem)

---



---


[Homepage](https://formanektomas.github.io/4EK417/)
