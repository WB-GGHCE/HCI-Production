
*===============================================================================
*===============================================================================
//						Component 2. Stunting Rates
// 	  				***   Stunting Rates for HCI    ***
*===============================================================================
*===============================================================================

/******************************************************************************/

// Do file to input raw data and standardize dataset and naming conventions.

/******************************************************************************/
// Purpose		    : To prepare stunting data  
// Input datasets	: stunting_WDI.dta
// Data Sources     : World Bank data bank
// Source Used		: 

// Output dataset	: stunting_svy_data.dta
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

// Stunting estimates from WDI
import excel using "$clone/01_data/stunting/P_Data_Extract_From_Health_Nutrition_and_Population_Statistics.xlsx", ///
					first sheet("Data") cellrange(A1:T1597) clear

//clean up steps
rename *, lower
rename (countrycode countryname) (wbcode wbcountryname)

replace seriescode = "stunt_svy_mf" 	if seriescode      == "SH.STA.STNT.ZS"
replace seriescode = "stunt_svy_m" 		if seriescode      == "SH.STA.STNT.MA.ZS"
replace seriescode = "stunt_svy_f" 		if seriescode      == "SH.STA.STNT.FE.ZS"
replace seriescode = "stunt_mod_mf"     if seriescode      == "SH.STA.STNT.ME.ZS"
replace seriescode = "stunt_mod_m"      if seriescode      == "SH.STA.STNT.ME.MA.ZS"
replace seriescode = "stunt_mod_f"      if seriescode      == "SH.STA.STNT.ME.FE.ZS"

foreach var of varlist yr2009-yr2024{
	replace `var' = "." if `var' == ".."
}

destring yr*, replace 
rename yr* value*
					
// Reshaping data
reshape long value, i(wbcode wbcountryname seriescode seriesname) j(year)

drop seriesname
reshape wide value, i(wbcode wbcountryname year) j(seriescode) s 	

rename value* *		

// Generating source
foreach gen in mf m f{
	gen stunt_svy_`gen'_src	= "UNICEF-WHO-WB JME" if !missing(stunt_svy_`gen')
	gen stunt_mod_`gen'_src = "UNICEF-WHO-WB JME (modeled estimates)" if !missing(stunt_mod_`gen')
}

// Label variables
foreach gen in mf m f{
	lab var stunt_svy_`gen'     "Prevalence of stunting, `gen'"
	lab var stunt_mod_`gen' 	"Prevalence of stunting, `gen' (modeled estimate)"
	lab var stunt_svy_`gen'_src "Prevalence of stunting, `gen', source"
	lab var stunt_mod_`gen'_src "Prevalence of stunting, `gen' (modeled estimate), source"
}	

// Merge with master data file
merge m:1 wbcode year using "$clone\01_data\misc\masterdata.dta",  keep(2 3) nogen
drop if wbcode =="x"
sort wbcode year

**************   Stunting dataset (using only survey data as in Old HCI) *************

// dropping modeled data 
drop stunt_mod_*

//  Transform JME data to rate - Rescale to rate instead of percent
foreach gen in mf m f {
	replace stunt_svy_`gen'= stunt_svy_`gen'/100
}

// Replacing _m and _f stunting values with _mf, if _m and _f are not available but _mf is available (otherwise _mf HCI will be based on stunting & ASR but _m and _f HCI will be based only on ASR) (2025: China, Finland, Vietnam, Belarus)
replace stunt_svy_m = stunt_svy_mf if stunt_svy_m == .
replace stunt_svy_f = stunt_svy_mf if stunt_svy_f == .

replace stunt_svy_m_src = stunt_svy_mf_src if stunt_svy_m_src == ""
replace stunt_svy_f_src = stunt_svy_mf_src if stunt_svy_f_src == ""

/******************************************************************************/
// Fill in gaps by using up to 10 lags
/******************************************************************************/
// For each `var' loop generates:
// `var'_rep:  Variable as reported
// `var'_fill:  Variable filled in with lags
// `var'_year: Year of actual data where filled-in data comes from
// `var'_source: Text describing source, suitable for notes
// Extra variables with year_mod and fill_mod suffix, which we are going to use in creating gender estimates for modeled data 
/******************************************************************************/

sort countrynumber year
xtset countrynumber year

local myvar stunt_svy_mf stunt_svy_m stunt_svy_f 				//  survey-based stunting
		
	foreach var of local myvar {	
		qui gen xx_0=`var'
		qui gen `var'_year=year if `var'~=.
		qui gen `var'_fill=`var' if `var'~=.
		
	forvalues i=1/10{
		qui gen xx_`i'=xx_`=scalar(`i'-1)'
		qui replace xx_`i'=L`i'.`var' if xx_`i'==. & year<= 2024
		qui replace `var'_year=L`i'.year if xx_`i'~=. & xx_`=scalar(`i'-1)'==. & year<= 2024
		}
		
		qui replace `var'_fill=xx_10 if `var'==.
		qui gen `var'_rep=`var'
		qui drop xx*
	}	
	
// One loop to generate filled-in lags for string variables containing source
foreach var in stunt_svy_mf stunt_svy_m stunt_svy_f {
	qui gen `var'_fill_src=`var'_src if `var'~=.
forvalues i=1/10{
	qui replace `var'_fill_src=`var'_src[_n-`i'] if `var'_year==L`i'.`var'_year & `var'_fill~=. & year <= 2024
	}
}

// Genrating Final 2025 variables for 2010, 2015, 2018, 2020 and 2025

foreach gen in mf m f {
	foreach var in fill year  {
		qui gen stunt_`gen'_`var'_2025=L1.stunt_svy_`gen'_`var'  if year==2025
		qui gen stunt_`gen'_`var'_2020=L6.stunt_svy_`gen'_`var'  if year==2025
		qui gen stunt_`gen'_`var'_2018=L8.stunt_svy_`gen'_`var'  if year==2025
		qui gen stunt_`gen'_`var'_2015=L11.stunt_svy_`gen'_`var' if year==2025
		qui gen stunt_`gen'_`var'_2010=L16.stunt_svy_`gen'_`var' if year==2025
	}
}

foreach gen in mf m f {
		qui gen stunt_`gen'_fill_src_2025=stunt_svy_`gen'_fill_src[_n-1]  if year==2025
		qui gen stunt_`gen'_fill_src_2020=stunt_svy_`gen'_fill_src[_n-6]  if year==2025
		qui gen stunt_`gen'_fill_src_2018=stunt_svy_`gen'_fill_src[_n-8]  if year==2025
		qui gen stunt_`gen'_fill_src_2015=stunt_svy_`gen'_fill_src[_n-11] if year==2025
		qui gen stunt_`gen'_fill_src_2010=stunt_svy_`gen'_fill_src[_n-16] if year==2025
		}

// Saving only survey-based final stunting data		
sa "$clone/03_output/stunting_svy_data.dta", replace	
		
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
