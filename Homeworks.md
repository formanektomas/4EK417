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
* U bodů 2. až 5. budete postupovat analogicky k zadání pro "nama_10r_2coe" (vyberte "zajímavou" proměnnou/jednotku měření, skupinu států/regionů, atd).  
* Doprovoďte Váš výstup stručným slovním komentářem (popište zvolené proměnné).

---

## Týden 3 (odevzdání do 8. 3. 2020)

* Úkol pro týden 3 je založen na příkladu `Assignment 1` ze skriptu `R03_Model_selection.R`.
* Na rozídl od `Assignment 1` ale **nepoužijete** pro stepwise regresi dataset "htv.csv".   
*  Každý si vyberte vhodný dataset, například ze seznamu zde  
    + https://vincentarelbundock.github.io/Rdatasets/datasets.html  
    + Použijtete-li data z balíčku, nepřikládatejte csv soubor,
    + místo toho použijte `R`-kód, např. : `MyData <- PackageName:::DatasetName`.
    + Vyberete-li jiný dataset, srozumitelně popište svá data a soubor přiložte.
* Použijte průřezová data a volte model tak, abyste měli spojitou závislou proměnnou.      
* U `Assignment 1`, body 1. až 6. budete postupovat analogicky k zadání ze skriptu `R03_Model_selection.R`, jen s jiným datasetem.
    + U datasetů s vysokým počtem proměnných / sloupců můžete omezit maximální uvažovaný počet regresorů pro stepwise regresi.
    + **Pozor**, řada datasetů obsahuje logaritmické transformace vybraných proměnných (a logaritmovanou závislou proměnnou nechcete mít v sadě potenciálních regresorů při stepwise analýze - viz též ř. 7 skriptu `R03_Model_selection.R`).
* Doprovoďte Váš výstup stručným slovním komentářem.

---


[Homepage](https://formanektomas.github.io/4EK417/)
