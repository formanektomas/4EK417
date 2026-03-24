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

## Týden 1 (odevzdání do 22.2.)

Vypracujte zadání ve skriptu `R03_data_handling_exercise.Rmd`.  
Zkompilovaný html/pdf/docx soubor odevzdejte prostřednictvím odevzdávárny v insisu.  

--- 

## Týden 2 (odevzdání do 1.3.)

* Stažení zajímavého datasetu z databáze Eurostat nebo podobné open access databáze, (u Eurostatu použijte data na úrovni NUTS2/NUTS3), prostřednictvím balíčku R.  
    - Orientace v datasetu: Popis ukazatelů, obsažených v datasetu (typově: jaké věkové skupiny jsou sledovány, ...).  
    - Úprava dat pomocí balíčku `dplyr` a pipe operátoru: filtrování "vhodných" ukazatelů podle Vašeho uvážení.
    - Slovně popište, jaká data jste vybrali (případně proč).  
    - Jednoduchá vizualizace dat pomocí balíčku `ggplot2`. Před vizualizací dat ověřte rozměr výsledného datasetu pomocí příkazu `dim()`. Při správném filtrování musí počet řádků datasetu odpovídat zobrazovaným datům. (Např: zobrazuji řady s HDP pro 10 regionů a 5 let -> data frame má 50 řádků v tzv. dlouhém formátu.)
    - Převod do formátu časových řad (využijte balíček `zoo`).  
    - Úkol může být založen na postupech ze skriptu `R07_Eurostat.Rmd` (ale nepoužívejte přímo datasety z tohoto skriptu).  
    - Doprovoďte Váš výstup stručným slovním komentářem (popište zvolené proměnné).
    - Nezapomeňte na formát odevzdání...   

---

## Týden 3 (odevzdání do 8. 3.)

Vizualizace prostorových dat v R - kartogram (infomapa)

* K vizualizaci použijte dva různé datasety: jeden může vycházet z úkolu pro minulý týden, druhý dataset si opět zvolte/vyhledejte na Eurostatu (nebo použijte jiný vhodný zdroj dat).

* Pro Vámi vybrané proměnné zobrazte infomapu, např. podle vzoru ze skriptu `R02_ggplot_choropleths.R`   
    + Zobrazte alespoň čtyři různé infomapy: použijte různé projekce, různá časová období (použijte fazety), odlišné NUTS úrovně, zobrazte proměnné pro různé sledované skupiny (věkové skupiny, skupiny podle vzdělání, pohlaví, atd.).  
    + Pokud pracujete se státy jako Francie nebo Španělsko, je vhodné z datasetu odstranit zámořská území (nebo ohraničit oblast zobrazovanou na mapě). 
    + Před vizualizací dat v `ggplot()` zkontrolujte rozměr datasetu.
    + Použití dat z Eurostatu není podmínkou, jinou databázi, případně rastrová data (satelitní snímkování). 


---  

## Týden 4 (odevzdání do 15. 3.)


Interpolace prostorových dat

* Vyřešte úlohu ze skriptu `R06b_Complex_spatial_interpolation_example.Rmd` (Blok 2) a odevzdejte ve zkompilovaném formátu (html/docx/pdf).
* Kromě IDW použijte i krigging.
* Před zpracováním dat je vhodné podrobně si přečíst doprovodné informace a návod ze skriptu.


---


## Týden 5 (odevzdání do 22. 3.)

Testování prostorové (ne)závislosti a shluková analýza    

+ Pro tento úkol lze použít data (tj. regiony), která jste stáhli v rámci úkolu v předchozích týdnech, **pokud má dataset alespoň 50 pozorování**. V opačném případě (malý výbět) najděte jiný dataset (ideálně na úrovni NUTS2 nebo NUTS3), abyste měli dostatek pozorování pro testy.  

+ Zvolte jednu proměnnou (a jedno období pozorování co nejblíže roku 2026) a proveďte **Moranův test** na prostorovou nezávislost (interpretujte výsledek testu).  

+ Použijte alespoň dva různé způsoby definice prostorové struktury (vzdálenost, vzdálenost + kNN, společná hranice) k ověření robustnosti výsledků vůči změnám prostorové struktury.  

+ Proveďte shlukovou analýzu (alespoň jeden typ výstupu) - jako vodítko můžete použít skript `R09_LISA_and_clusters.R` z bloku 2.  

+ Slovně okomentujte výsledky.  



---

## Týden 6 (odevzdání do 29. 3.)

Vizualizace dat, odhad prostorového regresního modelu, interpretace výsledků

+ [Zadání úkolu 6](https://github.com/formanektomas/4EK417/raw/master/Block2/London.zip)  



**Upozronění k Inovačnímu týdnu**  

- KEKO a Energetický regulační úřad pořádají ve středu 8.4. od 9:15 na SB304 (Žižkov) seminář na téma *Energetika v ČR a v Evropě - datová základna pro regulaci energetiky a ochranu spotřebitele*.  
- Úkol z 6. týdne (nebo libovolný jiný úkol za 5 bodů) lze nahradit účastí na semináři - podmínkou je registrace + osobní účast  
- registrační formulář zde: [Registrace seminář ERÚ](https://forms.office.com/e/AfGT2DVuBZ)  



--- 



[Homepage](https://formanektomas.github.io/4EK417/)
