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

## Týden 4 (odevzdání do 15. 10.)

Pro tento úkol lze použít data (mapu i sledovanou proměnnou), která jste stáhli v rámci úkolu z minulého týdne - **pouze pokud máte z minulého úkolu k dispozici alespoň 50 pozorování/regionů** (ideálně na úrovni NUTS2 nebo NUTS3).

* Prostorová struktura: stanovení matice sousednosti v `R`
    + Použijte alespoň dva různé způsoby stanovení prostorové struktury (vzdálenost mezi centroidy, kNN, společná hranice).  
    + Vizualizujte prostorovou strukturu na mapě.  
 
* Testy prostorové závislosti   
    + Zvolte jednu proměnnou (a jedno období pozorování - ideálně co nejblíže roku 2023) a proveďte **Moranův test** na prostorovou nezávislost.  
    + Použijte alespoň dva různé způsoby definice prostorové struktury (vzdálenost, vzdálenost + kNN, společná hranice) k ověření robustnosti výsledků Moranova testu vůči změnám prostorové struktury.  
    + Slovně okomentujte výsledky Moranova testu.

**Upozornění:** Vyhněte se nekompletním datasetům, které obsahují `NA` hodnoty u sledovaných geo-kódovaných proměnných. Na matici **W** chybějící pozorování proměnné nemá vliv, `moran.test()` umí pracovat s chybějícími daty, ale `moran.plot()` ani `geary.test()` nejsou kompatibilní s chybějícími hodnotami.

---   

## Týden 5 (odevzdání do 22. 10.)

Odhad regresního modelu s prostorovou závislostí (spatial lag model, nebo spatial Durbin model).  
- Jako závislou proměnnou využijte například znečištění ovzduší na úrovni NUTS2 regionu, případně jiný vhodný typ proměnné, získané na základě postupu probíraného na cvičení (`R02b_raster_data_terra_package.R` - zastavěnost, obdělávaná půda, atd.).  
- Jako regresor lze použít vhodný makroekonomický ukazatel, získaný z Eurostatu (HDP/capita, relativní počet pracovníků ve vybraném NACEr2 oboru, který odpovídá zvolené závislé proměnné - průmysl a doprava, zemědělství, dále např. hustota obyvatel, atd.). Pro svůj model zvolte 1 až 2 regresory.  
- Otestuje prostorovou závislost endogenní proměnné, proveďte diagnostické testy (viz skript `R10_Spatial_lag_model.R`). Pokud to situace umožní (tj. podle výsledku diagnostických testů) odhadněte regresní model.  
- V rámci HA5 není třeba hledat specifikaci modelu "aby to vyšlo", důležitý je postup zpracování dat a korektní interpretace testů. Pokud prostorový model nepůjde sestavit, nevadí.  

**Upozornění:** Pro korektní práci s balíčkem `terra` si zkontrolujte, zda máte aktuální verzi `R/RStudio`.

--- 

## Týden 6 (odevzdání do 29. 10.)

Zpracujte rozšířený abstrakt své seminární práce - popište vybrané téma (motivace, výzkumný záměr), popište data, popište preferovanou odhadovou metodu. Jaký je Váš konkrétní cíl? Jaké vidíte potenciální problémy či komplikace? Případně uveďte zpracovaný model a/nebo dílčí výstupy odhadu. Rozsah 1-2 strany A4 (cca 400-800 slov).  

--- 

## Týden 7 (odevzdání do 12. 10.)

*  Každý si vyberte vhodný dataset, například ze seznamu zde:  
    + https://vincentarelbundock.github.io/Rdatasets/datasets.html
    + Vyberete-li jiný dataset, srozumitelně popište data.
    + Závislou proměnnou pro svůj model pečlivě vybírejte, v kontextu datasetu Váš výběr musí dávat smysl -- výběr zdůvodněte.
    + Vybírejte takový dataset, abyste kromě závislé proměnné měli alespoň dalších 10+ potenciálních regresorů.

* Proveďte stepwise regresi, podle skriptu z bloku 3: `R03_Model_selection.R`
    * Proveďte alespoň dvě varianty výběru (best subset, forward, backwards), výstupy srovnejte (vizualizace, vyhodnocení)
 
* Proveďte tzv. penalizovanou regresi (alespoň jednu z variant: ridge, LASSO, elastic net).

* Popište/vyhodnoťte predikční vlastnosti.


--- 

## Týden 9 (odevzdání do 19. 11. 2023)

*  Pro tento úkol můžete vyjít z dat, která jste použili v týdnu 7

* Proveďte PCR regresi (PCA analýza + regrese na hlavních komponentách) a PLS regresi. Využijte příklady ze cvičení jako vzor.  
    * Postup odhadu a predikce proveďte podle vzoru ze cvičení - např. podle `R07_PCA_PCR.Rmd`.  


--- 

## Týden 10 (odevzdání do 26. 11. 2023)

*  Pro tento úkol můžete vyjít z dat, která jste použili v předchozím týdnu.

* Formulujte a odhadněte GAM model, použijte alespoň 3 různé specifikace (kombinace smoothning spline, local regression), proveďte diagnostické testy podle vzoru z cvičení.




--- 

---   

[Homepage](https://formanektomas.github.io/4EK417/)
