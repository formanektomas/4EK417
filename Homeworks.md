---
layout: default
---
# Zadání domácích úkolů

--- 

**Domácí úkoly zpracujte v `Rmd` (Markdown), nebo `qmd` (quarto) formátu,**   

**a vždy odevzdejte ve ZKOMPILOVANÉ verzi, tj. výstup do `html/pdf/docx` souboru.**  

- U zkompilovaných výstupů musejí být viditelné použité příkazy, tj. nastavení `echo=T` (je defaultní).  
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

## Týden 1 (odevzdání do 23.2.)

Vypracujte zadání ve skriptu `R03_data_handling_exercise.Rmd`.  
Zkompilovaný html/pdf/docx soubor odevzdejte prostřednictvím odevzdávárny v insisu.  


--- 

## Týden 2 (odevzdání do 2.3.)  

* Stažení zajímavého datasetu z databáze Eurostat/WDI, (u Eurostatu použijte data na úrovni NUTS2/NUTS3), prostřednictvím balíčku R.  
    - Orientace v datasetu: Popis ukazatelů, obsažených v datasetu (např.: jaké věkové skupiny jsou sledovány, ...).  
    - Úprava dat pomocí balíčku `dplyr` a pipe operátoru: filtrování "vhodných" ukazatelů podle Vašeho uvážení. Popište, jaká data jste vybrali (případně proč).  
    - Jednoduchá vizualizace dat pomocí balíčku `ggplot2`. Před vizualizací dat ověřte rozměr výsledného datasetu pomocí příkazu `dim()`. Při správném filtrování musí počet řádků datasetu odpovídat zobrazovaným datům. (Např: zobrazuji řady s HDP pro 10 regionů a 5 let -> data frame má 50 řádků v tzv. dlouhém formátu.)
    - Převod do formátu časových řad (využijte balíček `zoo`).  
    - Úkol může být založen na postupech ze skriptu `R07_Eurostat.Rmd` (ale nepoužívejte přímo datasety z tohoto skriptu).  
    - Doprovoďte Váš výstup stručným slovním komentářem (popište zvolené proměnné).  

---

## Týden 3 (odevzdání do 9. 3.)

Vizualizace prostorových dat v R - kartogram (infomapa)

* K vizualizaci použijte dva různé datasety: jeden může vycházet z úkolu pro minulý týden, druhý dataset si opět zvolte/vyhledejte na Eurostatu (nebo použijte jiný vhodný zdroj dat).

* Pro Vámi vybrané proměnné zobrazte infomapu, např. podle vzoru ze skriptu `R02_ggplot_choropleths.R`   
    + Zobrazte alespoň čtyři různé infomapy: použijte různé projekce, různá časová období (použijte fazety), odlišné NUTS úrovně, zobrazte proměnné pro různé sledované skupiny (věkové skupiny, skupiny podle vzdělání, pohlaví, atd.).  
    + Pokud pracujete se státy jako Francie nebo Španělsko, je vhodné z datasetu odstranit zámořská území (nebo ohraničit oblast zobrazovanou na mapě). 
    + Před vizualizací dat v `ggplot()` zkontrolujte rozměr datasetu.
    + Použití dat z Eurostatu není podmínkou, lze využít WDI nebo jinou databázi

+ **Bonus:** pokud pro zobrazení infomapy vyjdete z rasterových dat (vzdálené snímkování, viz skript `R03_raster_data.R`) můžete získat dva body navíc. Podmínkou je použití jiného rasteru a jiného státu, než se kterým jsme pracovali na cvičení.


===  

## Týden 4 (odevzdání do 16. 3.)

Interpolace prostorových dat

* Vyřešte úlohu ze skriptu `R06b_Complex_spatial_interpolation_example.Rmd` a odevzdejte ve zkompilovaném formátu (html/docx/pdf).  
* Před zpracováním dat je vhodné podrobně si přečíst doprovodné informace a návod ze skriptu.

---  

## Týden 5 (odevzdání do 23. 3.)

Testování prostorové (ne)závislosti a shluková analýza    

* Pro tento úkol lze použít data (tj. regiony), která jste stáhli v rámci úkolu v předchozích týdnech, pokud má výběr alespoň 40 pozorování. V opačném případě (malý výbět) najděte jiný dataset (ideálně na úrovni NUTS2 nebo NUTS3), nebo upravte filtrování jednotek, abyste měli dostatek pozorování pro analýzu.  

+ Zvolte alespoň jednu proměnnou (a jedno období pozorování - co nejblíže roku 2025) a proveďte **Moranův test** na prostorovou nezávislost.  

+ Použijte alespoň dva různé způsoby definice prostorové struktury (vzdálenost, vzdálenost + kNN, společná hranice) k ověření robustnosti výsledků vůči změnám prostorové struktury.  

+ Proveďte shlukovou analýzu (alespoň jeden typ výstupu) - jako vodítko můžete použít skript `R09_LISA_and_clusters.R`.  

+ Slovně okomentujte výsledky.  



--- 

## Týden 6 (odevzdání do 30. 3.) 

Vypracujte `Quick Exercise`, začínající na řádku 90 skriptu `R11_Direct_Indirect_Effects.R`. 
Proveďte následující kroky:

- Sestavte matici sousednosti **C** a matici prostorových vah **W** podle zadání (kNN).  
- Proveďte diagnostický test (SAR nebo SER model)  
- Odhadněte prostorový model  
- Vygemerujte tabulku mezních efektů a popište výsledky  
- Otestujte reziduální složku modelu na prostorovou nezávislost (popište výsledek testu)  
- Nezapomeňte kód překlopit do `Rmd` formátu a odevzdat ve *zkompilované podobě*   

--- 

## Týden 7 (odevzdání do 6. 4.)

*  Každý si vyberte vhodný dataset, například ze seznamu zde:  
    + https://vincentarelbundock.github.io/Rdatasets/datasets.html  
    + Vyberete-li jiný dataset, srozumitelně popište data.  
    + Závislou proměnnou pro svůj model pečlivě vybírejte, v kontextu datasetu Váš výběr odhadovaného musí dávat smysl -- výběr zdůvodněte.  
    + Vybírejte takový dataset, abyste kromě závislé proměnné měli alespoň dalších 10+ potenciálních regresorů -- aby použití penalizované regrese dávalo smysl.  

* Odhadněte modely pomocí penalizované regrese, např. podle skriptu: `R04_Elastic_Net_models.Rmd`  
    * Proveďte alespoň dvě varianty odhadu (ridge, LASSO, elastic net)  
    * Popište/vyhodnoťte predikční vlastnosti.  

--- 

## Týden 8 (odevzdání do 27. 4.)

* Pro tento úkol můžete vyjít z dat, která jste použili v předchozím úkolu   
*  Každý si vyberte vhodný dataset, například ze seznamu zde:  
    + https://vincentarelbundock.github.io/Rdatasets/datasets.html
    + Vyberete-li jiný dataset, srozumitelně popište data.
      
* S využitím svého datasetu odhadněte GAM model - specifikace modelu podle vlastního uvážení.  
* Použijte alespoň 3 různé specifikace (kombinace smoothning splines, local regression).  
* Proveďte diagnostické testy GAM modelu podle vzoru z cvičení, testy interpretujte a model podle potřeby upravte.  

---

## Týden 9 (odevzdání do 4. 5.)

* Doplňte (vyřešte zadání) ze skriptu `R06_LME_wagepanel_hierarchical_data.R`
* Uvažujte náhodné efekty na úrovni federálních států USA
* Nezapomeňte kód překlopit do `Rmd` formátu a odevzdat ve *zkompilované podobě*   



---  

[Homepage](https://formanektomas.github.io/4EK417/)
