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


[Homepage](https://formanektomas.github.io/4EK417/)
