
*===============================================================================
*===============================================================================
//						Component 3. Adult Survival (15 to 60) Rates
// 	  				***   Adult Survival Rates for HCI    ***
*===============================================================================
*===============================================================================

/******************************************************************************/

// Do file to input raw data and standardize dataset and naming conventions.

/******************************************************************************/
// Purpose		    : To prepare adult survival data  
// Input datasets	: WPP2024_GEN_F01_DEMOGRAPHIC_INDICATORS_COMPACT.xlsx
// Data Sources     : UNPD
// Source Used		: 

// Output dataset	: asr_data.dta
// Last edited	    : Oct 15, 2025
// Last run		    : Oct 15, 2025

// Notes            : 
//==============================================================================


*===============================================================================
// 0. Set globals
*===============================================================================

clear
cls
version 18
set more off

dir "$clone"

*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

*************** Preparng Adult survival data from UNPD  ************************

// Source: https://population.un.org/wpp/downloads?folder=Standard%20Projections&group=Most%20used
// Variable: Mortality between Age 15 and 60, both sexes (deaths under age 60 per 1,000 alive at age 15)

import excel using "$clone/01_data/asr_15to60/WPP2024_GEN_F01_DEMOGRAPHIC_INDICATORS_COMPACT.xlsx", cellrange(A17) firstrow clear  

rename *, lower
keep if type == "Country/Area"
//keep if ISO3Alphacode != ""

keep regionsubregioncountryorar iso3alphacode year mortalitybetweenage15and60 bj bk
rename (regionsubregioncountryorar iso3alphacode mortalitybetweenage15and60 bj bk) (wbcountryname wbcode amr_mf amr_m amr_f)
destring amr*, replace

// Adult survival 15 to 60: Complement of adult mortality
foreach gen in mf m f{
	gen surv_15to60_`gen' = 1-(amr_`gen'/1000)
}

drop amr*
keep wbcode year surv_15to60*

foreach gen in mf m f{
gen surv_15to60_`gen'_src = "UN Population Division" if !missing(surv_15to60_`gen')
}

//Merging Master data for country-year panel
merge m:1 wbcode year using "${clone}\01_data\misc\masterdata.dta"
drop if _merge == 1
drop _merge
drop if wbcode == "x"


sort countrynumber year
xtset countrynumber year
 
local myvar surv_15to60_mf surv_15to60_m surv_15to60_f
				
	foreach var of local myvar {	
		qui gen xx_0=`var'
		qui gen `var'_year=year if `var'~=.
		qui gen `var'_fill=`var' if `var'~=.
		qui gen `var'_fill_src = ""
			
	forvalues i=1/10{
		qui gen xx_`i'=xx_`=scalar(`i'-1)'
		qui replace xx_`i'=L`i'.`var' if xx_`i'==. & year<= 2024
		qui replace `var'_year=L`i'.year if xx_`i'~=. & xx_`=scalar(`i'-1)'==. & year<= 2024

			}
		
		qui replace `var'_fill_src = `var'_src if `var'_fill_src == "" & year <= 2024
		qui replace `var'_fill=xx_10 if `var'==.
		qui gen `var'_rep=`var'
		qui replace `var'_src = "" if `var'_fill == .
		qui drop xx*
		qui replace `var'_fill_src = `var'_src[_n-1] if year == 2024 & !missing(`var'_fill)
		}

// final filled 2025 variables for 2010, 2015, 2020 and 2025

foreach gen in mf m f {
		foreach var in fill year  {
			qui gen surv_15to60_`gen'_`var'_2025=L1.surv_15to60_`gen'_`var' if year==2025
			qui gen surv_15to60_`gen'_`var'_2020=L6.surv_15to60_`gen'_`var' if year==2025
			qui gen surv_15to60_`gen'_`var'_2018=L8.surv_15to60_`gen'_`var' if year==2025
			qui gen surv_15to60_`gen'_`var'_2015=L11.surv_15to60_`gen'_`var' if year==2025
			qui gen surv_15to60_`gen'_`var'_2010=L16.surv_15to60_`gen'_`var' if year==2025
			}
		}


foreach gen in mf m f {
		foreach var in src  {
			qui gen surv_15to60_`gen'_`var'_2025=surv_15to60_`gen'_fill_`var'[_n-1] if year==2025
			qui gen surv_15to60_`gen'_`var'_2020=surv_15to60_`gen'_fill_`var'[_n-6] if year==2025
			qui gen surv_15to60_`gen'_`var'_2018=surv_15to60_`gen'_fill_`var'[_n-8] if year==2025
			qui gen surv_15to60_`gen'_`var'_2015=surv_15to60_`gen'_fill_`var'[_n-11] if year==2025
			qui gen surv_15to60_`gen'_`var'_2010=surv_15to60_`gen'_fill_`var'[_n-16] if year==2025
			}
		}		

save "$clone/03_output/asr_data.dta", replace		

*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------