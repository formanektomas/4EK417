---
layout: default
---

## Obecná doporučení pro práci s R

1. Používejte nejnovější verzi [R](https://www.r-project.org/)
2. Používejte nejnovější verzi [RStudio](https://rstudio.com/products/rstudio/)
3. Aktualizujte balíčky
4. Je-li to nutné, nainstalujte si poslední verzi Pandoc (`Rmd` compiler)
  
      install.packages("installr",dependencies = T)  
      installr::install.pandoc() # may require admin access rights  
     

---


## Týden 1 (odevzdání do 23.2.)

*  Vyberte si vhodný dataset, například ze seznamu zde  
    + https://vincentarelbundock.github.io/Rdatasets/datasets.html 
    + (ideálně makro-data)
    + vyberete-li jiný dataset, srozumitelně popište svá data (např. v úvodu Rmd souboru)
    
* Pomocí jedné proměnné (typu GDP, INF, Imports, ....) sledované v čase pro různé průřezové jednotky, ukažte převod tabulky s daty mezi "dlouhým" a "krátkým" formátem.
    + předpokládám použití funkcí z balíčku `tidyr`, ale lze i jiné (`data.table`, `reshape2`)  

* Vhodným způsobem data zobrazte pomocí balíčku `ggplot2`  
    + alespoň 2 grafy, použijte různá nastavení (např. přidejte fazety, resp. vhodně ukažte práci s vrstvami/layers)
    
* Odevzdejte ve formátu `.R`, `.Rmd` nebo Rmd zkompilované do `html/pdf/docx` výstupu   
    + u zkompilovaných výstupů musejí být viditelné použité příkazy, tj. nastavtení `echo=T` (je defaultní).

---

## Týden 2 (odevzdání do 1. 3. 2020)

* Úkol pro týden 2 je založen na příkladu `Quick exercise` ze skriptu `R07_Eurostat.Rmd`  (viz níže).
* Na rozídl od `Quick exercise` ale v bodu 1. nepoužijete dataset "nama_10r_2coe".   
* Svůj dataset vyhledejte pomocí funkce `search_eurostat()`, klíčová slova a tedy použitý dataset dle uvážení každého studenta.   
* U bodů 2. až 5. budete postupovat analogicky k zadání pro "nama_10r_2coe" (vyberte "zajímavou" proměnnou/jednotku měření, skupinu států/regionů, atd.  
* Doprovoďte Váš výstup stručným slovním komentářem (popište zvolené proměnné).


### Quick exercise: 

**Total wages/compensations per region by NACE r2 activities**

* Use pipe operator for steps 4 & 5.  
* (you may find it easier to perform this exercise in a separate R-script, load `eurostat` `ggplot2` and `dplyr` first)  

1. Download "nama_10r_2coe" from Eurostat (use simplified time format).  
2. Check the structure of your dataset. 
3. Find out the meaning of `currency` and `nace_r2` codes.  
4. Retrieve data for the sector "Financial and insurance activities" for CZ, SK, SI, AT (NUTS0), years 2007-2017, in euro.
5. Plot the data using `ggplot` (follow formatting in Example 1 or choose your own style)

* This is just a simple exercise focused on downloading and filtering data from Eurostat... data among states are not directly comparable (we would need a per-employee standardization).


---


[Homepage](https://formanektomas.github.io/4EK417/)
