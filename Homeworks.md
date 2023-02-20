---
layout: default
---
# Zadání domácích úkolů

--- 

**Domácí úkoly zpracujte v `Rmd` (Markdown) formátu, odevzdávejte ZKOMPILOVANÉ do `html/pdf/docx` výstupu.**  
- U zkompilovaných výstupů musejí být viditelné použité příkazy, tj. nastavení `echo=T` (je defaultní).  


Obecná doporučení pro práci s R (domácí úkoly)

1. Používejte nejnovější verzi [R](https://www.r-project.org/)
2. Používejte nejnovější verzi [RStudio](https://rstudio.com/products/rstudio/)
3. Aktualizujte balíčky
4. Je-li to nutné, nainstalujte si poslední verzi Pandoc (`Rmd` compiler)
  
      install.packages("installr",dependencies = T)  
      installr::install.pandoc() # may require admin access rights  
     

---


## Týden 1 (odevzdání do 19.2.)

Vypracujte zadání ve skriptu `R02b_data_handling_exercise.Rmd`.
Zkompilovaný html/pdf/docx soubor odevzdejte prostřednictvím odevzdávárny v insisu. 

(filtrování údajů typu Date: např. `date >= "1980-01-01"` )


---

## Týden 2 (odevzdání do 26. 2.)  

Zkompilovaný html/pdf/docx soubor s úkolem odevzdejte prostřednictvím odevzdávárny v insisu. 

* Stažení zajímavého datasetu z databáze Eurostat/WDI, na úrovni NUTS2/NUTS3 (Eurostat), prostřednictvím balíčku R.   **5b**   
    - Úprava dat pomocí `dplyr` a pipe operátoru: filtrování "vhodných" ukazatelů podle Vašeho uvážení, popište, jaká data jste vybrali (případně proč), proveďte jednoduchá vizualizaci dat pomocí `ggplot2`.  
    - Úkol může být založen na postupech ze skriptu `R07_Eurostat.Rmd` (ale nepoužívejte přímo datasety z tohoto skriptu).  
    - **Pozor:** před vizualizací dat zkontrolujte rozměr použité tabulky - pomocí příkazu `dim()`. Při správném filtrování musí počet řádků odpovídat zobrazovaným datům. (Např: zobrazuji řady s HDP pro 10 regionů a 5 let = 50 řádků.) Tato kontrola musí být součástí odevzdaného úkolu.  
    - Doprovoďte Váš výstup stručným slovním komentářem (popište zvolené proměnné).

* **Bonus:** Vyřešte úkol, který se nachází na konci skriptu `R11_Missing_data.R`. Odevzdejte jako zkompilovaný Rmd soubor ve formátu html/pdf/docx, buď samostatně, nebo přiložte k předchozí úloze.   **2b**   


---


[Homepage](https://formanektomas.github.io/4EK417/)
