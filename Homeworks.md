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

## Týden 2 (odevzdání do 27. 2.)

* Stažení zajímavého datasetu z webové databáze (Eurostat, WB, ČSÚ, Yahoo) prostřednictvím vhodného balíčku R. Úprava dat pomocí `dplyr` a pipe operátoru, vizualizace.

Příklad zpracování:  

* Úkol může být založen na  skriptu `R07_Eurostat.Rmd`.  
* Na rozídl od `Quick exercise` ale nepoužijete dataset "nama_10r_2coe".   
* Svůj dataset vyhledejte pomocí funkce `search_eurostat()`, klíčová slova a tedy použitý dataset bude dle uvážení každého studenta.   
* U bodů 2. až 5. budete postupovat analogicky k zadání pro "nama_10r_2coe" (vyberte "zajímavou" proměnnou/jednotku měření, skupinu států/regionů, atd).  
* **Pozor:** před vizualizací dat v `ggplot()` zkontrolujte rozměr výsledné tabulky pomocí `dim()`. Při správném filtrování musí počet řádků odpovídat zobrazovaným datům. (Např: HDP pro 10 regionů a 5 let = 50 řádků.) Tato kontrola musí být součástí odevzdaného úkolu.  
* Doprovoďte Váš výstup stručným slovním komentářem (popište zvolené proměnné).

* Jako bonus (za 2 body) můžete odevzdat vřešený úkol, který se nachází na konci skriptu `R11_Missing_data.R`

---

## Týden 3 (odevzdání do 13. 3. 2022)

Vizualizace prostorových dat v R - kartogram (infomapa)

* Pro tento úkol můžete použít data z Eurostatu, ideálně na úrovni NUTS2 nebo NUTS3. 
    + Pro vhodnou proměnnou zobrazte infomapu, např. podle vzoru ze skriptu `R02_ggplot_choropleths.R`  
    + Použijte alespoň dva různé způsoby zobrazení dat (různé projekce, státy, časová období, NUTS úroveň, atd.).  
    + Pokud pracujete se státy jako Francie nebo Španělsko, je vhodné z datasetu odstranit zámořská území (např. ostrovy). 
    + Úkol zpracujte samostatně, prosím každého o vyznačení datasetu do Google docs (odkaz Vám byl zaslán emailem).
    + Před vizualizací dat v `ggplot()` zkontrolujte rozměr datasetu. 
    
* Odevzdejte ve formátu `.Rmd` nebo Rmd zkompilované do `html/pdf/docx` výstupu   
    + u zkompilovaných výstupů musejí být viditelné použité příkazy, tj. nastavení `echo=T` (je defaultní).


--- 

## Týden 4 (odevzdání do 13. 3. 2022)

Testování prostorové (ne)závislosti v R 

* Pro tento úkol můžete vyjít z dat, která jste použili v týdnu 3  - pokud jde o data na úrovni NUTS2 nebo NUTS3 (volte data tak, abyste měli alespoň cca 30 prostorových jednotek). 
    + Pozor na filtrování dat ze stažených tabulek Eurostatu. Pokud pro analýzu vyberete uřčité regiony (např. 100 regionů celkem), pak při korektním filtrování (jedna sledovaná proměnná, jeden rok), bude mít dataset stejný počet řádků jako je počet regionů.  
    + Pokud pracujete se státy jako Francie nebo Španělsko, je vhodné z datasetu odstranit zámořská území (např. ostrovy). 
    
+ Zvolte jednu proměnnou a jeden rok (ideálně co nejblíže roku 2020) a proveďte Moranův test na prostorovou nezávislost.  

+ Použijte alespoň dva různé způsoby definice prostorové struktury (vzdálenost, společná hranice) a ověřte robustnost výsledků vůči změnám prostorové struktury.  

+ Slovně okomentujte výsledky.

+ Zopakujte pro test prostorové nezávislosti založený na statistice: Gearyho C.  


---

## Týden 5 (odevzdání do 20. 3. 2022)

Doplňte skript `R10_Spatial_lag_model.R` - postupujte podle zadání, formulovaného na cvičení v týdnu 5.  

---

## Týden 6 (odevzdání do 27. 3. 2022)

Zpracujte rozšířený abstrakt své seminární práce - popište vybrané téma (motivace, výzkumný záměr), popište data, popište preferovanou odhadovou metodu. Jaký je Váš konkrétní cíl? Jaké vidíte potenciální problémy či komplikace? Případně uveďte zpracovaný model a/nebo dílčí výstupy odhadu. Rozsah 1-2 strany A4 (cca 400-800 slov).  

--- 

## Týden 7 (odevzdání do 3. 4. 2022)

*  Každý si vyberte vhodný dataset (optimálně takový, který má "mnoho" proměnných - potenciálních regresorů), například ze seznamu zde:  
    + https://vincentarelbundock.github.io/Rdatasets/datasets.html
    + Použijete-li data z balíčku, nepřikládatejte csv soubor,
    + místo toho načtěte data pomocí `R`-kódu (z balíčku).
    + Vyberete-li jiný dataset (než z výše uvedeného seznamu), srozumitelně popište svá data a soubor přiložte.
    + Informaci o vybraném souboru zaznamenejte na Google dokument (stejný jako u tří z předchozích úkolů) - a ověřte si, zda už se souborem nepracuje někdo jiný.  

* V datasetu vhodně vyberte závislou proměnnou a proveďte výběr regresorů pomocí (a) stepwise regrese a (b) pomocí některé varianty penalizované regrese (kritériem by měly být predikční vlastnosti modelu.
    * Výstup (vizualizace, vyhodnocení, predikce) proveďte podle vzorových skriptů ze cvičení (jste-li zvyklí pracovat s jinými balíčky/funkcemi, můžete je použít).  

* Odevzdejte ve formátu `.Rmd` nebo Rmd zkompilované do `html/pdf/docx` výstupu   
    + u zkompilovaných výstupů musejí být viditelné použité příkazy, tj. nastavení `echo=T` (je defaultní).  

---

---

[Homepage](https://formanektomas.github.io/4EK417/)
