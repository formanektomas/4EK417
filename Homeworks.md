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


## Týden 1 (odevzdání do 21.2.)

*  Vyberte si vhodný dataset, například ze seznamu zde  
    + https://vincentarelbundock.github.io/Rdatasets/datasets.html 
    + (ideálně makro-data)
    + vyberete-li jiný dataset, srozumitelně popište svá data (např. v úvodu Rmd souboru)
    
* Pomocí jedné proměnné (typu GDP, INF, Imports, ....) sledované v čase pro různé průřezové jednotky, ukažte převod tabulky s daty mezi "dlouhým" a "krátkým" formátem.
    + předpokládám použití funkcí z balíčku `tidyr`, ale lze i jiné (`data.table`, `reshape2`, atd.)  

* Vhodným způsobem data zobrazte pomocí balíčku `ggplot2`  
    + alespoň 2 grafy, použijte různá nastavení (např. přidejte fazety, resp. vhodně ukažte práci s vrstvami/layers)
    
* Odevzdejte ve formátu `.R`, `.Rmd` nebo Rmd zkompilované do `html/pdf/docx` výstupu   
    + u zkompilovaných výstupů musejí být viditelné použité příkazy, tj. nastavení `echo=T` (je defaultní).

---

## Týden 2 (odevzdání do 28. 2. 2021)

* Stažení zajímavého datasetu z webové databáze (Eurostat, WB, ČSÚ, Yahoo) prostřednictvím vhodného balíčku R. Úprava dat pomocí `dplyr` a pipe operátoru, vizualizace.

Příklad zpracování:  

* Úkol může být založen na příkladu `Quick exercise` ze skriptu `R07_Eurostat.Rmd`.  
* Na rozídl od `Quick exercise` ale v bodu 1. nepoužijete dataset "nama_10r_2coe".   
* Svůj dataset vyhledejte pomocí funkce `search_eurostat()`, klíčová slova a tedy použitý dataset bude dle uvážení každého studenta.   
* U bodů 2. až 5. budete postupovat analogicky k zadání pro "nama_10r_2coe" (vyberte "zajímavou" proměnnou/jednotku měření, skupinu států/regionů, atd).
* **Pozor:** před vizualizací dat v `ggplot()` zkontrolujte rozměr výsledné tabulky pomocí `dim()`. Při správném filtrování musí počet řádků odpovídat zobrazovaným datům. (Např: HDP pro 10 regionů a 5 let = 50 řádků.) Tato kontrola musí být součástí odevzdaného úkolu

* Doprovoďte Váš výstup stručným slovním komentářem (popište zvolené proměnné).


### Update 26.22021
Děkuji kolegovi Vojtěchu Vávrovi za upozornění na dnešní výpadek balíčku `{eurostat}`.  

Pokud by potíže přetrvávaly, lze alternativně použít `{Smarter Poland}` (nebo vzít data z jiné databáze).

`install.packages("SmarterPoland")  
library("SmarterPoland")   
help(package=SmarterPoland)  
GPD_data <- grepEurostatTOC("GDP")  
GDP <- getEurostatRCV(kod = "nama_10r_2gdp")`  




---


[Homepage](https://formanektomas.github.io/4EK417/)
