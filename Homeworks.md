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


## Týden 1 (odevzdání do 26.9.)

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

## Týden 2 (odevzdání do 3. 10. 2021)

* Stažení zajímavého datasetu z webové databáze (Eurostat, WB, ČSÚ, Yahoo) prostřednictvím vhodného balíčku R. Úprava dat pomocí `dplyr` a pipe operátoru, vizualizace.

Příklad zpracování:  

* Úkol může být založen na  skriptu `R07_Eurostat.Rmd`.  
* Na rozídl od `Quick exercise` ale nepoužijete dataset "nama_10r_2coe".   
* Svůj dataset vyhledejte pomocí funkce `search_eurostat()`, klíčová slova a tedy použitý dataset bude dle uvážení každého studenta.   
* U bodů 2. až 5. budete postupovat analogicky k zadání pro "nama_10r_2coe" (vyberte "zajímavou" proměnnou/jednotku měření, skupinu států/regionů, atd).  
* **Pozor:** před vizualizací dat v `ggplot()` zkontrolujte rozměr výsledné tabulky pomocí `dim()`. Při správném filtrování musí počet řádků odpovídat zobrazovaným datům. (Např: HDP pro 10 regionů a 5 let = 50 řádků.) Tato kontrola musí být součástí odevzdaného úkolu.  
* Doprovoďte Váš výstup stručným slovním komentářem (popište zvolené proměnné).

* Jako bonus (za 2 body) můžete odevzdat řešený úkol v závěru skriptu `R11_Missing_data.R`

--- 

## Týden 3 (odevzdání do 10. 10. 2021)

Vizualizace prostorových dat v R - kartogram (infomapa)

* Pro tento úkol můžete vyjít z dat, která jste použili v týdnu 2  - pokud jde o data z EU, ideálně na úrovni NUTS2 nebo NUTS3. 
    + Pro vhodnou proměnnou zobrazte infomapu, např. podle vzoru ze skriptu `R03_ggplot_choropleths.R`  
    + Použijte alespoň dva různé způsoby zobrazení dat (různé projekce, státy, časová období, NUTS úroveň, atd.).  
    + Pokud pracujete se státy jako Francie nebo Španělsko, je vhodné z datasetu odstranit zámořská území (např. ostrovy). 
    + Úkol zpracujte samostatně, prosím každého o vyznačení datasetu do Google docs (odkaz Vám byl zaslán emailem).


---

## Týden 4 (odevzdání do 17. 10. 2021)

Testování prostorové (ne)závislosti v R 

* Pro tento úkol můžete vyjít z dat, která jste použili v týdnu 3  - pokud jde o data na úrovni NUTS2 nebo NUTS3 (volte data tak, abyste měli alespoň cca 30 prostorových jednotek). 
    + Pozor na filtrování dat ze stažených tabulek Eurostatu. Pokud pro analýzu vyberete uřčité regiony (např. 100 regionů celkem), pak při korektním filtrování (jedna sledovaná proměnná, jeden rok), bude mít dataset stejný počet řádků jako je počet regionů.  
    + Pokud pracujete se státy jako Francie nebo Španělsko, je vhodné z datasetu odstranit zámořská území (např. ostrovy). 
    
+ Zvolte jednu proměnnou a jeden rok (ideálně co nejblíže roku 2020) a proveďte Moranův test na prostorovou nezávislost.  

+ Použijte alespoň dva různé způsoby definice prostorové struktury (vzdálenost, společná hranice) a ověřte robustnost výsledků vůči změnám prostorové struktury.  

+ Slovně okomentujte výsledky.

+ Zopakujte pro test prostorové nezávislosti založený na statistice: Gearyho C.  

---

[Homepage](https://formanektomas.github.io/4EK417/)
