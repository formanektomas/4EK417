---
layout: default
---
# Zadání domácích úkolů

--- 

**Domácí úkoly zpracujte v `Rmd` (Markdown), nebo `qmd` (quarto) formátu,**   

**a VŽDY odevzdejte ve ZKOMPILOVANÉ verzi, tj. výstup do `html/pdf/docx` souboru.**  

- U zkompilovaných výstupů musejí být viditelné použité příkazy, tj. nastavení `echo=T` (je defaultní, není třeba nastavovat).  
- Přiložte zdrojový Rmd nebo qmd soubor (případně dataset).  
- Pokud odevzdáváte úkol v komprimovaném souboru, používejte výhradně **.zip** formát.
- *html soubory kompilované z qmd skriptů odevzdávejte včetně složky s pomocnými soubory (grafy a podobné soubory)* 


Obecná doporučení pro práci s R (domácí úkoly)

1. Používejte nejnovější verzi [R](https://www.r-project.org/)
2. Používejte nejnovější verzi [RStudio](https://rstudio.com/products/rstudio/)
3. Aktualizujte balíčky
4. Je-li to nutné, nainstalujte si poslední verzi Pandoc (`Rmd` compiler)
  
      install.packages("installr",dependencies = T)  
      installr::install.pandoc() # may require admin access rights  
     

---

## Týden 1 (odevzdání do 21.9.)

Vypracujte zadání ve skriptu `R03_data_handling_exercise.Rmd`.  
Zkompilovaný html/pdf/docx soubor odevzdejte prostřednictvím odevzdávárny v insisu.  

--- 

## Týden 2 (odevzdání do 29.9.)

* Stažení zajímavého datasetu z databáze Eurostat/WDI/OECD, (u Eurostatu použijte data na úrovni NUTS2/NUTS3), prostřednictvím balíčku R.  
    - Orientace v datasetu: Popis ukazatelů, obsažených v datasetu (typově: jaké věkové skupiny jsou sledovány, ...).  
    - Úprava dat pomocí balíčku `dplyr` a pipe operátoru: filtrování "vhodných" ukazatelů podle Vašeho uvážení.
    - Slovně popište, jaká data jste vybrali (případně proč).  
    - Jednoduchá vizualizace dat pomocí balíčku `ggplot2`. Před vizualizací dat ověřte rozměr výsledného datasetu pomocí příkazu `dim()`. Při správném filtrování musí počet řádků datasetu odpovídat zobrazovaným datům. (Např: zobrazuji řady s HDP pro 10 regionů a 5 let -> data frame má 50 řádků v tzv. dlouhém formátu.)
    - Převod do formátu časových řad (využijte balíček `zoo`).  
    - Úkol může být založen na postupech ze skriptu `R07_Eurostat.Rmd` (ale nepoužívejte přímo datasety z tohoto skriptu).  
    - Doprovoďte Váš výstup stručným slovním komentářem (popište zvolené proměnné).  

---

## Týden 3 (odevzdání do 6. 10.)

Práce s rastrovými daty v R

* Podle vlastního uvážení vyberte vhodný rastr:
    * znečištění ovzduší z webu [https://maps.s5p-pal.com/no2-tropospheric/](https://maps.s5p-pal.com/no2-tropospheric/) ,
    * GHSL - Global Human Settlement Layer data z webu [https://human-settlement.emergency.copernicus.eu/download.php](https://human-settlement.emergency.copernicus.eu/download.php)  

* Zopakujte postup ze skriptu: `R03_raster_data.R` : pro Vámi vybraný stát nebo skupinu států (EU nebo mimo EU) ukažte práci s rastrovými daty: funkce `crop()`, `mask()`, `exact_extract()` a `ggplot()`.  
* Převeďte data z rastru na vhodně zvolené polygony (státy, administrativní regiony, vlastní definovanou síť) a zobrazte výsledek pomocí funkce `ggplot()`.  
* **Upozornění:** rastrové obrázky bývají veliké soubory, často i po oříznutí na úroveň státu (oblast analýzy). Pokud by vložení rastrového obrázku do odevzdávaného úkolu (html/docx/pdf soubor) vedlo k překročení maximální povolené velikosti souboru v odevzdávárně, tak rastr nevkládejte (nebo jen velmi malý kousek rastru na ukázku) a do výstupu vložte pouze skript s postupem zpracování (a třeba základní summary tabulku k rastru) a jako grafický výstup použijte až infomapu z  `ggplot()`.  
* *Pro úkol použijte jiný stát než ČR a zkuste si vybrat jiný dataset/raster, než jaký je ve vzorovém skriptu (oba weby obsahují informace ohledně obsahu jednotlivých rasterů).*  

---- 

## Týden 4 (odevzdání do 13. 10.)

Interpolace prostorových dat

* Vyřešte úlohu ze skriptu `R06b_Complex_spatial_interpolation_example.Rmd` (Blok 2) a odevzdejte ve zkompilovaném formátu (html/docx/pdf).  
* Před zpracováním dat je vhodné podrobně si přečíst doprovodné informace a návod ze skriptu.


---

## Týden 5 (odevzdání do 20. 10.)

Testování prostorové (ne)závislosti a shluková analýza    

* Pro tento úkol lze použít data (tj. regiony), která jste stáhli v rámci úkolu v předchozích týdnech, pokud má výběr **alespoň 40 pozorování  (regionů)**. V opačném případě (malý výbět) najděte jiný dataset (ideálně na úrovni NUTS2 nebo NUTS3), nebo upravte filtrování jednotek, abyste měli dostatek pozorování pro analýzu.  
+ Zvolte alespoň jednu proměnnou (a jedno období pozorování - co nejblíže roku 2025) a proveďte **Moranův test** na prostorovou nezávislost.  
+ Použijte alespoň dva různé způsoby definice prostorové struktury (vzdálenost, vzdálenost + kNN, společná hranice) k ověření robustnosti výsledků vůči změnám prostorové struktury.  
+ Zobrazte a okomentuje tzv. Moranův graf.  
+ Slovně okomentujte výsledky.  
+ (Nutnou podmínkou pro získání nenulového počtu bodů z úkolu je velikost výběru přesahující 40 pozorování a odevzdání úkolu ve zkompilovaném Rmd formátu.)



---

## Týden 9 (odevzdání do 17.11.)


* Stepwise a penalizovaná regrese

*  Každý si vyberte vhodný dataset, například ze seznamu zde:  
    + https://vincentarelbundock.github.io/Rdatasets/datasets.html
    + Vyberete-li jiný dataset, srozumitelně popište data.
    + Závislou proměnnou pro svůj model pečlivě vybírejte, v kontextu datasetu Váš výběr musí dávat smysl -- výběr zdůvodněte.
    + Vybírejte takový dataset, abyste kromě závislé proměnné měli alespoň dalších 15+ potenciálních regresorů.

* Proveďte stepwise regresi, použijte alespoň dvě varianty výběru (best subset, forward, backwards)
 
* Proveďte tzv. penalizovanou regresi (alespoň jednu z variant: ridge, LASSO, elastic net).

* Popište/vyhodnoťte predikční vlastnosti.

--- 

## Týden 10 (odevzdání do 24.11.)

* GAM

*  Každý si vyberte vhodný dataset, například ze seznamu zde:  
    + https://vincentarelbundock.github.io/Rdatasets/datasets.html
    + Vyberete-li jiný dataset, srozumitelně popište data.
    + Závislou proměnnou pro svůj model pečlivě vybírejte, v kontextu datasetu Váš výběr musí dávat smysl -- výběr zdůvodněte.
    + **Nepoužívejte datasety ze skriptů ze cvičení (Hitters, atd.).**

* S využitím svého datasetu odhadněte GAM model - specifikace modelu podle vlastního uvážení.  
* Použijte alespoň 2 různé specifikace (kombinace smoothning splines, local regression).  
* Proveďte diagnostické testy GAM modelu podle vzoru z cvičení, výsledky testů interpretujte a model podle potřeby upravte.  








--- 


[Homepage](https://formanektomas.github.io/4EK417/)
