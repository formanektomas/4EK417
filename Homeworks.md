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
    + u zkompilovaných výstupů musejí být viditelné použité příkazy, tj. nastavení `echo=T` (je defaultní).

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
* Odevzdejte ve formátu `.R`, `.Rmd` nebo Rmd zkompilované do `html/pdf/docx` výstupu   
    + u zkompilovaných výstupů musejí být viditelné použité příkazy, tj. nastavení `echo=T` (je defaultní).
    
---

## Týden 4 (odevzdání do 15. 3. 2020)

* Pro úkol 4 použijte stejný dataset jako byl použit pro úkol 3 (případnou změnu datasetu vysvětlete)  
* Odhadněte regresní model pomocí penalizované regrese a vyhodnoťte predičkní vlastnosti  
    + jako vzor můžete využít postup ze skriptu `R04_Elastic_Net_models.Rmd`,  
    + srovnejte predičkní vlastnosti pro dostatečně širokou škálu penalizačních parametrů $\lambda$,
    + použijte alespoň dvě možnosti penalizace (ridge, lasso, elastic net),  
    + generujte predikce (alespoň na ukázku, nebo rozdělte data na train/test sample), okomentuje výsledky.
* Pro stejný dataset proveďte regresi na hlavních komponentách (PCR).
    + jako vzor můžete využít postup ze skriptu `R07_PCA_PCR.Rmd`,  
    + vyhodnoťte statistiku KMO,  
    + srovnejte prediční vlastnosti regresních modelů s různým množstvím zahrných hlavních komponent.
* Doprovoďte Vaše výstupy stručným slovním komentářem.  
* Odevzdejte ve formátu `.R`, `.Rmd` nebo Rmd zkompilované do `html/pdf/docx` výstupu   
    + u zkompilovaných výstupů musejí být viditelné použité příkazy, tj. nastavení `echo=T` (je defaultní).
    
    
---

## Týden 10 (odevzdání do 26. 4. 2020)

Tvorba map a infomap (kartogramů) v R, pomocí balíčku `ggplot2`  

* Pro tento úkol můžeme vyjít z dat, která jste stáhli v rámci úkolu pro Týden 2 - ovšem pouze tehdy, obsahuje-li Váš dataset informace na úrovni NUTS2 nebo NUTS3. Pokud ne, vyhledejte dataset obsahově co nejpodobnější - tak abyste měli údaje na regionální úrovni NUTS2 nebo NUTS3.
* Vlastní úkol je následující: pro Vámi zvolený typ dat a úroveň NUTS (NUTS2/NUTS3) vygenerujete infomapu pro alespoň 3 státy EU a pro alespoň dvě časová období, takto:
    + Mapa 1: Prostá mapa Vámi zvolených států (bez "dat"), zobrazte regiony (např. NUTS2) a přidejte hranice států (NUTS0). Použijte zobrazení/projekci typu Mercator.
    + Mapa 2: Stejná jako mapa 1, použijte projekci typu Lambert (Lambert equal area).
    + Mapa 3: Pro jeden vybraný rok zobrazte infomapu (kartogram), na regionální úrovni (NUTS2/NUTS3), nezapomeňte na hranice států (NUTS0), použijte projekci typu Mercator
    + Mapa 4: Pomocí "fazet" upravte mapu 3 - zobrazte data za více časových období, použijte projeckci typu Lambert, zobrazte hranice států.
    + Mapa 5: Další mapa či kombinace map na zvolené téma podle Vašeho uvážení a podle typu dat.
    
+ Upozornění 1: U předchích úkolů měla řada studentů problémy s filtrováním dat ze stažených tabulek Eurostatu. Připomínám, že pokud Vámi zvolené státy (např. 4) mají určitý počet regionů NUTS2 (např. 100 celkem), pak při korektním filtrování (jedna sledovaná proměnná, 100 regionů krát tři roky) bude mít Váš dataset 300 řádků (a ne 15 tisíc.... například). 
    + V rámci odevzdávaného R/Rmd kódu proto uveďte přesný popis dat a také kontrolu správnosti filtrování (např. kontrola počtu řádků po filtrování).  
+ Upozronění 2: Aktualizujte si `R`, `RStudio`, `Pandoc` a všechny balíčky (viz odkazy nahoře na této stránce).

+ Domácí úkol odevzdejte prostřednctvím insisu do 26.4.

---

## Týden 12 (odevzdání do 10. 5. 2020)

Testování prostorové (ne)závislosti v R 

* Pro tento úkol můžeme vyjít z dat, která jste použili v předcházejícím úkolu (data na úrovni NUTS2 nebo NUTS3). 
    + Pozor, u řady studentů přetrvávají problémy s filtrováním dat ze stažených tabulek Eurostatu. Pokud pro analýzy vyberete uřčité regiony (např. 100 celkem), pak při korektním filtrování (jedna sledovaná proměnná, jeden rok), bude mít dataset stejný počet řádků jako je počet uvažovaných regionů. Pokud tomu tak není (např. v datasetu máte údaje 3x, v členění podle pohlaví za M/F/T), pak test nelze provést, resp. interpretovat  
    
+ Zvolte jednu proměnnou a jeden rok (ideálně co nejblíže roku 2020) a proveďte Moranův test na prostorovou závislost. Použijte alespoň tři různé způsoby definice prostorové struktury (stačí různé maximální vzdálenosti mezi sousedy, ideálně si vyzkoušejte i *kNN* přístup) a ověřte robustnost výsledků vůči změnám prostorové struktury. Slovně okomentujte výsledky.

+ Zopakujte předchozí bod pro test prostorové závislosti, založený na statistice: Gearyho C.  

---

[Homepage](https://formanektomas.github.io/4EK417/)
